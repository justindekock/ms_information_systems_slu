--use master;
--go

--alter database lab3_group17 set single_user with rollback immediate;
--go

--drop database lab3_group17;
--go

create database lab3_group17;
go
USE lab3_group17;
GO

-- SCHEMA CREATION
create schema General;
GO

create schema HR;
GO

create schema Sales;
GO


create table General.StateDetail (
	StateID varchar(2) constraint PK_State primary key, -- state abbreviation
	State varchar(20) unique not null
);

create table HR.Department (
	DeptID varchar(4) constraint PK_Dept primary key, -- like slsc for computer sales, slsa for appliance sales, opsf for facilities/operations, etc
	Department varchar(50) unique not null
);

create table HR.JobTitle (
	JobID varchar(4) constraint PK_Job primary key,
	JobTitle varchar(255) not null
);

create table HR.Employee ( 
	EmployeeID int constraint PK_Employee primary key, -- 5 digit integer
	FirstName varchar(255) not null, 
	LastName varchar(255) not null,
	JobID varchar(4) not null,
	DeptID varchar(4) not null,
	constraint FK_EmployeeJob foreign key (JobID) references HR.JobTitle (JobID),
	constraint FK_EmployeeDept foreign key (DeptID) references HR.Department (DeptID)
);

create table sales.Customer (
	CustomerID int constraint PK_Customer primary key, -- 9 digit integer
	FirstName varchar(255) not null, 
	LastName varchar(255) not null, 
	CustomerState varchar(2) not null, 
	CustomerCity varchar(255) null, 
	constraint FK_CustomerState foreign key (CustomerState) references General.StateDetail(StateID)
);

create table sales.Inventory (
	ItemID int constraint PK_Item primary key, -- 7 number 
	Item varchar(255) not null, 
	DeptID varchar(4) null, 
	Price float null, 
	OnHand int null, 
	OnOrder int null,
	constraint FK_ItemDept foreign key (DeptID) references HR.Department(DeptID)
);

create table sales.CustomerPurchase ( -- an individual purchase of an item within an order. each row is unique by (CustomerID, OrderID, ItemID)
	CustomerID int not null,
	OrderID int not null,
	EmployeeID int not null,
	PurchaseDate date not null,
	ItemID int not null, 
	Quantity int not null, 
	Price float not null, -- itemid price * quantity
	constraint PK_CustomerPurchase primary key (CustomerID, OrderID, ItemID),
	constraint FK_OrderCustomer foreign key (CustomerID) references sales.Customer (CustomerID),
	constraint FK_PurchaseSalesperson foreign key (EmployeeID) references HR.Employee (EmployeeID),
	constraint FK_OrderItem foreign key (ItemID) references sales.Inventory (ItemID)
);

create table sales.CustomerOrder ( -- the entirity of an order. each row is unique by (CustomerID, OrderID)
	CustomerID int not null,
	OrderID int not null,
	EmployeeID int null, 
	PurchaseDate date not null,
	ItemsPurchased int not null, -- sum of all quantity for the orderid
	TotalPrice float not null, -- sum of all price for the order id
	constraint PK_CustomerPurchase primary key (CustomerID, OrderID),
	constraint FK_Order foreign key (OrderID) references sales.CustomerPurchase (OrderID),
	constraint FK_OrderSalesperson foreign key (EmployeeID) references HR.Employee (EmployeeID)
);
GO