# Get list of available courses
DELIMITER //
CREATE PROCEDURE SP_AvailableCourses()
BEGIN
    
SELECT 	Title `Course Title`,
		CASE WHEN Name IS NULL THEN 'Teacher Not Yet Assigned' 
        ELSE Name END AS `Teacher Name` 
FROM mydb.courses c
LEFT JOIN mydb.users u ON u.UserId = c.TeacherId
WHERE isAvailable = 1;

END //

DELIMITER ;