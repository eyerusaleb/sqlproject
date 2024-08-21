create database  IMSDB; 
create table Products(
ProductID INT PRIMARY KEY,
ProductName varchar(50) not null ,
ProductDescripition Text,
Category varchar(30),
Price decimal(10,2) not null,
QuantityInStock INT NOT NULL
);
select * from  Products;
create table Suppliers(
SupplierID INT Primary Key,
SupplierName VARCHAR(50) NOT NULL, 
SupplierContact VARCHAR(20) ,
SupplierAddress VARCHAR(100)
);
insert into products  values 
    ( 1 , 'Laptop','Dell XPS 15', 'Electronics',999.99,50 ),
	(2,'T-Shirt','Cotton Tee','Clothing' ,19.99, 100 ),
    (3, 'Desk', 'Wooden Desk', 'Furniture', 249.99, 25),
    (4, 'Smartphone', 'iPhone 13 Pro', 'Electronics', 999.00, 75);
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
select * from products;
create table Suppliers(
SupplierID INT Primary Key,
SupplierName VARCHAR(50) NOT NULL, 
SupplierContact VARCHAR(20) ,
SupplierAddress VARCHAR(100)
);
insert into Suppliers values 
 (1 ,'ABC Computers','555-1234','123 Main St, Anytown'),
 (2 ,' XYZ Clothing','555-5678','456 Oak Rd,Somewhere') ,
  (3, 'Furniture Inc','555-9012', '789 Maple Blvd,Elsewhere');
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
create table Orders( 
OrderID INT Primary Key,
CustomerName VARCHAR(50) NOT NULL,
OrderDate DATE NOT NULL ,
ShipDate DATE ,
Status VARCHAR(20) NOT NULL ,
TotalAmount DECIMAL(10,2) NOT NULL
);
insert into  Orders values
(1 ,'John Doe','2023-6-01','2023-6-5', 'Shipped', 1999.98), 
(2 , 'Jane Smith',' 2023-7-15','2023-7-20', 'Pending', 749.99), 
( 3, 'Bob Johnson', '2023-8-01', '2023-8-5','Shipped', 299.98);
select * from Orders;
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE OrderDetails (
    OrderID INT,
    ProductID INT,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
INSERT INTO OrderDetails VALUES
(1, 1, 2, 999.99),
(1, 4, 1, 999.99),
(2, 4, 1, 749.99),
(3, 2, 5, 19.99),
 (3, 3, 1, 249.99),
 (2, 1, 1, 999.00);
 -- we have to change 5 to number between 1 and 4  becouse it must be the same to referenced column 
 
-- (2, 5, 1, 749.99),(4, 1, 1, 999.00);21:02:56	INSERT INTO OrderDetails VALUES     (2, 5, 1, 749.99)	Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`imsdb`.`orderdetails`, CONSTRAINT `orderdetails_ibfk_2` FOREIGN KEY (`ProductID`) REFERENCES `products` (`ProductID`))	0.016 sec
-- The OrderID column in the current table (where this constraint is defined) is designated as a foreign key.
-- This means that the values in this column must match values in the referenced column of another table.
select *  FROM  Orders;
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Inventory (
    InventoryID INT PRIMARY KEY,
    ProductID INT,
    SupplierID INT,
    InDate DATE NOT NULL,
    OutDate DATE,
    Quantity INT NOT NULL,
    Type VARCHAR(10) NOT NULL,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
    CHECK (Type IN ('Incoming', 'Outgoing'))
);
insert into Inventory values
(1,1, 1 , '2023-05-01',NULL,50,'Incoming'),
 (2,2,2,'2023-06-15', NULL,100,'Incoming'),
(3,3,3,'2023-07-01', NULL,25,'Incoming'),
 (4,4,1,'2023-08-01', NULL,75,'Incoming'),
 ( 5,4, 3,'2023-09-01', NULL,15, 'Incoming');
-- we have to change 5 to 4 becouse it must be the same to product id
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- * from suppliers;
-- Adjust roles as needed
CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    Username VARCHAR(50) NOT NULL,
    Password VARCHAR(100) NOT NULL,
    Role VARCHAR(20) NOT NULL,
    CHECK (Role IN ('Admin', 'manager', 'employee','Administrator')) 
);
insert into Users values 
( 1,'admin','$ecur3P@ssw0rd', 'Administrator'), 
(2,'manager','Gr34tM@nager123','Manager'), 
(3,'employee','Empl0y33Pass123','Employee');
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Question: "List all the product details (ProductID, ProductName, Price) along with their supplier 
-- information (SupplierName, SupplierAddress)." 4.1.
SELECT 
    Products.ProductID,ProductName,Price,Suppliers.SupplierName,SupplierAddress
FROM 
    Products
INNER JOIN 
    Suppliers ON Products.ProductID = Suppliers.SupplierID;
    -- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 4.2  Left join:- 
-- Question: "List all the products (ProductID, ProductName, Price) along with their supplier 
-- information (SupplierName, SupplierAddress), even if a product doesn't have an associated 
-- supplier." 
SELECT 
    Products.ProductID,ProductName,Price,Suppliers.SupplierName,SupplierAddress
FROM 
    Products
LEFT JOIN 
    Suppliers ON Products.ProductID = Suppliers.SupplierID;
-- Right join:- 
--  "List all the suppliers (SupplierID, SupplierName, SupplierAddress) along with the 
-- products (ProductID, ProductName, Price) they supply, even if a supplier doesn't have any 
-- associated products." 
SELECT 
    Suppliers.SupplierID,SupplierName,SupplierAddress,Products.ProductID,ProductName,Price
FROM 
    Products
RIGHT JOIN 
    Suppliers ON Products.ProductID = Suppliers.SupplierID;
    -- ----------------------------------------------------------------------------------------------------------------------------------------
-- Full join using union:-
-- "List all the products (ProductID, ProductName, Price) and suppliers (SupplierID, 
-- SupplierName, SupplierAddress), including any products that don't have an associated supplier 
-- and any suppliers that don't have any associated products."

SELECT 
    Products.ProductID,ProductName,Price, Suppliers.SupplierID,SupplierName,SupplierAddress
FROM 
    Products
LEFT JOIN 
    Suppliers ON Products.ProductID = Suppliers.SupplierID
UNION
SELECT 
    Products.ProductID,ProductName,Price,
    Suppliers.SupplierID,SupplierName,SupplierAddress
FROM 
    Suppliers
RIGHT JOIN 
    Products ON Suppliers.SupplierID=Products.ProductID;
-- Create a view that provides a summary of the products, including the product 
-- name, category, price, and quantity in stock. 
CREATE VIEW ProductSummary AS
SELECT 
    ProductName,
    Category,
    Price,
    QuantityInStock
FROM 
    Products;
   select *  from ProductSummary; 
  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
   --  Question: Create a view that shows the products along with their supplier information, 
-- including the supplier name and contact details. 
    
    CREATE VIEW ProductSupplierInfo AS
SELECT 
    Products.ProductID,ProductName,Price,QuantityInStock,Suppliers.SupplierName,SupplierContact,SupplierAddress
FROM 
    Products
JOIN 
    Suppliers ON Products.ProductID = Suppliers.SupplierID;
select *  from ProductSupplierInfo; 
    select * from Suppliers;
    -- ---------------------------------------------------------------------------------------------------------------------------------------------------------------
    -- Question: Create a view that provides a summary of the orders, including the customer name, order date, ship date, status, and total amount. 
    CREATE VIEW OrderSummary3 AS
SELECT 
    CustomerName,
       OrderDate,ShipDate,Status,TotalAmount from orders;
     select * from  OrderSummary3; 
     select * from products_view;
 -- ------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  Create a view that shows the inventory transactions, including the product name, supplier name, transaction type (incoming or outgoing), and the quantity
   
  CREATE VIEW InventoryTransactions AS
SELECT 
    Inventory.InventoryID,
    Products.ProductName,
    Suppliers.SupplierName,
    Inventory.Type AS TransactionType,
    Inventory.Quantity
FROM 
    Inventory
JOIN 
    Products ON Inventory.ProductID = Products.ProductID
JOIN 
    Suppliers ON Inventory.SupplierID = Suppliers.SupplierID;
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
  select * from InventoryTransactions;
  -- Create store procedure for to do the following task 
  -- Create a stored procedure GetOrdersByCustomer that retrieves all orders for 
-- a given customer.
  
  CREATE PROCEDURE GetOrdersByCustomer6(in customer varchar(50)) 
      SELECT 
        orders.OrderID,OrderDate,OrderAmount
    FROM 
        Orders 
        WHERE orders.CustomerName = 'customer';

CREATE PROCEDURE GetOrdersByCustomer6(customer nvarchar(30))
AS
SELECT * FROM orders WHERE CustomerName =  AND PostalCode = @PostalCode
GO;
delimiter //
create procedure GetOrdersByCustomer9()
begin
 SELECT OrderID,OrderDate,TotalAmount
from orders;
end //
delimiter ;
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------
delimiter //
create procedure GetOrdersByCustomer10(IN Customer varchar(100))
begin
 SELECT OrderID,OrderDate,TotalAmount from orders where CustomerName=Customer; 
end //
delimiter ;
CALL GetOrdersByCustomer10('John Doe');
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
--  Create a stored procedure GetOrdersByStatus that retrieves all orders 
-- with a given status. 

delimiter //
create procedure GetOrdersByStatus1(IN S varchar(100))
begin
 SELECT OrderID,CustomerName,OrderDate,TotalAmount from orders where Status=S; 
end //
delimiter ;
call  GetOrdersByStatus1('pending');
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  Create a stored procedure GetOrderDetails that retrieves the details of a specific order. 

delimiter //
create procedure GetOrderDetails (IN I  int)
begin
 SELECT ProductID,Quantity,UnitPrice from OrderDetails where OrderID=I; 
end //
delimiter ;

select * from OrderDetails;
select * from orders;
  call GetOrderDetails (1);
-- -----------------------------------------------------------

  
select *  from Inventory;

drop table Users