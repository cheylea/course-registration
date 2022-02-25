# School Course Registration App
*fill in desc*

## Directory
*need to add something here*

## Database Setup
Provided database is a MySQL database and can be installed using a tool such as MySQL Workbench.



## Installation
Use the package manager [npm](https://www.npmjs.com//) to install the dependencies.
```bash
npm install package.json
```

## Using the Server
*fill in*

## Testing the Database
There is a provided folder that can test the connection to the server and ensure you can receive data as well as test the individual stored procedures.

### Testing Queries
In the `test` file there is a sql file containing suggested test queries using the provided database. These can be run in the DBMS or used within the app.js file to test that the connection to the database server is working.

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
PORT=5000
USER=exampleuser
PASSWORD=examplepassword
DATABASE=mydb
MYDB_PORT=3306
HOST=localhost
```

## Contributing
Pull requests permitted. When contributing please update the test directory as appropriate with any additional requirements. 