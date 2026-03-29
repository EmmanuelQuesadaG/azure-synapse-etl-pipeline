-- ============================================================
-- SQL_best_recovery.sql
-- Creates an external table over the Gold layer CSV and
-- queries countries ranked by recovery gap.
--
-- Database:  SQL_covid_ww (Serverless SQL Pool)
-- Source:    Gold/best_recovery_GZ.csv
-- Layer:     Gold
-- ============================================================

-- Step 1: Create external file format (if not exists)
IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseDelimitedTextFormat01')
BEGIN
    CREATE EXTERNAL FILE FORMAT SynapseDelimitedTextFormat01
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
    WHERE name = 'ADFS_ExternalSource01'
)
BEGIN
    CREATE EXTERNAL DATA SOURCE ADFS_ExternalSource01
    WITH (
        LOCATION = 'abfss://datatokioolympicsgps@tokioolympicsgps.dfs.core.windows.net'
    );
END
GO

-- Step 3: Drop external table if it already exists (idempotent)
IF EXISTS (
    SELECT * FROM sys.external_tables
    WHERE name = 'TBL_best_recovery_GZ'
)
BEGIN
    DROP EXTERNAL TABLE dbo.TBL_best_recovery_GZ;
END
GO

-- Step 4: Create external table pointing to Gold layer CSV
CREATE EXTERNAL TABLE dbo.TBL_best_recovery_GZ (
    [Country]              NVARCHAR(4000),
    [recovered_by_cases]   FLOAT
)
WITH (
    LOCATION    = 'Gold/best_recovery_GZ.csv',
    DATA_SOURCE = ADFS_ExternalSource01,
    FILE_FORMAT = SynapseDelimitedTextFormat01
);
GO

-- Step 5: Validate — query top 100 rows
SELECT TOP 100 *
FROM dbo.TBL_best_recovery_GZ
ORDER BY recovered_by_cases DESC;
GO
