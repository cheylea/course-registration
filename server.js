/* Course Registration Server
This file connections to the database and server.
Once open, API calls can be made to the server
to perform basic actions required for handling
course registration.
*/

// Setup
const express = require('express');
const app = express();
const mysql = require('mysql2');
const dotenv = require('dotenv');
dotenv.config();


// Connect to the database
const connection = mysql.createConnection({
    host: process.env.HOST,
    user: process.env.USER,
    database: process.env.DATABASE,
    password: process.env.PASSWORD,
    port: process.env.MYDB_PORT,
  });


// Start server and listen on the host and port
var server = app.listen(process.env.PORT, function () {
    console.log(`Server is listening at http://${process.env.HOST}:${process.env.PORT}/`)
});

//Ping endpoint to test status
app.get("/ping", (request, response) => {  
    // If able to access the server return healthy
    return response.send({
      status: "Healthy",
    });
  });


/* Routing Requests
These are the main functionality APIs
that can be coneected to and interact
with stored procedures on the database.
*/

/* Activate Course (Admin Only)
This allows the user to set a course to
active if they are an admin user. This directly
handles issues such as confirming role and 
stopping if the course has already been activated.
*/
app.put('/activatecourse/:idcourse/:iduser', function (request, response) {
    // Log the request in the console
    console.log(request)
    // Make connection to database and call the stored procedure and attempt to update the row
    connection.query(`CALL SP_ActivateCourse(?,?);`, [request.params.idcourse, request.params.iduser], (error, result)=>{
        // Handle SQL errors
        if (error) throw error;
        // Database returns number to indicate what was completed
        // Get the value sent out of the database from the json body
        out = +JSON.parse(JSON.stringify(result[0]))[0].Result
        // Handle each result with messages to the user to confirm what has happened
        if (out === 0) { 
            message = "Success: Course activated."; //Success
        } else if (out === 1) {
            message = "Denied: User does not have the correct permissions to perform this action.";
        } else if (out === 2) {
            message = "Duplicate Action: Course already activated.";
        } else {
            message = "Unknown Error";
        };
        // Send the message to the user
        response.send(message)
    });
});

/* Deactivate Course (Admin Only)
This allows the user to set a course to
inactive if they are an admin user. This directly
handles issues such as confirming role and 
stopping if the course has already been deactivated.
*/
app.put('/deactivatecourse/:idcourse/:iduser', function (request, response) {
    // Log the request in the console
    console.log(request)
    // Make connection to database and call the stored procedure and attempt to update the row
    connection.query(`CALL SP_DeactivateCourse(?,?);`, [request.params.idcourse, request.params.iduser], (error, result)=>{
        // Handle SQL errors
        if (error) throw error;
        // Database returns number to indicate what was completed
        // Get the value sent out of the database from the json body
        out = +JSON.parse(JSON.stringify(result[0]))[0].Result
        // Handle each result with messages to the user to confirm what has happened
        if (out === 0) { 
            message = "Success: Course deactivated.";
        } else if (out === 1) {
            message = "Denied Permission: User does not have the correct permissions to perform this action.";
        } else if (out === 2) {
            message = "Duplicate Action: Course already deactivated.";
        } else {
            message = "Unknown Error";
        };
        // Send the message to the user
        response.send(message)
    });
});

/* Assign Course (Admin Only)
This allows the user to assign a teacher to
a course if they are an admin user. This directly
handles issues such as confirming role, stopping
if the course has already been assigned to that
specific teacher and checking the teacher
provided is valid.
*/
app.put('/assigncourse/:idcourse/:iduser/:idteacher', function (request, response) {
    // Log the request in the console
    console.log(request)
    // Make connection to database and call the stored procedure and attempt to update the row
    connection.query(`CALL SP_AssignCourse(?,?,?);`, [request.params.idcourse, request.params.iduser, request.params.idteacher], (error, result)=>{
        // Handle SQL errors
        if (error) throw error;
        // Database returns number to indicate what was completed
        // Get the value sent out of the database from the json body
        out = +JSON.parse(JSON.stringify(result[0]))[0].Result
        // Handle each result with messages to the user to confirm what has happened
        if (out === 0) { 
            message = "Success: Teacher assigned to course.";
        } else if (out === 1) {
            message = "Denied Permission: User does not have the correct permissions to perform this action.'";
        } else if (out === 2) {
            message = "Duplicate Action: Teacher already assigned to course.";
        } else if (out === 3) {
            message = "Invalid Parameter: Provided teacher is not valid, please use a real teacher.";
        } else {
            message = "Unknown Error";
        };
        // Send the message to the user
        response.send(message)
    });
});

/* Available Courses (All)
Fetches a list of all courses available
to the student alongside the teacher
assigned if this is available, for any user.
*/
app.get('/availablecourses', function (request, response) {
    // Log the request in the console
    console.log(request)
    // Make connection to database and call the stored procedure and attempt to get data
    connection.query(`CALL SP_AvailableCourses();`, (error, result)=>{
        // Handle SQL errors
        if (error) throw error;
        // Get just the data in a JSON format
        out = JSON.parse(JSON.stringify(result[0]))
        // Send results to the user
        response.send(out);
    });
});


/* Student Enrol (All)
This allows any user to enrol a student.
This directly handles issues such as a student
already being enrolled on a course or an invalid
student being provided
*/
app.post('/studentenrol/:idcourse/:idstudent', function (request, response) {
    // Log the request in the console
    console.log(request)
    // Make connection to database and call the stored procedure and attempt to insert new row
    connection.query(`CALL SP_StudentEnrol(?,?);`, [request.params.idcourse, request.params.idstudent], (error, result)=>{
        // Handle SQL errors
        if (error) throw error;
        // Database returns number to indicate what was completed
        // Get the value sent out of the database from the json body
        out = +JSON.parse(JSON.stringify(result[0]))[0].Result
        // Handle each result with messages to the user to confirm what has happened
        if (out === 0) { 
            message = "Success: Student enrolled."; //Success
        } else if (out === 2) {
            message = "Duplicate Action: Student is already enrolled. Please contact support team for assistance.";
        } else if (out === 3) {
            message = "Invalid Parameter: Student provided is not valid. Please provide a valid student.";
        } else {
            message = "Unknown Error";
        };
        // Send the message to the user
        response.send(message)
    });
});

/* Teacher Add Marks (Teacher Only)
This allows the user to add grades to the course
if the user is a teacher.
This directly handles issues such as incorrect 
permissions, an invalid student, the enrolment 
not existing and checks the mark is either a pass or fail.
*/
app.put('/teacheraddmarks/:idcourse/:idstudent/:iduser/:mark', function (request, response) {
    // Log the request in the console
    console.log(request)
    // Make connection to database and call the stored procedure and attempt to update the row
    connection.query(`CALL SP_TeacherAddMarks(?,?,?,?);`, [request.params.idcourse, request.params.idstudent, request.params.iduser, request.params.mark], (error, result)=>{
        // Handle SQL errors
        if (error) throw error;
        // Database returns number to indicate what was completed
        // Get the value sent out of the database from the json body
        out = +JSON.parse(JSON.stringify(result[0]))[0].Result
        // Handle each result with messages to the user to confirm what has happened
        if (out === 0) { 
            message = "Success: Mark updated"; //Success
        } else if (out === 1) {
            message = "Denied Permission: User does not have the correct permissions to perform this action.";
        } else if (out === 3) {
            message = "Invalid Parameter: Provided student is not valid, please use a valid student.";
        } else if (out === 4) {
            message = "Missing Data: Student does not have an enrolment for this course.";
        } else if (out === 5) {
            message = "Data Validation: Please only provide a mark of Pass or Fail";
        } else {
            message = "Unknown Error";
        };
        // Send the message to the user
        response.send(message)
    });
});

// Send 404 Error Result if doesn't exist
app.get('*', function(request, response) {  response.json({ error: '404 Page Not Found' });});
