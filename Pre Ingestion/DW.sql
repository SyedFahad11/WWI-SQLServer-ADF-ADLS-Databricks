/********************************************

FACT-1: Order
FACT-2: Sale
FACT-3: Transaction
FACT-4: Purchase
FACT-5: Stock Holding
FACT-6: Movement


Dimension-1: Customer
Dimension-2: Employee
Dimension-3: Date
Dimension-4: City
Dimension-5: Supplier
Dimension-6: StockItem
Dimension-7: Payment Method
Dimension-8: Transaction Type


*******************************************/
--FACT-1: Order
CREATE TABLE
    Order (
        OrderKey bigint IDENTITY (1, 1) NOT NULL,
        CityKey int NOT NULL,
        CustomerKey int NOT NULL,
        StockItemKey int NOT NULL,
        OrderDateKey date NOT NULL,
        PickedDate /*  */Key date,
        SalespersonKey int NOT NULL,
        PickerKey int,
        WWIOrderID int NOT NULL,
        WWIBackorderID int,
        Description nvarchar (100) NOT NULL,
        Package nvarchar (50)/*  */ NOT NULL,
        Quantity int NOT NULL,
        UnitPrice decimal(18, 2) NOT NULL,
        TaxRate decimal(18, 3) NOT NULL,
        TotalExcludingTax decimal(18, 2) NOT NULL,
        TaxAmount decimal(18, 2) NOT NULL,
        TotalIncludingTax decimal(18, 2) NOT NULL,
        LineageKey int NOT NULL
    )
--FACT-2: Sale
CREATE TABLE
    Sale (
        SaleKey bigint IDENTITY (1, 1) NOT NULL,
        CityKey int NOT NULL,
        CustomerKey int NOT NULL,
        BillToCustomer Key int NOT NULL,
        StockItemKey int NOT NULL,
        InvoiceDateKey date NOT NULL,
        DeliveryDateKey date,
        SalespersonKey int NOT NULL,
        WWIInvoiceID int NOT NULL,
        Description nvarchar (100) NOT NULL,
        Package nvarchar (50) NOT NULL,
        Quantity int NOT NULL,
        UnitPrice decimal(18, 2) NOT NULL,
        TaxRate decimal(18, 3) NOT NULL,
        TotalExcludingTax decimal(18, 2) NOT NULL,
        TaxAmount decimal(18, 2) NOT NULL,
        Profit decimal(18, 2) NOT NULL,
        TotalIncludingTax decimal(18, 2) NOT NULL,
        TotalDryItems int NOT NULL,
        TotalChillerItems int NOT NULL,
        LineageKey int NOT NULL
    )
--FACT-3: Transaction
CREATE TABLE
    Transaction_Fact (
        TransactionKey bigint IDENTITY (1, 1) NOT NULL,
        DateKey date NOT NULL,
        CustomerKey int,
        BillToCustomer Key int,
        SupplierKey int,
        TransactionTypeKey int NOT NULL,
        PaymentMethodKey int,
        WWICustomerTransactionID int,
        WWISupplierTransactionID int,
        WWIInvoiceID int,
        WWIPurchaseOrderID int,
        SupplierInvoiceNumber nvarchar (20),
        TotalExcludingTax decimal(18, 2) NOT NULL,
        TaxAmount decimal(18, 2) NOT NULL,
        TotalIncludingTax decimal(18, 2) NOT NULL,
        OutstandingBalance decimal(18, 2) NOT NULL,
        IsFinalized bit NOT NULL,
        LineageKey int NOT NULL
    )
--FACT-4: Purchase
CREATE TABLE
    Purchase_Fact (
        PurchaseKey bigint IDENTITY (1, 1) NOT NULL,
        DateKey date NOT NULL,
        SupplierKey int NOT NULL,
        StockItemKey int NOT NULL,
        WWIPurchaseOrderID int,
        OrderedOuters int NOT NULL,
        OrderedQuantity int NOT NULL,
        ReceivedOuters int NOT NULL,
        Package nvarchar (50) NOT NULL,
        IsOrderFinalized bit NOT NULL,
        LineageKey int NOT NULL
    )
--FACT-5: Stock Holding
CREATE TABLE
    StockHolding_Fact (
        StockHoldingKey bigint IDENTITY (1, 1) NOT NULL,
        StockItemKey int NOT NULL,
        QuantityOnHand int NOT NULL,
        BinLocation nvarchar (20) NOT NULL,
        LastStocktakeQuantity int NOT NULL,
        LastCostPrice decimal(18, 2) NOT NULL,
        ReorderLevel int NOT NULL,
        TargetStockLevel int NOT NULL,
        LineageKey int NOT NULL
    )
--FACT-6: Movement
CREATE TABLE
    Movement_Fact (
        MovementKey bigint IDENTITY (1, 1) NOT NULL,
        DateKey date NOT NULL,
        StockItemKey int NOT NULL,
        CustomerKey int,
        SupplierKey int,
        TransactionTypeKey int NOT NULL,
        WWIStockItemTransactionID int NOT NULL,
        WWIInvoiceID int,
        WWIPurchaseOrderID int,
        Quantity int NOT NULL,
        LineageKey int NOT NULL
    )

/******************************************/

--DIMENSION-1: Customer

CREATE TABLE Customer_Dim (
    CustomerKey int NOT NULL DEFAULT (NEXT VALUE FOR [Sequences].[CustomerKey]),
    WWICustomerID int NOT NULL,
    Customer nvarchar(100) NOT NULL,
    BillToCustomer nvarchar(100) NOT NULL,
    Category nvarchar(50) NOT NULL,
    BuyingGroup nvarchar(50) NOT NULL,
    PrimaryContact nvarchar(50) NOT NULL,
    PostalCode nvarchar(10) NOT NULL,
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NOT NULL,
    LineageKey int NOT NULL
);
--DIMENSION-2: Employee
CREATE TABLE Employee_Dim  (
    EmployeeKey int NOT NULL DEFAULT (NEXT VALUE FOR [Sequences].[EmployeeKey]),
    WWIEmployeeID int NOT NULL,
    Employee nvarchar(50) NOT NULL,
    PreferredName nvarchar(50) NOT NULL,
    IsSalesperson bit NOT NULL,
    Photo varbinary(max),
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NOT NULL,
    LineageKey int NOT NULL
);
--DIMENSION-3: Date
CREATE TABLE Date_Dim  (
    Date date NOT NULL,
    DayNumber int NOT NULL,
    Day nvarchar(10) NOT NULL,
    Month nvarchar(10) NOT NULL,
    ShortMonth nvarchar(3) NOT NULL,
    CalendarMonth Number int NOT NULL,
    CalendarMonthLabel nvarchar(20) NOT NULL,
    CalendarYear int NOT NULL,
    CalendarYearLabel nvarchar(10) NOT NULL,
    FiscalMonth Number int NOT NULL,
    FiscalMonthLabel nvarchar(20) NOT NULL,
    FiscalYear int NOT NULL,
    FiscalYear Label nvarchar(10) NOT NULL,
    ISOWeek Number int NOT NULL
);
--DIMENSION-4: City
CREATE TABLE City_Dim  (
    CityKey int NOT NULL DEFAULT (NEXT VALUE FOR [Sequences].[CityKey]),
    WWICityID int NOT NULL,
    City nvarchar(50) NOT NULL,
    StateProvince nvarchar(50) NOT NULL,
    Country nvarchar(60) NOT NULL,
    Continent nvarchar(30) NOT NULL,
    SalesTerritory nvarchar(50) NOT NULL,
    Region nvarchar(30) NOT NULL,
    Subregion nvarchar(30) NOT NULL,
    Location,
    LatestRecordedPopulation bigint NOT NULL,
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NOT NULL,
    LineageKey int NOT NULL
);
--DIMENSION-5: Supplier
CREATE TABLE Supplier_Dim  (
    SupplierKey int NOT NULL DEFAULT (NEXT VALUE FOR [Sequences].[SupplierKey]),
    WWISupplierID int NOT NULL,
    Supplier nvarchar(100) NOT NULL,
    Category nvarchar(50) NOT NULL,
    PrimaryContact nvarchar(50) NOT NULL,
    SupplierReference nvarchar(20),
    PaymentDays int NOT NULL,
    PostalCode nvarchar(10) NOT NULL,
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NOT NULL,
    LineageKey int NOT NULL
);
--DIMENSION-6: StockItem
CREATE TABLE StockItem_Dim  (
    StockItemKey int NOT NULL DEFAULT (NEXT VALUE FOR [Sequences].[StockItemKey]),
    WWIStockItemID int NOT NULL,
    StockItem nvarchar(100) NOT NULL,
    Color nvarchar(20) NOT NULL,
    SellingPackage nvarchar(50) NOT NULL,
    BuyingPackage nvarchar(50) NOT NULL,
    Brand nvarchar(50) NOT NULL,
    Size nvarchar(20) NOT NULL,
    LeadTimeDays int NOT NULL,
    QuantityPerOuter int NOT NULL,
    IsChillerStock bit NOT NULL,
    Barcode nvarchar(50),
    TaxRate decimal(18, 3) NOT NULL,
    UnitPrice decimal(18, 2) NOT NULL,
    RecommendedRetailPrice decimal(18, 2),
    TypicalWeightPerUnit decimal(18, 3) NOT NULL,
    Photo varbinary(max),
    ValiFrom datetime2 NOT NULL,
    ValidTo datetime2 NOT NULL,
    LineageKey int NOT NULL
);
--DIMENSION-7: Payment Method
CREATE TABLE PaymentMethod_Dim  (
    PaymentMethod Key int NOT NULL DEFAULT (NEXT VALUE FOR [Sequences].[PaymentMethodKey]),
    WWIPaymentMethodID int NOT NULL,
    PaymentMethod nvarchar(50) NOT NULL,
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NOT NULL,
    LineageKey int NOT NULL
);
--DIMENSION-8: Transaction Type
CREATE TABLE TransactionType_Dim (
    TransactionTypeKey int NOT NULL DEFAULT (NEXT VALUE FOR [Sequences].[TransactionTypeKey]),
    WWITransactionTypeID int NOT NULL,
    TransactionType nvarchar(50) NOT NULL,
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NOT NULL,
    LineageKey int NOT NULL
);

CREATE TABLE Lineage (
    LineageKey int NOT NULL DEFAULT (NEXT VALUE FOR [Sequences].[LineageKey]),
    DataLoadStarted datetime2 NOT NULL,
    TableName nvarchar(128) NOT NULL,
    DataLoadCompleted datetime2,
    WasSuccessful bit NOT NULL,
    SourceSystemCutoffTime datetime2 NOT NULL
);

/*****************************************************/
CREATE TABLE City_Staging (
    City Staging Key int IDENTITY(1, 1) NOT NULL,
    WWI City ID int NOT NULL,
    City nvarchar(50) NOT NULL,
    State Province nvarchar(50) NOT NULL,
    Country nvarchar(60) NOT NULL,
    Continent nvarchar(30) NOT NULL,
    Sales Territory nvarchar(50) NOT NULL,
    Region nvarchar(30) NOT NULL,
    Subregion nvarchar(30) NOT NULL,
    Location,
    Latest Recorded Population bigint NOT NULL,
    Valid
    From datetime2 NOT NULL,
        Valid To datetime2 NOT NULL
);
CREATE TABLE Customer_Staging (
    Customer Staging Key int IDENTITY(1, 1) NOT NULL,
    WWI Customer ID int NOT NULL,
    Customer nvarchar(100) NOT NULL,
    Bill To Customer nvarchar(100) NOT NULL,
    Category nvarchar(50) NOT NULL,
    Buying Group nvarchar(50) NOT NULL,
    Primary Contact nvarchar(50) NOT NULL,
    Postal Code nvarchar(10) NOT NULL,
    Valid
    From datetime2 NOT NULL,
        Valid To datetime2 NOT NULL
);
CREATE TABLE Employee_Staging (
    Employee Staging Key int IDENTITY(1, 1) NOT NULL,
    WWI Employee ID int NOT NULL,
    Employee nvarchar(50) NOT NULL,
    Preferred Name nvarchar(50) NOT NULL,
    Is Salesperson bit NOT NULL,
    Photo varbinary(max),
    Valid
    From datetime2 NOT NULL,
        Valid To datetime2 NOT NULL
);
CREATE TABLE ETL Cutoff (
    Table Name nvarchar(128) NOT NULL,
    Cutoff Time datetime2 NOT NULL
);

CREATE TABLE Movement_Staging (
    Movement Staging Key bigint IDENTITY(1, 1) NOT NULL,
    Date Key date,
    Stock Item Key int,
    Customer Key int,
    Supplier Key int,
    Transaction Type Key int,
    WWI Stock Item Transaction ID int,
    WWI Invoice ID int,
    WWI Purchase Order ID int,
    Quantity int,
    WWI Stock Item ID int,
    WWI Customer ID int,
    WWI Supplier ID int,
    WWI Transaction Type ID int,
    Last Modifed
    When datetime2
);
CREATE TABLE Order_Staging (
    Order Staging Key bigint IDENTITY(1, 1) NOT NULL,
    City Key int,
    Customer Key int,
    Stock Item Key int,
    Order Date Key date,
    Picked Date Key date,
    Salesperson Key int,
    Picker Key int,
    WWI Order ID int,
    WWI Backorder ID int,
    Description nvarchar(100),
    Package nvarchar(50),
    Quantity int,
    Unit Price decimal(18, 2),
    Tax Rate decimal(18, 3),
    Total Excluding Tax decimal(18, 2),
    Tax Amount decimal(18, 2),
    Total Including Tax decimal(18, 2),
    Lineage Key int,
    WWI City ID int,
    WWI Customer ID int,
    WWI Stock Item ID int,
    WWI Salesperson ID int,
    WWI Picker ID int,
    Last Modified
    When datetime2
);
CREATE TABLE PaymentMethod_Staging (
    Payment Method Staging Key int IDENTITY(1, 1) NOT NULL,
    WWI Payment Method ID int NOT NULL,
    Payment Method nvarchar(50) NOT NULL,
    Valid
    From datetime2 NOT NULL,
        Valid To datetime2 NOT NULL
);
CREATE TABLE Purchase_Staging (
    Purchase Staging Key bigint IDENTITY(1, 1) NOT NULL,
    Date Key date,
    Supplier Key int,
    Stock Item Key int,
    WWI Purchase Order ID int,
    Ordered Outers int,
    Ordered Quantity int,
    Received Outers int,
    Package nvarchar(50),
    Is Order Finalized bit,
    WWI Supplier ID int,
    WWI Stock Item ID int,
    Last Modified
    When datetime2
);
CREATE TABLE Sale_Staging (
    Sale Staging Key bigint IDENTITY(1, 1) NOT NULL,
    City Key int,
    Customer Key int,
    Bill To Customer Key int,
    Stock Item Key int,
    Invoice Date Key date,
    Delivery Date Key date,
    Salesperson Key int,
    WWI Invoice ID int,
    Description nvarchar(100),
    Package nvarchar(50),
    Quantity int,
    Unit Price decimal(18, 2),
    Tax Rate decimal(18, 3),
    Total Excluding Tax decimal(18, 2),
    Tax Amount decimal(18, 2),
    Profit decimal(18, 2),
    Total Including Tax decimal(18, 2),
    Total Dry Items int,
    Total Chiller Items int,
    WWI City ID int,
    WWI Customer ID int,
    WWI Bill To Customer ID int,
    WWI Stock Item ID int,
    WWI Salesperson ID int,
    Last Modified
    When datetime2
);
CREATE TABLE Stock Holding (
    Stock Holding Key bigint IDENTITY(1, 1) NOT NULL,
    Stock Item Key int NOT NULL,
    Quantity On Hand int NOT NULL,
    Bin Location nvarchar(20) NOT NULL,
    Last Stocktake Quantity int NOT NULL,
    Last Cost Price decimal(18, 2) NOT NULL,
    Reorder Level int NOT NULL,
    Target Stock Level int NOT NULL,
    Lineage Key int NOT NULL
);
CREATE TABLE StockHolding_Staging (
    Stock Holding Staging Key bigint IDENTITY(1, 1) NOT NULL,
    Stock Item Key int,
    Quantity On Hand int,
    Bin Location nvarchar(20),
    Last Stocktake Quantity int,
    Last Cost Price decimal(18, 2),
    Reorder Level int,
    Target Stock Level int,
    WWI Stock Item ID int
);
CREATE TABLE StockItem_Staging (
    Stock Item Staging Key int IDENTITY(1, 1) NOT NULL,
    WWI Stock Item ID int NOT NULL,
    Stock Item nvarchar(100) NOT NULL,
    Color nvarchar(20) NOT NULL,
    Selling Package nvarchar(50) NOT NULL,
    Buying Package nvarchar(50) NOT NULL,
    Brand nvarchar(50) NOT NULL,
    Size nvarchar(20) NOT NULL,
    Lead Time Days int NOT NULL,
    Quantity Per Outer int NOT NULL,
    Is Chiller Stock bit NOT NULL,
    Barcode nvarchar(50),
    Tax Rate decimal(18, 3) NOT NULL,
    Unit Price decimal(18, 2) NOT NULL,
    Recommended Retail Price decimal(18, 2),
    Typical Weight Per Unit decimal(18, 3) NOT NULL,
    Photo varbinary(max),
    Valid
    From datetime2 NOT NULL,
        Valid To datetime2 NOT NULL
);
CREATE TABLE Supplier_Staging (
    Supplier Staging Key int IDENTITY(1, 1) NOT NULL,
    WWI Supplier ID int NOT NULL,
    Supplier nvarchar(100) NOT NULL,
    Category nvarchar(50) NOT NULL,
    Primary Contact nvarchar(50) NOT NULL,
    Supplier Reference nvarchar(20),
    Payment Days int NOT NULL,
    Postal Code nvarchar(10) NOT NULL,
    Valid
    From datetime2 NOT NULL,
        Valid To datetime2 NOT NULL
);
CREATE TABLE Transaction_Staging (
    Transaction Staging Key bigint IDENTITY(1, 1) NOT NULL,
    Date Key date,
    Customer Key int,
    Bill To Customer Key int,
    Supplier Key int,
    Transaction Type Key int,
    Payment Method Key int,
    WWI Customer Transaction ID int,
    WWI Supplier Transaction ID int,
    WWI Invoice ID int,
    WWI Purchase Order ID int,
    Supplier Invoice Number nvarchar(20),
    Total Excluding Tax decimal(18, 2),
    Tax Amount decimal(18, 2),
    Total Including Tax decimal(18, 2),
    Outstanding Balance decimal(18, 2),
    Is Finalized bit,
    WWI Customer ID int,
    WWI Bill To Customer ID int,
    WWI Supplier ID int,
    WWI Transaction Type ID int,
    WWI Payment Method ID int,
    Last Modified
    When datetime2
);
CREATE TABLE TransactionType_Staging (
    Transaction Type Staging Key int IDENTITY(1, 1) NOT NULL,
    WWI Transaction Type ID int NOT NULL,
    Transaction Type nvarchar(50) NOT NULL,
    Valid
    From datetime2 NOT NULL,
        Valid To datetime2 NOT NULL
)