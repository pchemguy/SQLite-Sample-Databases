DROP TABLE IF EXISTS "Employees";
DROP TABLE IF EXISTS "Customers";
DROP TABLE IF EXISTS "Categories";
DROP TABLE IF EXISTS "Products";
DROP TABLE IF EXISTS "Suppliers";
DROP TABLE IF EXISTS "Orders";
DROP TABLE IF EXISTS "Order Details";
DROP TABLE IF EXISTS "Shippers";

CREATE TABLE "Employees" (
	"EmployeeID" INTEGER PRIMARY KEY,
	"LastName" nvarchar (20) NOT NULL ,
	"FirstName" nvarchar (10) NOT NULL ,
	"Title" nvarchar (30) NULL ,
	"TitleOfCourtesy" nvarchar (25) NULL ,
	"BirthDate" "datetime" NULL ,
	"HireDate" "datetime" NULL ,
	"Address" nvarchar (60) NULL ,
	"City" nvarchar (15) NULL ,
	"Region" nvarchar (15) NULL ,
	"PostalCode" nvarchar (10) NULL ,
	"Country" nvarchar (15) NULL ,
	"HomePhone" nvarchar (24) NULL ,
	"Extension" nvarchar (4) NULL ,
	"Photo" "image" NULL ,
	"Notes" "ntext" NULL ,
	"ReportsTo" "int" NULL ,
	"PhotoPath" nvarchar (255) NULL ,
	CONSTRAINT "CK_Birthdate" CHECK (BirthDate < date('now'))
);
CREATE INDEX "LastName" ON "Employees"("LastName");
CREATE INDEX "PostalCodeEmployees" ON "Employees"("PostalCode");

CREATE TABLE "Categories" (
	"CategoryID" INTEGER PRIMARY KEY,
	"CategoryName" nvarchar (15) NOT NULL ,
	"Description" "ntext" NULL ,
	"Picture" "image" NULL
);
CREATE INDEX "CategoryName" ON "Categories"("CategoryName");

CREATE TABLE "Customers" (
	"CustomerID" nchar (5) NOT NULL ,
	"CompanyName" nvarchar (40) NOT NULL ,
	"ContactName" nvarchar (30) NULL ,
	"ContactTitle" nvarchar (30) NULL ,
	"Address" nvarchar (60) NULL ,
	"City" nvarchar (15) NULL ,
	"Region" nvarchar (15) NULL ,
	"PostalCode" nvarchar (10) NULL ,
	"Country" nvarchar (15) NULL ,
	"Phone" nvarchar (24) NULL ,
	"Fax" nvarchar (24) NULL ,
	CONSTRAINT "PK_Customers" PRIMARY KEY  
	(
		"CustomerID"
	)
);
CREATE INDEX "City" ON "Customers"("City");
CREATE INDEX "CompanyNameCustomers" ON "Customers"("CompanyName");
CREATE INDEX "PostalCodeCustomers" ON "Customers"("PostalCode");
CREATE INDEX "Region" ON "Customers"("Region");

CREATE TABLE "Shippers" (
	"ShipperID" INTEGER PRIMARY KEY,
	"CompanyName" nvarchar (40) NOT NULL ,
	"Phone" nvarchar (24) NULL
);

CREATE TABLE "Suppliers" (
	"SupplierID" INTEGER PRIMARY KEY,
	"CompanyName" nvarchar (40) NOT NULL ,
	"ContactName" nvarchar (30) NULL ,
	"ContactTitle" nvarchar (30) NULL ,
	"Address" nvarchar (60) NULL ,
	"City" nvarchar (15) NULL ,
	"Region" nvarchar (15) NULL ,
	"PostalCode" nvarchar (10) NULL ,
	"Country" nvarchar (15) NULL ,
	"Phone" nvarchar (24) NULL ,
	"Fax" nvarchar (24) NULL ,
	"HomePage" "ntext" NULL
);
CREATE INDEX "CompanyNameSuppliers" ON "Suppliers"("CompanyName");
CREATE INDEX "PostalCodeSuppliers" ON "Suppliers"("PostalCode");

CREATE TABLE "Orders" (
	"OrderID" INTEGER PRIMARY KEY,
	"CustomerID" nchar (5) NULL ,
	"EmployeeID" "int" NULL ,
	"OrderDate" "datetime" NULL ,
	"RequiredDate" "datetime" NULL ,
	"ShippedDate" "datetime" NULL ,
	"ShipVia" "int" NULL ,
	"Freight" "money" NULL CONSTRAINT "DF_Orders_Freight" DEFAULT (0),
	"ShipName" nvarchar (40) NULL ,
	"ShipAddress" nvarchar (60) NULL ,
	"ShipCity" nvarchar (15) NULL ,
	"ShipRegion" nvarchar (15) NULL ,
	"ShipPostalCode" nvarchar (10) NULL ,
	"ShipCountry" nvarchar (15) NULL ,
	CONSTRAINT "FK_Orders_Customers" FOREIGN KEY 
	(
		"CustomerID"
	) REFERENCES "Customers" (
		"CustomerID"
	),
	CONSTRAINT "FK_Orders_Employees" FOREIGN KEY 
	(
		"EmployeeID"
	) REFERENCES "Employees" (
		"EmployeeID"
	),
	CONSTRAINT "FK_Orders_Shippers" FOREIGN KEY 
	(
		"ShipVia"
	) REFERENCES "Shippers" (
		"ShipperID"
	)
);
CREATE INDEX "CustomerID" ON "Orders"("CustomerID");
CREATE INDEX "CustomersOrders" ON "Orders"("CustomerID");
CREATE INDEX "EmployeeID" ON "Orders"("EmployeeID");
CREATE INDEX "EmployeesOrders" ON "Orders"("EmployeeID");
CREATE INDEX "OrderDate" ON "Orders"("OrderDate");
CREATE INDEX "ShippedDate" ON "Orders"("ShippedDate");
CREATE INDEX "ShippersOrders" ON "Orders"("ShipVia");
CREATE INDEX "ShipPostalCode" ON "Orders"("ShipPostalCode");

CREATE TABLE "Products" (
	"ProductID" INTEGER PRIMARY KEY,
	"ProductName" nvarchar (40) NOT NULL ,
	"SupplierID" "int" NULL ,
	"CategoryID" "int" NULL ,
	"QuantityPerUnit" nvarchar (20) NULL ,
	"UnitPrice" "money" NULL CONSTRAINT "DF_Products_UnitPrice" DEFAULT (0),
	"UnitsInStock" "smallint" NULL CONSTRAINT "DF_Products_UnitsInStock" DEFAULT (0),
	"UnitsOnOrder" "smallint" NULL CONSTRAINT "DF_Products_UnitsOnOrder" DEFAULT (0),
	"ReorderLevel" "smallint" NULL CONSTRAINT "DF_Products_ReorderLevel" DEFAULT (0),
	"Discontinued" "bit" NOT NULL CONSTRAINT "DF_Products_Discontinued" DEFAULT (0),
	CONSTRAINT "FK_Products_Categories" FOREIGN KEY 
	(
		"CategoryID"
	) REFERENCES "Categories" (
		"CategoryID"
	),
	CONSTRAINT "FK_Products_Suppliers" FOREIGN KEY 
	(
		"SupplierID"
	) REFERENCES "Suppliers" (
		"SupplierID"
	),
	CONSTRAINT "CK_Products_UnitPrice" CHECK (UnitPrice >= 0),
	CONSTRAINT "CK_ReorderLevel" CHECK (ReorderLevel >= 0),
	CONSTRAINT "CK_UnitsInStock" CHECK (UnitsInStock >= 0),
	CONSTRAINT "CK_UnitsOnOrder" CHECK (UnitsOnOrder >= 0)
);
CREATE INDEX "CategoriesProducts" ON "Products"("CategoryID");
CREATE INDEX "CategoryID" ON "Products"("CategoryID");
CREATE INDEX "ProductName" ON "Products"("ProductName");
CREATE INDEX "SupplierID" ON "Products"("SupplierID");
CREATE INDEX "SuppliersProducts" ON "Products"("SupplierID");

CREATE TABLE "Order Details" (
	"OrderID" "int" NOT NULL ,
	"ProductID" "int" NOT NULL ,
	"UnitPrice" "money" NOT NULL CONSTRAINT "DF_Order_Details_UnitPrice" DEFAULT (0),
	"Quantity" "smallint" NOT NULL CONSTRAINT "DF_Order_Details_Quantity" DEFAULT (1),
	"Discount" "real" NOT NULL CONSTRAINT "DF_Order_Details_Discount" DEFAULT (0),
	CONSTRAINT "PK_Order_Details" PRIMARY KEY  
	(
		"OrderID",
		"ProductID"
	),
	CONSTRAINT "FK_Order_Details_Orders" FOREIGN KEY 
	(
		"OrderID"
	) REFERENCES "Orders" (
		"OrderID"
	),
	CONSTRAINT "FK_Order_Details_Products" FOREIGN KEY 
	(
		"ProductID"
	) REFERENCES "Products" (
		"ProductID"
	),
	CONSTRAINT "CK_Discount" CHECK (Discount >= 0 and (Discount <= 1)),
	CONSTRAINT "CK_Quantity" CHECK (Quantity > 0),
	CONSTRAINT "CK_UnitPrice" CHECK (UnitPrice >= 0)
);

CREATE TABLE [Territories] 
	([TerritoryID] [nvarchar] (20) NOT NULL ,
	[TerritoryDescription] [nchar] (50) NOT NULL ,
        [RegionID] [int] NOT NULL
);

CREATE TABLE [EmployeeTerritories] 
	([EmployeeID] [int] NOT NULL,
	[TerritoryID] [nvarchar] (20) NOT NULL 
);

CREATE  INDEX "OrderID" ON "Order Details"("OrderID");
CREATE  INDEX "OrdersOrder_Details" ON "Order Details"("OrderID");
CREATE  INDEX "ProductID" ON "Order Details"("ProductID");
CREATE  INDEX "ProductsOrder_Details" ON "Order Details"("ProductID");
