"""Unit tests for dimension cleaning and calendar generation."""

import pandas as pd

from src.transform.dimensions import build_date_dimension, transform_aircraft, transform_airlines


def test_dimension_transformations_normalize_text_and_filter_invalid_rows() -> None:
    """Normalize valid dimension values and reject empty attributes or invalid capacity."""
    airlines = pd.DataFrame(
        [
            {"airline_id": 1, "code": " PA ", "name": "  Peru   Air ", "country": " Peru "},
            {"airline_id": 2, "code": "BAD", "name": "   ", "country": "Peru"},
        ]
    )
    aircraft = pd.DataFrame(
        [
            {
                "aircraft_id": 1,
                "registration": " OB-100 ",
                "manufacturer": " Airbus ",
                "model": " A320 ",
                "capacity": 180,
            },
            {
                "aircraft_id": 2,
                "registration": " TEST-0 ",
                "manufacturer": " Boeing ",
                "model": " 737 ",
                "capacity": 0,
            },
        ]
    )

    cleaned_airlines = transform_airlines(airlines)
    cleaned_aircraft = transform_aircraft(aircraft)

    assert cleaned_airlines.to_dict(orient="records") == [
        {"source_airline_id": 1, "code": "PA", "name": "Peru Air", "country": "Peru"}
    ]
    assert cleaned_aircraft["source_aircraft_id"].tolist() == [1]
    assert cleaned_aircraft.loc[0, "registration"] == "OB-100"


def test_build_date_dimension_creates_expected_calendar_attributes() -> None:
    """Create one date row per scheduled departure day with an integer date key."""
    flights = pd.DataFrame(
        {
            "scheduled_departure": [
                "2026-09-20 08:00:00",
                "2026-09-20 15:00:00",
                "2026-10-01 08:00:00",
            ]
        }
    )

    dates = build_date_dimension(flights)

    assert dates["date_key"].tolist() == [20260920, 20261001]
    assert dates["quarter_number"].tolist() == [3, 4]
    assert dates["day_of_week"].tolist() == ["Sunday", "Thursday"]
