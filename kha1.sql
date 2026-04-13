CREATE TABLE flights (
    flight_id SERIAL PRIMARY KEY,
    flight_name VARCHAR(100),
    available_seats INT
);

CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,
    flight_id INT REFERENCES flights(flight_id),
    customer_name VARCHAR(100)
);

INSERT INTO flights (flight_name, available_seats) 
VALUES ('VN123', 3), ('VN456', 2);

BEGIN;
UPDATE flights 
SET available_seats = available_seats - 1 
WHERE flight_name = 'VN123';
INSERT INTO bookings (flight_id, customer_name) 
VALUES (1, 'Nguyen Van A');
COMMIT;

SELECT * FROM flights;
SELECT * FROM bookings;

BEGIN;
UPDATE flights 
SET available_seats = available_seats - 1 
WHERE flight_name = 'VN123';
INSERT INTO bookings (flight_id, customer_name) 
VALUES (999, 'Khach Hang Loi');
ROLLBACK;

SELECT * FROM flights;
SELECT * FROM bookings;
