-- ============================================================
-- SQL_covid_worldwide.sql
-- Creates an external table over the Gold layer CSV and
-- queries the full enriched COVID-19 worldwide dataset.
--
-- Database:  SQL_covid_ww (Serverless SQL Pool)
-- Source:    Gold/covid_worldwide_GZ.csv
-- Layer:     Gold
-- ============================================================

-- Step 1: Create external file format (if not exists)
IF NOT EXISTS (
    SELECT * FROM sys.external_file_formats
    WHERE name = 'SynapseDelimitedTextFormat'
)
BEGIN
    CREATE EXTERNAL FILE FORMAT SynapseDelimitedTextFormat
    WITH (
        FORMAT_TYPE = DELIMITEDTEXT,
        FORMAT_OPTIONS (
            FIELD_TERMINATOR = ',',
            FIRST_ROW       = 2,
            USE_TYPE_DEFAULT = TRUE
        )
    );
END
GO

-- Step 2: Create external data source (if not exists)
-- ⚠️ Update the LOCATION with your own storage account name
IF NOT EXISTS (
    SELECT * FROM sys.external_data_sources
    WHERE name = 'ADFS_ExternalSource02'
)
BEGIN
    CREATE EXTERNAL DATA SOURCE ADFS_ExternalSource02
    WITH (
        LOCATION = 'abfss://datatokioolympicsgps@tokioolympicsgps.dfs.core.windows.net'
    );
END
GO

-- Step 3: Drop external table if it already exists (idempotent)
IF EXISTS (
    SELECT * FROM sys.external_tables
    WHERE name = 'TBL_covid_worldwide_GZ'
)
BEGIN
    DROP EXTERNAL TABLE dbo.TBL_covid_worldwide_GZ;
END
GO

-- Step 4: Create external table pointing to Gold layer CSV
-- Note: column names match the Silver output schema
CREATE EXTERNAL TABLE dbo.TBL_covid_worldwide_GZ (
    [Country]         NVARCHAR(4000),
    [Total Cases]     FLOAT,
    [Total Deaths]    FLOAT,
    [Total Recovered] FLOAT,
    [Active Cases]    FLOAT,
    [Total Tests]     FLOAT,
    [Population]      FLOAT
)
WITH (
    LOCATION    = 'Gold/covid_worldwide_GZ.csv',
    DATA_SOURCE = ADFS_ExternalSource02,
    FILE_FORMAT = SynapseDelimitedTextFormat
);
GO

-- Step 5: Validate — query top 100 rows ordered by total cases
SELECT TOP 100 *
FROM dbo.TBL_covid_worldwide_GZ
ORDER BY [Total Cases] DESC;
GO
