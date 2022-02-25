# Make a Course Available
DELIMITER //
CREATE PROCEDURE SP_AssignCourse(
	IN Provided_CourseName VARCHAR(45),
    IN Provided_TeacherName VARCHAR(45),
    IN Provided_UserName  VARCHAR(45),
    OUT result VARCHAR(200))
BEGIN
	DECLARE UserId_Var INT; 
    DECLARE CourseId_Var INT;
    DECLARE TeacherId_Var INT;
    DECLARE RoleCheck_Admin_Var INT;
    DECLARE RoleCheck_Teacher_Var INT;
    DECLARE ActivationCheck_Var INT;

	# Get the UserId from the given name
	SELECT UserId
	INTO UserId_Var
	FROM (SELECT * FROM mydb.users u WHERE Name = Provided_UserName) getuserid;
    
    # Get the Teacher Id from the given name
	SELECT UserId
	INTO TeacherId_Var
	FROM (SELECT * FROM mydb.users u WHERE Name = Provided_TeacherName) getteacherid;
	
	# Check if the user is an admin user
	SELECT RoleId
	INTO RoleCheck_Admin_Var
	FROM (SELECT * FROM mydb.users u WHERE UserId = UserId_Var) rolecheckadmin;

	# Check if the teacher is a teacher user
	SELECT RoleId
	INTO RoleCheck_Teacher_Var
	FROM (SELECT * FROM mydb.users u WHERE UserId = TeacherId_Var) rolecheckteacher;
    
	IF RoleCheck_Admin_Var <> 1 
		THEN
			# Reject user from updating the course
			SELECT 'User does not have the correct permissions to perform this action.'
			INTO result;
        ELSE IF
			RoleCheck_Teacher_Var <> 2
		THEN
			# Reject user from updating the course
			SELECT 'Provided teacher is not valid, please use a real teacher.'
			INTO result;
		ELSE
			# Get the CourseId from the given name
			SELECT CourseId
			INTO CourseId_Var
			FROM (SELECT * FROM mydb.courses u WHERE Title = Provided_CourseName) getcourseid;

			# Update the course to Available
			UPDATE mydb.courses
			SET TeacherId = TeacherId_Var
			WHERE courseid = CourseId_Var;
			
			# Return Success Message
			SELECT 'Teacher assigned to course.'
			INTO result;
			END IF;
	END IF;
END //

DELIMITER ;