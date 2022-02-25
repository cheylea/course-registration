
// get the client
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

// simple query
connection.query(`CALL SP_AvailableCourses();`, (err, res)=>{
	return console.log(res)
});