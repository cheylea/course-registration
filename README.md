# School Course Registration App
This app is a server that can be run and used to interact with a connected database.

The functionality is as follows:
* Activate the course in the system (admin only)
* Deactivate the course in the system (admin only)
* Assign the course to a teacher (admin only)
* Get a list of available courses
* Enrol a student in a course
* Add the marks to the course enrolment record (teacher only)

## Directory
```bash
C:.
├───database_scripts
│   └───create_stored_procedures
├───test
│   └───test_connection
└───server.js
```

## Installation
Use the package manager [npm](https://www.npmjs.com//) to install the dependencies.
```bash
npm install package.json
```

## Using the Server
### Set up .env document
Create a .env file in the same place as the `server.js` file and use the below template to replace with login details for your database server. The port and host provided will be the port you want to run the server on.

```bash
PORT=5000
USER=exampleuser
PASSWORD=examplepassword
DATABASE=mydb
MYDB_PORT=3306
HOST=localhost
```

### Run the server
Navigate to the folder containing the file and run the following in the terminal.
```bash
node server.js
```
The result should give the following depending on the host and the port provided in the .env file.
```bash
Server is listening at http://localhost:5000/
```

### API
A tool such as Postman can be used to send calls to the server:

![](https://imgur.com/a/5osKPr6 "Postman Example")

## Database Setup
Provided database is a MySQL database and can be installed using a tool such as MySQL Workbench.

Once the database is installed, open the scripts in the folder `database_scripts\create_stored_procedures` within the DBMS and run each one once. When the schema is refreshed the stored procedures should appear on the database.

## Testing the Database
There is a provided folder that can test the connection to the server and ensure you can receive data as well as test the individual stored procedures.

### Testing Queries
In the `test` file there is a sql file containing suggested test queries using the provided database. These can be run in the DBMS directly or used within the `app.js` file to test that the connection to the database server is working.

### Running app.js
The SQL Query can be set within this file:
```javascript
// simple query
connection.query(`CALL SP_AvailableCourses();`, (err, res)=>{
	return console.log(res)
});
```

To run the test, navigate to the test_connection folder and run the following in the termine:

```bash
node app.js
```

### Set up .env document
Create a .env file in the `test_connection` folder and use the below template to replace with login details for your database server.

```bash
PORT=5050
USER=exampleuser
PASSWORD=examplepassword
DATABASE=mydb
MYDB_PORT=3306
HOST=localhost
```

## Contributing
Pull requests permitted. When contributing please update the test directory as appropriate with any additional requirements. 
