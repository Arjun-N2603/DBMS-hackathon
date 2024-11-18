
-- Drop existing tables if they exist (in correct order due to dependencies)
DROP TABLE IF EXISTS Booking;
DROP TABLE IF EXISTS Loyalty_Program;
DROP TABLE IF EXISTS Seat_Allocation;
DROP TABLE IF EXISTS Passengers;
DROP TABLE IF EXISTS Flights;

-- Create Flights table
CREATE TABLE Flights (
    flight_id INT PRIMARY KEY,
    flight_number VARCHAR(10) NOT NULL,
    departure_time DATETIME NOT NULL,
    arrival_time DATETIME NOT NULL,
    source VARCHAR(50) NOT NULL,
    destination VARCHAR(50) NOT NULL,
    class VARCHAR(20) CHECK (class IN ('Economy', 'Business', 'First')) NOT NULL
);

-- Create Passengers table
CREATE TABLE Passengers (
    passenger_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    seat_preference VARCHAR(10) CHECK (seat_preference IN ('Window', 'Aisle', 'Middle')) NOT NULL,
    class VARCHAR(20) CHECK (class IN ('Economy', 'Business', 'First')) NOT NULL
);

-- Create Seat_Allocation table
CREATE TABLE Seat_Allocation (
    allocation_id INT PRIMARY KEY,
    flight_id INT NOT NULL,
    seat_number VARCHAR(5) NOT NULL,
    status VARCHAR(10) CHECK (status IN ('Available', 'Booked', 'Reserved')) NOT NULL,
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id)
);

-- Create Loyalty_Program table
CREATE TABLE Loyalty_Program (
    passenger_id INT PRIMARY KEY,
    points INT DEFAULT 0,
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id)
);

-- Create Booking table
CREATE TABLE Booking (
    booking_id INT PRIMARY KEY,
    flight_id INT NOT NULL,
    passenger_id INT NOT NULL,
    seat_number VARCHAR(5) NOT NULL,
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id),
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id),
    FOREIGN KEY (flight_id, seat_number) REFERENCES Seat_Allocation(flight_id, seat_number)
);

-- Add unique constraints
ALTER TABLE Flights ADD CONSTRAINT UQ_FlightNumber UNIQUE (flight_number);
ALTER TABLE Seat_Allocation ADD CONSTRAINT UQ_FlightSeat UNIQUE (flight_id, seat_number);