-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- Week 2
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

-- 
-- Exercise: Create a virtual table to summarize data
-- 

-- Task 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- In the first task, Little Lemon need you to create a virtual table called OrdersView
--  that focuses on OrderID, Quantity and Cost columns
--  within the Orders table for all orders with a quantity greater than 2. 
CREATE VIEW OrdersView AS
SELECT OrderID, Quantity, TotalCost
FROM Orders
WHERE Quantity > 2;

Select * from OrdersView;

-- Task 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- For your second task, Little Lemon need information from four tables on all customers with orders that cost more than $150. 
-- Extract the required information from each of the following tables by using the relevant JOIN clause: 
-- Customers table: The customer id and full name.
-- Orders table: The order id and cost.
-- Menus table: The menus name.
-- MenusItems table: course name and starter name.
-- The result set should be sorted by the lowest cost amount.

SELECT Customers.CustomerID, CONCAT(Customers.FirstName, " ", Customers.LastName) AS "FullName", Orders.OrderID,
Orders.TotalCost, Menu.MenuName, MenuItems.CourseName, MenuItems.StarterName
FROM Orders
JOIN Customers ON Orders.CustomerID = Customers.CustomerID
JOIN Menu ON Orders.MenuID = Menu.MenuID
JOIN MenuItems ON Menu.MenuItemID = MenuItems.MenuItemID
WHERE Orders.TotalCost > 150
ORDER BY TotalCost DESC;

-- Task 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- For the third and final task, Little Lemon need you to find all menu items for which more than 2 orders have been placed. 
-- You can carry out this task by creating a subquery that lists the menu names from the menus table for any order quantity with more than 2.
-- Here’s some guidance around completing this task: 
-- Use the ANY operator in a subquery
-- The outer query should be used to select the menu name from the menus table.
-- The inner query should check if any item quantity in the order table is more than 2. 

SELECT MenuName
FROM Menu
WHERE  (SELECT Quantity FROM Orders) > 2;
-- ***********************************************************************************************


--
-- Exercise: Create optimized queries to manage and analyze data
--

-- Task 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- In this first task, Little Lemon need you to create a procedure that displays the maximum ordered quantity in the Orders table. 
-- Creating this procedure will allow Little Lemon to reuse the logic implemented in the procedure easily 
-- without retyping the same code over again and again to check the maximum quantity. 

-- change delimiter to create procedure
delimiter //

-- create stored procedure
CREATE PROCEDURE GetMaxQuantity()
BEGIN
SELECT OrderID, Quantity
FROM Orders
ORDER BY Quantity DESC
LIMIT 1;
END
//

-- reset delimiter
delimiter ;

-- invoking procedure
CALL GetMaxQuantity();
-- delete procdure
DROP PROCEDURE GetMaxQuantity;


-- Task 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- In the second task, Little Lemon need you to help them to create a prepared statement called GetOrderDetail.
-- This prepared statement will help to reduce the parsing time of queries. It will also help to secure the database from SQL injections.
-- The prepared statement should accept one input argument, the CustomerID value, from a variable. 
-- The statement should return the order id, the quantity and the order cost from the Orders table. 
-- Once you create the prepared statement, you can create a variable called id and assign it value of 1. 

-- create prepared statements
PREPARE GetOrderDetail FROM 'SELECT OrderID, CustomerID, Quantity, TotalCost FROM Orders WHERE CustomerID = ?';

-- create variable 
SET @id = 1;
-- invoke prepared statements
EXECUTE GetOrderDetail USING @id;

-- delete prepared statement
DROP PREPARE GetOrderDetail;


-- Task 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- Your third and final task is to create a stored procedure called CancelOrder. 
-- Little Lemon want to use this stored procedure to delete an order record based on the user input of the order id.
-- Creating this procedure will allow Little Lemon to cancel any order by specifying the order id value in the procedure parameter 
-- without typing the entire SQL delete statement.   

-- change delimiter to create procedure
delimiter //
-- create stored procedure
CREATE PROCEDURE CancelOrder(IN UserOrderID INT)
BEGIN
DELETE FROM Orders
WHERE OrderID = UserOrderID;

SELECT UserOrderID AS "Confirmation"
FROM Orders;
END
//
-- reset delimiter
delimiter ;

-- invoking procedure
Call CancelOrder(2);
-- delete procdure
DROP PROCEDURE CancelOrder;


--
-- Exercise: Create SQL queries to check available bookings based on user input
-- 


-- Task 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- Little Lemon wants to populate the Bookings table of their database with some records of data.
-- Your first task is to replicate the list of records in the following table by adding them to the Little Lemon booking table. 
-- You can use simple INSERT statements to complete this task.

INSERT INTO Booking (BookingID, BookingDate, TableNo, StaffNo)
VALUES
(5, 2022-10-10, 5, 5),
(6, 2022-11-12, 6, 6),
(7, 2022-10-11, 7, 7),
(8, 2022-10-13, 8, 8);


-- Task 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- Little Lemon need you to create a stored procedure called CheckBooking to check whether a table in the restaurant is already booked. 
-- Creating this procedure helps to minimize the effort involved in repeatedly coding the same SQL statements.
-- The procedure should have two input parameters in the form of booking date and table number. 
-- You can also create a variable in the procedure to check the status of each table.

-- change delimiter to create procedure
delimiter //
-- create stored procedure
CREATE PROCEDURE CheckBooking(IN UserDate DATE, UserTableNo INT)
BEGIN
SELECT BookingDate, TableNo
FROM Bookings
WHERE BookingDate = '2022-01-12' AND TableNo = 1;

END
//
-- reset delimiter
delimiter ;

-- invoking procedure
Call CheckBooking(2022-01-12, 1);
-- delete procdure
DROP PROCEDURE CheckBooking;


-- Task 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- Little Lemon need to verify a booking, and decline any reservations for tables that are already booked under another name. 
-- Since integrity is not optional, Little Lemon need to ensure that every booking attempt includes these verification and decline steps. 
-- However, implementing these steps requires a stored procedure and a transaction. 
-- To implement these steps, you need to create a new procedure called AddValidBooking.
-- This procedure must use a transaction statement to perform a rollback if a customer reserves a table that’s already booked under another name.  
-- Use the following guidelines to complete this task:
-- The procedure should include two input parameters in the form of booking date and table number.
-- It also requires at least one variable and should begin with a START TRANSACTION statement.
-- Your INSERT statement must add a new booking record using the input parameter's values.
-- Use an IF ELSE statement to check if a table is already booked on the given date. 
-- If the table is already booked, then rollback the transaction. If the table is available, then commit the transaction. 



-- SKIP $$$$$$$$$$$


--
-- Exercise: Create SQL queries to add and update bookings
-- 

-- Task 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- In this first task you need to create a new procedure called AddBooking to add a new table booking record.
-- The procedure should include four input parameters in the form of the following bookings parameters:
-- booking id, 
-- customer id, 
-- booking date,
-- and table number.

-- change delimiter to create procedure
delimiter //
-- create stored procedure
CREATE PROCEDURE AddBooking(IN UserBookingID INT, UserBookingDate DATE, UserTableNo INT, UserStaffNo INT)
BEGIN
INSERT INTO Bookings (BookingID, BookingDate, TableNo, StaffNo)
VALUES
(UserBookingID, UserBookingDate, UserTableNo, UserStaffNo);
END
//
-- reset delimiter
delimiter ;

-- invoking procedure
Call AddBooking(10, 2022-01-12, 3, 3);
-- delete procdure
DROP PROCEDURE AddBooking;


-- Task 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- Little Lemon need you to create a new procedure called UpdateBooking that they can use to update existing bookings in the booking table.
-- The procedure should have two input parameters in the form of booking id and booking date.
-- You must also include an UPDATE statement inside the procedure. 

-- change delimiter to create procedure
delimiter //
-- create stored procedure
CREATE PROCEDURE UpdateBooking(IN UserBookingID INT, UserBookingDate DATE)
BEGIN
UPDATE Bookings
SET BookingDate = UserBookignDate
WHERE BookingID = UserBookingID;
END
//
-- reset delimiter
delimiter ;

-- invoking procedure
Call UpdateBooking(10, 2022-01-12);
-- delete procdure
DROP PROCEDURE UpdateBooking;


-- Task 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- Little Lemon need you to create a new procedure called CancelBooking that they can use to cancel or remove a booking.
-- The procedure should have one input parameter in the form of booking id. You must also write a DELETE statement inside the procedure. 

-- change delimiter to create procedure
delimiter //
-- create stored procedure
CREATE PROCEDURE CancelBooking(IN UserBookingID INT)
BEGIN
DELETE FROM Bookings
WHERE BookingID = UserBookingID;
END
//
-- reset delimiter
delimiter ;

-- invoking procedure
Call CancelBooking(10);
-- delete procdure
DROP PROCEDURE CancelBooking;



