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

CREATE FUNCTION calculate_discount(
    loyalty_points INT,
    base_ticket_price DECIMAL(10,2)
) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE discount_percentage DECIMAL(5,2);
    
    -- Set discount percentage based on loyalty points
    CASE
        WHEN loyalty_points <= 1000 THEN SET discount_percentage = 0;
        WHEN loyalty_points <= 5000 THEN SET discount_percentage = 5;
        WHEN loyalty_points <= 10000 THEN SET discount_percentage = 10;
        ELSE SET discount_percentage = 15;
    END CASE;
    
    -- Calculate and return discounted price
    RETURN base_ticket_price * (1 - discount_percentage/100);
END //

-- Create view to display passenger discount information
CREATE OR REPLACE VIEW passenger_discounts AS
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) as full_name,
    100.00 as base_ticket_price,
    calculate_discount(COALESCE(lp.points, 0), 100.00) as discounted_price,
    COALESCE(lp.points, 0) as loyalty_points
FROM 
    Passengers p
    LEFT JOIN Loyalty_Program lp ON p.passenger_id = lp.passenger_id //

DELIMITER ;
