"""Preparation of OLAP dimension DataFrames."""

from __future__ import annotations

import pandas as pd


def _clean_strings(frame: pd.DataFrame, columns: list[str]) -> pd.DataFrame:
    """Normalize whitespace and convert empty text values to missing values."""
    result = frame.copy()
    for column in columns:
        result[column] = (
            result[column].astype("string").str.replace(r"\s+", " ", regex=True).str.strip()
        )
        result[column] = result[column].replace("", pd.NA)
    return result


def _dimension(
    frame: pd.DataFrame, source_column: str, rename: dict[str, str], string_columns: list[str]
) -> pd.DataFrame:
    """Apply shared cleansing, required-field validation, and source-key deduplication."""
    result = _clean_strings(frame, string_columns).rename(columns=rename)
    required = [rename[source_column], *string_columns]
    return result.dropna(subset=required).drop_duplicates(
        subset=[rename[source_column]], keep="last"
    )


def transform_airlines(frame: pd.DataFrame) -> pd.DataFrame:
    """Clean and deduplicate the airline dimension by its OLTP natural key."""
    return _dimension(
        frame, "airline_id", {"airline_id": "source_airline_id"}, ["code", "name", "country"]
    )


def transform_airports(frame: pd.DataFrame) -> pd.DataFrame:
    """Clean and deduplicate the shared airport dimension."""
    return _dimension(
        frame,
        "airport_id",
        {"airport_id": "source_airport_id"},
        ["iata_code", "name", "city", "country"],
    )


def transform_aircraft(frame: pd.DataFrame) -> pd.DataFrame:
    """Clean aircraft rows and discard non-positive capacities."""
    result = _dimension(
        frame,
        "aircraft_id",
        {"aircraft_id": "source_aircraft_id"},
        ["registration", "manufacturer", "model"],
    )
    result["capacity"] = pd.to_numeric(result["capacity"], errors="coerce")
    return result.dropna(subset=["capacity"]).loc[lambda data: data["capacity"] > 0]


def transform_statuses(frame: pd.DataFrame) -> pd.DataFrame:
    """Clean and deduplicate flight statuses."""
    return _dimension(frame, "status_id", {"status_id": "source_status_id"}, ["name"])


def build_date_dimension(flights: pd.DataFrame) -> pd.DataFrame:
    """Generate DimDate from valid scheduled departure dates."""
    dates = (
        pd.to_datetime(flights["scheduled_departure"], errors="coerce")
        .dropna()
        .dt.normalize()
        .drop_duplicates()
    )
    result = pd.DataFrame({"date_value": dates})
    result["date_key"] = result["date_value"].dt.strftime("%Y%m%d").astype(int)
    result["day_number"] = result["date_value"].dt.day
    result["month_number"] = result["date_value"].dt.month
    result["month_name"] = result["date_value"].dt.month_name()
    result["quarter_number"] = result["date_value"].dt.quarter
    result["year_number"] = result["date_value"].dt.year
    result["day_of_week"] = result["date_value"].dt.day_name()
    return result[
        [
            "date_key",
            "date_value",
            "day_number",
            "month_number",
            "month_name",
            "quarter_number",
            "year_number",
            "day_of_week",
        ]
    ]
