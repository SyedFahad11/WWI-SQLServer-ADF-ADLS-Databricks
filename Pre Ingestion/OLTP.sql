/*************************
    PURCHASING
 *************************/
CREATE TABLE Purchasing.SupplierCategories (
    SupplierCategoryID int NOT NULL DEFAULT (NEXT VALUE FOR [Sequences].[SupplierCategoryID]),
    SupplierCategoryName nvarchar(50) NOT NULL,
    LastEditedBy int NOT NULL,
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NOT NULL
);
CREATE TABLE Purchasing.Suppliers (
    SupplierID int NOT NULL DEFAULT (NEXT VALUE FOR [Sequences].[SupplierID]),
    SupplierName nvarchar(100) NOT NULL,
    SupplierCategoryID int NOT NULL,
    PrimaryContactPersonID int NOT NULL,
    AlternateContactPersonID int NOT NULL,
    DeliveryMethodID int,
    DeliveryCityID int NOT NULL,
    PostalCityID int NOT NULL,
    SupplierReference nvarchar(20),
    BankAccountName nvarchar(50),
    BankAccountBranch nvarchar(50),
    BankAccountCode nvarchar(20),
    BankAccountNumber nvarchar(20),
    BankInternationalCode nvarchar(20),
    PaymentDays int NOT NULL,
    InternalComments nvarchar(max),
    PhoneNumber nvarchar(20) NOT NULL,
    FaxNumber nvarchar(20) NOT NULL,
    WebsiteURL nvarchar(256) NOT NULL,
    DeliveryAddressLine1 nvarchar(60) NOT NULL,
    DeliveryAddressLine2 nvarchar(60),
    DeliveryPostalCode nvarchar(10) NOT NULL,
    DeliveryLocation,
    PostalAddressLine1 nvarchar(60) NOT NULL,
    PostalAddressLine2 nvarchar(60),
    PostalPostalCode nvarchar(10) NOT NULL,
    LastEditedBy int NOT NULL,
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NOT NULL
);
CREATE TABLE Purchasing.SupplierTransactions (
    SupplierTransactionID int NOT NULL DEFAULT (NEXT VALUE FOR [Sequences].[TransactionID]),
    SupplierID int NOT NULL,
    TransactionTypeID int NOT NULL,
    PurchaseOrderID int,
    PaymentMethodID int,
    SupplierInvoiceNumber nvarchar(20),
    TransactionDate date NOT NULL,
    AmountExcludingTax decimal(18, 2) NOT NULL,
    TaxAmount decimal(18, 2) NOT NULL,
    TransactionAmount decimal(18, 2) NOT NULL,
    OutstandingBalance decimal(18, 2) NOT NULL,
    FinalizationDate date,
    IsFinalized AS(
        case
            when [FinalizationDate] IS NULL then CONVERT([bit],(0))
            else CONVERT([bit],(1))
        end
    ),
    LastEditedBy int NOT NULL,
    LastEditedWhen datetime2 NOT NULL DEFAULT (sysdatetime())
)
CREATE TABLE Purchasing.PurchaseOrderLines (
    PurchaseOrderLineID int NOT NULL DEFAULT (NEXT VALUE FOR [Sequences].[PurchaseOrderLineID]),
    PurchaseOrderID int NOT NULL,
    StockItemID int NOT NULL,
    OrderedOuters int NOT NULL,
    Description nvarchar(100) NOT NULL,
    ReceivedOuters int NOT NULL,
    PackageTypeID int NOT NULL,
    ExpectedUnitPricePerOuter decimal(18, 2),
    LastReceiptDate date,
    IsOrderLineFinalized bit NOT NULL,
    LastEditedBy int NOT NULL,
    LastEditedWhen datetime2 NOT NULL DEFAULT (sysdatetime())
);
CREATE TABLE Purchasing.PurchaseOrders (
    PurchaseOrderID int NOT NULL DEFAULT (NEXT VALUE FOR [Sequences].[PurchaseOrderID]),
    SupplierID int NOT NULL,
    OrderDate date NOT NULL,
    DeliveryMethodID int NOT NULL,
    ContactPersonID int NOT NULL,
    ExpectedDeliveryDate date,
    SupplierReference nvarchar(20),
    IsOrderFinalized bit NOT NULL,
    Comments nvarchar(max),
    InternalComments nvarchar(max),
    LastEditedBy int NOT NULL,
    LastEditedWhen datetime2 NOT NULL DEFAULT (sysdatetime())
);
/*************************
    WAREHOUSE
 *************************/
;
CREATE TABLE Warehouse.VehicleTemperatures (
    VehicleTemperatureID bigint IDENTITY(1, 1) NOT NULL,
    VehicleRegistration nvarchar(20) NOT NULL,
    ChillerSensorNumber int NOT NULL,
    RecordedWhen datetime2 NOT NULL,
    Temperature decimal(10, 2) NOT NULL,
    FullSensorData nvarchar(1000),
    IsCompressed bit NOT NULL,
    CompressedSensorData varbinary(max)
);
CREATE TABLE Warehouse.ColdRoomTemperatures (
    ColdRoomTemperatureID bigint IDENTITY(1, 1) NOT NULL,
    ColdRoomSensorNumber int NOT NULL,
    RecordedWhen datetime2 NOT NULL,
    Temperature decimal(10, 2) NOT NULL,
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NOT NULL
);
CREATE TABLE Warehouse.Colors (
    ColorID int NOT NULL DEFAULT (NEXT VALUE FOR [Sequences].[ColorID]),
    ColorName nvarchar(20) NOT NULL,
    LastEditedBy int NOT NULL,
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NOT NULL
);
CREATE TABLE  Warehouse.StockItemHoldings (
    StockItemID int NOT NULL,
    QuantityOnHand int NOT NULL,
    BinLocation nvarchar(20) NOT NULL,
    LastStocktakeQuantity int NOT NULL,
    LastCostPrice decimal(18, 2) NOT NULL,
    ReorderLevel int NOT NULL,
    TargetStockLevel int NOT NULL,
    LastEditedBy int NOT NULL,
    LastEditedWhen datetime2 NOT NULL DEFAULT (sysdatetime())
);
CREATE TABLE  Warehouse.StockItems (
    StockItemID int NOT NULL DEFAULT (NEXT VALUE FOR [Sequences].[StockItemID]),
    StockItemName nvarchar(100) NOT NULL,
    SupplierID int NOT NULL,
    ColorID int,
    UnitPackageID int NOT NULL,
    OuterPackageID int NOT NULL,
    Brand nvarchar(50),
    Size nvarchar(20),
    LeadTimeDays int NOT NULL,
    QuantityPerOuter int NOT NULL,
    IsChillerStock bit NOT NULL,
    Barcode nvarchar(50),
    TaxRate decimal(18, 3) NOT NULL,
    UnitPrice decimal(18, 2) NOT NULL,
    RecommendedRetailPrice decimal(18, 2),
    TypicalWeightPerUnit decimal(18, 3) NOT NULL,
    MarketingComments nvarchar(max),
    InternalComments nvarchar(max),
    Photo varbinary(max),
    CustomFields nvarchar(max),
    Tags AS(json_query([CustomFields], N'$.Tags')),
    SearchDetails AS(
        concat([StockItemName], N' ', [MarketingComments])
    ),
    LastEditedBy int NOT NULL,
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NOT NULL
);
CREATE TABLE  Warehouse.StockItemStockGroups (
    StockItemStockGroupID int NOT NULL DEFAULT (
        NEXT VALUE FOR [Sequences].[StockItemStockGroupID]
    ),
    StockItemID int NOT NULL,
    StockGroupID int NOT NULL,
    LastEditedBy int NOT NULL,
    LastEditedWhen datetime2 NOT NULL DEFAULT (sysdatetime())
);
CREATE TABLE  Warehouse.StockItemTransactions (
    StockItemTransactionID int NOT NULL DEFAULT (NEXT VALUE FOR [Sequences].[TransactionID]),
    StockItemID int NOT NULL,
    TransactionTypeID int NOT NULL,
    CustomerID int,
    InvoiceID int,
    SupplierID int,
    PurchaseOrderID int,
    TransactionOccurredWhen datetime2 NOT NULL,
    Quantity decimal(18, 3) NOT NULL,
    LastEditedBy int NOT NULL,
    LastEditedWhen datetime2 NOT NULL DEFAULT (sysdatetime())
);
CREATE TABLE  Warehouse.StockGroups (
    StockGroupID int NOT NULL DEFAULT (NEXT VALUE FOR [Sequences].[StockGroupID]),
    StockGroupName nvarchar(50) NOT NULL,
    LastEditedBy int NOT NULL,
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NOT NULL
);
CREATE TABLE  Warehouse.PackageTypes (
    PackageTypeID int NOT NULL DEFAULT (NEXT VALUE FOR [Sequences].[PackageTypeID]),
    PackageTypeName nvarchar(50) NOT NULL,
    LastEditedBy int NOT NULL,
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NOT NULL
)
/***************************
        SALES
 ***************************/

CREATE TABLE Sales.BuyingGroups (
    BuyingGroupID int NOT NULL DEFAULT (NEXT VALUE FOR [Sequences].[BuyingGroupID]),
    BuyingGroupName nvarchar(50) NOT NULL,
    LastEditedBy int NOT NULL,
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NOT NULL
);
CREATE TABLE Sales.SpecialDeals (
    SpecialDealID int NOT NULL DEFAULT (NEXT VALUE FOR [Sequences].[SpecialDealID]),
    StockItemID int,
    CustomerID int,
    BuyingGroupID int,
    CustomerCategoryID int,
    StockGroupID int,
    DealDescription nvarchar(30) NOT NULL,
    StartDate date NOT NULL,
    EndDate date NOT NULL,
    DiscountAmount decimal(18, 2),
    DiscountPercentage decimal(18, 3),
    UnitPrice decimal(18, 2),
    LastEditedBy int NOT NULL,
    LastEditedWhen datetime2 NOT NULL DEFAULT (sysdatetime())
);
CREATE TABLE Sales.CustomerCategories (
    CustomerCategoryID int NOT NULL DEFAULT (NEXT VALUE FOR [Sequences].[CustomerCategoryID]),
    CustomerCategoryName nvarchar(50) NOT NULL,
    LastEditedBy int NOT NULL,
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NOT NULL
);
CREATE TABLE Sales.CustomerTransactions (
    CustomerTransactionID int NOT NULL DEFAULT (NEXT VALUE FOR [Sequences].[TransactionID]),
    CustomerID int NOT NULL,
    TransactionTypeID int NOT NULL,
    InvoiceID int,
    PaymentMethodID int,
    TransactionDate date NOT NULL,
    AmountExcludingTax decimal(18, 2) NOT NULL,
    TaxAmount decimal(18, 2) NOT NULL,
    TransactionAmount decimal(18, 2) NOT NULL,
    OutstandingBalance decimal(18, 2) NOT NULL,
    FinalizationDate date,
    IsFinalized AS(
        case
            when [FinalizationDate] IS NULL then CONVERT([bit],(0))
            else CONVERT([bit],(1))
        end
    ),
    LastEditedBy int NOT NULL,
    LastEditedWhen datetime2 NOT NULL DEFAULT (sysdatetime())
);
CREATE TABLE Sales.InvoiceLines (
    InvoiceLineID int NOT NULL DEFAULT (NEXT VALUE FOR [Sequences].[InvoiceLineID]),
    InvoiceID int NOT NULL,
    StockItemID int NOT NULL,
    Description nvarchar(100) NOT NULL,
    PackageTypeID int NOT NULL,
    Quantity int NOT NULL,
    UnitPrice decimal(18, 2),
    TaxRate decimal(18, 3) NOT NULL,
    TaxAmount decimal(18, 2) NOT NULL,
    LineProfit decimal(18, 2) NOT NULL,
    ExtendedPrice decimal(18, 2) NOT NULL,
    LastEditedBy int NOT NULL,
    LastEditedWhen datetime2 NOT NULL DEFAULT (sysdatetime())
);
CREATE TABLE Sales.Invoices (
    InvoiceID int NOT NULL DEFAULT (NEXT VALUE FOR [Sequences].[InvoiceID]),
    CustomerID int NOT NULL,
    BillToCustomerID int NOT NULL,
    OrderID int,
    DeliveryMethodID int NOT NULL,
    ContactPersonID int NOT NULL,
    AccountsPersonID int NOT NULL,
    SalespersonPersonID int NOT NULL,
    PackedByPersonID int NOT NULL,
    InvoiceDate date NOT NULL,
    CustomerPurchaseOrderNumber nvarchar(20),
    IsCreditNote bit NOT NULL,
    CreditNoteReason nvarchar(max),
    Comments nvarchar(max),
    DeliveryInstructions nvarchar(max),
    InternalComments nvarchar(max),
    TotalDryItems int NOT NULL,
    TotalChillerItems int NOT NULL,
    DeliveryRun nvarchar(5),
    RunPosition nvarchar(5),
    ReturnedDeliveryData nvarchar(max),
    ConfirmedDeliveryTime AS(
        TRY_CONVERT(
            [datetime2](7),
            json_value([ReturnedDeliveryData], N'$.DeliveredWhen'),
            (126)
        )
    ),
    ConfirmedReceivedBy AS(
        json_value([ReturnedDeliveryData], N'$.ReceivedBy')
    ),
    LastEditedBy int NOT NULL,
    LastEditedWhen datetime2 NOT NULL DEFAULT (sysdatetime())
);

CREATE TABLE Sales.OrderLines (
    OrderLineID int NOT NULL DEFAULT (NEXT VALUE FOR [Sequences].[OrderLineID]),
    OrderID int NOT NULL,
    StockItemID int NOT NULL,
    Description nvarchar(100) NOT NULL,
    PackageTypeID int NOT NULL,
    Quantity int NOT NULL,
    UnitPrice decimal(18, 2),
    TaxRate decimal(18, 3) NOT NULL,
    PickedQuantity int NOT NULL,
    PickingCompletedWhen datetime2,
    LastEditedBy int NOT NULL,
    LastEditedWhen datetime2 NOT NULL DEFAULT (sysdatetime())
);

CREATE TABLE Sales.Orders (
    OrderID int NOT NULL DEFAULT (NEXT VALUE FOR [Sequences].[OrderID]),
    CustomerID int NOT NULL,
    SalespersonPersonID int NOT NULL,
    PickedByPersonID int,
    ContactPersonID int NOT NULL,
    BackorderOrderID int,
    OrderDate date NOT NULL,
    ExpectedDeliveryDate date NOT NULL,
    CustomerPurchaseOrderNumber nvarchar(20),
    IsUndersupplyBackordered bit NOT NULL,
    Comments nvarchar(max),
    DeliveryInstructions nvarchar(max),
    InternalComments nvarchar(max),
    PickingCompletedWhen datetime2,
    LastEditedBy int NOT NULL,
    LastEditedWhen datetime2 NOT NULL DEFAULT (sysdatetime())
);
CREATE TABLE Sales.Customers (
    CustomerID int NOT NULL DEFAULT (NEXT VALUE FOR [Sequences].[CustomerID]),
    CustomerName nvarchar(100) NOT NULL,
    BillToCustomerID int NOT NULL,
    CustomerCategoryID int NOT NULL,
    BuyingGroupID int,
    PrimaryContactPersonID int NOT NULL,
    AlternateContactPersonID int,
    DeliveryMethodID int NOT NULL,
    DeliveryCityID int NOT NULL,
    PostalCityID int NOT NULL,
    CreditLimit decimal(18, 2),
    AccountOpenedDate date NOT NULL,
    StandardDiscountPercentage decimal(18, 3) NOT NULL,
    IsStatementSent bit NOT NULL,
    IsOnCreditHold bit NOT NULL,
    PaymentDays int NOT NULL,
    PhoneNumber nvarchar(20) NOT NULL,
    FaxNumber nvarchar(20) NOT NULL,
    DeliveryRun nvarchar(5),
    RunPosition nvarchar(5),
    WebsiteURL nvarchar(256) NOT NULL,
    DeliveryAddressLine1 nvarchar(60) NOT NULL,
    DeliveryAddressLine2 nvarchar(60),
    DeliveryPostalCode nvarchar(10) NOT NULL,
    DeliveryLocation,
    PostalAddressLine1 nvarchar(60) NOT NULL,
    PostalAddressLine2 nvarchar(60),
    PostalPostalCode nvarchar(10) NOT NULL,
    LastEditedBy int NOT NULL,
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NOT NULL
)
/*****************************
        APPLICATION
 *****************************/

CREATE TABLE Application.Cities (
    CityID int NOT NULL DEFAULT (NEXT VALUE FOR [Sequences].[CityID]),
    CityName nvarchar(50) NOT NULL,
    StateProvinceID int NOT NULL,
    Location,
    LatestRecordedPopulation bigint,
    LastEditedBy int NOT NULL,
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NOT NULL
);
CREATE TABLE Application.Countries (
    CountryID int NOT NULL DEFAULT (NEXT VALUE FOR [Sequences].[CountryID]),
    CountryName nvarchar(60) NOT NULL,
    FormalName nvarchar(60) NOT NULL,
    IsoAlpha3Code nvarchar(3),
    IsoNumericCode int,
    CountryType nvarchar(20),
    LatestRecordedPopulation bigint,
    Continent nvarchar(30) NOT NULL,
    Region nvarchar(30) NOT NULL,
    Subregion nvarchar(30) NOT NULL,
    Border,
    LastEditedBy int NOT NULL,
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NOT NULL
);
CREATE TABLE Application.DeliveryMethods (
    DeliveryMethodID int NOT NULL DEFAULT (NEXT VALUE FOR [Sequences].[DeliveryMethodID]),
    DeliveryMethodName nvarchar(50) NOT NULL,
    LastEditedBy int NOT NULL,
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NOT NULL
);
CREATE TABLE Application.PaymentMethods (
    PaymentMethodID int NOT NULL DEFAULT (NEXT VALUE FOR [Sequences].[PaymentMethodID]),
    PaymentMethodName nvarchar(50) NOT NULL,
    LastEditedBy int NOT NULL,
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NOT NULL
);
CREATE TABLE Application.People (
    PersonID int NOT NULL DEFAULT (NEXT VALUE FOR [Sequences].[PersonID]),
    FullName nvarchar(50) NOT NULL,
    PreferredName nvarchar(50) NOT NULL,
    SearchName AS(concat([PreferredName], N' ', [FullName])),
    IsPermittedToLogon bit NOT NULL,
    LogonName nvarchar(50),
    IsExternalLogonProvider bit NOT NULL,
    HashedPassword varbinary(max),
    IsSystemUser bit NOT NULL,
    IsEmployee bit NOT NULL,
    IsSalesperson bit NOT NULL,
    UserPreferences nvarchar(max),
    PhoneNumber nvarchar(20),
    FaxNumber nvarchar(20),
    EmailAddress nvarchar(256),
    Photo varbinary(max),
    CustomFields nvarchar(max),
    OtherLanguages AS(json_query([CustomFields], N'$.OtherLanguages')),
    LastEditedBy int NOT NULL,
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NOT NULL
);

CREATE TABLE Application.StateProvinces (
    StateProvinceID int NOT NULL DEFAULT (NEXT VALUE FOR [Sequences].[StateProvinceID]),
    StateProvinceCode nvarchar(5) NOT NULL,
    StateProvinceName nvarchar(50) NOT NULL,
    CountryID int NOT NULL,
    SalesTerritory nvarchar(50) NOT NULL,
    Border,
    LatestRecordedPopulation bigint,
    LastEditedBy int NOT NULL,
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NOT NULL
);
CREATE TABLE Application.SystemParameters (
    SystemParameterID int NOT NULL DEFAULT (NEXT VALUE FOR [Sequences].[SystemParameterID]),
    DeliveryAddressLine1 nvarchar(60) NOT NULL,
    DeliveryAddressLine2 nvarchar(60),
    DeliveryCityID int NOT NULL,
    DeliveryPostalCode nvarchar(10) NOT NULL,
    DeliveryLocation NOT NULL,
    PostalAddressLine1 nvarchar(60) NOT NULL,
    PostalAddressLine2 nvarchar(60),
    PostalCityID int NOT NULL,
    PostalPostalCode nvarchar(10) NOT NULL,
    ApplicationSettings nvarchar(max) NOT NULL,
    LastEditedBy int NOT NULL,
    LastEditedWhen datetime2 NOT NULL DEFAULT (sysdatetime())
);
CREATE TABLE Application.TransactionTypes (
    TransactionTypeID int NOT NULL DEFAULT (NEXT VALUE FOR [Sequences].[TransactionTypeID]),
    TransactionTypeName nvarchar(50) NOT NULL,
    LastEditedBy int NOT NULL,
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NOT NULL
)
/*****************************
        ARCHIVES
 *****************************/
;
CREATE TABLE BuyingGroups_Archive (
    BuyingGroupID int NOT NULL,
    BuyingGroupName nvarchar(50) NOT NULL,
    LastEditedBy int NOT NULL,
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NOT NULL
);
CREATE TABLE TransactionTypes_Archive (
    TransactionTypeID int NOT NULL,
    TransactionTypeName nvarchar(50) NOT NULL,
    LastEditedBy int NOT NULL,
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NOT NULL
);
CREATE TABLE Suppliers_Archive (
    SupplierID int NOT NULL,
    SupplierName nvarchar(100) NOT NULL,
    SupplierCategoryID int NOT NULL,
    PrimaryContactPersonID int NOT NULL,
    AlternateContactPersonID int NOT NULL,
    DeliveryMethodID int,
    DeliveryCityID int NOT NULL,
    PostalCityID int NOT NULL,
    SupplierReference nvarchar(20),
    BankAccountName nvarchar(50),
    BankAccountBranch nvarchar(50),
    BankAccountCode nvarchar(20),
    BankAccountNumber nvarchar(20),
    BankInternationalCode nvarchar(20),
    PaymentDays int NOT NULL,
    InternalComments nvarchar(max),
    PhoneNumber nvarchar(20) NOT NULL,
    FaxNumber nvarchar(20) NOT NULL,
    WebsiteURL nvarchar(256) NOT NULL,
    DeliveryAddressLine1 nvarchar(60) NOT NULL,
    DeliveryAddressLine2 nvarchar(60),
    DeliveryPostalCode nvarchar(10) NOT NULL,
    DeliveryLocation,
    PostalAddressLine1 nvarchar(60) NOT NULL,
    PostalAddressLine2 nvarchar(60),
    PostalPostalCode nvarchar(10) NOT NULL,
    LastEditedBy int NOT NULL,
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NOT NULL
);
CREATE TABLE SupplierCategories_Archive (
    SupplierCategoryID int NOT NULL,
    SupplierCategoryName nvarchar(50) NOT NULL,
    LastEditedBy int NOT NULL,
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NOT NULL
);
CREATE TABLE StockItems_Archive (
    StockItemID int NOT NULL,
    StockItemName nvarchar(100) NOT NULL,
    SupplierID int NOT NULL,
    ColorID int,
    UnitPackageID int NOT NULL,
    OuterPackageID int NOT NULL,
    Brand nvarchar(50),
    Size nvarchar(20),
    LeadTimeDays int NOT NULL,
    QuantityPerOuter int NOT NULL,
    IsChillerStock bit NOT NULL,
    Barcode nvarchar(50),
    TaxRate decimal(18, 3) NOT NULL,
    UnitPrice decimal(18, 2) NOT NULL,
    RecommendedRetailPrice decimal(18, 2),
    TypicalWeightPerUnit decimal(18, 3) NOT NULL,
    MarketingComments nvarchar(max),
    InternalComments nvarchar(max),
    Photo varbinary(max),
    CustomFields nvarchar(max),
    Tags nvarchar(max),
    SearchDetails nvarchar(max) NOT NULL,
    LastEditedBy int NOT NULL,
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NOT NULL
);
CREATE TABLE StateProvinces_Archive (
    StateProvinceID int NOT NULL,
    StateProvinceCode nvarchar(5) NOT NULL,
    StateProvinceName nvarchar(50) NOT NULL,
    CountryID int NOT NULL,
    SalesTerritory nvarchar(50) NOT NULL,
    Border,
    LatestRecordedPopulation bigint,
    LastEditedBy int NOT NULL,
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NOT NULL
);
CREATE TABLE StockGroups_Archive (
    StockGroupID int NOT NULL,
    StockGroupName nvarchar(50) NOT NULL,
    LastEditedBy int NOT NULL,
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NOT NULL
);
CREATE TABLE Cities_Archive (
    CityID int NOT NULL,
    CityName nvarchar(50) NOT NULL,
    StateProvinceID int NOT NULL,
    Location,
    LatestRecordedPopulation bigint,
    LastEditedBy int NOT NULL,
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NOT NULL
);
CREATE TABLE ColdRoomTemperatures_Archive (
    ColdRoomTemperatureID bigint NOT NULL,
    ColdRoomSensorNumber int NOT NULL,
    RecordedWhen datetime2 NOT NULL,
    Temperature decimal(10, 2) NOT NULL,
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NOT NULL
);
CREATE TABLE Colors_Archive (
    ColorID int NOT NULL,
    ColorName nvarchar(20) NOT NULL,
    LastEditedBy int NOT NULL,
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NOT NULL
);
CREATE TABLE Countries_Archive (
    CountryID int NOT NULL,
    CountryName nvarchar(60) NOT NULL,
    FormalName nvarchar(60) NOT NULL,
    IsoAlpha3Code nvarchar(3),
    IsoNumericCode int,
    CountryType nvarchar(20),
    LatestRecordedPopulation bigint,
    Continent nvarchar(30) NOT NULL,
    Region nvarchar(30) NOT NULL,
    Subregion nvarchar(30) NOT NULL,
    Border,
    LastEditedBy int NOT NULL,
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NOT NULL
);
CREATE TABLE CustomerCategories_Archive (
    CustomerCategoryID int NOT NULL,
    CustomerCategoryName nvarchar(50) NOT NULL,
    LastEditedBy int NOT NULL,
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NOT NULL
);
CREATE TABLE Customers_Archive (
    CustomerID int NOT NULL,
    CustomerName nvarchar(100) NOT NULL,
    BillToCustomerID int NOT NULL,
    CustomerCategoryID int NOT NULL,
    BuyingGroupID int,
    PrimaryContactPersonID int NOT NULL,
    AlternateContactPersonID int,
    DeliveryMethodID int NOT NULL,
    DeliveryCityID int NOT NULL,
    PostalCityID int NOT NULL,
    CreditLimit decimal(18, 2),
    AccountOpenedDate date NOT NULL,
    StandardDiscountPercentage decimal(18, 3) NOT NULL,
    IsStatementSent bit NOT NULL,
    IsOnCreditHold bit NOT NULL,
    PaymentDays int NOT NULL,
    PhoneNumber nvarchar(20) NOT NULL,
    FaxNumber nvarchar(20) NOT NULL,
    DeliveryRun nvarchar(5),
    RunPosition nvarchar(5),
    WebsiteURL nvarchar(256) NOT NULL,
    DeliveryAddressLine1 nvarchar(60) NOT NULL,
    DeliveryAddressLine2 nvarchar(60),
    DeliveryPostalCode nvarchar(10) NOT NULL,
    DeliveryLocation,
    PostalAddressLine1 nvarchar(60) NOT NULL,
    PostalAddressLine2 nvarchar(60),
    PostalPostalCode nvarchar(10) NOT NULL,
    LastEditedBy int NOT NULL,
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NOT NULL
);
CREATE TABLE People_Archive (
    PersonID int NOT NULL,
    FullName nvarchar(50) NOT NULL,
    PreferredName nvarchar(50) NOT NULL,
    SearchName nvarchar(101) NOT NULL,
    IsPermittedToLogon bit NOT NULL,
    LogonName nvarchar(50),
    IsExternalLogonProvider bit NOT NULL,
    HashedPassword varbinary(max),
    IsSystemUser bit NOT NULL,
    IsEmployee bit NOT NULL,
    IsSalesperson bit NOT NULL,
    UserPreferences nvarchar(max),
    PhoneNumber nvarchar(20),
    FaxNumber nvarchar(20),
    EmailAddress nvarchar(256),
    Photo varbinary(max),
    CustomFields nvarchar(max),
    OtherLanguages nvarchar(max),
    LastEditedBy int NOT NULL,
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NOT NULL
);
CREATE TABLE DeliveryMethods_Archive (
    DeliveryMethodID int NOT NULL,
    DeliveryMethodName nvarchar(50) NOT NULL,
    LastEditedBy int NOT NULL,
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NOT NULL
);
CREATE TABLE PackageTypes_Archive (
    PackageTypeID int NOT NULL,
    PackageTypeName nvarchar(50) NOT NULL,
    LastEditedBy int NOT NULL,
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NOT NULL
);
CREATE TABLE PaymentMethods_Archive (
    PaymentMethodID int NOT NULL,
    PaymentMethodName nvarchar(50) NOT NULL,
    LastEditedBy int NOT NULL,
    ValidFrom datetime2 NOT NULL,
    ValidTo datetime2 NOT NULL
)