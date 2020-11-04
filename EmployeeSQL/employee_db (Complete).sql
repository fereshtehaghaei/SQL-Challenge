--***************************************************************************************************
------------------------------------- PART I: DATA ENGINEERING  -------------------------------------
--***************************************************************************************************
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
-- Create Employees Table 
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
-- Create Departments Table 
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
-- Create Dept_Employee Table 
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
-- Create Dept_Manager Table 
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
-- Create Salaries Table 
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


--***************************************************************************************************
--------------------------------------- PART II: DATA ANALYSIS --------------------------------------
--***************************************************************************************************

-- Viewing tables that will be used in JOIN
SELECT * FROM Employees;
SELECT * FROM Salaries;

-- Question(1): List the following details of each employee: employee number, last name, first name, sex, and salary.
SELECT E.emp_no, E.last_name, E.first_name, E.sex, S.salary
FROM Employees E
JOIN Salaries S
ON E.emp_no = S.emp_no;


-- Question(2): List first name, last name, and hire date for employees who were hired in 1986.
SELECT first_name, last_name, hire_date
FROM Employees
WHERE hire_date BETWEEN '1986-01-01' AND '1986-12-31'
ORDER BY hire_date DESC;		-- Did a ORDER BY DESC and ASC for myself to check dates and results

/* Or it could be done this way as well, it's longer:
				WHERE
						hire_date > '1985-12-31' 
				AND 
						hire_date < '1987-1-1'
						
				ORDER BY hire_date DESC; 	
*/


-- Question(3): List the manager of each department with the following information: 
-- department number, department name, the manager's employee number, last name, first name.

-- Viewing tables that will be used in JOIN
SELECT * FROM Employees;
SELECT * FROM Departments;
SELECT * FROM Dept_Manager;

SELECT D.dept_no, D.dept_name, DM.emp_no, E.last_name, E.first_name
FROM Departments AS D
JOIN Dept_Manager AS DM
ON D.dept_no = DM.dept_no
JOIN Employees AS E
ON E.emp_no = DM.emp_no;


-- Question(4): List the department of each employee with the following information: 
-- employee number, last name, first name, and department name.

-- Viewing tables that will be used in JOIN
SELECT * FROM Employees;
SELECT * FROM Dept_Employee;
SELECT * FROM Departments;

SELECT E.emp_no, E.last_name, E.first_name, D.dept_name
FROM Employees AS E
JOIN Dept_Employee AS DE
ON E.emp_no = DE.emp_no
JOIN Departments AS D
ON D.dept_no = DE.dept_no;


-- Question(5): List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."

-- Viewing table's columns
SELECT * FROM Employees;

SELECT E.first_name, E.last_name, E.sex
FROM Employees AS E
WHERE E.first_name = 'Hercules'
AND E.last_name LIKE 'B%';


-- Question(6):List all employees in the Sales department, including their employee number, last name, first name, and department name.

-- Viewing tables that will be used in JOIN
SELECT * FROM Employees;
SELECT * FROM Dept_Employee;
SELECT * FROM Departments;

SELECT E.emp_no, E.last_name, E.first_name, D.dept_name
FROM Dept_Employee AS DM
JOIN Employees AS E
ON DM.emp_no = E.emp_no
JOIN Departments AS D
ON D.dept_no = DM.dept_no
WHERE dept_name ='Sales';

-- Question(7):List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.

-- Viewing tables that will be used in JOIN
SELECT * FROM Employees;
SELECT * FROM Dept_Employee;
SELECT * FROM Departments;

SELECT E.emp_no, E.last_name, E.first_name, D.dept_name
FROM Dept_Employee AS DM
JOIN Employees AS E
ON DM.emp_no = E.emp_no
JOIN Departments AS D
ON D.dept_no = DM.dept_no
WHERE D.dept_name = 'Sales' 
OR D.dept_name = 'Development';

-- Question(8): In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
SELECT last_name,
COUNT(last_name) AS frequency_count
FROM Employees
GROUP BY last_name
ORDER BY frequency_count DESC;


------ THE END of QUERIES -------
---------------------------------

-- For myself, Code to see unique count for last name
SELECT COUNT(DISTINCT last_name) 
FROM Employees;

/* -------------- This is a reminder for myself ---------------------
The GROUP BY statement groups rows that have the same values into summary rows, 
like "find the number of customers in each country". 
The GROUP BY statement is often used with aggregate functions (COUNT, MAX, MIN, SUM, AVG) 
to group the result-set by one or more columns.
*/