
-- First ensure we have a test passenger
INSERT INTO Passengers (passenger_id, first_name, last_name, seat_preference, class)
VALUES (1, 'Test', 'User', 'Window', 'Economy')
ON DUPLICATE KEY UPDATE class = 'Economy';

-- Step 1: Open Connection/Session 1 and run:
SET autocommit = 0;
SET @result1 = '';
CALL update_passenger_class(1, 'Business', @result1);
SELECT @result1;

-- Step 2: While Session 1 is still processing (during the 10-second sleep)
-- Open Connection/Session 2 in a new query window and run:
SET @result2 = '';
CALL update_passenger_class(1, 'First', @result2);
SELECT @result2;

-- Step 3: After both transactions complete, verify the final state:
SELECT passenger_id, class 
FROM Passengers 
WHERE passenger_id = 1;