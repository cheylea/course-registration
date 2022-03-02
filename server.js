// setup
const express = require('express');
const app = express();
const mysql = require('mysql2');
const dotenv = require('dotenv');
const PORT = process.env.PORT
dotenv.config();


// create the connection to database
const connection = mysql.createConnection({
    host: process.env.HOST,
    user: process.env.USER,
    database: process.env.DATABASE,
    password: process.env.PASSWORD,
    port: process.env.MYDB_PORT,
  });


// Start server and listen on http://localhost:5000/
var server = app.listen(5000, function () {
    console.log(`Server is listening at http://localhost:5000/`)
});

//Ping endpoint to test status
app.get("/ping", (req, res) => {  
    return res.send({
      status: "Healthy",
    });
  });

// Routing Requests

// Activate Course (Admin Only)
app.put('/activatecourse/:namecourse/:nameuser', function (request, response) {
    console.log(request)
    connection.query(`CALL SP_ActivateCourse(?,?);`, [request.params.namecourse, request.params.nameuser], (error, result)=>{
        if (error) throw error;
        out = +JSON.parse(JSON.stringify(result[0]))[0].Result
        if (out === 0) { 
            message = "Success: Course activated."; //Success
        } else if (out === 1) {
            message = "Denied: User does not have the correct permissions to perform this action.";
        } else if (out === 2) {
            message = "Duplicate Action: Course already activated.";
        } else {
            message = "Unknown Error";
        };
        response.send(message)
    });
});

// Deactivate Course (Admin Only)
app.put('/deactivatecourse/:namecourse/:nameuser', function (request, response) {
    console.log(request)
    connection.query(`CALL SP_DeactivateCourse(?,?);`, [request.params.namecourse, request.params.nameuser], (error, result)=>{
        if (error) throw error;
        out = +JSON.parse(JSON.stringify(result[0]))[0].Result
        if (out === 0) { 
            message = "Success: Course deactivated."; //Success
        } else if (out === 1) {
            message = "Denied Permission: User does not have the correct permissions to perform this action.";
        } else if (out === 2) {
            message = "Duplicate Action: Course already deactivated.";
        } else {
            message = "Unknown Error";
        };
        response.send(message)
    });
});

// Assign Course (Admin Only)
app.put('/assigncourse/:namecourse/:nameuser/:nameteacher', function (request, response) {
    console.log(request)
    connection.query(`CALL SP_AssignCourse(?,?,?);`, [request.params.namecourse, request.params.nameuser, request.params.nameteacher], (error, result)=>{
        if (error) throw error;
        out = +JSON.parse(JSON.stringify(result[0]))[0].Result
        if (out === 0) { 
            message = "Success: Teacher assigned to course."; //Success
        } else if (out === 1) {
            message = "Denied Permission: User does not have the correct permissions to perform this action.'";
        } else if (out === 2) {
            message = "Duplicate Action: Teacher already assigned to course.";
        } else if (out === 3) {
            message = "Invalid Parameter: Provided teacher is not valid, please use a real teacher.";
        } else {
            message = "Unknown Error";
        };
        response.send(message)
    });
});

// Available Courses (All)
app.get('/availablecourses', function (request, response) {
    console.log(request)
    connection.query(`CALL SP_AvailableCourses();`, (error, result)=>{
        if (error) throw error;

        response.end(JSON.stringify(result));
    });
});

// Student Enrol (All)
app.post('/studentenrol/:namecourse/:namestudent', function (request, response) {
    console.log(request)
    connection.query(`CALL SP_StudentEnrol(?,?);`, [request.params.namecourse, request.params.namestudent], (error, result)=>{
        if (error) throw error;
        out = +JSON.parse(JSON.stringify(result[0]))[0].Result
        if (out === 0) { 
            message = "Success: Student enrolled."; //Success
        } else if (out === 2) {
            message = "Duplicate Action: Student is already enrolled. Please contact support team for assistance.";
        } else if (out === 3) {
            message = "Invalid Parameter: Student name provided is not valid. Please provide a valid student name.";
        } else {
            message = "Unknown Error";
        };
        response.send(message)
    });
});

// Teacher Add Marks (Teacher Only)
app.put('/teacheraddmarks/:namecourse/:namestudent/:nameuser/:mark', function (request, response) {
    console.log(request)
    connection.query(`CALL SP_TeacherAddMarks(?,?,?,?);`, [request.params.namecourse, request.params.namestudent, request.params.nameuser, request.params.mark], (error, result)=>{
        if (error) throw error;
        out = +JSON.parse(JSON.stringify(result[0]))[0].Result
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
        response.send(message)
    });
});

// 404 Error Result
app.get('*', function(req, res) {  res.json({ error: '404 Page Not Found' });});