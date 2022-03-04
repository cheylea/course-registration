# Make a Course Available
DELIMITER //
CREATE PROCEDURE SP_AssignCourse(
	IN Provided_CourseId INT,
    IN Provided_UserId INT,
    IN Provided_TeacherId INT)

BEGIN
    DECLARE RoleCheck_Admin_Var INT;
    DECLARE RoleCheck_Teacher_Var INT;
    DECLARE Assignment_Check_Var INT;
    DECLARE Result INT;
	
	# Check if the user is an admin user
	SELECT RoleId
	INTO RoleCheck_Admin_Var
	FROM (SELECT * FROM mydb.users u WHERE UserId = Provided_UserId) rolecheckadmin;

	# Check if the teacher is a teacher user
	SELECT RoleId
	INTO RoleCheck_Teacher_Var
	FROM (SELECT * FROM mydb.users u WHERE UserId = Provided_TeacherId) rolecheckteacher;
    
    # Check if teacher already assigned
    SELECT TeacherId
    INTO Assignment_Check_Var
    FROM (SELECT * FROM mydb.courses WHERE TeacherId = Provided_TeacherId AND CourseId = Provided_CourseId) assigncheck;
    
	IF RoleCheck_Admin_Var <> 1 
		THEN
			# Reject user from updating the course
			SELECT 1
			INTO Result;
        ELSE IF
			RoleCheck_Teacher_Var IS NULL OR RoleCheck_Teacher_Var <> 2
		THEN
			# Reject user from updating the course
			SELECT 3
			INTO Result;
		ELSE IF
			Assignment_Check_Var IS NOT NULL
		THEN 
			# Reject user from assigning, already assigned
            SELECT 2
            INTO Result;
        ELSE
			# Update the course to Available
			UPDATE mydb.courses
			SET TeacherId = Provided_TeacherId
			WHERE courseid = Provided_CourseId;
			
			# Return Success Message
			SELECT 0
			INTO Result;
			END IF;
	END IF;
    END IF;
    SELECT Result;
END //

DELIMITER ;