DELIMITER //

CREATE PROCEDURE update_seat_preference(
    IN p_passenger_id INT,
    IN p_new_preference VARCHAR(10)
)
BEGIN
    DECLARE passenger_exists INT;
    
    -- Check if passenger exists
    SELECT COUNT(*) INTO passenger_exists
    FROM Passengers
    WHERE passenger_id = p_passenger_id;
    
    -- Validate seat preference
    IF p_new_preference NOT IN ('Window', 'Aisle', 'Middle') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid seat preference. Must be Window, Aisle, or Middle';
    END IF;
    
    -- Update preference if passenger exists
    IF passenger_exists > 0 THEN
        UPDATE Passengers
        SET seat_preference = p_new_preference
        WHERE passenger_id = p_passenger_id;
        
        SELECT 'Seat preference updated successfully' AS message;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Passenger not found';
    END IF;
END //

DELIMITER ;
