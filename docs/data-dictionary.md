# 📖 Data Dictionary

Field-level descriptions for all datasets used in this project.

---

## Tokyo 2020 Olympics Datasets

### Athletes.csv

| Column | Type | Description |
|--------|------|-------------|
| `PersonName` | string | Full name of the athlete |
| `Country` | string | Country code (NOC) |
| `Discipline` | string | Sport discipline |

### Teams.csv

| Column | Type | Description |
|--------|------|-------------|
| `TeamName` | string | Name of the team |
| `Discipline` | string | Sport discipline |
| `Country` | string | Country code (NOC) |
| `Event` | string | Event the team participates in |

### Medals.csv

| Column | Type | Description |
|--------|------|-------------|
| `Rank` | integer | Medal ranking position |
| `Team/NOC` | string | Team or National Olympic Committee |
| `Gold` | integer | Number of gold medals |
| `Silver` | integer | Number of silver medals |
| `Bronze` | integer | Number of bronze medals |
| `Total` | integer | Total medals |
| `Rank by Total` | integer | Ranking by total medal count |

### Coaches.csv

| Column | Type | Description |
|--------|------|-------------|
| `Name` | string | Full name of the coach |
| `Country` | string | Country code (NOC) |
| `Discipline` | string | Sport discipline |
| `Event` | string | Specific event coached |

### EntriesGender.csv

| Column | Type | Description |
|--------|------|-------------|
| `Discipline` | string | Sport discipline |
| `Female` | integer | Number of female athletes |
| `Male` | integer | Number of male athletes |
| `Total` | integer | Total athletes in discipline |

---

## COVID-19 Worldwide Dataset

### covid_worldwide_rd.csv (Bronze/Silver)

| Column | Type | Description |
|--------|------|-------------|
| `Country` | string | Country name |
| `Total Cases` | double | Cumulative confirmed cases |
| `Total Deaths` | double | Cumulative deaths |
| `Total Recovered` | double | Cumulative recovered cases |
| `Active Cases` | double | Currently active cases |
| `Total Test` | double | Total tests performed |
| `Population` | double | Country population |

### covid_worldwide_SZ.csv (Silver — cleaned)

Same schema as Bronze with the following changes:
- Column names normalized (spaces removed or replaced with underscores)
- Null values handled
- Data types cast explicitly

### covid_worldwide_GZ.csv (Gold — full enriched dataset)

Same columns as Silver plus two calculated metrics:

| Column | Type | Description |
|--------|------|-------------|
| `percentage of patients death` | float | Total Deaths / Total Cases |
| `recovered by cases` | float | Total Cases − Total Recovered (recovery gap) |

### top_cases_GZ.csv (Gold — aggregated)

| Column | Type | Description |
|--------|------|-------------|
| `Country` | string | Country name |
| `Total Deaths` | float | Top 10 countries by total death count |

### less_cases_GZ.csv (Gold — aggregated)

| Column | Type | Description |
|--------|------|-------------|
| `Country` | string | Country name |
| `Total Deaths` | float | Countries with the lowest death counts |

### percentage_of_death_GZ.csv (Gold — aggregated)

| Column | Type | Description |
|--------|------|-------------|
| `Country` | string | Country name |
| `percentage of patients death` | float | Death rate ranked descending |

### best_recovery_GZ.csv (Gold — aggregated)

| Column | Type | Description |
|--------|------|-------------|
| `Country` | string | Country name |
| `recovered_by_cases` | float | Recovery gap (Total Cases − Total Recovered), ranked descending |

---

## Naming Conventions

| Layer | File pattern | Example |
|-------|-------------|---------|
| LandingZone | `{name}.csv` | `Athletes.csv` |
| Bronze | `{name}_LZ.csv` | `Athletes_LZ.csv` |
| Silver | `{name}_SZ.csv` | `covid_worldwide_SZ.csv` |
| Gold | `{name}_GZ.csv` | `best_recovery_GZ.csv` |
