"""Centralized SQLAlchemy engines for the OLTP and OLAP databases."""

from __future__ import annotations

import os
from functools import lru_cache
from urllib.parse import quote_plus

from dotenv import load_dotenv
from sqlalchemy import Engine, create_engine


@lru_cache(maxsize=1)
def _database_settings() -> tuple[str, str, str, str, str, str]:
    """Load and validate the connection settings shared by both databases."""
    load_dotenv()
    required = ("DB_HOST", "DB_PORT", "DB_USER", "DB_PASSWORD", "OLTP_DATABASE", "OLAP_DATABASE")
    missing = [name for name in required if not os.getenv(name)]
    if missing:
        raise RuntimeError(f"Missing required environment variables: {', '.join(missing)}")

    return tuple(os.environ[name] for name in required)  # type: ignore[return-value]


def get_engine(database_name: str) -> Engine:
    """Return a pooled MySQL engine for the requested configured database."""
    host, port, user, password, oltp_database, olap_database = _database_settings()
    if database_name not in (oltp_database, olap_database):
        raise ValueError("Database must be OLTP_DATABASE or OLAP_DATABASE from .env")

    url = f"mysql+pymysql://{quote_plus(user)}:{quote_plus(password)}@{host}:{port}/{database_name}"
    return create_engine(url, pool_pre_ping=True)


def get_oltp_engine() -> Engine:
    """Return the engine connected to flight_management."""
    return get_engine(_database_settings()[4])


def get_olap_engine() -> Engine:
    """Return the engine connected to flight_analytics."""
    return get_engine(_database_settings()[5])
