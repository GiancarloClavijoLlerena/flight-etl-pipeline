"""Integration tests against the Docker MySQL environment."""

import os

import pytest
from sqlalchemy import text

from src.database import connection
from src.database.connection import get_olap_engine
from src.pipeline import FlightETLPipeline


@pytest.fixture
def docker_database_environment(monkeypatch: pytest.MonkeyPatch) -> None:
    """Configure the integration test to use the Docker MySQL host by default."""
    defaults = {
        "DB_HOST": "localhost",
        "DB_PORT": "3307",
        "DB_USER": "root",
        "DB_PASSWORD": "flight_etl_password",
        "OLTP_DATABASE": "flight_management",
        "OLAP_DATABASE": "flight_analytics",
    }
    for variable, default in defaults.items():
        monkeypatch.setenv(variable, os.getenv(f"TEST_{variable}", default))
    connection._database_settings.cache_clear()
    yield
    connection._database_settings.cache_clear()


@pytest.mark.integration
def test_pipeline_is_idempotent_against_mysql(docker_database_environment: None) -> None:
    """Run the pipeline twice and confirm that the fact table count remains stable."""
    pipeline = FlightETLPipeline()
    pipeline.run()
    with get_olap_engine().connect() as connection:
        first_count = connection.execute(text("SELECT COUNT(*) FROM fact_flight")).scalar_one()

    pipeline.run()
    with get_olap_engine().connect() as connection:
        second_count = connection.execute(text("SELECT COUNT(*) FROM fact_flight")).scalar_one()

    assert first_count > 0
    assert second_count == first_count
