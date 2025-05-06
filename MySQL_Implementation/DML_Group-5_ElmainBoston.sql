-- ___________________________________________________________ ELMAIN BOSTON ___________________________________________________________________________________________________

-- Simple Query

-- Display all from customer
SELECT Customer_ID AS ID, First_Name AS Name, State, Date_of_Birth
FROM customer;

-- Display Distinct Shipping Partner Name
SELECT DISTINCT Shipping_Partner
FROM shipping;

-- Display tailor name which starts with 'A'
SELECT Tailor_Name
FROM tailor
WHERE TAILOR_NAME LIKE 'A%';

-- _____________________________________________________________________________________________________________________________________________________________________________

--  Aggregate Query

-- Display average product price for each category
SELECT Category, AVG(PRICE) As Price_AVG
FROM product
GROUP BY Category;

-- Display combined price of all product of category 'Outerwear'
SELECT SUM(Price) AS Total_Price 
FROM product 
WHERE Category='Outerwear';

-- ____________________________________________________________________________________________________________________________________________________________________________________

-- Inner Join

-- Display designer name for the product id 'P0006 ' 
SELECT D.Designer_Name 
FROM Designer D, Product P 
WHERE D.Designer_ID = P.Designer_ID AND P.Product_ID ='P0006';

-- Outer join 

-- List all designers and their products, including designers without any products.

SELECT D.Designer_ID, D.Designer_Name, P.Product_Name
FROM Designer D
LEFT OUTER JOIN Product P ON D.Designer_ID = P.Designer_ID;

-- ___________________________________________________________________________________________________________________________________________________________________________________________

-- Nested Query

-- Display Designers with rating higher than the average rating
SELECT Designer_Name, Rating 
FROM Designer 
WHERE Rating > (SELECT AVG(Rating) 
				FROM Designer);

-- Retrieve customers with their Date of Birth, who have placed at least one order.
SELECT Customer_ID, First_Name, Last_Name, Date_of_Birth
FROM Customer
WHERE Customer_ID IN (SELECT DISTINCT Customer_ID 
					  FROM Orders);

-- _____________________________________________________________________________________________________________________________________________________________________________

--  Correlated Query

-- Find all customers whose State matches the State of any store.
SELECT Customer_ID, First_Name, State
FROM Customer C
WHERE EXISTS (SELECT * 
              FROM Store S 
              WHERE C.State = S.State);

-- Display customers who have more than two tailors in their states
SELECT First_Name, Last_Name, State 
FROM Customer c 
WHERE 2 < (SELECT COUNT(*) 
           FROM Tailor t 
           WHERE t.State = c.State);

-- _____________________________________________________________________________________________________________________________________________________________________________

-- >=ALL, >ANY, EXISTS, NOT EXISTS

-- Display names of the Designers who have worked on products which cost more than average price of all products
SELECT Designer_Name 
FROM Designer d
WHERE EXISTS (SELECT * 
			  FROM Product p 
              WHERE p.Designer_ID = d.Designer_ID AND p.Price > (SELECT AVG(Price) FROM Product));

-- Display names of the tailors who have worked with the Designers who have rating more than 4.5 
SELECT t.Tailor_Name
FROM Tailor t
WHERE t.Tailor_ID IN (SELECT c.Tailor_ID 
                      FROM Customized c 
                      WHERE c.Designer_ID = ANY (SELECT d.Designer_ID 
												 FROM Designer d 
                                                 WHERE d.Rating > 4.5));

-- _____________________________________________________________________________________________________________________________________________________________________________

-- Subquery in SELECT and FROM

-- Display customer_ID, First_Name and the number of orders placed by each customer of top 5 customers who made the highest number of orders
SELECT C.Customer_ID, C.First_Name, C.Last_Name, (SELECT COUNT(*) FROM Orders O WHERE O.Customer_ID = C.Customer_ID) AS Order_Count
FROM Customer C
ORDER BY Order_Count DESC
LIMIT 5;

-- _____________________________________________________________________________________________________________________________________________________________________________

-- Set Operation

-- Display all unique customers who have placed either only 'Customized' orders or only 'Ready-made' orders
SELECT DISTINCT Customer_ID
FROM Orders
WHERE Sale_Type = 'Customized' AND
Customer_ID NOT IN (SELECT Customer_ID 
                    FROM Orders 
                    WHERE Sale_Type = 'Ready-made')
UNION
SELECT DISTINCT Customer_ID
FROM Orders
WHERE Sale_Type = 'Ready-made' AND 
Customer_ID NOT IN (SELECT Customer_ID 
                    FROM Orders 
                    WHERE Sale_Type = 'Customized');

-- Retrieve all customer IDs from both the "Orders" and "Customized" tables.
SELECT Customer_ID
FROM Orders
WHERE Sale_Type = 'Customized'
INTERSECT 
SELECT Customer_ID
FROM Orders
WHERE Sale_Type = 'Ready-made';

-- _____________________________________________________________________________________________________________________________________________________________________________

