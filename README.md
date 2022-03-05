# School Course Registration App
This app is a server that can be run and used to interact with a connected database. 

The functionality is as follows:
* Activate the course in the system (admin only)
* Deactivate the course in the system (admin only)
* Assign the course to a teacher (admin only)
* Get a list of available courses
* Enrol a student in a course
* Add the marks to the course enrolment record (teacher only)

### Prerequisites
It uses [Node.js](https://nodejs.org/en/download/), [Express](https://expressjs.com/en/starter/installing.html) and [MySQL](https://dev.mysql.com/downloads/) so ensure you have these installed before beginning.

## Directory
The below directory shows some of the main files references in this README.
```
C:.
├───database_scripts
│   └───create_stored_procedures
├───test
│   ├───postman
│   │   ├───basic_requests.postman-collection.json
│   │   ├───data_reset_for_testing.sql
│   │   └───full_testing.postman-collection.json
│   └───testing_database
│       ├───app.js
│   	└───testingqueries.sql
├───postman
│   ├───course-registration.postman_collection.json
│   └───Testing_API.postman_collection.json
├───server.js
└───package.json
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
PORT=5050
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
Server is listening at http://localhost:5050/
```

### API
A tool such as [Postman](https://www.postman.com/) can be used to send calls to the server.

Included in this repository in the `test\postman` folder is a json file `basic_requests.postman-collection.json` that can be imported into the Postman application to use with this server to check each API is working.

For full testing, within the folder there is also a json file `full_testing.postman-collection.json`. See Testing the Server section for more information.

## Database Setup
Provided database is a MySQL database and can be installed using a tool such as MySQL Workbench.

Once the database is installed, open the scripts in the folder `database_scripts\create_stored_procedures` within the DBMS and run each one once. When the schema is refreshed the stored procedures should appear on the database.

## Testing the Database
There is a provided folder that can test the connection to the server and ensure you can receive data as well as test the individual stored procedures.

### Testing Queries
In the `test\database` file there is a sql file containing suggested test queries using the provided database. These can be run in the DBMS directly or used within the `app.js` file to test that the connection to the database server is working.

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

## Testing the Server

### Preparation
Before beginning testing, please ensure the following:

* Check your MySQL server is running
* Ensure `full_testing.postman-collection.json` has been imported into the POSTMAN application for full testing or `basic_requests.postman-collection.json` for quick testing.
* There is a `data_reset_for_testing.sql` found in the `test\postman`. Run this file on the database before beginning full testing.
* You have created a .env file as instructed previously, and `PORT` is set to `5050`
* Run the `server.js` file to open the server.

### Testing
Once the server is running the first method to call should be the /ping in order to check the server is running.

Once this has passed, each test can be run from top to bottom to check the expected message is returned.


## Contributing
Pull requests permitted. When contributing please update the test directory as appropriate with any additional requirements. 
