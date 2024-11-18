use hackathon;

set FOREIGN_key_checks = 0;

DROP TABLE flights;

CREATE TABLE Flights (
    flight_id INT PRIMARY KEY AUTO_INCREMENT,
    flight_number VARCHAR(10) NOT NULL,
    departure_time DATETIME NOT NULL,
    arrival_time DATETIME NOT NULL,
    source VARCHAR(50) NOT NULL,
    destination VARCHAR(50) NOT NULL,
    class VARCHAR(20) CHECK (class IN ('Economy', 'Business', 'First')) NOT NULL
)
ENGINE=FEDERATED
DEFAULT CHARSET=utf8mb4
CONNECTION='mysql://Arjun:Arjundbms@172.20.10.2:3306/hackathon/flights';

drop table Passengers;
-- Create Passengers table
CREATE TABLE Passengers (
    passenger_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    seat_preference VARCHAR(10) CHECK (seat_preference IN ('Window', 'Aisle', 'Middle')) NOT NULL,
    class VARCHAR(20) CHECK (class IN ('Economy', 'Business', 'First')) NOT NULL
)
ENGINE=FEDERATED
DEFAULT CHARSET=utf8mb4
CONNECTION='mysql://Arjun:Arjundbms@172.20.10.2:3306/hackathon/passengers';

-- Create Seat_Allocation table
DROP TABLE seat_allocation;
CREATE TABLE Seat_Allocation (
    allocation_id INT PRIMARY KEY AUTO_INCREMENT,
    flight_id INT NOT NULL,
    seat_number VARCHAR(5) NOT NULL,
    status VARCHAR(10) CHECK (status IN ('Available', 'Booked', 'Reserved')) NOT NULL,
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id)
)
ENGINE=FEDERATED
DEFAULT CHARSET=utf8mb4
CONNECTION='mysql://Arjun:Arjundbms@172.20.10.2:3306/hackathon/Seat_Allocation';

DROP TABLE loyalty_program;
CREATE TABLE Loyalty_Program (
    passenger_id INT PRIMARY KEY,
    points INT DEFAULT 0,
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id)
)
ENGINE=FEDERATED
DEFAULT CHARSET=utf8mb4
CONNECTION='mysql://Arjun:Arjundbms@172.20.10.2:3306/hackathon/Loyalty_Program';

DROP TABLE booking;
CREATE TABLE Booking (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    flight_id INT NOT NULL,
    passenger_id INT NOT NULL,
    seat_number VARCHAR(5) NOT NULL,
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id),
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id),
    FOREIGN KEY (flight_id, seat_number) REFERENCES Seat_Allocation(flight_id, seat_number)
)
ENGINE=FEDERATED
DEFAULT CHARSET=utf8mb4
CONNECTION='mysql://Arjun:Arjundbms@172.20.10.2:3306/hackathon/Booking';

set FOREIGN_key_checks = 1;
