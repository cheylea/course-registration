# Activate a Course
CALL SP_ActivateCourse('Databases','Clark Taylor', @result);
SELECT @result;

# Deactivate a Course
CALL SP_DeactivateCourse('Databases','Max Barrett', @result);
SELECT @result;

# Assign Course
CALL SP_AssignCourse('Machine learning','Max Barrett','Natalie Armstrong', @result);
SELECT @result;

# Get Available Courses
CALL SP_AvailableCourses();

# Student Enrolment
CALL SP_StudentEnrol('Databases','Nicholas Ross',@result);
SELECT @result;

# Add marks for students
CALL SP_TeacherAddMarks('Databases','Nicholas Ross', 'Carina Higgins', 'Fail', @result);
SELECT @result;