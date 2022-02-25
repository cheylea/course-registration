# Make a Course Available
DELIMITER //
CREATE PROCEDURE SP_ActivateCourse(
	IN Provided_CourseName VARCHAR(45),
    IN Provided_UserName  VARCHAR(45),
    OUT result VARCHAR(200))
BEGIN
	DECLARE UserId_Var INT; 
    DECLARE CourseId_Var INT;
    DECLARE RoleCheck_Var INT;
    DECLARE ActivationCheck_Var INT;

	# Get the UserId from the given name
	SELECT UserId
	INTO UserId_Var
	FROM (SELECT * FROM mydb.users u WHERE Name = Provided_UserName) getuserid;
	
	# Check if the user is an admin user
	SELECT COUNT(*)
	INTO RoleCheck_Var
	FROM (SELECT * FROM mydb.users u WHERE RoleId = 1 and UserId = UserId_Var) rolecheck;

	IF RoleCheck_Var <> 1 
		THEN
			# Reject user from updating the course
			SELECT 'User does not have the correct permissions to perform this action.'
			INTO result;
        ELSE
			# Get the CourseId from the given name
			SELECT CourseId
			INTO CourseId_Var
			FROM (SELECT * FROM mydb.courses u WHERE Title = Provided_CourseName) getcourseid;
            
			# Check if course is already activated
			SELECT isAvailable
			INTO ActivationCheck_Var
            FROM mydb.courses
			WHERE courseid = CourseId_Var;
			
			IF ActivationCheck_Var = 1 THEN
				SELECT 'Course already activated.'
				INTO result;
			ELSE
				# Update the course to Available
				UPDATE mydb.courses
				SET isAvailable = 1
				WHERE courseid = CourseId_Var;
				
				# Return Success Message
				SELECT 'Course activated.'
				INTO result;
			END IF;
	END IF;
END //

DELIMITER ;