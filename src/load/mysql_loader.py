"""Idempotent MySQL loading for dimensions and FactFlight."""

from __future__ import annotations

import logging
from typing import Any

import pandas as pd
from sqlalchemy import Engine, text
from sqlalchemy.engine import Connection

LOGGER = logging.getLogger(__name__)
BATCH_SIZE = 1_000
ALLOWED_TABLES = frozenset(
    {
        "dim_date",
        "dim_airline",
        "dim_airport",
        "dim_aircraft",
        "dim_flight_status",
        "fact_flight",
    }
)


class MySQLLoader:
    """Load dimensional data with MySQL UPSERT statements."""

    def __init__(self, engine: Engine) -> None:
        """Store the centralized OLAP engine used for transactional writes."""
        self.engine = engine

    @staticmethod
    def _records(frame: pd.DataFrame) -> list[dict[str, Any]]:
        """Convert Pandas scalar values to database-driver-compatible Python values."""
        records: list[dict[str, Any]] = []
        for record in frame.to_dict(orient="records"):
            cleaned: dict[str, Any] = {}
            for column, value in record.items():
                if pd.isna(value):
                    cleaned[column] = None
                elif isinstance(value, pd.Timestamp):
                    cleaned[column] = value.to_pydatetime()
                elif hasattr(value, "item"):
                    cleaned[column] = value.item()
                else:
                    cleaned[column] = value
            records.append(cleaned)
        return records

    def _upsert(
        self, connection: Connection, table: str, frame: pd.DataFrame, natural_key: str
    ) -> None:
        """Upsert one DataFrame in bounded batches using its natural key."""
        if table not in ALLOWED_TABLES:
            raise ValueError(f"Unsupported OLAP table: {table}")
        if frame.empty:
            LOGGER.info("No rows to load into %s", table)
            return
        columns = list(frame.columns)
        update_columns = [column for column in columns if column != natural_key]
        # Identifiers come from the fixed ETL schema and are checked against ALLOWED_TABLES.
        statement_sql = (
            f"INSERT INTO {table} ({', '.join(columns)}) "  # noqa: S608
            f"VALUES ({', '.join(f':{column}' for column in columns)}) "
            "ON DUPLICATE KEY UPDATE "
            f"{', '.join(f'{column} = VALUES({column})' for column in update_columns)}"
        )
        statement = text(statement_sql)
        records = self._records(frame)
        for start in range(0, len(records), BATCH_SIZE):
            connection.execute(statement, records[start : start + BATCH_SIZE])
        LOGGER.info("Loaded %d rows into %s in batches of %d", len(frame), table, BATCH_SIZE)

    @staticmethod
    def _key_map(
        connection: Connection, table: str, source_column: str, key_column: str
    ) -> pd.Series:
        """Read an approved dimension's source-to-surrogate-key mapping."""
        if table not in ALLOWED_TABLES:
            raise ValueError(f"Unsupported OLAP table: {table}")
        query = text(f"SELECT {source_column}, {key_column} FROM {table}")  # noqa: S608
        frame = pd.read_sql(query, connection)
        return frame.set_index(source_column)[key_column]

    def _resolve_fact_keys(self, connection: Connection, facts: pd.DataFrame) -> pd.DataFrame:
        """Replace OLTP foreign keys with OLAP surrogate keys for fact loading."""
        result = facts.copy()
        mappings = (
            ("airline_id", "dim_airline", "source_airline_id", "airline_key", "airline_key"),
            ("aircraft_id", "dim_aircraft", "source_aircraft_id", "aircraft_key", "aircraft_key"),
            (
                "origin_airport_id",
                "dim_airport",
                "source_airport_id",
                "airport_key",
                "origin_airport_key",
            ),
            (
                "destination_airport_id",
                "dim_airport",
                "source_airport_id",
                "airport_key",
                "destination_airport_key",
            ),
            ("status_id", "dim_flight_status", "source_status_id", "status_key", "status_key"),
        )
        for fact_column, table, source_column, key_column, target_column in mappings:
            result[target_column] = result[fact_column].map(
                self._key_map(connection, table, source_column, key_column)
            )

        key_columns = [
            "airline_key",
            "aircraft_key",
            "origin_airport_key",
            "destination_airport_key",
            "status_key",
        ]
        if result[key_columns].isna().any().any():
            unresolved = result.loc[
                result[key_columns].isna().any(axis=1), "source_flight_id"
            ].tolist()
            raise ValueError(f"Unable to resolve dimension keys for source flights: {unresolved}")

        return result[
            [
                "source_flight_id",
                "date_key",
                "airline_key",
                "aircraft_key",
                "origin_airport_key",
                "destination_airport_key",
                "status_key",
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

    def load(self, dimensions: dict[str, pd.DataFrame], facts: pd.DataFrame) -> None:
        """Load all dimensions and facts atomically, updating existing natural keys."""
        with self.engine.begin() as connection:
            self._upsert(connection, "dim_date", dimensions["date"], "date_key")
            self._upsert(connection, "dim_airline", dimensions["airline"], "source_airline_id")
            self._upsert(connection, "dim_airport", dimensions["airport"], "source_airport_id")
            self._upsert(connection, "dim_aircraft", dimensions["aircraft"], "source_aircraft_id")
            self._upsert(connection, "dim_flight_status", dimensions["status"], "source_status_id")
            self._upsert(
                connection,
                "fact_flight",
                self._resolve_fact_keys(connection, facts),
                "source_flight_id",
            )
