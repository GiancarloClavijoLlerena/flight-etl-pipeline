"""Flight cleansing and metric calculation for FactFlight."""

from __future__ import annotations

from dataclasses import dataclass

import pandas as pd

DATE_COLUMNS = ["scheduled_departure", "scheduled_arrival", "actual_departure", "actual_arrival"]
KNOWN_STATUSES = {"programado", "retrasado", "en curso", "finalizado", "cancelado"}


@dataclass(frozen=True)
class FlightTransformationResult:
    """Valid fact rows and the quality controls applied during transformation."""

    flights: pd.DataFrame
    quality_metrics: dict[str, int]


def _reject_invalid_rows(
    frame: pd.DataFrame, valid_rows: pd.Series, metric_name: str, metrics: dict[str, int]
) -> pd.DataFrame:
    """Record a rejection count and retain only rows that satisfy one validation rule."""
    metrics[metric_name] = int((~valid_rows).sum())
    return frame.loc[valid_rows].copy()


def transform_flights(frame: pd.DataFrame) -> FlightTransformationResult:
    """Clean flights, calculate metrics, and report rejected rows by validation rule."""
    result = frame.copy()
    metrics = {"source_flights": len(result)}
    for column in DATE_COLUMNS:
        result[column] = pd.to_datetime(result[column], errors="coerce")

    for column in ("flight_number", "status_name"):
        result[column] = (
            result[column]
            .astype("string")
            .str.replace(r"\s+", " ", regex=True)
            .str.strip()
            .replace("", pd.NA)
        )

    required = [
        "flight_id",
        "flight_number",
        "airline_id",
        "aircraft_id",
        "origin_airport_id",
        "destination_airport_id",
        "status_id",
        "status_name",
        "scheduled_departure",
        "scheduled_arrival",
        "distance",
    ]
    result["distance"] = pd.to_numeric(result["distance"], errors="coerce")
    result = _reject_invalid_rows(
        result, ~result[required].isna().any(axis=1), "missing_required", metrics
    )
    result = _reject_invalid_rows(
        result,
        ~result.duplicated(subset=["flight_id"], keep="last"),
        "duplicate_flight_id",
        metrics,
    )
    result = _reject_invalid_rows(result, result["distance"] > 0, "invalid_distance", metrics)
    result = _reject_invalid_rows(
        result,
        result["origin_airport_id"] != result["destination_airport_id"],
        "same_origin_destination",
        metrics,
    )
    result = _reject_invalid_rows(
        result,
        result["scheduled_arrival"] > result["scheduled_departure"],
        "invalid_scheduled_timeline",
        metrics,
    )
    normalized_status = result["status_name"].str.casefold()
    result = _reject_invalid_rows(
        result, normalized_status.isin(KNOWN_STATUSES), "unknown_status", metrics
    )
    normalized_status = result["status_name"].str.casefold()
    actual_timeline_valid = result["actual_arrival"].isna() | (
        result["actual_departure"].notna()
        & (result["actual_arrival"] >= result["actual_departure"])
    )
    result = _reject_invalid_rows(result, actual_timeline_valid, "invalid_actual_timeline", metrics)

    normalized_status = result["status_name"].str.casefold()
    has_actual_departure = result["actual_departure"].notna()
    has_actual_arrival = result["actual_arrival"].notna()
    operational_status_valid = (
        ((normalized_status == "cancelado") & ~has_actual_departure & ~has_actual_arrival)
        | ((normalized_status == "programado") & ~has_actual_departure & ~has_actual_arrival)
        | ((normalized_status == "en curso") & has_actual_departure & ~has_actual_arrival)
        | ((normalized_status == "finalizado") & has_actual_departure & has_actual_arrival)
        | (normalized_status == "retrasado")
    )
    result = _reject_invalid_rows(
        result, operational_status_valid, "inconsistent_operational_status", metrics
    )

    result["date_key"] = result["scheduled_departure"].dt.strftime("%Y%m%d").astype(int)
    result["scheduled_duration_minutes"] = (
        ((result["scheduled_arrival"] - result["scheduled_departure"]).dt.total_seconds() / 60)
        .round()
        .astype(int)
    )
    result["actual_duration_minutes"] = (
        ((result["actual_arrival"] - result["actual_departure"]).dt.total_seconds() / 60)
        .round()
        .astype("Int64")
    )
    result["departure_delay_minutes"] = (
        ((result["actual_departure"] - result["scheduled_departure"]).dt.total_seconds() / 60)
        .round()
        .astype("Int64")
    )
    result["arrival_delay_minutes"] = (
        ((result["actual_arrival"] - result["scheduled_arrival"]).dt.total_seconds() / 60)
        .round()
        .astype("Int64")
    )
    result["cancelled_flag"] = (result["status_name"].str.casefold() == "cancelado").astype(int)
    result["flight_count"] = 1

    facts = result.rename(columns={"flight_id": "source_flight_id"})[
        [
            "source_flight_id",
            "scheduled_departure",
            "date_key",
            "airline_id",
            "aircraft_id",
            "origin_airport_id",
            "destination_airport_id",
            "status_id",
            "flight_number",
            "flight_count",
            "distance",
            "scheduled_duration_minutes",
            "actual_duration_minutes",
            "departure_delay_minutes",
            "arrival_delay_minutes",
            "cancelled_flag",
        ]
    ]
    metrics["valid_flights"] = len(facts)
    return FlightTransformationResult(flights=facts, quality_metrics=metrics)


def reject_unresolved_dimension_references(
    flights: pd.DataFrame, dimensions: dict[str, pd.DataFrame]
) -> tuple[pd.DataFrame, int]:
    """Discard flights whose OLTP keys were removed from their cleaned dimensions."""
    valid_references = (
        flights["airline_id"].isin(dimensions["airline"]["source_airline_id"])
        & flights["aircraft_id"].isin(dimensions["aircraft"]["source_aircraft_id"])
        & flights["origin_airport_id"].isin(dimensions["airport"]["source_airport_id"])
        & flights["destination_airport_id"].isin(dimensions["airport"]["source_airport_id"])
        & flights["status_id"].isin(dimensions["status"]["source_status_id"])
    )
    rejected = int((~valid_references).sum())
    return flights.loc[valid_references].copy(), rejected
