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
WHERE CourseId = 2; #Databases
# Activate a Course
CALL SP_ActivateCourse(2,30); # (Databases, Julia Scott) | Expected: 1
CALL SP_ActivateCourse(2,1); # (Databases, Clark Taylor) | Expected: 0
CALL SP_ActivateCourse(2,1); # (Databases, Clark Taylor) | Expected: 2
# Deactivate a Course
CALL SP_DeactivateCourse(2,30); # (Databases, Julia Scott) | Expected: 1
CALL SP_DeactivateCourse(2,1); # (Databases, Clark Taylor) | Expected: 0
CALL SP_DeactivateCourse(2,1); # (Databases, Clark Taylor) | Expected: 2


# Assignment Tests
# Complete the following statements one by one in order to test
# Ensure course is unassigned
UPDATE mydb.courses
SET TeacherId = 0
WHERE CourseId = 3; # Machine Learning
# Assign Course
CALL SP_AssignCourse(3,2,2); # (Machine Learning, Natalie Armstrong, Natalie Armstrong) | Expected: 3
CALL SP_AssignCourse(3,3,3); # (Machine Learning, Max Barrett, Max Barrett) | Expected: 1
CALL SP_AssignCourse(3,2,3); # (Machine Learning, Natalie Armstrong, Max Barrett) | Expected: 0
CALL SP_AssignCourse(3,2,3); # (Machine Learning, Natalie Armstrong, Max Barrett) | Expected: 2
CALL SP_AssignCourse(3,2,2); # (Machine Learning, Natalie Armstrong, Natalie Armstrong) | Expected: 3
CALL SP_AssignCourse(3,3,3); # (Machine Learning, Max Barrett, Max Barrett) | Expected: 1
# Ensure teacher not assigned to course
UPDATE mydb.courses
SET TeacherId = 0
WHERE CourseId = 10; # Project management
# Assign to one course
CALL SP_AssignCourse(10,2,5); # (Machine Learning, Natalie Armstrong, Catherine Nelson)
# Continue tests
CALL SP_AssignCourse(9,2,5); # (Machine Learning, Natalie Armstrong, Catherine Nelson)  | Expected: 0
CALL SP_AssignCourse(9,2,5); # (Machine Learning, Natalie Armstrong, Catherine Nelson)  | Expected: 2


# Get Available Courses
# Complete the following statements one by one in order to test
CALL SP_AvailableCourses(); #Expected: List of courses set to 1 for isAvailable in the table

# Student Enrolment Tests
# Complete the following statements one by one in order to test
# Ensure the student is not enroled
DELETE FROM mydb.enrolments WHERE UserId = 29; # Miley Cunningham
# Enrol Course
CALL SP_StudentEnrol(2,1); # (Databases, Clark Taylor) | Expected: 3
CALL SP_StudentEnrol(2,29); # (Databases, Miley Cunningham) | Expected: 0
CALL SP_StudentEnrol(2,29); # (Databases, Miley Cunningham) | Expected: 2

# Teacher Add Marks Tests
# Complete the following statements one by one in order to test
# Ensure student is enroled
CALL SP_StudentEnrol(2,29); # (Databases, Miley Cunningham)
# Start tests
CALL SP_TeacherAddMarks(2,29,9,'Pass'); # (Databases, Miley Cunningham, Carina Higgins, Pass) | Expected: 0
CALL SP_TeacherAddMarks(2,29,9,'Fail'); # (Databases, Miley Cunningham, Carina Higgins, Fail) | Expected: 0
CALL SP_TeacherAddMarks(2,29,9,'Pas'); # (Databases, Miley Cunningham, Carina Higgins, Pas) | Expected: 5
CALL SP_TeacherAddMarks(2,29,29,'Pass'); # (Databases, Miley Cunningham, Miley Cunningham, Pass) | Expected: 1
CALL SP_TeacherAddMarks(2,9,9,'Fail'); # (Databases, Carina Higgins, Carina Higgins, Pass) | Expected: 3
CALL SP_TeacherAddMarks(3,29,9,'Pass'); # (Machine Learning, Miley Cunningham, Carina Higgins, Pass) | Expected: 4
# Ensure the student is not enroled
DELETE FROM mydb.enrolments WHERE UserId = 29; # Miley Cunngham
# Continue tests
CALL SP_TeacherAddMarks(2,29,9,'Pass'); # (Databases, Miley Cunningham, Carina Higgins, Pass) | Expected: 4
