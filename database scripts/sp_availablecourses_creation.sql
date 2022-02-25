# Get list of available courses
DELIMITER //
CREATE PROCEDURE SP_AvailableCourses()
BEGIN
    
SELECT Title `Course Title`, Name `Teacher Name` FROM mydb.courses c
JOIN mydb.users u ON u.UserId = c.TeacherId
WHERE isAvailable = 1;

END //

DELIMITER ;