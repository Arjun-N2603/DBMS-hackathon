-- Create the tables for SkyHigh Airlines Reservation System

-- Create PASSENGER table
CREATE TABLE PASSENGER (
    passenger_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_email (email)
);

-- Create FLIGHT table
CREATE TABLE FLIGHT (
    flight_number VARCHAR(10) PRIMARY KEY,
    origin VARCHAR(50) NOT NULL,
    destination VARCHAR(50) NOT NULL,
    departure_time DATETIME NOT NULL,
    arrival_time DATETIME NOT NULL,
    aircraft_type VARCHAR(50) NOT NULL,
    status ENUM('Scheduled', 'Boarding', 'Departed', 'Arrived', 'Cancelled') DEFAULT 'Scheduled',
    INDEX idx_departure (departure_time),
    INDEX idx_status (status)
);

-- Create SEAT table
CREATE TABLE SEAT (
    seat_id INT PRIMARY KEY AUTO_INCREMENT,
    flight_number VARCHAR(10) NOT NULL,
    seat_number VARCHAR(4) NOT NULL,
    seat_class ENUM('Economy', 'Business', 'First') NOT NULL,
    seat_type ENUM('Window', 'Middle', 'Aisle') NOT NULL,
    is_available BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (flight_number) REFERENCES FLIGHT(flight_number),
    UNIQUE KEY unique_seat (flight_number, seat_number),
    INDEX idx_availability (is_available)
);

-- Create BOOKING table
CREATE TABLE BOOKING (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    passenger_id INT NOT NULL,
    flight_number VARCHAR(10) NOT NULL,
    seat_id INT NOT NULL,
    booking_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    booking_status ENUM('Confirmed', 'Cancelled', 'Waitlisted') DEFAULT 'Confirmed',
    fare_amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (passenger_id) REFERENCES PASSENGER(passenger_id),
    FOREIGN KEY (flight_number) REFERENCES FLIGHT(flight_number),
    FOREIGN KEY (seat_id) REFERENCES SEAT(seat_id),
    INDEX idx_booking_status (booking_status)
);

-- Create LOYALTY_ACCOUNT table
CREATE TABLE LOYALTY_ACCOUNT (
    loyalty_id INT PRIMARY KEY AUTO_INCREMENT,
    passenger_id INT NOT NULL UNIQUE,
    points_balance INT DEFAULT 0,
    tier_status ENUM('Bronze', 'Silver', 'Gold', 'Platinum') DEFAULT 'Bronze',
    join_date DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (passenger_id) REFERENCES PASSENGER(passenger_id),
    INDEX idx_tier (tier_status)
);

-- Modify existing LOYALTY_ACCOUNT table
ALTER TABLE LOYALTY_ACCOUNT 
ADD COLUMN lifetime_miles INT DEFAULT 0,
ADD COLUMN available_miles INT DEFAULT 0;

-- Create MILES_HISTORY table
CREATE TABLE MILES_HISTORY (
    miles_history_id INT PRIMARY KEY AUTO_INCREMENT,
    loyalty_id INT NOT NULL,
    flight_number VARCHAR(10),
    miles_earned INT NOT NULL,
    transaction_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    transaction_type ENUM('Flight', 'Bonus', 'Redemption', 'Expiry') NOT NULL,
    description VARCHAR(255),
    FOREIGN KEY (loyalty_id) REFERENCES LOYALTY_ACCOUNT(loyalty_id),
    FOREIGN KEY (flight_number) REFERENCES FLIGHT(flight_number),
    INDEX idx_loyalty_date (loyalty_id, transaction_date)
);

-- Create MILES_REDEMPTION table
CREATE TABLE MILES_REDEMPTION (
    redemption_id INT PRIMARY KEY AUTO_INCREMENT,
    loyalty_id INT NOT NULL,
    miles_redeemed INT NOT NULL,
    redemption_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    redemption_type ENUM('Upgrade', 'FreeFlight', 'Discount', 'Lounge') NOT NULL,
    booking_id INT,
    status ENUM('Pending', 'Approved', 'Completed', 'Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (loyalty_id) REFERENCES LOYALTY_ACCOUNT(loyalty_id),
    FOREIGN KEY (booking_id) REFERENCES BOOKING(booking_id),
    INDEX idx_loyalty_date (loyalty_id, redemption_date)
);