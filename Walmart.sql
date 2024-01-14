SHOW DATABASES;
CREATE DATABASE walmart;
USE walmart;

CREATE TABLE customer(customer_id VARCHAR(8) PRIMARY KEY,
                      customer_name VARCHAR(30) NOT NULL
                      );
DESC customer;

CREATE TABLE address(postal_code NUMERIC(5) PRIMARY KEY,
					 country VARCHAR(15) NOT NULL,
                     region VARCHAR(5),
                     state VARCHAR(30),
                     city VARCHAR(30)
                     );
DESC address;

CREATE TABLE product(product_id VARCHAR(15) PRIMARY KEY,
                     product_name CHAR NOT NULL,
                     category CHAR(15) NOT NULL,
                     sub_category CHAR(12) NOT NULL
                     );
DESC product;

CREATE TABLE sales(row_id NUMERIC(5) PRIMARY KEY,
                   order_id VARCHAR(15) NOT NULL,
                   order_date DATE NOT NULL,
                   ship_date DATE NOT NULL,
                   ship_mode VARCHAR(15) NOT NULL,
                   customer_id VARCHAR(8),
                   segment CHAR(15) NOT NULL,
                   postal_code NUMERIC(5),
                   product_id VARCHAR(15),
                   sales DOUBLE NOT NULL,
                   quantity NUMERIC NOT NULL,
                   discount DOUBLE ,
                   profit DOUBLE,
                   FOREIGN KEY(customer_id) REFERENCES customer(customer_id),
                   FOREIGN KEY(postal_code) REFERENCES address(postal_code),
                   FOREIGN KEY(product_id) REFERENCES product(product_id),
                   CHECK(discount<= 1.00)
                   );
DESC sales;

# Change data type to VARCHAR of Product Name Column in Produt Table
ALTER TABLE product MODIFY COLUMN product_name VARCHAR(250) NOT NULL;
DESC product;

# Find all the information about each Sales
SELECT * FROM sales;

# Find the Customer_id, Segment and Postal Code from Sales
SELECT Customer_id, Segment, Postal_code FROM sales;

# List all the segments (no duplicates)
SELECT DISTINCT Segment FROM sales;

# Find the list of 10 customers with highest orders among all the customers in decreasing order
SELECT Customer_id, COUNT(row_id) AS "Order Frequency" FROM sales
				GROUP BY customer_id
				ORDER BY COUNT(row_id) DESC 
                LIMIT 10;

# Find 10 customers with the highest Sales along with the quantity ordered and order frequency
SELECT Customer_id, COUNT(row_id) AS "Order Frequency",
				SUM(quantity) AS "Total Units Ordered",
				CONCAT("$",FORMAT(SUM(sales),'C')) AS "Total Sales" 
                FROM sales 
				GROUP BY customer_id 
                ORDER BY SUM(sales) DESC 
                LIMIT 10;

# Find the name of 5 customer with the highest amount of Sales
SELECT DISTINCT c.Customer_id, Customer_name FROM sales s
				JOIN customer c
                ON s.customer_id = c.customer_id
				GROUP BY customer_id 
                ORDER BY SUM(sales) 
                DESC LIMIT 5;

# Find Segment wise number of orders and total sales (ordered from highest to lowest)
SELECT Segment, Count(*) AS Total_Order, CONCAT('$',Format(SUM(sales),'c')) AS Total_Sales
				FROM sales
                GROUP BY Segment
                ORDER BY SUM(sales) DESC;

# Find State wise average Sales
SELECT State, CONCAT('$',Format(AVG(sales),'c')) AS Average_Sales FROM sales s
				JOIN address a
                ON s.postal_code = a.postal_code
                GROUP BY state
                ORDER BY AVG(Sales) DESC;

# Find all the loss making Sales
SELECT Order_id, Customer_id, Product_id, Profit FROM sales
				WHERE profit <0
				ORDER BY profit ASC;

# Find Sales after 2013 for Washington State 
-- must include Customer name, Segment, City, Product Category, Sales
SELECT Order_date, Customer_Name, Segment, City, Category, Sub_Category, Sales
		FROM Sales 
		JOIN customer 
        USING(customer_id)
        JOIN product
        USING(product_id)
        JOIN address
        USING(postal_code)
        WHERE State ="Washington" AND order_date> '2013-12-31'
        ORDER BY order_date;
        
DROP DATABASE walmart;
