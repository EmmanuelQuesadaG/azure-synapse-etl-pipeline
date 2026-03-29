# 🏗️ Architecture — Azure Synapse ETL Pipeline

## Overview

This project implements a **Medallion Architecture** on Microsoft Azure, using a combination of Azure Data Factory for ingestion orchestration, Azure Data Lake Storage Gen2 as the storage backbone, Apache Spark for transformation, and Azure Synapse Analytics as the unified analytics platform.

---

## Azure Services Used

| Service | Role |
|---|---|
| **Azure Data Lake Storage Gen2** | Central storage with hierarchical namespace. Holds all layers. |
| **Azure Data Factory (ADF)** | Orchestrates data movement from Landing Zone to Bronze layer. |
| **Azure Synapse Analytics** | Workspace hosting Spark pools, notebooks, and SQL pool. |
| **Apache Spark Pool** | Executes PySpark notebooks for Bronze→Silver and Silver→Gold transformations. |
| **Serverless SQL Pool** | Enables SQL querying over Gold layer files without a dedicated database engine. |
| **Lake Database (LakeDB)** | Logical database created in Synapse pointing to Gold CSV files as external tables. |

---

## Storage Container Structure

The storage container `datatokioolympicsgps` is organized as follows:

    datatokioolympicsgps/
    ├── LandingZone/     ← Raw files uploaded here before ingestion
    ├── Bronze/          ← Raw files copied as-is from LandingZone
    ├── Silver/          ← Cleaned and standardized files (post-Spark)
    ├── Gold/            ← Aggregated and analytics-ready files
    └── Logs/            ← ADF pipeline execution logs

---

## Layer Definitions

### Bronze — Raw Ingestion
- Data is copied directly from the LandingZone without modification
- Preserves the original file schema and content
- Serves as the source of truth and recovery point
- Populated by **ADF Copy Data** activities

### Silver — Cleaned Data
- Data is read from Bronze using PySpark in Synapse notebooks
- Operations: null handling, type casting, column renaming, deduplication
- Output files written back to the Silver folder in ADLS Gen2
- Populated by **nbk_covid_BZ_to_SZ**

### Gold — Analytical Layer
- Data is aggregated and enriched from Silver using PySpark
- Optimized for analytical queries (grouped, sorted, filtered)
- Output files are the source for the Lake Database external tables
- Populated by **nbk_covid_SZ_to_GZ**

---

## Data Flow Diagram

    [Source CSVs]
         │
         ▼
    [LandingZone] ──── ADF Pipeline ────▶ [Bronze]
                        Copy Data                │
                        + Delete LZ              │
                                                 ▼
                                         [Spark Notebook]
                                         nbk_covid_BZ_to_SZ
                                                 │
                                                 ▼
                                            [Silver]
                                                 │
                                                 ▼
                                         [Spark Notebook]
                                         nbk_covid_SZ_to_GZ
                                                 │
                                                 ▼
                                             [Gold]
                                                 │
                                                 ▼
                                    [Lake Database — LakeDB]
                                    External tables over Gold
                                                 │
                                                 ▼
                                    [Serverless SQL Pool]
                                    Queryable via T-SQL

---

## ADF Pipelines — Design Pattern

Each pipeline follows the same pattern:

    [Copy Data Activity]  ──on success──▶  [Delete Activity]
    Source: LandingZone/file.csv           Source: LandingZone/file.csv
    Sink:   Bronze/file_LZ.csv             Cleans up LandingZone after copy

Logging is enabled on both activities, writing to `datatokioolympicsgps/Logs`.

**Linked Services used:**
- `ADLSext` — Connected to source (LandingZone reads)
- `ADLSLoad` — Connected to sink (Bronze writes)
- `ADLSLog` — Connected to logging folder

---

## Spark Pool Configuration

| Parameter | Value |
|---|---|
| Pool name | `sparkpool` |
| Node family | Memory optimized |
| Node size | Small (4 vCores, 28 GB RAM) |
| Auto-scale | Enabled |
| Min nodes | 3 |

> Note: Memory optimized is the only family available under the Azure for Students subscription.

---

## Lake Database (LakeDB)

The Lake Database is a logical Synapse construct that maps external table definitions to Gold-layer CSV files in ADLS Gen2.

**External tables created:**
- `TBL_best_recovery_GZ` → `datatokioolympicsgps/Gold/best_recovery_GZ.csv`
- `TBL_covid_worldwide_GZ` → `datatokioolympicsgps/Gold/covid_worldwide_GZ.csv`

Column names were normalized on creation (e.g., `recovered by cases` → `recovered_by_cases`).

---

## SQL Serverless Pool

Database name: `SQL_covid_ww` (Serverless, no dedicated compute)

Two SQL scripts were created to query the Lake Database:
- `SQL_covid_worldwide` — Full COVID dataset via external file format
- `SQL_best_recovery` — Best recovery rate per country

Both use `CREATE EXTERNAL TABLE` with `OPENROWSET` against the Gold layer ABFSS paths.
