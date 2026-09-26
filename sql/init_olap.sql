CREATE DATABASE IF NOT EXISTS flight_analytics
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE flight_analytics;

CREATE TABLE IF NOT EXISTS dim_date (
    date_key INT PRIMARY KEY,
    date_value DATE NOT NULL UNIQUE,
    day_number TINYINT NOT NULL,
    month_number TINYINT NOT NULL,
    month_name VARCHAR(20) NOT NULL,
    quarter_number TINYINT NOT NULL,
    year_number SMALLINT NOT NULL,
    day_of_week VARCHAR(20) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS dim_airline (
    airline_key INT AUTO_INCREMENT PRIMARY KEY,
    source_airline_id INT NOT NULL UNIQUE,
    code VARCHAR(10) NOT NULL,
    name VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS dim_airport (
    airport_key INT AUTO_INCREMENT PRIMARY KEY,
    source_airport_id INT NOT NULL UNIQUE,
    iata_code CHAR(3) NOT NULL,
    name VARCHAR(150) NOT NULL,
    city VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS dim_aircraft (
    aircraft_key INT AUTO_INCREMENT PRIMARY KEY,
    source_aircraft_id INT NOT NULL UNIQUE,
    registration VARCHAR(20) NOT NULL,
    manufacturer VARCHAR(100) NOT NULL,
    model VARCHAR(100) NOT NULL,
    capacity SMALLINT NOT NULL,
    CONSTRAINT chk_dim_aircraft_capacity CHECK (capacity > 0)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS dim_flight_status (
    status_key INT AUTO_INCREMENT PRIMARY KEY,
    source_status_id TINYINT NOT NULL UNIQUE,
    name VARCHAR(30) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS fact_flight (
    flight_key BIGINT AUTO_INCREMENT PRIMARY KEY,
    source_flight_id BIGINT NOT NULL UNIQUE,
    date_key INT NOT NULL,
    airline_key INT NOT NULL,
    aircraft_key INT NOT NULL,
    origin_airport_key INT NOT NULL,
    destination_airport_key INT NOT NULL,
    status_key INT NOT NULL,
    flight_number VARCHAR(10) NOT NULL,
    flight_count INT NOT NULL DEFAULT 1,
    distance DECIMAL(8,2) NOT NULL,
    scheduled_duration_minutes INT NULL,
    actual_duration_minutes INT NULL,
    departure_delay_minutes INT NULL,
    arrival_delay_minutes INT NULL,
    cancelled_flag TINYINT NOT NULL DEFAULT 0,
    CONSTRAINT chk_fact_flight_count CHECK (flight_count = 1),
    CONSTRAINT chk_fact_flight_distance CHECK (distance > 0),
    CONSTRAINT fk_fact_date FOREIGN KEY (date_key) REFERENCES dim_date(date_key),
    CONSTRAINT fk_fact_airline FOREIGN KEY (airline_key) REFERENCES dim_airline(airline_key),
    CONSTRAINT fk_fact_aircraft FOREIGN KEY (aircraft_key) REFERENCES dim_aircraft(aircraft_key),
    CONSTRAINT fk_fact_origin_airport FOREIGN KEY (origin_airport_key) REFERENCES dim_airport(airport_key),
    CONSTRAINT fk_fact_destination_airport FOREIGN KEY (destination_airport_key) REFERENCES dim_airport(airport_key),
    CONSTRAINT fk_fact_status FOREIGN KEY (status_key) REFERENCES dim_flight_status(status_key)
) ENGINE=InnoDB;
