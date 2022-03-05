DROP PROCEDURE IF EXISTS SP_StudentEnrol;

# Student Enrol in Course
DELIMITER //
CREATE PROCEDURE SP_StudentEnrol(
	IN Provided_CourseId INT,
    IN Provided_StudentId INT)
BEGIN
    DECLARE RoleCheck_Var INT;
    DECLARE EnrolmentCheck_Var INT;
    DECLARE ChangeCheck_Var INT;
    DECLARE Result INT;
	
	# Check if the user is a student
	SELECT RoleId
	INTO RoleCheck_Var
	FROM (SELECT * FROM mydb.users u WHERE UserId = Provided_StudentId) rolecheck;

	IF RoleCheck_Var IS NULL OR RoleCheck_Var <> 3 
		THEN
			# Reject user from updating the course
			SELECT 3
			INTO result;
        ELSE            
			# Check if student is already enrolled
			SELECT UserId
			INTO EnrolmentCheck_Var
            FROM mydb.enrolments
			WHERE UserId = Provided_StudentId;
			
			IF EnrolmentCheck_Var IS NOT NULL
				THEN
					SELECT 2
					INTO result;
				ELSE
					# Add enrolment to the table
					INSERT INTO mydb.enrolments (CourseId, UserId)
					VALUES (Provided_CourseId, Provided_StudentId);
				
					# Check Successful
					SELECT ROW_COUNT()
					INTO ChangeCheck_Var;
                
					IF ChangeCheck_Var = 1
						THEN
							# Return Success Message
							SELECT 0
							INTO result;
				END IF;
            END IF;
		END IF;
SELECT Result;
END //

DELIMITER ;