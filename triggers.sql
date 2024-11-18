DELIMITER //

CREATE TRIGGER after_booking_insert 
AFTER INSERT ON Booking
FOR EACH ROW 
BEGIN
    UPDATE Seat_Allocation 
    SET status = 'Booked'
    WHERE flight_id = NEW.flight_id 
    AND seat_number = NEW.seat_number;
END//

DELIMITER ;

SET @result1 = '';
CALL update_passenger_class(1, 'Business', @result1);
SELECT @result1;