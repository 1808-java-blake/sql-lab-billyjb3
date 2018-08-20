-- Part I – Working with an existing database

-- 1.0 Setting up Oracle Chinook
-- In this section you will begin the process of working with the Oracle Chinook database
-- Task – Open the Chinook_Oracle.sql file and execute the scripts within.

-- 2.0 SQL Queries
-- In this section you will be performing various queries against the Oracle Chinook database.

-- 2.1 SELECT
-- Task – Select all records from the Employee table.
SELECT * FROM employee;
-- Task – Select all records from the Employee table where last name is King.
SELECT * FROM employee WHERE lastname = 'King';
-- Task – Select all records from the Employee table where first name is Andrew and REPORTSTO is NULL.
SELECT * FROM employee WHERE firstname = 'Andrew' AND reportsto IS NULL;

-- 2.2 ORDER BY
-- Task – Select all albums in Album table and sort result set in descending order by title.
SELECT * FROM album ORDER BY title DESC;
-- Task – Select first name from Customer and sort result set in ascending order by city
SELECT firstname FROM customer ORDER BY city ASC;

-- 2.3 INSERT INTO
-- Task – Insert two new records into Genre table\
INSERT INTO genre VALUES (26, 'LoFi'), (27, 'Instrumental Metal');
-- Task – Insert two new records into Employee table
INSERT INTO employee VALUES (9, 'Roberst', 'John', 'Janitor', 6, '1921-12-21 00:00:00', '1999-05-23 00:00:00', '123 Drivedown Road', 'Denver', 'CO', 'United States', '54789', '1(876)-5412', '1(874)125-9864', 'john@chinookcorp.com');
INSERT INTO employee VALUES (10, 'Green', 'Yoda', 'Persuasive Salesman', 2, '1704-08-14 00:00:00', '2007-12-09 00:00:00', '800 North Bog Street', 'LandOLakes', 'FL', 'United States', '36547', '1(541)123-4567', '1(874)125-9864', 'yoda@chinookcorp.com');
-- Task – Insert two new records into Customer table
INSERT INTO customer VALUES (60, 'Jimmy', 'John', 'Sandwich Shop', '123 The Road Street', 'Coldtown', 'Alaska', 'United States', '12345', '123-948-8395', '123-123-1234', 'jimmy@sandwich.com', 3),
							(61, 'Bob', 'Ross', 'Paint That', '321 Street Road', 'Sunville', 'Arizona', 'United States', '54321', '321-321-4321', '246-135-0987', 'bob@painters.com', 2);

-- 2.4 UPDATE
-- Task – Update Aaron Mitchell in Customer table to Robert Walter
UPDATE customer SET firstname = 'Robert', lastname = 'Walter' WHERE customerid = 32;

-- Task – Update name of artist in the Artist table “Creedence Clearwater Revival” to “CCR”
UPDATE artist SET name = 'CCR' WHERE name = 'Creedence Clearwater Revival';


-- 2.5 LIKE
-- Task – Select all invoices with a billing address like “T%”
SELECT * FROM invoice WHERE billingaddress LIKE 'T%';


-- 2.6 BETWEEN
-- Task – Select all invoices that have a total between 15 and 50
SELECT * FROM invoice WHERE total > 15 AND total < 50;

-- Task – Select all employees hired between 1st of June 2003 and 1st of March 2004
SELECT * FROM employee WHERE hiredate > '2003-06-01' AND hiredate < '2004-03-01';


-- 2.7 DELETE
-- Task – Delete a record in Customer table where the name is Robert Walter (There may be constraints that rely on this, find out how to resolve them).
ALTER TABLE invoiceline DROP CONSTRAINT fk_invoicelineinvoiceid;
ALTER TABLE invoice DROP CONSTRAINT fk_invoicecustomerid;
ALTER TABLE invoice ADD CONSTRAINT fk_invoicecustomerid FOREIGN KEY (customerid) REFERENCES customer (customerid) ON DELETE CASCADE;
ALTER TABLE invoiceline ADD CONSTRAINT fk_invoicelineinvoiceid FOREIGN KEY (invoiceid) REFERENCES invoice (invoiceid) ON DELETE CASCADE;
DELETE FROM customer WHERE firstname = 'Robert' AND lastname = 'Walter';

-- 3.0 SQL Functions
-- In this section you will be using the Oracle system functions, as well as your own functions, to perform various actions against the database

-- 3.1 System Defined Functions
-- Task – Create a function that returns the current time.
CREATE OR REPLACE FUNCTION getTheTime()
RETURNS timestamp AS $$
BEGIN
	RETURN NOW();
END;
$$ LANGUAGE plpgsql;

SELECT getTheTime();

-- Task – create a function that returns the length of a mediatype from the mediatype table
CREATE OR REPLACE FUNCTION type_length (mediatype VARCHAR)
RETURNS INTEGER AS $$
BEGIN
	RETURN LENGTH(mediatype);
END;
$$ LANGUAGE plpgsql;

SELECT type_length(name) FROM mediatype WHERE mediatypeid = 1;

-- 3.2 System Defined Aggregate Functions
-- Task – Create a function that returns the average total of all invoices
CREATE OR REPLACE FUNCTION invoice_average()
RETURNS TABLE(average NUMERIC) AS $$
BEGIN
	RETURN QUERY SELECT AVG(total) FROM invoice;
END;
$$ LANGUAGE plpgsql;

SELECT invoice_average();

-- Task – Create a function that returns the most expensive track
CREATE OR REPLACE FUNCTION top_dollar()
RETURNS TABLE(tid INTEGER, nme VARCHAR, aid INTEGER, mid INTEGER, gid INTEGER, cmpsr VARCHAR, ms INTEGER, bts INTEGER, prc NUMERIC) AS $$
BEGIN
	RETURN QUERY SELECT * FROM track WHERE unitprice = (SELECT MAX(unitprice) FROM track);
END;
$$ LANGUAGE plpgsql;

SELECT top_dollar();

-- 3.3 User Defined Scalar Functions
-- Task – Create a function that returns the average price of invoiceline items in the invoiceline table

-- 3.4 User Defined Table Valued Functions
-- Task – Create a function that returns all employees who are born after 1968.
CREATE OR REPLACE FUNCTION old_employees()
RETURNS TABLE(eid INTEGER, fstn VARCHAR, lstn VARCHAR) as $$
BEGIN
	RETURN QUERY SELECT employeeid, firstname, lastname FROM employee WHERE birthdate >= '01-01-1969 00:00:00';
END;
$$ LANGUAGE plpgsql;

SELECT old_employees();

-- 4.0 Stored Procedures
--  In this section you will be creating and executing stored procedures. You will be creating various types of stored procedures that take input and output parameters.

-- 4.1 Basic Stored Procedure
-- Task – Create a stored procedure that selects the first and last names of all the employees.
CREATE OR REPLACE FUNCTION get_names()
RETURNS TABLE(fn VARCHAR, ln VARCHAR) AS $$
BEGIN
	RETURN QUERY SELECT firstname, lastname FROM employee;
END;
$$ LANGUAGE plpgsql;

SELECT get_names();

-- 4.2 Stored Procedure Input Parameters
-- Task – Create a stored procedure that updates the personal information of an employee.
CREATE OR REPLACE FUNCTION update_employee(lstname VARCHAR, fstname VARCHAR, ttl VARCHAR, rprtto INTEGER, bthday TIMESTAMP, hrday TIMESTAMP, 
										   addrs VARCHAR, cty VARCHAR, stat VARCHAR, cntry VARCHAR, pstlcode VARCHAR, phn VARCHAR, fx VARCHAR, emal VARCHAR)
RETURNS NULL 
BEGIN
	
END;
$$ LANGUAGE plpgsql;
-- Task – Create a stored procedure that returns the managers of an employee.

-- 4.3 Stored Procedure Output Parameters
-- Task – Create a stored procedure that returns the name and company of a customer.
CREATE OR REPLACE FUNCTION customer_info(customer_id INTEGER)
RETURNS TABLE(first_name VARCHAR, last_name VARCHAR, customer_company VARCHAR) AS $$
BEGIN
	RETURN QUERY SELECT firstname, lastname, company FROM customer WHERE customerid = customer_id;
END;
$$ LANGUAGE plpgsql;

SELECT customer_info(10);

-- 5.0 Transactions
-- In this section you will be working with transactions. Transactions are usually nested within a stored procedure. You will also be working with handling errors in your SQL.
-- Task – Create a transaction that given a invoiceId will delete that invoice (There may be constraints that rely on this, find out how to resolve them).
CREATE OR REPLACE FUNCTION delete_invoice(invoice_id INTEGER)
RETURNS VOID AS $$
BEGIN
	ALTER TABLE invoiceline DROP CONSTRAINT fk_invoicelineinvoiceid;
	ALTER TABLE invoiceline ADD CONSTRAINT fk_invoicelineinvoiceid FOREIGN KEY (invoiceid) REFERENCES invoice (invoiceid) ON DELETE CASCADE;
	DELETE FROM invoice WHERE invoiceid = invoice_id;
END;
$$ LANGUAGE plpgsql;

SELECT delete_invoice(1);

-- Task – Create a transaction nested within a stored procedure that inserts a new record in the Customer table
CREATE OR REPLACE FUNCTION new_customer(new_customerid INTEGER, new_firstname VARCHAR, new_lastname VARCHAR, new_company VARCHAR, new_address VARCHAR, new_city VARCHAR, 
										new_state VARCHAR, new_country VARCHAR, new_postalcode VARCHAR, new_phone VARCHAR, new_fax VARCHAR, new_email VARCHAR, 
										new_supportrepid INTEGER)
RETURNS VOID AS $$
BEGIN
	INSERT INTO customer (customerid, firstname, lastname, company, address, city, state, country, postalcode, phone, fax, email, supportrepid) VALUES
		(new_customerid, new_firstname, new_lastname, new_company, new_address, new_city, new_state, new_country, new_postalcode, new_phone, new_fax, new_email, new_supportrepid);
END;
$$ LANGUAGE plpgsql;

SELECT new_customer(60, 'firstname', 'lastname', 'company', 'address', 'city', 'state', 'country', 'postalcode', 'phone', 'fax', 'email', 5);

-- 6.0 Triggers
-- In this section you will create various kinds of triggers that work when certain DML statements are executed on a table.

-- 6.1 AFTER/FOR
-- Task - Create an after insert trigger on the employee table fired after a new record is inserted into the table.
CREATE OR REPLACE FUNCTION employee_insert_triggerd()
RETURNS TRIGGER AS $$
BEGIN
	UPDATE employee SET lastname = 'triggered', firstname = 'triggered' WHERE employeeid = (SELECT MAX(employeeid) FROM employee);
	return NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER triggered_employee AFTER INSERT ON employee FOR EACH ROW EXECUTE PROCEDURE employee_insert_triggerd();

INSERT INTO employee VALUES (15, 'lastname', 'firstname', 'title', 2, '10-10-2010', '11-11-2011', 'address', 'city', 'state', 'country', 'pcode', '111-111-1111', '222-222-2222', 'email@email.com');

-- Task – Create an after update trigger on the album table that fires after a row is inserted in the table
CREATE OR REPLACE FUNCTION updated_album_triggered()
RETURNS TRIGGER AS $$
DECLARE lastid INTEGER;
BEGIN
	SELECT MAX(albumid) INTO lastid FROM album;
	INSERT INTO album VALUES (lastid+1, 'triggered album title', 1);
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER triggered_album_update AFTER UPDATE ON album FOR EACH ROW EXECUTE PROCEDURE updated_album_triggered();

UPDATE album SET title = 'this set off a trigger' WHERE albumid = 1;

-- Task – Create an after delete trigger on the customer table that fires after a row is deleted from the table.

-- 6.2 INSTEAD OF
-- Task – Create an instead of trigger that restricts the deletion of any invoice that is priced over 50 dollars.

-- 7.0 JOINS
-- In this section you will be working with combing various tables through the use of joins. You will work with outer, inner, right, left, cross, and self joins.

-- 7.1 INNER
-- Task – Create an inner join that joins customers and orders and specifies the name of the customer and the invoiceId.
SELECT customer.firstname, customer.lastname, invoice.invoiceid FROM customer INNER JOIN invoice ON customer.customerid = invoice.customerid;

-- 7.2 OUTER
-- Task – Create an outer join that joins the customer and invoice table, specifying the CustomerId, firstname, lastname, invoiceId, and total.
SELECT customer.customerid, customer.firstname, customer.lastname, invoice.invoiceid, invoice.total FROM customer FULL OUTER JOIN invoice ON customer.customerid = invoice.customerid;

-- 7.3 RIGHT
-- Task – Create a right join that joins album and artist specifying artist name and title.
SELECT artist.name, album.title FROM album RIGHT JOIN artist ON artist.artistid = album.artistid;

-- 7.4 CROSS
-- Task – Create a cross join that joins album and artist and sorts by artist name in ascending order.
SELECT * FROM album CROSS JOIN artist ORDER BY artist.name ASC;

-- 7.5 SELF
-- Task – Perform a self-join on the employee table, joining on the reportsto column.
SELECT e.firstname, e.lastname, m.firstname, m.lastname FROM employee e
INNER JOIN employee m ON e.reportsto = m.employeeid;







