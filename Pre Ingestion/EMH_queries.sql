--Sales.Customers 663 rows
--1
SELECT 
	CT.CityName
	,COUNT(CustomerID) AS Cnt 
FROM Sales.Customers C 
JOIN Application.Cities CT ON C.DeliveryCityID=CT.CityID
GROUP BY CT.CityID,CityName ORDER BY Cnt DESC;

--2
SELECT 
	StockGroupName
	,Count(StockItemID) AS Cnt 
FROM Warehouse.StockItemStockGroups BRDG 
JOIN Warehouse.StockGroups SG ON BRDG.StockGroupId=SG.StockGroupID
GROUP BY SG.StockGroupID,StockGroupName;

--3
SELECT 
	PO.PurchaseOrderId
	,SUM(ExpectedUnitPricePerOuter*ReceivedOuters) AS amt
	,YEAR(PO.OrderDate)
FROM Purchasing.PurchaseOrderLines POL
JOIN Purchasing.PurchaseOrders PO ON POL.PurchaseOrderID=PO.PurchaseOrderID
WHERE YEAR(PO.OrderDate)= (SELECT MAX(YEAR(OrderDate)) FROM Purchasing.PurchaseOrders)-1
GROUP BY Po.PurchaseOrderID, PO.OrderDate --If there is more finer grain than PurchaseOrderID, it will do final group by on that
ORDER BY amt DESC;

--4
SELECT * FROM Purchasing.Suppliers WHERE SupplierName LIKE 'A%';

--5
SELECT AVG(cnt) FROM (
SELECT InvoiceID, COUNT(InvoiceLineID) AS cnt FROM Sales.InvoiceLines GROUP BY InvoiceID)A;



--6
/*Customers Are Tailspin Toys(Different Locations)-3, Wingtip Toys(Different Locations)-3 or Retail Customers
One Can check in CustomerCategories. Different Locations for two major novelty shops are categorised into BuyingGroups

SELECT * FROM Sales.Invoices I JOIN Sales.Customers C ON I.CustomerID=C.CustomerID JOIN Application.DeliveryMethods DM ON I.DeliveryMethodID=DM.DeliveryMethodID WHERE I.BillToCustomerID=1 ;
SELECT * FROM Sales.Customers;
SELECT * fROM Sales.Orders;

SELECT * FROM Sales.InvoiceLines WHERE InvoiceID=64220;
SELECT * FROM Sales.Invoices WHERE InvoiceID=64220;
SELECT * FROM Sales.Customers C WHERE CustomerID=401;
SELECT * FROM Sales.CustomerCategories WHERE CustomerCategoryID=3;
SELECT * FROM Sales.BuyingGroups WHERE BuyingGroupID=1;
SELECT IL.InvoiceID AS ID,SUM(ExtendedPrice) AS Price FROM Sales.Invoices I JOIN Sales.InvoiceLines IL ON IL.InvoiceID=I.InvoiceID WHERE I.BillToCustomerID=1 GROUP BY IL.InvoiceID ORDER BY PRICE DESC ;

SELECT * FROM Sales.CustomerCategories;

SELECT CustomerID, CustomerName,CG.CustomerCategoryName,CG.CustomerCategoryID FROM Sales.Customers C JOIN Sales.CustomerCategories CG ON C.CustomerCategoryID=CG.CustomerCategoryID;
*/

SELECT * FROM Sales.OrderLines;
SELECT 
	CustomerName
	,OrderID 
FROM Sales.Orders O 
JOIN Sales.Customers C ON O.CustomerID=C.CustomerID 
WHERE O.OrderID  NOT IN ( SELECT DISTINCT OrderID FROM Sales.Invoices);

--7
--228265
SELECT * FROM Warehouse.StockItems S LEFT JOIN Sales.InvoiceLines IL ON S.StockItemID=IL.StockItemID WHERE InvoiceLineID IS NULL;

--8
SELECT 
	*, 
	SUM(Qty) OVER (ORDER BY YEAR, MONTH) AS Cum 
FROM (
	SELECT DISTINCT
		MONTH(I.InvoiceDate) AS Month
		,YEAR(I.InvoiceDate) AS Year
		,SUM(Quantity) AS Qty
		,SUM(ExtendedPrice) AS Sale

	FROM Sales.InvoiceLines IL 
	JOIN Sales.Invoices I ON IL.InvoiceID=I.InvoiceID
	GROUP BY MONTH(I.InvoiceDate), YEAR(I.InvoiceDate) 
)A

--9
SELECT 
	CustomerID
	,MAX(InvoiceAmt)-MIN(InvoiceAmt) AS diff 
FROM (
	SELECT 
		I.CustomerID, 
		SUM(IL.ExtendedPrice) AS InvoiceAmt 
	FROM Sales.InvoiceLines IL 
	JOIN Sales.Invoices I ON IL.InvoiceID=I.InvoiceID 
	GROUP BY IL.InvoiceID,I.CustomerID) A
GROUP BY CustomerID 
ORDER BY diff DESC ;

--10
WITH CTE AS(
	SELECT 
		DISTINCT
		I.InvoiceDate
		,SUM(IL.ExtendedPrice) OVER (PARTITION BY I.InvoiceDate) AS DailySale
		,SUM(IL.Quantity)OVER (PARTITION BY I.InvoiceDate) AS QuantitySold
	FROM Sales.InvoiceLines IL 
	JOIN Sales.Invoices I ON IL.InvoiceID=I.InvoiceID 
	WHERE  I.InvoiceDate>DATEADD(DAY,-30,(SELECT MAX(I.InvoiceDate) FROM Sales.Invoices I))
)
SELECT * FROM CTE;
--Both works
WITH CTE AS(
	SELECT 
		DISTINCT
		I.InvoiceDate
		,SUM(IL.ExtendedPrice) OVER (PARTITION BY I.InvoiceDate) AS DailySale
		,SUM(IL.Quantity)OVER (PARTITION BY I.InvoiceDate) AS QuantitySold
	FROM Sales.InvoiceLines IL 
	JOIN Sales.Invoices I ON IL.InvoiceID=I.InvoiceID 
	WHERE  DATEDIFF(DAY,I.InvoiceDate,(SELECT MAX(I.InvoiceDate) FROM Sales.Invoices I))<30
)
SELECT RANK()OVER (ORDER BY DailySale DESC) ,* FROM CTE;

--11

