DROP DATABASE IF EXISTS Winery
; 

CREATE DATABASE Winery
;

USE Winery
;

CREATE TABLE Supplier (
  SupplierID int AUTO_INCREMENT PRIMARY KEY,
  SupplierName varchar(100) NOT NULL,
  ContactName varchar(100) NOT NULL,
  Address varchar(255),
  Email varchar(100),
  Phone varchar(15)  
)
;

INSERT INTO Supplier (SupplierName,ContactName,Address,Email,Phone)
VALUES
('Bottles and Corks R Us', 'Jim Bottles', '123 Bottle St, San Diego, CA 92109', 'Jim@BottlesRUs.com','555-401-9512')
,('Random Supply Co.', 'Sam Pitchfork', '123 Supplies St, San Diego, CA 92109', 'Sam@RandomSupplies.com','555-321-2465')
,('Vats Vats and More Vats', 'Van Cubbs', '123 Vat Ave, San Diego, CA 92109', 'Van@VatsVatsVats.com','555-854-3356')
;

CREATE TABLE Delivery (
    DeliveryID int AUTO_INCREMENT PRIMARY KEY,
    SupplierID int NOT NULL,
    DeliveryDate date NOT NULL,
    ExpectedDate date NOT NULL,
    ActualDate date,
    CONSTRAINT fk_Supplier
    FOREIGN KEY (SupplierID)
    REFERENCES Supplier(SupplierID)
)
; 

INSERT INTO Delivery (SupplierID,DeliveryDate,ExpectedDate,ActualDate)
(SELECT SupplierID, '2026-01-15', '2026-01-17', '2026-01-17' FROM Supplier WHERE SupplierName = 'Bottles and Corks R Us')
UNION ALL
(SELECT SupplierID, '2026-01-15', '2026-01-16', '2026-01-16' FROM Supplier WHERE SupplierName = 'Random Supply Co.')
UNION ALL
(SELECT SupplierID, '2026-01-22', '2026-01-23', '2026-01-25' FROM Supplier WHERE SupplierName = 'Vats Vats and More Vats')
UNION ALL
(SELECT SupplierID, '2026-02-15', '2026-02-17', '2026-02-17' FROM Supplier WHERE SupplierName = 'Bottles and Corks R Us')
UNION ALL
(SELECT SupplierID, '2026-02-15', '2026-02-16', '2026-02-16' FROM Supplier WHERE SupplierName = 'Random Supply Co.')
UNION ALL
(SELECT SupplierID, '2026-02-22', '2026-02-23', '2026-02-25' FROM Supplier WHERE SupplierName = 'Vats Vats and More Vats')
;

CREATE TABLE Inventory_Item (
    InventoryItemID int AUTO_INCREMENT PRIMARY KEY,
    SupplierID int NOT NULL,    
    ItemName varchar(100) NOT NULL,
    CurrentStock int NOT NULL,
    CONSTRAINT fk_InventorySupplier
    FOREIGN KEY (SupplierID)
    REFERENCES Supplier(SupplierID)            
)
;

INSERT INTO Inventory_Item (SupplierID, ItemName, CurrentStock)
(SELECT SupplierID, 'Bottles', 23 FROM Supplier WHERE SupplierName = 'Bottles and Corks R Us')
UNION ALL
(SELECT SupplierID, 'Corks', 534 FROM Supplier WHERE SupplierName = 'Bottles and Corks R Us')
UNION ALL
(SELECT SupplierID, 'Labels', 2310 FROM Supplier WHERE SupplierName = 'Random Supply Co.')
UNION ALL
(SELECT SupplierID, 'Boxes', 125 FROM Supplier WHERE SupplierName = 'Random Supply Co.')
UNION ALL
(SELECT SupplierID, 'Vats', 7 FROM Supplier WHERE SupplierName = 'Vats Vats and More Vats')
UNION ALL
(SELECT SupplierID, 'Tubing', 38 FROM Supplier WHERE SupplierName = 'Vats Vats and More Vats'
)
;

CREATE TABLE Delivery_Item (
    DeliveryItemID int AUTO_INCREMENT PRIMARY KEY,
    DeliveryID int NOT NULL,
    InventoryItemID int NOT NULL,
    QuantityReceived int NOT NULL,
    CONSTRAINT fk_Delivery
    FOREIGN KEY (DeliveryID)
    REFERENCES Delivery(DeliveryID),
    CONSTRAINT fk_Inventory_Item
    FOREIGN KEY (InventoryItemID)
    REFERENCES Inventory_Item(InventoryItemID)
)
; 

INSERT INTO Delivery_Item (DeliveryID, InventoryItemID, QuantityReceived)
(SELECT 1, InventoryItemID, 25 FROM Inventory_Item WHERE ItemName = 'Bottles')
UNION ALL
(SELECT 1, InventoryItemID, 250 FROM Inventory_Item WHERE ItemName = 'Corks')
UNION ALL
(SELECT 2, InventoryItemID, 500 FROM Inventory_Item WHERE ItemName = 'Labels')
UNION ALL
(SELECT 2, InventoryItemID, 50 FROM Inventory_Item WHERE ItemName = 'Boxes')
UNION ALL
(SELECT 3, InventoryItemID, 2 FROM Inventory_Item WHERE ItemName = 'Vats')
UNION ALL
(SELECT 3, InventoryItemID, 5 FROM Inventory_Item WHERE ItemName = 'Tubing')
UNION ALL
(SELECT 4, InventoryItemID, 25 FROM Inventory_Item WHERE ItemName = 'Bottles')
UNION ALL
(SELECT 4, InventoryItemID, 300 FROM Inventory_Item WHERE ItemName = 'Corks')
UNION ALL
(SELECT 5, InventoryItemID, 550 FROM Inventory_Item WHERE ItemName = 'Labels')
UNION ALL
(SELECT 5, InventoryItemID, 25 FROM Inventory_Item WHERE ItemName = 'Boxes')
UNION ALL
(SELECT 6, InventoryItemID, 1 FROM Inventory_Item WHERE ItemName = 'Vats')
UNION ALL
(SELECT 6, InventoryItemID, 5 FROM Inventory_Item WHERE ItemName = 'Tubing')
;

CREATE TABLE Distributor (
  DistributorID int AUTO_INCREMENT PRIMARY KEY,
  DistributorName varchar(100) NOT NULL,
  ContactName varchar(100) NOT NULL,
  Address varchar(255),
  Email varchar(100),
  Phone varchar(15) 
)
;

INSERT INTO Distributor (DistributorName,ContactName,Address,Email,Phone)
VALUES
('Wine Shippers R Us', 'James Glass', '123 Wine St, San Diego, CA 92109', 'James@WineShippersRUs.com','555-156-8885')
,('Big Beautiful Wine Shop', 'Diane McManley', '123 Groove Dr, San Diego, CA 92109', 'Diane@BigBeautifulWineShop.com','555-213-5642')
;

CREATE TABLE Shipment (
    ShipmentID int AUTO_INCREMENT PRIMARY KEY,
    DistributorID int NOT NULL,
    ShipmentDate date NOT NULL,
    DeliveryStatus varchar(20) NOT NULL,
    TrackingNumber int NOT NULL,
    CONSTRAINT fk_Distributor
    FOREIGN KEY (DistributorID)
    REFERENCES Distributor(DistributorID)
); 

INSERT INTO Shipment
(DistributorID, ShipmentDate, DeliveryStatus, TrackingNumber)
VALUES
(1, '2026-06-02', 'Delivered', 84561231),
(2, '2026-06-05', 'Delivered', 84561232),
(1, '2026-06-09', 'In Transit', 84561233),
(2, '2026-06-13', 'Delivered', 84561234),
(1, '2026-06-17', 'Pending', 84561235),
(2, '2026-06-21', 'Delivered', 84561236),
(1, '2026-06-25', 'Delivered', 84561237),
(2, '2026-06-29', 'In Transit', 84561238),
(1, '2026-07-03', 'Delivered', 84561239),
(2, '2026-07-08', 'Pending', 84561240);

CREATE TABLE Wine (
    WineID int AUTO_INCREMENT PRIMARY KEY,
    WineName varchar(100) NOT NULL,
    WineType varchar(100),
    YearProduced int
); 

INSERT INTO Wine (WineName, WineType, YearProduced)
VALUES
('Merlot', 'Red',2020)
,('Cabernet','Red',2020)
,('Chablis','White',2020)
,('Chardonnay','White',2020)
,('Merlot', 'Red',2021)
,('Merlot', 'Red',2022)
,('Cabernet','Red',2022)
,('Chablis','White',2022)
,('Chardonnay','White',2022)
;

CREATE TABLE Shipment_Wine (
    ShipmentWineID int AUTO_INCREMENT PRIMARY KEY,
    ShipmentID int NOT NULL,
    WineID int NOT NULL,
    QuantityShipped int,
    CONSTRAINT fk_Shipment
    FOREIGN KEY (ShipmentID)
    REFERENCES Shipment(ShipmentID),
    CONSTRAINT fk_Wine
    FOREIGN KEY (WineID)
    REFERENCES Wine(WineID)
)
; 

INSERT INTO Shipment_Wine
(ShipmentID, WineID, QuantityShipped)
VALUES
(1, 1, 24),
(1, 2, 12),
(1, 4, 18),
(2, 3, 24),
(2, 4, 24),
(3, 5, 36),
(3, 8, 12),
(4, 6, 24),
(4, 7, 24),
(4, 9, 18);

CREATE TABLE Department (
    DepartmentID int AUTO_INCREMENT PRIMARY KEY,
    DepartmentName varchar(100)
)
; 

INSERT INTO Department (DepartmentName)
VALUES
('Management')
,('Finance')
,('Marketing')
,('Production')
,('Distribution'
)
;

CREATE TABLE Employee (
    EmployeeID int AUTO_INCREMENT PRIMARY KEY,
    DepartmentID int NOT NULL,
    FirstName varchar(100),
    LastName varchar(100),
    Position varchar(100),
    CONSTRAINT fk_Department
    FOREIGN KEY (DepartmentID)
    REFERENCES Department(DepartmentID)
)
; 

INSERT INTO Employee (DepartmentID, FirstName, LastName, Position)
(SELECT DepartmentID,'Stan','Bacchus', 'Owner' FROM Department WHERE DepartmentName = 'Management')
UNION ALL
(SELECT DepartmentID,'Davis','Bacchus', 'Owner' FROM Department WHERE DepartmentName = 'Management')
UNION ALL
(SELECT DepartmentID,'Janet','Collins', 'Manager' FROM Department WHERE DepartmentName = 'Finance')
UNION ALL
(SELECT DepartmentID,'Roz','Murphy', 'Manager' FROM Department WHERE DepartmentName = 'Marketing')
UNION ALL
(SELECT DepartmentID,'Bob','Ulrich', 'Assistant' FROM Department WHERE DepartmentName = 'Marketing')
UNION ALL
(SELECT DepartmentID,'Henry','Doyle', 'Manager' FROM Department WHERE DepartmentName = 'Production')
UNION ALL
(SELECT DepartmentID,'Jon','Walmsley', 'Line Worker' FROM Department WHERE DepartmentName = 'Production')
UNION ALL
(SELECT DepartmentID,'Roxanne','Buenaventura', 'Line Worker' FROM Department WHERE DepartmentName = 'Production')
UNION ALL
(SELECT DepartmentID,'Timothy','Martin', 'Line Worker' FROM Department WHERE DepartmentName = 'Production')
UNION ALL
(SELECT DepartmentID,'Peter','Ddamulira', 'Line Worker' FROM Department WHERE DepartmentName = 'Production')
UNION ALL
(SELECT DepartmentID,'Maria','Costanza', 'Manager' FROM Department WHERE DepartmentName = 'Distribution')
;

CREATE TABLE TimeSheet (
    TimesheetID int AUTO_INCREMENT PRIMARY KEY,
    EmployeeID int NOT NULL,
    DateWorked date,
    HoursWorked int,
    CONSTRAINT fk_Employee
    FOREIGN KEY (EmployeeID)
    REFERENCES Employee(EmployeeID)
)
; 

INSERT INTO TimeSheet (EmployeeID, DateWorked, HoursWorked)
VALUES
(1, '2026-07-06', 7),
(2, '2026-07-06', 8),
(3, '2026-07-06', 6),
(4, '2026-07-06', 6),
(5, '2026-07-06', 8),
(6, '2026-07-06', 8),
(7, '2026-07-06', 10),
(8, '2026-07-06', 8),
(9, '2026-07-06', 8),
(10, '2026-07-06', 8),
(11, '2026-07-06', 8),
(1, '2026-07-07', 8),
(2, '2026-07-07', 8),
(3, '2026-07-07', 8),
(4, '2026-07-07', 8),
(5, '2026-07-07', 7),
(6, '2026-07-07', 9),
(7, '2026-07-07', 8),
(8, '2026-07-07', 10),
(9, '2026-07-07', 8),
(10, '2026-07-07', 8),
(11, '2026-07-07', 8),
(1, '2026-07-08', 8),
(2, '2026-07-08', 8),
(3, '2026-07-08', 8),
(4, '2026-07-08', 8),
(5, '2026-07-08', 8),
(6, '2026-07-08', 8),
(7, '2026-07-08', 8),
(8, '2026-07-08', 10),
(9, '2026-07-08', 8),
(10, '2026-07-08', 8),
(11, '2026-07-08', 8),
(1, '2026-07-09', 8),
(2, '2026-07-09', 8),
(3, '2026-07-09', 8),
(4, '2026-07-09', 9),
(5, '2026-07-09', 8),
(6, '2026-07-09', 9),
(7, '2026-07-09', 8),
(8, '2026-07-09', 8),
(9, '2026-07-09', 8),
(10, '2026-07-09', 8),
(11, '2026-07-09', 8),
(1, '2026-07-10', 6),
(2, '2026-07-10', 6),
(3, '2026-07-10', 8),
(4, '2026-07-10', 8),
(5, '2026-07-10', 8),
(6, '2026-07-10', 7),
(7, '2026-07-10', 8),
(8, '2026-07-10', 8),
(9, '2026-07-10', 9),
(10, '2026-07-10', 8),
(11, '2026-07-10', 8);