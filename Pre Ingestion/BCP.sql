/*DECLARE @bcpCmd NVARCHAR(MAX);

SELECT @bcpCmd = STRING_AGG( CAST(
    'bcp WideWorldImporters.' + QUOTENAME(s.name) + '.' + QUOTENAME(t.name) +
    ' out "C:\BCPOutput\' + t.name + '.csv"' +
    ' -c -t"," -h "COLUMN_NAMES"' +
    ' -S PTDELL0026\SQLEXPRESS -U sa -P Welcome@1234' AS NVARCHAR(MAX)),
    CHAR(13) + CHAR(10)
)
FROM sys.tables t
JOIN sys.schemas s ON t.schema_id = s.schema_id;

PRINT @bcpCmd;
*/
GO
DECLARE 
    @SchemaName SYSNAME,
    @TableName SYSNAME,
    @HeaderSQL NVARCHAR(MAX),
    @DataSQL NVARCHAR(MAX),
    @BCPCmd NVARCHAR(MAX),
	@SchemaSpecific NVARCHAR(MAX);

DECLARE table_cursor CURSOR FAST_FORWARD FOR
SELECT s.name, t.name
FROM sys.tables t
JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE t.is_ms_shipped = 0 AND t.name NOT LIKE'%Archive%' AND t.name <> 'initial_orders' AND t.name <> 'sysdiagrams' AND s.name='Sales';

OPEN table_cursor;
FETCH NEXT FROM table_cursor INTO @SchemaName, @TableName;

WHILE @@FETCH_STATUS = 0
BEGIN
    /* Header row */
    SELECT @HeaderSQL =
        'SELECT ''' +
        STRING_AGG(c.name, ''',''') WITHIN GROUP (ORDER BY c.column_id) +
        ''''
    FROM sys.columns c
    WHERE c.object_id = OBJECT_ID(QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName));

    /* Data row: CAST EVERYTHING TO VARCHAR */
    SELECT @DataSQL =
        'SELECT ' +
        STRING_AGG(
            'CAST(' + QUOTENAME(c.name) + ' AS VARCHAR(MAX))',
            ','
        ) WITHIN GROUP (ORDER BY c.column_id) +
        ' FROM WideWorldImporters.' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName)
    FROM sys.columns c
    WHERE c.object_id = OBJECT_ID(QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName));

    /* Final BCP command */
    SET @BCPCmd =
        'bcp "' +
        @HeaderSQL +
        ' UNION ALL ' +
        @DataSQL +
        '" queryout "C:\BCPOutput\' + @TableName + '.csv"' +
        ' -c -t"," -S PTDELL0026\SQLEXPRESS -U sa -P Welcome@1234';

   PRINT @BCPCmd;        -- Debug
	--SET @SchemaSpecific=@SchemaSpecific+@BCPCmd;
   -- EXEC xp_cmdshell @BCPCmd;

    FETCH NEXT FROM table_cursor INTO @SchemaName, @TableName;
END

CLOSE table_cursor;
DEALLOCATE table_cursor;

--PRINT @SchemaSpecific;
--SELECT 'ColorID','ColorName','LastEditedBy','ValidFrom','ValidTo' UNION ALL SELECT * FROM WideWorldImporters.[Warehouse].[Colors];

--bcp "SELECT 'ColorID','ColorName','LastEditedBy','ValidFrom','ValidTo' UNION ALL SELECT * FROM WideWorldImporters.[Warehouse].[Colors]" queryout "C:\BCPOutput\Colors.csv" -c -t"," -S PTDELL0026\SQLEXPRESS -U sa -P Welcome@1234
--bcp "SELECT 'PaymentMethodID','PaymentMethodName','LastEditedBy','ValidFrom','ValidTo' UNION ALL SELECT CAST([PaymentMethodID] AS VARCHAR(8000)),CAST([PaymentMethodName] AS VARCHAR(8000)),CAST([LastEditedBy] AS VARCHAR(8000)),CAST([ValidFrom] AS VARCHAR(8000)),CAST([ValidTo] AS VARCHAR(8000)) FROM WideWorldImporters.[Application].[PaymentMethods]" queryout "C:\BCPOutput\PaymentMethods.csv" -c -t"," -S PTDELL0026\SQLEXPRESS -U sa -P Welcome@1234
