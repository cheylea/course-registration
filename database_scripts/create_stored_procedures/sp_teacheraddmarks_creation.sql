	# Teachers add marks to pass or fail students
	DELIMITER //
	CREATE PROCEDURE SP_TeacherAddMarks(
		IN Provided_CourseId INT,
		IN Provided_StudentId INT,
		IN Provided_UserId INT,
		IN Mark VARCHAR(4))
	BEGIN
		DECLARE UserId_Var INT; 
		DECLARE CourseId_Var INT;
		DECLARE StudentId_Var INT;
		DECLARE RoleCheck_Teacher_Var INT;
		DECLARE RoleCheck_Student_Var INT;
		DECLARE EnrolmentCheck_Var INT;
		DECLARE Result INT;
		
		# Check if the user is a teacher
		SELECT RoleId
		INTO RoleCheck_Teacher_Var
		FROM (SELECT * FROM mydb.users u WHERE UserId = Provided_UserId) rolecheckteacher;
		
		# Check if the student is a student
		SELECT RoleId
		INTO RoleCheck_Student_Var
		FROM (SELECT * FROM mydb.users u WHERE UserId = Provided_StudentId) rolecheckstudent;
		
		# Check enrolment exists for student
		SELECT EnrolmentId
		INTO EnrolmentCheck_Var
		FROM (SELECT * FROM mydb.enrolments e WHERE UserId = Provided_StudentId AND CourseId = Provided_CourseId) enrolmentcheck;
		
		
		IF RoleCheck_Teacher_Var IS NULL OR RoleCheck_Teacher_Var <> 2 
			THEN
				# Reject user from updating the course
				SELECT 1
				INTO result;
			ELSE IF
				RoleCheck_Student_Var IS NULL OR RoleCheck_Student_Var <> 3
			THEN
				# Reject user from updating the course
				SELECT 3
				INTO result;
			ELSE IF
				EnrolmentCheck_Var IS NULL
			THEN
				# Enrolment does not exist
				SELECT 4
				INTO result;
			ELSE IF
				Mark <> 'Pass' AND Mark <> 'Fail'
			THEN
				# Invalid grade provided
				SELECT 5
				INTO Result;
			ELSE IF
				Mark = 'Pass'
			THEN
				# Update mark to pass
				UPDATE mydb.enrolments
				SET Mark = 1
				WHERE UserId = StudentId_Var;
				
				# Return Success Message
				SELECT 0
				INTO Result;
			ELSE
				# Update mark to fail
				UPDATE mydb.enrolments
				SET Mark = 0
				WHERE UserId = StudentId_Var;
				
				# Return Success Message
				SELECT 0
				INTO Result;
		END IF;
		END IF;
		END IF;
		END IF;
		END IF;
		SELECT Result;
	END //

DELIMITER ;
