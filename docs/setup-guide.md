# 🚀 Setup Guide — Azure Infrastructure

Step-by-step guide to recreate the Azure infrastructure used in this project. Designed for an Azure for Students subscription.

---

## Step 1 — Create Resource Group

1. Log in to [portal.azure.com](https://portal.azure.com)
2. Search for **"Resource groups"** → click **Create**
3. Fill in:
   - **Subscription:** Azure for Students
   - **Resource group name:** `tokio-olympics-eqg` (use your own initials)
   - **Region:** East US
4. Click **Review + create** → **Create**

---

## Step 2 — Create Storage Account (ADLS Gen2)

1. Search for **"Storage accounts"** → click **Create**
2. Fill in:
   - **Resource group:** `tokio-olympics-eqg`
   - **Storage account name:** `tokioolympicseqg` (no dashes, same as resource group)
   - **Region:** East US
   - **Performance:** Standard
   - **Redundancy:** LRS (Locally Redundant)
3. Go to **Advanced** tab → enable **Hierarchical namespace**
4. Click **Review + create** → **Create**
5. Go to the resource → **Containers** → **+ Container**
   - Name: `datatokioolympicseqg`
6. Enter the container → **Add directory** — create these 5:
   - `LandingZone`
   - `Bronze`
   - `Silver`
   - `Gold`
   - `Logs`

---

## Step 3 — Register Resource Providers

This step is required to avoid deployment errors with Synapse.

1. Go to **Subscriptions** → select **Azure for Students**
2. Left menu → **Settings** → **Resource providers**
3. Search and **Register** each of these:
   - `Microsoft.Synapse`
   - `Microsoft.Sql`
   - `Microsoft.StreamAnalytics`

---

## Step 4 — Create Azure Data Factory

1. Search for **"Data factories"** → click **Create**
2. Fill in:
   - **Resource group:** `tokio-olympics-eqg`
   - **Name:** `adftokioolympicseqg`
   - **Region:** East US
   - **Version:** V2
3. Click **Review + create** → **Create**
4. Go to the resource → **Launch Studio** (explore but no config needed at this stage)

---

## Step 5 — Create Azure Synapse Analytics Workspace

1. Search for **"Azure Synapse Analytics"** → click **Create**
2. Fill in:
   - **Resource group:** `tokio-olympics-eqg`
   - **Workspace name:** `syntokioolympicseqg`
   - **Region:** East US 2 (important: use East US 2 here)
   - **Select Data Lake Storage Gen2:** From subscription
   - **Account name:** `tokioolympicseqg`
   - **File system name:** `datatokioolympicseqg`
3. Go to **Security** tab → set an SQL admin password
4. Click **Review + create** → **Create**

> If you get a deployment error, verify that `Microsoft.Sql` and `Microsoft.StreamAnalytics` are registered (Step 3) and retry.

---

## Step 6 — Create Apache Spark Pool

1. Open your Synapse workspace → click **Open Synapse Studio**
2. Left menu → **Manage** → **Apache Spark pools** → **+ New**
3. Fill in:
   - **Name:** `sparkpool`
   - **Node family:** Memory optimized
   - **Node size:** Small (4 vCores / 28 GB)
   - **Auto-scale:** Enabled
   - **Min/Max nodes:** 3 / 10
4. Click **Review + create** → **Create**

---

## Step 7 — Upload Source Files

1. In Synapse Studio → **Data** tab → **Linked** → expand your storage → `LandingZone`
2. Click **Upload** → select all source CSV files:
   - `Athletes.csv`
   - `Teams.csv`
   - `Medals.csv`
   - `Coaches.csv`
   - `EntriesGender.csv`
   - `covid_worldwide_rd.csv`

---

## Step 8 — Create ADF Pipelines

See the `pipelines/` folder for the JSON definitions of each pipeline.

Each pipeline follows this pattern:
- **Copy Data** activity: reads from `LandingZone`, writes to `Bronze`
- **Delete** activity: removes the file from `LandingZone` after successful copy
- **Logging** enabled to `Logs/` folder

Linked services required:
- `ADLSext` — Source linked service (LandingZone reads)
- `ADLSLoad` — Sink linked service (Bronze writes)
- `ADLSLog` — Logging linked service

---

## Step 9 — Run Spark Notebooks

1. In Synapse Studio → **Develop** → **+** → **Notebook**
2. Attach to `sparkpool`
3. Import or paste code from `notebooks/` folder
4. Run in order:
   - `nbk_covid_BZ_to_SZ` — Bronze to Silver
   - `nbk_covid_SZ_to_GZ` — Silver to Gold
5. Update the ABFSS path in each notebook to match your storage account name

---

## Step 10 — Create Lake Database and SQL Pool

1. In Synapse Studio → **Data** → **Workspace** → **+** → **Lake database**
   - Name: `LakeDB`
   - Linked service: `ADLSLoad`
   - Input folder: `datatokioolympicseqg/Gold`
2. Add external tables from Gold CSV files (see `docs/architecture.md`)
3. Create SQL database (Serverless): `SQL_covid_ww`
4. Run SQL scripts from `sql/gold/` folder

---

## Notes

- All resource names should use your own initials to avoid naming conflicts
- The Azure for Students subscription has limits on cores — use Small node sizes
- Always **Publish all** in Synapse Studio before closing a session
