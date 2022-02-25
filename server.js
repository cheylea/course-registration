// setup
const express = require('express');
const app = express();
const mysql = require('mysql2');
const dotenv = require('dotenv');
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
    console.log("app listening at http://localhost:5000/")
});

// Different Routing Requests
// Activate Course (Admin Only)
app.put('/activatecourse', function (req, res) {
    
    res.send('Hello World! - activate courses')
})

// Deactivate Course (Admin Only)
app.put('/deactivatecourse', function (req, res) {
    res.send('Hello World! - deactivate courses')
})

// Assign Course (Admin Only)
app.put('/assigncourse', function (req, res) {
    res.send('Hello World! - assign course')
})

// Available Courses (All)
app.get('/availablecourses', function (req, res) {
    res.send('Hello World! - available courses')
    connection.connect()
    connection.query(`CALL SP_AvailableCourses();`, (err, res)=>{
        return console.log(res)
    });
    connection.end()
})

// Student Enrol (All)
app.post('/studentenrol', function (req, res) {
    res.send('Hello World! - studentenrol')
})

// Teacher Add Marks (Teacher Only)
app.put('/teacheraddmarks', function (req, res) {
    res.send('Hello World! - teacher add marks')
})