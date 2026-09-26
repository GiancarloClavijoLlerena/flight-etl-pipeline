"""Read-only extraction queries for the flight_management OLTP database."""

from __future__ import annotations

import logging

import pandas as pd
from sqlalchemy import Engine, text

LOGGER = logging.getLogger(__name__)


class MySQLExtractor:
    """Extract OLTP entities as Pandas DataFrames without transforming them."""

    def __init__(self, engine: Engine) -> None:
        """Store the centralized OLTP engine used for read-only queries."""
        self.engine = engine

    def extract_all(self) -> dict[str, pd.DataFrame]:
        """Extract every source entity required by the dimensional model."""
        queries = {
            "airlines": "SELECT airline_id, code, name, country FROM airline ORDER BY airline_id",
            "airports": (
                "SELECT airport_id, iata_code, name, city, country FROM airport ORDER BY airport_id"
            ),
            "aircraft": (
                "SELECT aircraft_id, registration, manufacturer, model, capacity "
                "FROM aircraft ORDER BY aircraft_id"
            ),
            "statuses": "SELECT status_id, name FROM flight_status ORDER BY status_id",
            "flights": """
                SELECT f.flight_id, f.flight_number, f.airline_id, f.aircraft_id,
                       f.origin_airport_id, f.destination_airport_id, f.status_id,
                       fs.name AS status_name, f.scheduled_departure, f.actual_departure,
                       f.scheduled_arrival, f.actual_arrival, f.distance
                FROM flight AS f
                INNER JOIN flight_status AS fs ON fs.status_id = f.status_id
                ORDER BY f.flight_id
            """,
        }
        frames: dict[str, pd.DataFrame] = {}
        with self.engine.connect() as connection:
            for name, query in queries.items():
                LOGGER.info("Extracting %s", name)
                frames[name] = pd.read_sql(text(query), connection)
                LOGGER.info("%d %s extracted", len(frames[name]), name)
        return frames
