------ DATA ENGINEERING -------

-- Drop tables incase they exists I used CASCADE because I had foreign keys assigned.
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS Departments CASCADE;
DROP TABLE IF EXISTS Dept_Employee CASCADE;
DROP TABLE IF EXISTS Dept_Manager CASCADE;
DROP TABLE IF EXISTS Salaries CASCADE;
DROP TABLE IF EXISTS Title CASCADE;


----------------------------------
-- Creating Title Table 
----------------------------------
CREATE TABLE Title 
(
    title_id VARCHAR   NOT NULL,
    title VARCHAR   NOT NULL,
		PRIMARY KEY (title_id) 
);

-- Import table data from CSV file
-- Query * FROM Title Table Confirming Data
SELECT *
FROM Title ;


----------------------------------
-- Creating Employees Table 
----------------------------------
CREATE TABLE Employees 
(
    emp_no INT   NOT NULL,
    emp_title_id VARCHAR   NOT NULL,
    birth_date DATE   NOT NULL,
    first_name VARCHAR   NOT NULL,
    last_name VARCHAR   NOT NULL,
    sex VARCHAR   NOT NULL,
    hire_date DATE   NOT NULL,
    	PRIMARY KEY (emp_no),
		FOREIGN KEY(emp_title_id) REFERENCES Title(title_id) -- My side note: The table that you are trying to add the info to, that's where you create the foreign key
);

-- Import table data from CSV file
-- Query * FROM Employees Table Confirming Data
SELECT *
FROM Employees;


----------------------------------
-- Creating Departments Table 
----------------------------------
CREATE TABLE Departments 
(
    dept_no VARCHAR   NOT NULL,
    dept_name VARCHAR   NOT NULL,
     		PRIMARY KEY (dept_no)
);

-- Import table data from CSV file
-- Query * FROM Departments Table Confirming Data
SELECT *
FROM Departments;


---------------------------------- 
-- Creating Dept_Employee Table 
----------------------------------
CREATE TABLE Dept_Employee 
(
    emp_no INT   NOT NULL,
    dept_no VARCHAR   NOT NULL,
	FOREIGN KEY(emp_no)REFERENCES Employees (emp_no),
	FOREIGN KEY(dept_no)REFERENCES Departments (dept_no)
);

-- Import table data from CSV file
-- Query * FROM Dept_Employee Table Confirming Data
SELECT *
FROM Dept_Employee;


----------------------------------
-- Creating Dept_Manager Table 
----------------------------------
CREATE TABLE Dept_Manager 
(
    dept_no VARCHAR   NOT NULL,
    emp_no INT   NOT NULL,
	FOREIGN KEY(emp_no)REFERENCES Employees (emp_no),
	FOREIGN KEY(dept_no)REFERENCES Departments (dept_no)

);

-- Import table data from CSV file
-- Query * FROM Dept_Manager Table Confirming Data
SELECT *
FROM Dept_Manager;


----------------------------------
-- Creating Salaries Table 
----------------------------------
CREATE TABLE Salaries 
(
    emp_no INT   NOT NULL,
    salary INT   NOT NULL,
	FOREIGN KEY(emp_no)REFERENCES Employees (emp_no)
);

-- Import table data from CSV file
-- Query * FROM Salaries Table Confirming Data
SELECT *
FROM Salaries;

/* 
	The first time I forgot to set a foreing key for Employees table so I had to ALTER my table.
	I re-did the query and created new tables so this ALTER line is commented out now because
	Foreign key was assigned inside Employee Table and since we assigning a foreign key to Employees from 
	a primary key in Title table, I had to create title table before Employees.
*/

/*
ALTER TABLE Employees ADD CONSTRAINT fk_title_id
FOREIGN KEY(emp_title_id) REFERENCES Title(title_id);
*/

