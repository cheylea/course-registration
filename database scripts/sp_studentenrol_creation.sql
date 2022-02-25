# Student Enrol in Course
DELIMITER //
CREATE PROCEDURE SP_StudentEnrol(
	IN Provided_CourseName VARCHAR(45),
    IN Provided_StudentName  VARCHAR(45),
    OUT result VARCHAR(200))
BEGIN
	DECLARE StudentId_Var INT; 
    DECLARE CourseId_Var INT;
    DECLARE RoleCheck_Var INT;
    DECLARE EnrolmentCheck_Var INT;

	# Get the UserId from the given name
	SELECT UserId
	INTO StudentId_Var
	FROM (SELECT * FROM mydb.users u WHERE Name = Provided_StudentName) getstudentid;
	
	# Check if the user is a student
	SELECT RoleId
	INTO RoleCheck_Var
	FROM (SELECT * FROM mydb.users u WHERE UserId = StudentId_Var) rolecheck;

	IF RoleCheck_Var <> 3 
		THEN
			# Reject user from updating the course
			SELECT 'Student name provided is not valid. Please provide a valid student name.'
			INTO result;
        ELSE
			# Get the CourseId from the given name
			SELECT CourseId
			INTO CourseId_Var
			FROM (SELECT * FROM mydb.courses u WHERE Title = Provided_CourseName) getcourseid;
            
			# Check if student is already enrolled
			SELECT UserId
			INTO EnrolmentCheck_Var
            FROM mydb.enrolments
			WHERE UserId = StudentId_Var;
			
			IF EnrolmentCheck_Var IS NOT NULL THEN
				SELECT 'Student is already enrolled. Please contact support team for assistance.'
				INTO result;
			ELSE
				# Update the course to Available
				INSERT INTO mydb.enrolments (CourseId, UserId)
				VALUES (CourseId_Var, StudentId_Var);
				
				# Return Success Message
				SELECT 'Student enrolled.'
				INTO result;
			END IF;
	END IF;
END //

DELIMITER ;