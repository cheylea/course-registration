# Make a Course Available
DELIMITER //
CREATE PROCEDURE SP_ActivateCourse(
	IN Provided_CourseId INT,
    IN Provided_UserId INT
    )
BEGIN
    DECLARE CourseId_Var INT;
    DECLARE RoleCheck_Var INT;
    DECLARE ActivationCheck_Var INT;
    DECLARE Result INT;

	# Check if the user is an admin user
	SELECT COUNT(*)
	INTO RoleCheck_Var
	FROM (SELECT * FROM mydb.users u WHERE RoleId = 1 and UserId = Provided_UserId) rolecheck;

	IF RoleCheck_Var <> 1 
		THEN
			# Reject user from updating the course
			SELECT 1
			INTO Result;
        ELSE
			# Check if course is already activated
			SELECT isAvailable
			INTO ActivationCheck_Var
            FROM mydb.courses
			WHERE courseid = Provided_CourseId;
			
			IF ActivationCheck_Var = 1 THEN
				SELECT 2
				INTO Result;
			ELSE
				# Update the course to Available
				UPDATE mydb.courses
				SET isAvailable = 1
				WHERE courseid = Provided_CourseId;
				
				# Return Success
				SELECT 0
				INTO Result;
			END IF;
	END IF;
    SELECT Result;
END //

DELIMITER ;