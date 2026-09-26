"""Executable entry point for the Flight ETL Pipeline."""

from __future__ import annotations

import logging
import sys
from pathlib import Path

from src.pipeline import FlightETLPipeline


def configure_logging() -> None:
    """Write operational logs to the console and logs/flight_etl.log."""
    log_file = Path(__file__).parent / "logs" / "flight_etl.log"
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s [%(levelname)s] %(message)s",
        handlers=[logging.StreamHandler(), logging.FileHandler(log_file, encoding="utf-8")],
    )


def main() -> None:
    """Configure logging and run the ETL process with a nonzero failure exit code."""
    configure_logging()
    try:
        FlightETLPipeline().run()
    except Exception:
        sys.exit(1)


if __name__ == "__main__":
    main()
