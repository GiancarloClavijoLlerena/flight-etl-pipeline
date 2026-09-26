"""Unit tests for flight cleansing, metrics, and quality controls."""

import pandas as pd

from src.transform.flights import transform_flights


def _flight(**overrides: object) -> dict[str, object]:
    """Build a valid finalised flight and override only the fields needed by a test."""
    flight = {
        "flight_id": 1,
        "flight_number": "LA100",
        "airline_id": 1,
        "aircraft_id": 1,
        "origin_airport_id": 1,
        "destination_airport_id": 2,
        "status_id": 4,
        "status_name": "Finalizado",
        "scheduled_departure": "2026-09-20 08:00:00",
        "actual_departure": "2026-09-20 08:10:00",
        "scheduled_arrival": "2026-09-20 10:00:00",
        "actual_arrival": "2026-09-20 10:05:00",
        "distance": 500.0,
    }
    flight.update(overrides)
    return flight


def test_transform_flights_calculates_metrics_and_rejects_invalid_rows() -> None:
    """Keep only valid flights and expose a quality count for each invalid case."""
    frame = pd.DataFrame(
        [
            _flight(),
            _flight(flight_id=2, flight_number="LA101", distance=0),
            _flight(
                flight_id=3,
                flight_number="LA102",
                status_id=5,
                status_name="Cancelado",
            ),
            _flight(
                flight_id=4,
                flight_number="LA103",
                actual_departure="2026-09-20 10:00:00",
                actual_arrival="2026-09-20 09:30:00",
            ),
            _flight(flight_id=5, flight_number="   "),
            _flight(
                flight_id=6,
                flight_number="LA105",
                status_id=6,
                status_name="Sin confirmar",
                actual_departure=None,
                actual_arrival=None,
            ),
        ]
    )

    result = transform_flights(frame)

    assert result.flights["source_flight_id"].tolist() == [1]
    assert result.flights.loc[0, "scheduled_duration_minutes"] == 120
    assert result.flights.loc[0, "actual_duration_minutes"] == 115
    assert result.flights.loc[0, "departure_delay_minutes"] == 10
    assert result.flights.loc[0, "arrival_delay_minutes"] == 5
    assert result.quality_metrics == {
        "source_flights": 6,
        "missing_required": 1,
        "duplicate_flight_id": 0,
        "invalid_distance": 1,
        "same_origin_destination": 0,
        "invalid_scheduled_timeline": 0,
        "unknown_status": 1,
        "invalid_actual_timeline": 1,
        "inconsistent_operational_status": 1,
        "valid_flights": 1,
    }
