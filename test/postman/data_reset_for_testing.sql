# Reset the database to prepare for full testing

DELETE FROM mydb.enrolments WHERE UserId = 10; # Nicholas Ross

UPDATE mydb.courses
SET TeacherId = 0
WHERE CourseId = 1; # Data structures

UPDATE mydb.courses
SET isAvailable = 0
WHERE CourseId = 7; # Game development