DROP PROCEDURE IF EXISTS SP_DeactivateCourse;

# Make a Course Available
DELIMITER //
CREATE PROCEDURE SP_DeactivateCourse(
	IN Provided_CourseId INT,
    IN Provided_UserId INT)

BEGIN
    DECLARE CourseId_Var INT;
    DECLARE RoleCheck_Var INT;
    DECLARE ActivationCheck_Var INT;
    DECLARE ChangeCheck_Var INT;
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
			# Check Course Exists
			SELECT COUNT(*)
			INTO CourseId_Var
			FROM mydb.courses
			WHERE courseid = Provided_CourseId;

		IF CourseId_Var = 0 
			THEN
				# Cannot update as does not exist
				SELECT 4
				INTO Result;
			ELSE
				# Check if course is already activated
				SELECT isAvailable
				INTO ActivationCheck_Var
				FROM mydb.courses
				WHERE courseid = Provided_CourseId;
			
			IF ActivationCheck_Var = 0
				THEN
					# Course already activated
					SELECT 2
					INTO Result;
				ELSE
					# Update the course to available
					UPDATE mydb.courses
					SET isAvailable = 0
					WHERE courseid = Provided_CourseId;
					
                    # Check Successful
					SELECT ROW_COUNT()
					INTO ChangeCheck_Var;
                
                IF ChangeCheck_Var = 1
					THEN
						# Return Success
						SELECT 0
						INTO Result;
				END IF;
			END IF;
		END IF;
    END IF;
SELECT Result;
END //

DELIMITER ;
