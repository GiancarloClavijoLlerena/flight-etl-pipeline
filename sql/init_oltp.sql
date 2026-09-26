CREATE DATABASE IF NOT EXISTS flight_management
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE flight_management;

CREATE TABLE IF NOT EXISTS airline (
    airline_id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(10) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS airport (
    airport_id INT AUTO_INCREMENT PRIMARY KEY,
    iata_code CHAR(3) NOT NULL UNIQUE,
    name VARCHAR(150) NOT NULL,
    city VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS aircraft (
    aircraft_id INT AUTO_INCREMENT PRIMARY KEY,
    registration VARCHAR(20) NOT NULL UNIQUE,
    manufacturer VARCHAR(100) NOT NULL,
    model VARCHAR(100) NOT NULL,
    capacity SMALLINT NOT NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS flight_status (
    status_id TINYINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS flight (
    flight_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    flight_number VARCHAR(10) NOT NULL,
    airline_id INT NOT NULL,
    aircraft_id INT NOT NULL,
    origin_airport_id INT NOT NULL,
    destination_airport_id INT NOT NULL,
    status_id TINYINT NOT NULL,
    scheduled_departure DATETIME NOT NULL,
    actual_departure DATETIME NULL,
    scheduled_arrival DATETIME NOT NULL,
    actual_arrival DATETIME NULL,
    distance DECIMAL(8,2) NOT NULL,
    CONSTRAINT fk_flight_airline FOREIGN KEY (airline_id) REFERENCES airline(airline_id),
    CONSTRAINT fk_flight_aircraft FOREIGN KEY (aircraft_id) REFERENCES aircraft(aircraft_id),
    CONSTRAINT fk_flight_origin FOREIGN KEY (origin_airport_id) REFERENCES airport(airport_id),
    CONSTRAINT fk_flight_destination FOREIGN KEY (destination_airport_id) REFERENCES airport(airport_id),
    CONSTRAINT fk_flight_status FOREIGN KEY (status_id) REFERENCES flight_status(status_id)
) ENGINE=InnoDB;
