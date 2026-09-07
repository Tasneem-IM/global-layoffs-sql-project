# layoffs-sql-data-cleaning-eda

![SQL](https://img.shields.io/badge/SQL-MySQL-blue) ![Status](https://img.shields.io/badge/status-complete-brightgreen)

SQL project cleaning and analyzing a real-world dataset of global tech layoffs — includes duplicate removal, data standardization, null handling, and exploratory analysis using window functions and CTEs.

## Table of Contents

- [Project Overview](#-project-overview)
- [Dataset](#️-dataset)
- [Tools Used](#️-tools-used)
- [Part 1: Data Cleaning](#-part-1-data-cleaning)
- [Part 2: Exploratory Data Analysis](#-part-2-exploratory-data-analysis-eda)
- [Key Findings](#-key-findings)
- [Repository Structure](#-repository-structure)
- [How to Run](#️-how-to-run)
- [Data Source](#-data-source)
- [License](#-license)

## Project Overview

The raw dataset contained duplicate records, inconsistent text formatting, mixed date formats, and missing values — all common issues in real-world data. This project walks through a full **data cleaning pipeline** followed by an **exploratory data analysis (EDA)** phase, all written in pure SQL (MySQL).

## Dataset

The dataset contains layoff records for companies worldwide, with the following columns:

| Column | Description |
|---|---|
| `company` | Name of the company |
| `location` | City/location of the company |
| `industry` | Industry sector |
| `total_laid_off` | Number of employees laid off |
| `percentage_laid_off` | Percentage of workforce laid off |
| `date` | Date of the layoff event |
| `stage` | Company funding stage |
| `country` | Country of operation |
| `funds_raised_millions` | Total funds raised by the company (in millions) |

##  Tools Used

- **MySQL** — all queries written and tested in MySQL syntax
- Window functions (`ROW_NUMBER`, `DENSE_RANK`, `SUM() OVER`)
- CTEs (Common Table Expressions)
- Self-joins for null-filling logic

##  Part 1: Data Cleaning

Steps performed on a staging copy of the raw table (to keep the original data safe):

1. **Removing Duplicates**
   - Used `ROW_NUMBER()` partitioned across all relevant columns to flag exact duplicate rows
   - Deleted rows where the row number exceeded 1, keeping only unique records

2. **Standardizing the Data**
   - Trimmed extra whitespace from company names
   - Unified inconsistent industry naming (e.g., merged all `Crypto%` variants into a single `Crypto` category)
   - Fixed inconsistent country entries (e.g., trailing periods in `United States.`)
   - Converted the `date` column from text to a proper SQL `DATE` type using `STR_TO_DATE`

3. **Handling Null & Missing Values**
   - Converted blank strings to proper `NULL` values
   - Used a self-join on `company` to fill in missing `industry` values from other rows of the same company where the industry was known

##  Part 2: Exploratory Data Analysis (EDA)

Key questions explored after cleaning the data:

- What is the **maximum single-day layoff count**, and which companies laid off **100% of their workforce**?
- Which **countries** were hit hardest by total layoffs?
- What are the **total layoffs per calendar year**, to identify trends over time?
- What does the **month-by-month rolling (cumulative) total** of layoffs look like?
- Which **top 5 companies had the highest layoffs per year**, using `DENSE_RANK()`?

## 📈 Key Findings

- A number of companies laid off **100% of their staff** — typically startups that shut down entirely rather than downsizing.
- Layoffs were heavily concentrated in specific **countries and industries**, rather than spread evenly.
- The **rolling monthly total** reveals clear acceleration periods, highlighting the most severe waves of layoffs.
- The **top 5 companies per year** shift significantly from one year to the next, reflecting changing economic pressures across industries.

##  Repository Structure

```
layoffs-sql-project/
│
├── README.md
└── sql/
    ├── 01_data_cleaning.sql
    └── 02_exploratory_analysis.sql
```

##  How to Run

1. Import the raw `layoffs` dataset into a MySQL database.
2. Run `01_data_cleaning.sql` to create a staging table and produce a cleaned version of the data.
3. Run `02_exploratory_analysis.sql` against the cleaned table to reproduce the analysis and findings above.




---

Feel free to explore the SQL scripts in the `sql/` folder for the full logic behind each step. Contributions and suggestions are welcome!
