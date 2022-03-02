# Activate a Course
CALL SP_ActivateCourse('Databases','Clark Taylor');

# Deactivate a Course
CALL SP_DeactivateCourse('Databases','Clark Taylor');

# Assign Course
CALL SP_AssignCourse('Machine learning','Natalie Armstrong','Natalie Armstrong');

# Get Available Courses
CALL SP_AvailableCourses();

# Student Enrolment
CALL SP_StudentEnrol('Databases','Miley Cunningham');

# Add marks for students
CALL SP_TeacherAddMarks('Databases','Valeria Cooper', 'Carina Higgins', 'Pass');