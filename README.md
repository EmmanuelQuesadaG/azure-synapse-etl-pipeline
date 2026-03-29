# 🔄 Azure Synapse ETL Pipeline

ETL pipeline built with Azure Synapse Analytics using Medallion Architecture (Bronze/Silver/Gold)
---

## 🎯 Objective

Build an end-to-end ETL pipeline that ingests raw data, applies transformations, and delivers a clean analytical layer using Azure cloud services.

---

## 🛠️ Tech Stack

![Azure Synapse](https://img.shields.io/badge/Azure%20Synapse-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)
![Azure Data Lake](https://img.shields.io/badge/Azure%20Data%20Lake-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-CC2927?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)

---

## 🏗️ Architecture

> Diagram coming soon

**Medallion Architecture:**
- **Bronze** — Raw data ingested as-is from the source
- **Silver** — Cleaned and standardized data
- **Gold** — Aggregated and ready for analysis

---

## 📁 Repository Structure
```
azure-synapse-etl-pipeline/
├── docs/               → Architecture and data dictionary
├── sql/
│   ├── bronze/         → Raw ingestion scripts
│   ├── silver/         → Transformation scripts
│   └── gold/           → Analytical layer scripts
├── pipelines/          → Exported Synapse pipeline definitions
├── screenshots/        → Visual evidence of the project
└── README.md
```

---

## 🔄 Pipeline Steps

1. Ingest raw data into Bronze layer
2. Clean and transform into Silver layer
3. Aggregate into Gold layer
4. Orchestrate with Synapse Pipeline

---

## 📊 Results

> Screenshots and metrics coming soon

---

## 📚 Learnings

> To be updated as the project progresses
