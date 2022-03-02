# Testing queries on the stored procedures

# Guide to Number Results
# 0 Success 
# 1 Denied Permission
# 2 Duplicate Action
# 3 Invalid Parameter
# 4 Missing Data
# 5 Data Validation

# Activation tests
# Complete the following statements one by one in order to test
# Ensure course is already deactivated
UPDATE mydb.courses
SET isAvailable = 0
WHERE Title = 'Databases';
# Activate a Course
CALL SP_ActivateCourse('Databases','Clark T'); # Expected: 1
CALL SP_ActivateCourse('Databases','Clark Taylor'); # Expected: 0
CALL SP_ActivateCourse('Databases','Clark Taylor'); # Expected: 2
# Deactivate a Course
CALL SP_DeactivateCourse('Databases','Clark T'); # Expected: 1
CALL SP_DeactivateCourse('Databases','Clark Taylor'); # Expected: 0
CALL SP_DeactivateCourse('Databases','Clark Taylor'); # Expected: 2


# Assignment Tests
# Complete the following statements one by one in order to test
# Ensure course is unassigned
UPDATE mydb.courses
SET TeacherId = 0
WHERE CourseId = 3; #Machine Learning
# Assign Course
CALL SP_AssignCourse('Machine learning','Natalie Armstrong','Natalie Armstrong'); # Expected: 3
CALL SP_AssignCourse('Machine learning','Max Barrett','Max Barrett'); # Expected: 1
CALL SP_AssignCourse('Machine learning','Natalie Armstrong','Max Barrett'); # Expected: 0
CALL SP_AssignCourse('Machine learning','Natalie Armstrong','Max Barrett'); # Expected: 2
CALL SP_AssignCourse('Machine learning','Natalie Armstrong','Natalie Armstrong'); # Expected: 3
CALL SP_AssignCourse('Machine learning','Max Barrett','Max Barrett'); # Expected: 1

# Get Available Courses
# Complete the following statements one by one in order to test
CALL SP_AvailableCourses(); #Expected: List of courses set to 1 for isAvailable in the table

# Student Enrolment Tests
# Complete the following statements one by one in order to test
# Ensure the student is not enroled
DELETE FROM mydb.enrolments WHERE UserId = 29; # Miley Cunngham
# Enrol Course
CALL SP_StudentEnrol('Databases','Miley Cunngham'); # Expected: 3
CALL SP_StudentEnrol('Databases','Miley Cunningham'); # Expected: 0
CALL SP_StudentEnrol('Databases','Miley Cunningham'); # Expected: 2

# Teacher Add Marks Tests
# Complete the following statements one by one in order to test
# Ensure student is enroled
CALL SP_StudentEnrol('Databases','Miley Cunningham');
# Start tests
CALL SP_TeacherAddMarks('Databases','Miley Cunningham', 'Carina Higgins', 'Pass'); #Expected: 0
CALL SP_TeacherAddMarks('Databases','Miley Cunningham', 'Carina Higgins', 'Fail'); #Expected: 0
CALL SP_TeacherAddMarks('Databases','Miley Cunningham', 'Carina Higgins', 'Pas'); #Expected: 5
CALL SP_TeacherAddMarks('Databases','Miley Cunningham', 'Natalie Armstrong', 'Pass'); #Expected: 1
CALL SP_TeacherAddMarks('Databases','Miley Cunning', 'Carina Higgins', 'Fail'); #Expected: 3
# Ensure the student is not enroled
DELETE FROM mydb.enrolments WHERE UserId = 29; # Miley Cunngham
# Continue tests
CALL SP_TeacherAddMarks('Databases','Miley Cunningham', 'Carina Higgins', 'Pass'); #Expected: 4