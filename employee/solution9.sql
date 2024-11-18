-- Employee table
CREATE TABLE employees (
employee_id INT PRIMARY KEY,
employee_name VARCHAR(100)
);
-- Employee_hierarchy table
CREATE TABLE employee_hierarchy (
employee_id INT,
manager_id INT,
FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);
-- Insert employees
INSERT INTO employees (employee_id, employee_name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie');
-- Insert employee hierarchy (relationships between employees)
INSERT INTO employee_hierarchy (employee_id, manager_id) VALUES
(2, 1), -- Bob reports to Alice
(3, 1); -- Charlie reports to Alice

-- Write a recursive query that can be used to find all employees who report to Alice directly or
--indirectly. Paste screenshots of the output in the submission report.

--solution

WITH RECURSIVE subordinates(employee_id, manager_id, level) AS (
    -- Base case: direct reports to Alice
    SELECT employee_id, manager_id, 1
    FROM employee_hierarchy
    WHERE manager_id = 1
    
    UNION ALL
    
    -- Recursive case: indirect reports
    SELECT h.employee_id, h.manager_id, s.level + 1
    FROM employee_hierarchy h
    JOIN subordinates s ON h.manager_id = s.employee_id
)
SELECT e.employee_name, s.level
FROM subordinates s
JOIN employees e ON s.employee_id = e.employee_id
ORDER BY s.level, e.employee_name;
