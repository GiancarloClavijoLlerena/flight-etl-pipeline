USE flight_management;

INSERT INTO airline (code, name, country) VALUES
    ('LAT', 'LATAM Airlines', 'Chile'),
    ('AVA', 'Avianca', 'Colombia'),
    ('COP', 'Copa Airlines', 'Panama'),
    ('AAL', 'American Airlines', 'United States'),
    ('DAL', 'Delta Air Lines', 'United States'),
    ('IBE', 'Iberia', 'Spain'),
    ('UAE', 'Emirates', 'United Arab Emirates'),
    ('KLM', 'KLM Royal Dutch Airlines', 'Netherlands'),
    ('AFR', 'Air France', 'France'),
    ('BAW', 'British Airways', 'United Kingdom'),
    ('LUF', 'Lufthansa', 'Germany'),
    ('AZU', 'Azul Brazilian Airlines', 'Brazil'),
    ('ARG', 'Aerolineas Argentinas', 'Argentina'),
    ('AMX', 'Aeromexico', 'Mexico'),
    ('ACA', 'Air Canada', 'Canada'),
    ('UAL', 'United Airlines', 'United States'),
    ('SWA', 'Southwest Airlines', 'United States'),
    ('QTR', 'Qatar Airways', 'Qatar'),
    ('ANA', 'All Nippon Airways', 'Japan'),
    ('QFA', 'Qantas', 'Australia')
ON DUPLICATE KEY UPDATE name = VALUES(name), country = VALUES(country);

INSERT INTO airport (iata_code, name, city, country) VALUES
    ('LIM', 'Jorge Chavez International Airport', 'Lima', 'Peru'),
    ('BOG', 'El Dorado International Airport', 'Bogota', 'Colombia'),
    ('SCL', 'Arturo Merino Benitez International Airport', 'Santiago', 'Chile'),
    ('MIA', 'Miami International Airport', 'Miami', 'United States'),
    ('PTY', 'Tocumen International Airport', 'Panama City', 'Panama'),
    ('MAD', 'Adolfo Suarez Madrid-Barajas Airport', 'Madrid', 'Spain'),
    ('JFK', 'John F. Kennedy International Airport', 'New York', 'United States'),
    ('EZE', 'Ministro Pistarini International Airport', 'Buenos Aires', 'Argentina'),
    ('CUN', 'Cancun International Airport', 'Cancun', 'Mexico'),
    ('GYE', 'Jose Joaquin de Olmedo International Airport', 'Guayaquil', 'Ecuador'),
    ('GRU', 'Sao Paulo-Guarulhos International Airport', 'Sao Paulo', 'Brazil'),
    ('MEX', 'Benito Juarez International Airport', 'Mexico City', 'Mexico'),
    ('LAX', 'Los Angeles International Airport', 'Los Angeles', 'United States'),
    ('ORD', 'O Hare International Airport', 'Chicago', 'United States'),
    ('ATL', 'Hartsfield-Jackson Atlanta International Airport', 'Atlanta', 'United States'),
    ('CDG', 'Charles de Gaulle Airport', 'Paris', 'France'),
    ('LHR', 'Heathrow Airport', 'London', 'United Kingdom'),
    ('FRA', 'Frankfurt Airport', 'Frankfurt', 'Germany'),
    ('AMS', 'Amsterdam Airport Schiphol', 'Amsterdam', 'Netherlands'),
    ('DXB', 'Dubai International Airport', 'Dubai', 'United Arab Emirates'),
    ('DOH', 'Hamad International Airport', 'Doha', 'Qatar'),
    ('YYZ', 'Toronto Pearson International Airport', 'Toronto', 'Canada'),
    ('NRT', 'Narita International Airport', 'Tokyo', 'Japan'),
    ('SYD', 'Sydney Kingsford Smith Airport', 'Sydney', 'Australia'),
    ('BCN', 'Josep Tarradellas Barcelona-El Prat Airport', 'Barcelona', 'Spain'),
    ('FCO', 'Leonardo da Vinci-Fiumicino Airport', 'Rome', 'Italy'),
    ('SFO', 'San Francisco International Airport', 'San Francisco', 'United States'),
    ('YUL', 'Montreal-Trudeau International Airport', 'Montreal', 'Canada'),
    ('MDE', 'Jose Maria Cordova International Airport', 'Medellin', 'Colombia'),
    ('UIO', 'Mariscal Sucre International Airport', 'Quito', 'Ecuador')
ON DUPLICATE KEY UPDATE
    name = VALUES(name), city = VALUES(city), country = VALUES(country);

INSERT INTO aircraft (registration, manufacturer, model, capacity) VALUES
    ('CC-BGA', 'Airbus', 'A320-200', 180),
    ('N783AV', 'Airbus', 'A320neo', 165),
    ('HP-1830CMP', 'Boeing', '737-800', 160),
    ('N901AN', 'Boeing', '787-9 Dreamliner', 285),
    ('N412DX', 'Airbus', 'A321neo', 197),
    ('EC-MXY', 'Airbus', 'A330-200', 288),
    ('CC-COL', 'Boeing', '787-9 Dreamliner', 300),
    ('N622VA', 'Airbus', 'A320-200', 150),
    ('PT-MXA', 'Airbus', 'A321neo', 214),
    ('LV-KAN', 'Boeing', '737-800', 170),
    ('XA-ABC', 'Boeing', '737 MAX 8', 186),
    ('N123UA', 'Boeing', '737 MAX 9', 179),
    ('N456WN', 'Boeing', '737-800', 175),
    ('A6-EQA', 'Airbus', 'A380-800', 517),
    ('A7-BAA', 'Boeing', '787-8 Dreamliner', 254),
    ('PH-BKA', 'Boeing', '787-10 Dreamliner', 344),
    ('F-GZND', 'Airbus', 'A350-900', 324),
    ('G-EUYN', 'Airbus', 'A320neo', 180),
    ('D-AIXA', 'Airbus', 'A350-900', 293),
    ('C-GAUN', 'Boeing', '787-9 Dreamliner', 298),
    ('JA801A', 'Boeing', '787-8 Dreamliner', 184),
    ('VH-QPA', 'Airbus', 'A330-300', 297),
    ('EC-NGT', 'Airbus', 'A320-200', 171),
    ('N395AN', 'Airbus', 'A321neo', 196),
    ('N501DL', 'Airbus', 'A220-300', 130),
    ('HP-1840CMP', 'Boeing', '737-800', 160),
    ('CC-BHB', 'Airbus', 'A321neo', 224),
    ('N789UA', 'Boeing', '787-9 Dreamliner', 257),
    ('C-GHPB', 'Airbus', 'A220-300', 137),
    ('A6-EOB', 'Boeing', '777-300ER', 354)
ON DUPLICATE KEY UPDATE
    manufacturer = VALUES(manufacturer), model = VALUES(model), capacity = VALUES(capacity);

INSERT INTO flight_status (name) VALUES
    ('Programado'),
    ('Retrasado'),
    ('En curso'),
    ('Finalizado'),
    ('Cancelado')
ON DUPLICATE KEY UPDATE name = VALUES(name);

-- Each INSERT is idempotent by the operational flight number and scheduled departure.
INSERT INTO flight (flight_number, airline_id, aircraft_id, origin_airport_id, destination_airport_id, status_id, scheduled_departure, actual_departure, scheduled_arrival, actual_arrival, distance)
SELECT 'LA2380', a.airline_id, ac.aircraft_id, origin.airport_id, destination.airport_id, s.status_id,
       '2026-09-20 06:10:00', '2026-09-20 06:12:00', '2026-09-20 11:50:00', '2026-09-20 11:45:00', 4118.00
FROM airline a, aircraft ac, airport origin, airport destination, flight_status s
WHERE a.code = 'LAT' AND ac.registration = 'CC-BGA' AND origin.iata_code = 'LIM' AND destination.iata_code = 'SCL' AND s.name = 'Finalizado'
  AND NOT EXISTS (SELECT 1 FROM flight f WHERE f.flight_number = 'LA2380' AND f.scheduled_departure = '2026-09-20 06:10:00');

INSERT INTO flight (flight_number, airline_id, aircraft_id, origin_airport_id, destination_airport_id, status_id, scheduled_departure, actual_departure, scheduled_arrival, actual_arrival, distance)
SELECT 'AV074', a.airline_id, ac.aircraft_id, origin.airport_id, destination.airport_id, s.status_id,
       '2026-09-20 07:00:00', '2026-09-20 07:42:00', '2026-09-20 10:05:00', '2026-09-20 10:48:00', 1887.00
FROM airline a, aircraft ac, airport origin, airport destination, flight_status s
WHERE a.code = 'AVA' AND ac.registration = 'N783AV' AND origin.iata_code = 'BOG' AND destination.iata_code = 'LIM' AND s.name = 'Retrasado'
  AND NOT EXISTS (SELECT 1 FROM flight f WHERE f.flight_number = 'AV074' AND f.scheduled_departure = '2026-09-20 07:00:00');

INSERT INTO flight (flight_number, airline_id, aircraft_id, origin_airport_id, destination_airport_id, status_id, scheduled_departure, actual_departure, scheduled_arrival, actual_arrival, distance)
SELECT 'CM132', a.airline_id, ac.aircraft_id, origin.airport_id, destination.airport_id, s.status_id,
       '2026-09-20 08:35:00', '2026-09-20 08:25:00', '2026-09-20 11:20:00', '2026-09-20 11:05:00', 1795.00
FROM airline a, aircraft ac, airport origin, airport destination, flight_status s
WHERE a.code = 'COP' AND ac.registration = 'HP-1830CMP' AND origin.iata_code = 'PTY' AND destination.iata_code = 'BOG' AND s.name = 'Finalizado'
  AND NOT EXISTS (SELECT 1 FROM flight f WHERE f.flight_number = 'CM132' AND f.scheduled_departure = '2026-09-20 08:35:00');

INSERT INTO flight (flight_number, airline_id, aircraft_id, origin_airport_id, destination_airport_id, status_id, scheduled_departure, actual_departure, scheduled_arrival, actual_arrival, distance)
SELECT 'AA918', a.airline_id, ac.aircraft_id, origin.airport_id, destination.airport_id, s.status_id,
       '2026-09-20 10:30:00', '2026-09-20 10:31:00', '2026-09-20 18:55:00', '2026-09-20 19:20:00', 7109.00
FROM airline a, aircraft ac, airport origin, airport destination, flight_status s
WHERE a.code = 'AAL' AND ac.registration = 'N901AN' AND origin.iata_code = 'MIA' AND destination.iata_code = 'MAD' AND s.name = 'Finalizado'
  AND NOT EXISTS (SELECT 1 FROM flight f WHERE f.flight_number = 'AA918' AND f.scheduled_departure = '2026-09-20 10:30:00');

INSERT INTO flight (flight_number, airline_id, aircraft_id, origin_airport_id, destination_airport_id, status_id, scheduled_departure, actual_departure, scheduled_arrival, actual_arrival, distance)
SELECT 'DL203', a.airline_id, ac.aircraft_id, origin.airport_id, destination.airport_id, s.status_id,
       '2026-09-21 06:00:00', '2026-09-21 06:18:00', '2026-09-21 09:10:00', '2026-09-21 09:28:00', 1757.00
FROM airline a, aircraft ac, airport origin, airport destination, flight_status s
WHERE a.code = 'DAL' AND ac.registration = 'N412DX' AND origin.iata_code = 'MIA' AND destination.iata_code = 'JFK' AND s.name = 'Finalizado'
  AND NOT EXISTS (SELECT 1 FROM flight f WHERE f.flight_number = 'DL203' AND f.scheduled_departure = '2026-09-21 06:00:00');

INSERT INTO flight (flight_number, airline_id, aircraft_id, origin_airport_id, destination_airport_id, status_id, scheduled_departure, actual_departure, scheduled_arrival, actual_arrival, distance)
SELECT 'IB6024', a.airline_id, ac.aircraft_id, origin.airport_id, destination.airport_id, s.status_id,
       '2026-09-21 12:15:00', NULL, '2026-09-21 23:00:00', NULL, 10050.00
FROM airline a, aircraft ac, airport origin, airport destination, flight_status s
WHERE a.code = 'IBE' AND ac.registration = 'EC-MXY' AND origin.iata_code = 'MAD' AND destination.iata_code = 'LIM' AND s.name = 'Cancelado'
  AND NOT EXISTS (SELECT 1 FROM flight f WHERE f.flight_number = 'IB6024' AND f.scheduled_departure = '2026-09-21 12:15:00');

INSERT INTO flight (flight_number, airline_id, aircraft_id, origin_airport_id, destination_airport_id, status_id, scheduled_departure, actual_departure, scheduled_arrival, actual_arrival, distance)
SELECT 'LA405', a.airline_id, ac.aircraft_id, origin.airport_id, destination.airport_id, s.status_id,
       '2026-09-21 14:20:00', '2026-09-21 14:20:00', '2026-09-21 16:25:00', '2026-09-21 16:18:00', 1138.00
FROM airline a, aircraft ac, airport origin, airport destination, flight_status s
WHERE a.code = 'LAT' AND ac.registration = 'CC-COL' AND origin.iata_code = 'SCL' AND destination.iata_code = 'EZE' AND s.name = 'Finalizado'
  AND NOT EXISTS (SELECT 1 FROM flight f WHERE f.flight_number = 'LA405' AND f.scheduled_departure = '2026-09-21 14:20:00');

INSERT INTO flight (flight_number, airline_id, aircraft_id, origin_airport_id, destination_airport_id, status_id, scheduled_departure, actual_departure, scheduled_arrival, actual_arrival, distance)
SELECT 'AV8381', a.airline_id, ac.aircraft_id, origin.airport_id, destination.airport_id, s.status_id,
       '2026-09-22 05:45:00', '2026-09-22 06:30:00', '2026-09-22 07:55:00', '2026-09-22 08:40:00', 970.00
FROM airline a, aircraft ac, airport origin, airport destination, flight_status s
WHERE a.code = 'AVA' AND ac.registration = 'N622VA' AND origin.iata_code = 'BOG' AND destination.iata_code = 'GYE' AND s.name = 'Retrasado'
  AND NOT EXISTS (SELECT 1 FROM flight f WHERE f.flight_number = 'AV8381' AND f.scheduled_departure = '2026-09-22 05:45:00');

INSERT INTO flight (flight_number, airline_id, aircraft_id, origin_airport_id, destination_airport_id, status_id, scheduled_departure, actual_departure, scheduled_arrival, actual_arrival, distance)
SELECT 'CM279', a.airline_id, ac.aircraft_id, origin.airport_id, destination.airport_id, s.status_id,
       '2026-09-22 09:10:00', '2026-09-22 09:28:00', '2026-09-22 12:25:00', NULL, 2413.00
FROM airline a, aircraft ac, airport origin, airport destination, flight_status s
WHERE a.code = 'COP' AND ac.registration = 'HP-1830CMP' AND origin.iata_code = 'PTY' AND destination.iata_code = 'MIA' AND s.name = 'En curso'
  AND NOT EXISTS (SELECT 1 FROM flight f WHERE f.flight_number = 'CM279' AND f.scheduled_departure = '2026-09-22 09:10:00');

INSERT INTO flight (flight_number, airline_id, aircraft_id, origin_airport_id, destination_airport_id, status_id, scheduled_departure, actual_departure, scheduled_arrival, actual_arrival, distance)
SELECT 'AA1045', a.airline_id, ac.aircraft_id, origin.airport_id, destination.airport_id, s.status_id,
       '2026-09-22 11:40:00', '2026-09-22 11:35:00', '2026-09-22 14:35:00', '2026-09-22 14:20:00', 1757.00
FROM airline a, aircraft ac, airport origin, airport destination, flight_status s
WHERE a.code = 'AAL' AND ac.registration = 'N412DX' AND origin.iata_code = 'JFK' AND destination.iata_code = 'MIA' AND s.name = 'Finalizado'
  AND NOT EXISTS (SELECT 1 FROM flight f WHERE f.flight_number = 'AA1045' AND f.scheduled_departure = '2026-09-22 11:40:00');

INSERT INTO flight (flight_number, airline_id, aircraft_id, origin_airport_id, destination_airport_id, status_id, scheduled_departure, actual_departure, scheduled_arrival, actual_arrival, distance)
SELECT 'DL1789', a.airline_id, ac.aircraft_id, origin.airport_id, destination.airport_id, s.status_id,
       '2026-09-23 08:25:00', NULL, '2026-09-23 10:20:00', NULL, 1224.00
FROM airline a, aircraft ac, airport origin, airport destination, flight_status s
WHERE a.code = 'DAL' AND ac.registration = 'N622VA' AND origin.iata_code = 'MIA' AND destination.iata_code = 'CUN' AND s.name = 'Programado'
  AND NOT EXISTS (SELECT 1 FROM flight f WHERE f.flight_number = 'DL1789' AND f.scheduled_departure = '2026-09-23 08:25:00');

INSERT INTO flight (flight_number, airline_id, aircraft_id, origin_airport_id, destination_airport_id, status_id, scheduled_departure, actual_departure, scheduled_arrival, actual_arrival, distance)
SELECT 'IB6650', a.airline_id, ac.aircraft_id, origin.airport_id, destination.airport_id, s.status_id,
       '2026-09-23 13:00:00', '2026-09-23 13:55:00', '2026-09-23 21:30:00', '2026-09-23 22:45:00', 5768.00
FROM airline a, aircraft ac, airport origin, airport destination, flight_status s
WHERE a.code = 'IBE' AND ac.registration = 'EC-MXY' AND origin.iata_code = 'MAD' AND destination.iata_code = 'JFK' AND s.name = 'Retrasado'
  AND NOT EXISTS (SELECT 1 FROM flight f WHERE f.flight_number = 'IB6650' AND f.scheduled_departure = '2026-09-23 13:00:00');

INSERT INTO flight (flight_number, airline_id, aircraft_id, origin_airport_id, destination_airport_id, status_id, scheduled_departure, actual_departure, scheduled_arrival, actual_arrival, distance)
SELECT 'LA1436', a.airline_id, ac.aircraft_id, origin.airport_id, destination.airport_id, s.status_id,
       '2026-09-24 07:30:00', '2026-09-24 07:36:00', '2026-09-24 10:20:00', '2026-09-24 10:35:00', 1887.00
FROM airline a, aircraft ac, airport origin, airport destination, flight_status s
WHERE a.code = 'LAT' AND ac.registration = 'CC-BGA' AND origin.iata_code = 'LIM' AND destination.iata_code = 'BOG' AND s.name = 'Finalizado'
  AND NOT EXISTS (SELECT 1 FROM flight f WHERE f.flight_number = 'LA1436' AND f.scheduled_departure = '2026-09-24 07:30:00');

INSERT INTO flight (flight_number, airline_id, aircraft_id, origin_airport_id, destination_airport_id, status_id, scheduled_departure, actual_departure, scheduled_arrival, actual_arrival, distance)
SELECT 'AV090', a.airline_id, ac.aircraft_id, origin.airport_id, destination.airport_id, s.status_id,
       '2026-09-24 16:45:00', '2026-09-24 16:40:00', '2026-09-24 19:55:00', '2026-09-24 19:40:00', 2413.00
FROM airline a, aircraft ac, airport origin, airport destination, flight_status s
WHERE a.code = 'AVA' AND ac.registration = 'N783AV' AND origin.iata_code = 'BOG' AND destination.iata_code = 'MIA' AND s.name = 'Finalizado'
  AND NOT EXISTS (SELECT 1 FROM flight f WHERE f.flight_number = 'AV090' AND f.scheduled_departure = '2026-09-24 16:45:00');

INSERT INTO flight (flight_number, airline_id, aircraft_id, origin_airport_id, destination_airport_id, status_id, scheduled_departure, actual_departure, scheduled_arrival, actual_arrival, distance)
SELECT 'CM493', a.airline_id, ac.aircraft_id, origin.airport_id, destination.airport_id, s.status_id,
       '2026-09-25 06:50:00', '2026-09-25 07:05:00', '2026-09-25 10:05:00', '2026-09-25 10:15:00', 2733.00
FROM airline a, aircraft ac, airport origin, airport destination, flight_status s
WHERE a.code = 'COP' AND ac.registration = 'HP-1830CMP' AND origin.iata_code = 'PTY' AND destination.iata_code = 'LIM' AND s.name = 'Finalizado'
  AND NOT EXISTS (SELECT 1 FROM flight f WHERE f.flight_number = 'CM493' AND f.scheduled_departure = '2026-09-25 06:50:00');

INSERT INTO flight (flight_number, airline_id, aircraft_id, origin_airport_id, destination_airport_id, status_id, scheduled_departure, actual_departure, scheduled_arrival, actual_arrival, distance)
SELECT 'AA2690', a.airline_id, ac.aircraft_id, origin.airport_id, destination.airport_id, s.status_id,
       '2026-09-25 14:15:00', NULL, '2026-09-25 17:05:00', NULL, 1757.00
FROM airline a, aircraft ac, airport origin, airport destination, flight_status s
WHERE a.code = 'AAL' AND ac.registration = 'N412DX' AND origin.iata_code = 'MIA' AND destination.iata_code = 'JFK' AND s.name = 'Cancelado'
  AND NOT EXISTS (SELECT 1 FROM flight f WHERE f.flight_number = 'AA2690' AND f.scheduled_departure = '2026-09-25 14:15:00');

INSERT INTO flight (flight_number, airline_id, aircraft_id, origin_airport_id, destination_airport_id, status_id, scheduled_departure, actual_departure, scheduled_arrival, actual_arrival, distance)
SELECT 'LA2680', a.airline_id, ac.aircraft_id, origin.airport_id, destination.airport_id, s.status_id,
       '2026-09-26 09:00:00', NULL, '2026-09-26 14:30:00', NULL, 4118.00
FROM airline a, aircraft ac, airport origin, airport destination, flight_status s
WHERE a.code = 'LAT' AND ac.registration = 'CC-COL' AND origin.iata_code = 'SCL' AND destination.iata_code = 'LIM' AND s.name = 'Programado'
  AND NOT EXISTS (SELECT 1 FROM flight f WHERE f.flight_number = 'LA2680' AND f.scheduled_departure = '2026-09-26 09:00:00');

-- Generate an additional operational history. The generated flight number and
-- scheduled departure make this section safe to execute repeatedly.
DELIMITER //

DROP PROCEDURE IF EXISTS seed_simulated_flights //

CREATE PROCEDURE seed_simulated_flights()
BEGIN
    DECLARE sequence_number INT DEFAULT 1;
    DECLARE airline_code VARCHAR(10);
    DECLARE aircraft_registration VARCHAR(20);
    DECLARE origin_code CHAR(3);
    DECLARE destination_code CHAR(3);
    DECLARE status_name VARCHAR(30);
    DECLARE scheduled_departure_value DATETIME;
    DECLARE scheduled_arrival_value DATETIME;
    DECLARE actual_departure_value DATETIME;
    DECLARE actual_arrival_value DATETIME;
    DECLARE airline_source_id INT;
    DECLARE aircraft_source_id INT;
    DECLARE origin_source_id INT;
    DECLARE destination_source_id INT;
    DECLARE status_source_id TINYINT;
    DECLARE duration_minutes INT;

    WHILE sequence_number <= 10000 DO
        SET airline_code = ELT(MOD(sequence_number - 1, 20) + 1, 'LAT', 'AVA', 'COP', 'AAL', 'DAL', 'IBE', 'UAE', 'KLM', 'AFR', 'BAW', 'LUF', 'AZU', 'ARG', 'AMX', 'ACA', 'UAL', 'SWA', 'QTR', 'ANA', 'QFA');
        SET aircraft_registration = ELT(MOD(sequence_number - 1, 30) + 1, 'CC-BGA', 'N783AV', 'HP-1830CMP', 'N901AN', 'N412DX', 'EC-MXY', 'CC-COL', 'N622VA', 'PT-MXA', 'LV-KAN', 'XA-ABC', 'N123UA', 'N456WN', 'A6-EQA', 'A7-BAA', 'PH-BKA', 'F-GZND', 'G-EUYN', 'D-AIXA', 'C-GAUN', 'JA801A', 'VH-QPA', 'EC-NGT', 'N395AN', 'N501DL', 'HP-1840CMP', 'CC-BHB', 'N789UA', 'C-GHPB', 'A6-EOB');
        SET origin_code = ELT(MOD(sequence_number - 1, 30) + 1, 'LIM', 'BOG', 'SCL', 'MIA', 'PTY', 'MAD', 'JFK', 'EZE', 'CUN', 'GYE', 'GRU', 'MEX', 'LAX', 'ORD', 'ATL', 'CDG', 'LHR', 'FRA', 'AMS', 'DXB', 'DOH', 'YYZ', 'NRT', 'SYD', 'BCN', 'FCO', 'SFO', 'YUL', 'MDE', 'UIO');
        SET destination_code = ELT(MOD(sequence_number + 6, 30) + 1, 'LIM', 'BOG', 'SCL', 'MIA', 'PTY', 'MAD', 'JFK', 'EZE', 'CUN', 'GYE', 'GRU', 'MEX', 'LAX', 'ORD', 'ATL', 'CDG', 'LHR', 'FRA', 'AMS', 'DXB', 'DOH', 'YYZ', 'NRT', 'SYD', 'BCN', 'FCO', 'SFO', 'YUL', 'MDE', 'UIO');
        SET status_name = ELT(MOD(sequence_number - 1, 5) + 1, 'Finalizado', 'Retrasado', 'Programado', 'En curso', 'Cancelado');
        SET scheduled_departure_value = TIMESTAMP(
            DATE_ADD('2026-08-01', INTERVAL FLOOR((sequence_number - 1) / 4) DAY),
            MAKETIME(6 + MOD(sequence_number, 14), MOD(sequence_number * 7, 60), 0)
        );
        SET duration_minutes = 95 + MOD(sequence_number * 23, 310);
        SET scheduled_arrival_value = DATE_ADD(scheduled_departure_value, INTERVAL duration_minutes MINUTE);
        SET actual_departure_value = NULL;
        SET actual_arrival_value = NULL;

        IF status_name = 'Finalizado' THEN
            SET actual_departure_value = DATE_ADD(scheduled_departure_value, INTERVAL (MOD(sequence_number, 16) - 6) MINUTE);
            SET actual_arrival_value = DATE_ADD(actual_departure_value, INTERVAL (duration_minutes + MOD(sequence_number, 21) - 10) MINUTE);
        ELSEIF status_name = 'Retrasado' THEN
            SET actual_departure_value = DATE_ADD(scheduled_departure_value, INTERVAL (20 + MOD(sequence_number, 71)) MINUTE);
            SET actual_arrival_value = DATE_ADD(actual_departure_value, INTERVAL (duration_minutes + MOD(sequence_number, 31)) MINUTE);
        ELSEIF status_name = 'En curso' THEN
            SET actual_departure_value = DATE_ADD(scheduled_departure_value, INTERVAL MOD(sequence_number, 18) MINUTE);
        END IF;

        SELECT airline_id INTO airline_source_id FROM airline WHERE code = airline_code;
        SELECT aircraft_id INTO aircraft_source_id FROM aircraft WHERE registration = aircraft_registration;
        SELECT airport_id INTO origin_source_id FROM airport WHERE iata_code = origin_code;
        SELECT airport_id INTO destination_source_id FROM airport WHERE iata_code = destination_code;
        SELECT status_id INTO status_source_id FROM flight_status WHERE name = status_name;

        INSERT INTO flight (
            flight_number, airline_id, aircraft_id, origin_airport_id, destination_airport_id,
            status_id, scheduled_departure, actual_departure, scheduled_arrival, actual_arrival, distance
        )
        SELECT
            CONCAT('SIM', LPAD(sequence_number, 4, '0')),
            airline_source_id,
            aircraft_source_id,
            origin_source_id,
            destination_source_id,
            status_source_id,
            scheduled_departure_value,
            actual_departure_value,
            scheduled_arrival_value,
            actual_arrival_value,
            550.00 + MOD(sequence_number * 137, 6500)
        WHERE NOT EXISTS (
            SELECT 1
            FROM flight AS existing_flight
            WHERE existing_flight.flight_number = CONCAT('SIM', LPAD(sequence_number, 4, '0'))
              AND existing_flight.scheduled_departure = scheduled_departure_value
        );

        SET sequence_number = sequence_number + 1;
    END WHILE;
END //

CALL seed_simulated_flights() //
DROP PROCEDURE seed_simulated_flights //

DELIMITER ;

-- Intentional dirty-source cases for ETL learning. The OLTP DDL keeps PK and
-- FK constraints but deliberately leaves business-quality rules to the ETL.
-- Do not use this section as a production data-loading pattern.

INSERT INTO airline (code, name, country) VALUES
    ('EDU', '   ', 'Training')
ON DUPLICATE KEY UPDATE name = VALUES(name), country = VALUES(country);

INSERT INTO airport (iata_code, name, city, country) VALUES
    ('ZZZ', '   ', 'Unknown', 'Training')
ON DUPLICATE KEY UPDATE name = VALUES(name), city = VALUES(city), country = VALUES(country);

INSERT INTO aircraft (registration, manufacturer, model, capacity) VALUES
    ('TEST-000', '   ', 'Training Aircraft', 0)
ON DUPLICATE KEY UPDATE manufacturer = VALUES(manufacturer), model = VALUES(model), capacity = VALUES(capacity);

INSERT INTO flight_status (name) VALUES
    ('Sin confirmar')
ON DUPLICATE KEY UPDATE name = VALUES(name);

DELIMITER //

DROP PROCEDURE IF EXISTS seed_dirty_flight_cases //

CREATE PROCEDURE seed_dirty_flight_cases()
BEGIN
    DECLARE valid_airline_id INT;
    DECLARE dirty_airline_id INT;
    DECLARE valid_aircraft_id INT;
    DECLARE dirty_aircraft_id INT;
    DECLARE lim_airport_id INT;
    DECLARE scl_airport_id INT;
    DECLARE dirty_airport_id INT;
    DECLARE final_status_id TINYINT;
    DECLARE cancelled_status_id TINYINT;
    DECLARE unknown_status_id TINYINT;

    SELECT airline_id INTO valid_airline_id FROM airline WHERE code = 'LAT';
    SELECT airline_id INTO dirty_airline_id FROM airline WHERE code = 'EDU';
    SELECT aircraft_id INTO valid_aircraft_id FROM aircraft WHERE registration = 'CC-BGA';
    SELECT aircraft_id INTO dirty_aircraft_id FROM aircraft WHERE registration = 'TEST-000';
    SELECT airport_id INTO lim_airport_id FROM airport WHERE iata_code = 'LIM';
    SELECT airport_id INTO scl_airport_id FROM airport WHERE iata_code = 'SCL';
    SELECT airport_id INTO dirty_airport_id FROM airport WHERE iata_code = 'ZZZ';
    SELECT status_id INTO final_status_id FROM flight_status WHERE name = 'Finalizado';
    SELECT status_id INTO cancelled_status_id FROM flight_status WHERE name = 'Cancelado';
    SELECT status_id INTO unknown_status_id FROM flight_status WHERE name = 'Sin confirmar';

    INSERT INTO flight (flight_number, airline_id, aircraft_id, origin_airport_id, destination_airport_id, status_id, scheduled_departure, actual_departure, scheduled_arrival, actual_arrival, distance)
    SELECT '   ', valid_airline_id, valid_aircraft_id, lim_airport_id, scl_airport_id, final_status_id,
           '2033-08-01 08:00:00', '2033-08-01 08:10:00', '2033-08-01 11:30:00', '2033-08-01 11:20:00', 4118.00
    WHERE NOT EXISTS (SELECT 1 FROM flight WHERE flight_number = '   ' AND scheduled_departure = '2033-08-01 08:00:00');

    INSERT INTO flight (flight_number, airline_id, aircraft_id, origin_airport_id, destination_airport_id, status_id, scheduled_departure, actual_departure, scheduled_arrival, actual_arrival, distance)
    SELECT 'DQF0002', valid_airline_id, valid_aircraft_id, lim_airport_id, scl_airport_id, final_status_id,
           '2033-08-02 08:00:00', '2033-08-02 08:10:00', '2033-08-02 11:30:00', '2033-08-02 11:20:00', 0.00
    WHERE NOT EXISTS (SELECT 1 FROM flight WHERE flight_number = 'DQF0002' AND scheduled_departure = '2033-08-02 08:00:00');

    INSERT INTO flight (flight_number, airline_id, aircraft_id, origin_airport_id, destination_airport_id, status_id, scheduled_departure, actual_departure, scheduled_arrival, actual_arrival, distance)
    SELECT 'DQF0003', valid_airline_id, valid_aircraft_id, lim_airport_id, lim_airport_id, final_status_id,
           '2033-08-03 08:00:00', '2033-08-03 08:10:00', '2033-08-03 11:30:00', '2033-08-03 11:20:00', 10.00
    WHERE NOT EXISTS (SELECT 1 FROM flight WHERE flight_number = 'DQF0003' AND scheduled_departure = '2033-08-03 08:00:00');

    INSERT INTO flight (flight_number, airline_id, aircraft_id, origin_airport_id, destination_airport_id, status_id, scheduled_departure, actual_departure, scheduled_arrival, actual_arrival, distance)
    SELECT 'DQF0004', valid_airline_id, valid_aircraft_id, lim_airport_id, scl_airport_id, final_status_id,
           '2033-08-04 11:30:00', '2033-08-04 11:40:00', '2033-08-04 08:00:00', '2033-08-04 11:20:00', 4118.00
    WHERE NOT EXISTS (SELECT 1 FROM flight WHERE flight_number = 'DQF0004' AND scheduled_departure = '2033-08-04 11:30:00');

    INSERT INTO flight (flight_number, airline_id, aircraft_id, origin_airport_id, destination_airport_id, status_id, scheduled_departure, actual_departure, scheduled_arrival, actual_arrival, distance)
    SELECT 'DQF0005', valid_airline_id, valid_aircraft_id, lim_airport_id, scl_airport_id, unknown_status_id,
           '2033-08-05 08:00:00', NULL, '2033-08-05 11:30:00', NULL, 4118.00
    WHERE NOT EXISTS (SELECT 1 FROM flight WHERE flight_number = 'DQF0005' AND scheduled_departure = '2033-08-05 08:00:00');

    INSERT INTO flight (flight_number, airline_id, aircraft_id, origin_airport_id, destination_airport_id, status_id, scheduled_departure, actual_departure, scheduled_arrival, actual_arrival, distance)
    SELECT 'DQF0006', dirty_airline_id, valid_aircraft_id, lim_airport_id, scl_airport_id, final_status_id,
           '2033-08-06 08:00:00', '2033-08-06 08:10:00', '2033-08-06 11:30:00', '2033-08-06 11:20:00', 4118.00
    WHERE NOT EXISTS (SELECT 1 FROM flight WHERE flight_number = 'DQF0006' AND scheduled_departure = '2033-08-06 08:00:00');

    INSERT INTO flight (flight_number, airline_id, aircraft_id, origin_airport_id, destination_airport_id, status_id, scheduled_departure, actual_departure, scheduled_arrival, actual_arrival, distance)
    SELECT 'DQF0007', valid_airline_id, valid_aircraft_id, dirty_airport_id, scl_airport_id, final_status_id,
           '2033-08-07 08:00:00', '2033-08-07 08:10:00', '2033-08-07 11:30:00', '2033-08-07 11:20:00', 4118.00
    WHERE NOT EXISTS (SELECT 1 FROM flight WHERE flight_number = 'DQF0007' AND scheduled_departure = '2033-08-07 08:00:00');

    INSERT INTO flight (flight_number, airline_id, aircraft_id, origin_airport_id, destination_airport_id, status_id, scheduled_departure, actual_departure, scheduled_arrival, actual_arrival, distance)
    SELECT 'DQF0008', valid_airline_id, dirty_aircraft_id, lim_airport_id, scl_airport_id, final_status_id,
           '2033-08-08 08:00:00', '2033-08-08 08:10:00', '2033-08-08 11:30:00', '2033-08-08 11:20:00', 4118.00
    WHERE NOT EXISTS (SELECT 1 FROM flight WHERE flight_number = 'DQF0008' AND scheduled_departure = '2033-08-08 08:00:00');

    INSERT INTO flight (flight_number, airline_id, aircraft_id, origin_airport_id, destination_airport_id, status_id, scheduled_departure, actual_departure, scheduled_arrival, actual_arrival, distance)
    SELECT 'DQF0009', valid_airline_id, valid_aircraft_id, lim_airport_id, scl_airport_id, final_status_id,
           '2033-08-09 08:00:00', '2033-08-09 10:00:00', '2033-08-09 11:30:00', '2033-08-09 09:30:00', 4118.00
    WHERE NOT EXISTS (SELECT 1 FROM flight WHERE flight_number = 'DQF0009' AND scheduled_departure = '2033-08-09 08:00:00');

    INSERT INTO flight (flight_number, airline_id, aircraft_id, origin_airport_id, destination_airport_id, status_id, scheduled_departure, actual_departure, scheduled_arrival, actual_arrival, distance)
    SELECT 'DQF0010', valid_airline_id, valid_aircraft_id, lim_airport_id, scl_airport_id, cancelled_status_id,
           '2033-08-10 08:00:00', '2033-08-10 08:10:00', '2033-08-10 11:30:00', '2033-08-10 11:20:00', 4118.00
    WHERE NOT EXISTS (SELECT 1 FROM flight WHERE flight_number = 'DQF0010' AND scheduled_departure = '2033-08-10 08:00:00');
END //

CALL seed_dirty_flight_cases() //
DROP PROCEDURE seed_dirty_flight_cases //

DELIMITER ;

-- These rows satisfy OLTP constraints but contain operational inconsistencies.
-- They exercise Transform quality controls and must not reach fact_flight.
DELIMITER //

DROP PROCEDURE IF EXISTS seed_quality_control_cases //

CREATE PROCEDURE seed_quality_control_cases()
BEGIN
    DECLARE sequence_number INT DEFAULT 1;
    DECLARE status_name VARCHAR(30);
    DECLARE status_source_id TINYINT;
    DECLARE scheduled_departure_value DATETIME;
    DECLARE actual_departure_value DATETIME;
    DECLARE actual_arrival_value DATETIME;
    DECLARE airline_source_id INT;
    DECLARE aircraft_source_id INT;
    DECLARE origin_source_id INT;
    DECLARE destination_source_id INT;

    SELECT airline_id INTO airline_source_id FROM airline WHERE code = 'LAT';
    SELECT aircraft_id INTO aircraft_source_id FROM aircraft WHERE registration = 'CC-BGA';
    SELECT airport_id INTO origin_source_id FROM airport WHERE iata_code = 'LIM';
    SELECT airport_id INTO destination_source_id FROM airport WHERE iata_code = 'SCL';

    WHILE sequence_number <= 20 DO
        SET status_name = ELT(MOD(sequence_number - 1, 5) + 1, 'Cancelado', 'Programado', 'En curso', 'Finalizado', 'Retrasado');
        SET scheduled_departure_value = DATE_ADD('2033-07-01 08:00:00', INTERVAL sequence_number DAY);
        SET actual_departure_value = NULL;
        SET actual_arrival_value = NULL;

        IF status_name = 'Cancelado' THEN
            SET actual_departure_value = DATE_ADD(scheduled_departure_value, INTERVAL 10 MINUTE);
            SET actual_arrival_value = DATE_ADD(scheduled_departure_value, INTERVAL 220 MINUTE);
        ELSEIF status_name = 'Programado' THEN
            SET actual_departure_value = DATE_ADD(scheduled_departure_value, INTERVAL 5 MINUTE);
        ELSEIF status_name = 'En curso' THEN
            SET actual_departure_value = DATE_ADD(scheduled_departure_value, INTERVAL 5 MINUTE);
            SET actual_arrival_value = DATE_ADD(scheduled_departure_value, INTERVAL 215 MINUTE);
        ELSEIF status_name = 'Retrasado' THEN
            SET actual_arrival_value = DATE_ADD(scheduled_departure_value, INTERVAL 230 MINUTE);
        END IF;

        SELECT status_id INTO status_source_id FROM flight_status WHERE name = status_name;

        INSERT INTO flight (
            flight_number, airline_id, aircraft_id, origin_airport_id, destination_airport_id,
            status_id, scheduled_departure, actual_departure, scheduled_arrival, actual_arrival, distance
        )
        SELECT
            CONCAT('DQC', LPAD(sequence_number, 4, '0')),
            airline_source_id,
            aircraft_source_id,
            origin_source_id,
            destination_source_id,
            status_source_id,
            scheduled_departure_value,
            actual_departure_value,
            DATE_ADD(scheduled_departure_value, INTERVAL 210 MINUTE),
            actual_arrival_value,
            4118.00
        WHERE NOT EXISTS (
            SELECT 1
            FROM flight AS existing_flight
            WHERE existing_flight.flight_number = CONCAT('DQC', LPAD(sequence_number, 4, '0'))
              AND existing_flight.scheduled_departure = scheduled_departure_value
        );

        SET sequence_number = sequence_number + 1;
    END WHILE;
END //

CALL seed_quality_control_cases() //
DROP PROCEDURE seed_quality_control_cases //

DELIMITER ;
