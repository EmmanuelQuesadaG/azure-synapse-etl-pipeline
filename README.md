# 🏅 Azure Synapse ETL Pipeline — Tokyo Olympics & COVID-19

End-to-end ETL pipeline built on **Azure Synapse Analytics** using **Medallion Architecture** (Bronze / Silver / Gold). Ingests, transforms, and serves structured data from two real-world datasets: Tokyo 2020 Olympics and COVID-19 worldwide statistics.

> Built as a portfolio project to demonstrate cloud data engineering skills using Azure-native services.

---

## 🛠️ Tech Stack

![Azure Synapse](https://img.shields.io/badge/Azure%20Synapse%20Analytics-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)
![Azure Data Lake](https://img.shields.io/badge/Azure%20Data%20Lake%20Gen2-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)
![Azure Data Factory](https://img.shields.io/badge/Azure%20Data%20Factory-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)
![Apache Spark](https://img.shields.io/badge/Apache%20Spark-E25A1C?style=for-the-badge&logo=apachespark&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-CC2927?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)

---

## 🎯 Objective

Design and implement a modern cloud data architecture on Microsoft Azure that:

- Ingests raw CSV files into a **Data Lake** (Bronze layer)
- Cleans and standardizes data using **Apache Spark notebooks** (Silver layer)
- Aggregates and serves analytics-ready tables (Gold layer)
- Exposes data via a **Serverless SQL Pool** for querying

---

## 🏗️ Architecture

    ┌─────────────────────────────────────────────────────────────────┐
    │                     Azure Cloud                                  │
    │                                                                  │
    │  ┌──────────────┐    ┌─────────────────────────────────────┐    │
    │  │  Landing Zone │───▶│     Azure Data Lake Storage Gen2    │    │
    │  │  (Raw CSVs)  │    │                                     │    │
    │  └──────────────┘    │  ┌──────────┐ ┌────────┐ ┌──────┐  │    │
    │                      │  │  Bronze  │ │ Silver │ │ Gold │  │    │
    │  ┌──────────────┐    │  │ Raw Data │ │Cleaned │ │Aggre-│  │    │
    │  │ Azure Data   │───▶│  │          │ │  Data  │ │gated │  │    │
    │  │ Factory      │    │  └──────────┘ └────────┘ └──────┘  │    │
    │  │ (Pipelines)  │    └─────────────────────────────────────┘    │
    │  └──────────────┘              │            │                    │
    │                                ▼            ▼                    │
    │                    ┌───────────────────────────────┐            │
    │                    │   Azure Synapse Analytics      │            │
    │                    │   - Spark Pools (Notebooks)    │            │
    │                    │   - Serverless SQL Pool        │            │
    │                    │   - Lake Database (LakeDB)     │            │
    │                    └───────────────────────────────┘            │
    └─────────────────────────────────────────────────────────────────┘

**Medallion Architecture:**

- **Landing Zone** — Raw files uploaded before ingestion
- **Bronze** — Data copied as-is from Landing Zone via ADF pipeline
- **Silver** — Cleaned and standardized via PySpark notebooks
- **Gold** — Aggregated and analytics-ready data
- **LakeDB / SQL Pool** — Queryable external tables on top of Gold layer

---

## 📁 Repository Structure

    azure-synapse-etl-pipeline/
    ├── docs/
    │   ├── architecture.md          → Detailed architecture explanation
    │   ├── data-dictionary.md       → Field descriptions for all datasets
    │   └── setup-guide.md           → Step-by-step Azure infrastructure setup
    ├── pipelines/
    │   ├── pipeline_athletes_lz_to_bz.json
    │   ├── pipeline_teams_lz_to_bz.json
    │   ├── pipeline_medals_lz_to_bz.json
    │   ├── pipeline_coaches_lz_to_bz.json
    │   ├── pipeline_entriesgender_lz_to_bz.json
    │   └── pipeline_covid_lz_to_bz.json
    ├── notebooks/
    │   ├── nbk_covid_BZ_to_SZ.ipynb
    │   └── nbk_covid_SZ_to_GZ.ipynb
    ├── sql/
    │   ├── bronze/
    │   │   └── README.md
    │   ├── silver/
    │   │   └── README.md
    │   └── gold/
    │       ├── SQL_covid_worldwide.sql
    │       └── SQL_best_recovery.sql
    ├── screenshots/
    │   └── README.md
    └── README.md

---

## 📦 Datasets

### Tokyo 2020 Olympics
| File | Description |
|------|-------------|
| `Athletes.csv` | Athlete name, country, discipline |
| `Teams.csv` | Team name, country, discipline, events |
| `Medals.csv` | Gold, silver, bronze count per country |
| `Coaches.csv` | Coach name, country, discipline |
| `EntriesGender.csv` | Male/female athlete count per discipline |

### COVID-19 Worldwide
| File | Description |
|------|-------------|
| `covid_worldwide_rd.csv` | Total cases, deaths, recovered, active by country |

---

## 🔄 Pipeline Flow

### Phase 1 — Infrastructure Setup (Lab 1)
1. Create **Resource Group** (`tokio-olympics-eqg`)
2. Create **Storage Account** with hierarchical namespace (ADLS Gen2)
3. Create container with directories: `LandingZone`, `Bronze`, `Silver`, `Gold`, `Logs`
4. Register providers: `Microsoft.Synapse`, `Microsoft.Sql`, `Microsoft.StreamAnalytics`
5. Deploy **Azure Data Factory** instance
6. Deploy **Azure Synapse Analytics** workspace

### Phase 2 — Data Ingestion via ADF (Lab 2)
1. Upload source CSV files to `LandingZone`
2. Create ADF pipelines: one per dataset (6 total)
3. Each pipeline: **Copy Data** (LZ → Bronze) + **Delete** (cleanup LZ)
4. Configure logging to `Logs` folder
5. Trigger and validate pipeline runs

### Phase 3 — Transformation with Spark (Lab 3)
1. Create **Apache Spark Pool** in Synapse
2. Notebook `nbk_covid_BZ_to_SZ`: Bronze → Silver (clean, standardize)
3. Notebook `nbk_covid_SZ_to_GZ`: Silver → Gold (aggregate, enrich)
4. Create **Lake Database** (`LakeDB`) pointing to Gold layer
5. Create external tables from Gold CSV files
6. Run **Serverless SQL** queries on top of Lake Database

---

## 📊 Results

> Screenshots will be added as the project is executed.

Key outputs:
- `best_recovery_GZ.csv` — Countries ranked by recovery rate
- `covid_worldwide_SZ.csv` — Cleaned COVID dataset
- External tables queryable via SQL serverless pool

---

## 🚀 How to Reproduce

### Prerequisites
- Active Azure subscription (Azure for Students works)
- Access to Azure Portal
- Source CSV files (Tokyo Olympics + COVID datasets)

### Steps
1. Follow `docs/setup-guide.md` to provision all Azure resources
2. Upload CSV files to the `LandingZone` container directory
3. Run the ADF pipelines in order (one per dataset)
4. Open Synapse Studio → run notebooks in order: BZ→SZ, then SZ→GZ
5. Create Lake Database and external tables as described in `docs/architecture.md`
6. Query results using the Serverless SQL Pool

---

## 📚 Learnings

- Configured end-to-end Azure data architecture from scratch on a student subscription
- Designed Medallion Architecture separating raw, clean, and analytical data layers
- Built ADF pipelines with Copy + Delete activities and logging enabled
- Used PySpark in Synapse notebooks for data transformation across layers
- Created external tables in a Lake Database queryable via SQL serverless pool
- Managed resource provider registration and cross-service linked connections

---

## 👤 Author

**Emmanuel Quesada G.**
Data Engineering Student — Universidad Cenfotec
[GitHub](https://github.com/EmmanuelQuesadaG)
