"""Pipeline orchestration for the flight ETL process."""

from __future__ import annotations

import logging

from src.database.connection import get_olap_engine, get_oltp_engine
from src.extract.mysql_extractor import MySQLExtractor
from src.load.mysql_loader import MySQLLoader
from src.transform.dimensions import (
    build_date_dimension,
    transform_aircraft,
    transform_airlines,
    transform_airports,
    transform_statuses,
)
from src.transform.flights import reject_unresolved_dimension_references, transform_flights

LOGGER = logging.getLogger(__name__)


class FlightETLPipeline:
    """Coordinate the Extract, Transform, and Load stages."""

    def run(self) -> None:
        """Execute the full ETL process and propagate failures to the caller."""
        try:
            LOGGER.info("Starting Flight ETL Pipeline")
            LOGGER.info("Connecting to OLTP database")
            extracted = MySQLExtractor(get_oltp_engine()).extract_all()

            LOGGER.info("Transforming dimensions")
            transformation = transform_flights(extracted["flights"])
            dimensions = {
                "airline": transform_airlines(extracted["airlines"]),
                "airport": transform_airports(extracted["airports"]),
                "aircraft": transform_aircraft(extracted["aircraft"]),
                "status": transform_statuses(extracted["statuses"]),
            }
            for name, source_name in (
                ("airline", "airlines"),
                ("airport", "airports"),
                ("aircraft", "aircraft"),
                ("status", "statuses"),
            ):
                source_count = len(extracted[source_name])
                valid_count = len(dimensions[name])
                LOGGER.info(
                    "Dimension quality: %s source=%d, accepted=%d, rejected=%d",
                    name,
                    source_count,
                    valid_count,
                    source_count - valid_count,
                )
            facts, unresolved_references = reject_unresolved_dimension_references(
                transformation.flights, dimensions
            )
            dimensions["date"] = build_date_dimension(facts)
            quality = {
                **transformation.quality_metrics,
                "unresolved_dimension_references": unresolved_references,
                "loaded_flights": len(facts),
            }
            LOGGER.info(
                "Data quality: source=%d, missing=%d, duplicates=%d, invalid_distance=%d, "
                "same_airport=%d, invalid_schedule=%d, unknown_status=%d, invalid_actual=%d, "
                "inconsistent_status=%d, unresolved_dimensions=%d, loaded=%d",
                quality["source_flights"],
                quality["missing_required"],
                quality["duplicate_flight_id"],
                quality["invalid_distance"],
                quality["same_origin_destination"],
                quality["invalid_scheduled_timeline"],
                quality["unknown_status"],
                quality["invalid_actual_timeline"],
                quality["inconsistent_operational_status"],
                quality["unresolved_dimension_references"],
                quality["loaded_flights"],
            )
            LOGGER.info("Calculating flight metrics for %d valid flights", len(facts))

            LOGGER.info("Connecting to OLAP database")
            MySQLLoader(get_olap_engine()).load(dimensions, facts)
            LOGGER.info("ETL Pipeline completed successfully")
        except Exception:
            LOGGER.exception("ETL Pipeline failed")
            raise
