📊 SQL Data Cleaning Project – Layoffs Dataset
📌 Project Overview

This project focuses on cleaning and preparing a real-world layoffs dataset using MySQL.
The raw data contained duplicates, inconsistent formatting, incorrect data types, and missing values.
The goal was to transform the dataset into a clean, analysis-ready table.

🛠 Tools & Technologies

MySQL

SQL Window Functions

Common Table Expressions (CTEs)

Joins & Self-Joins

Data Type Conversion

📂 Dataset Information

Original Table: layoffs_staging

Cleaned Table: layoffs_staging2

Data Includes:

Company

Location

Industry

Total Layoffs

Percentage Laid Off

Date

Company Stage

Country

Funds Raised

🔄 Data Cleaning Process
🔹 Stage 1: Finding and Removing Duplicates

Used ROW_NUMBER() window function to identify duplicate rows.

Partitioned data based on all major columns.

Created a new staging table to safely remove duplicates.

Deleted records where row_num > 1.

Result: Only unique records retained.

🔹 Stage 2: Standardizing Data

Removed leading and trailing spaces from company names.

Standardized industry values (e.g., Crypto-related values).

Cleaned country names by removing trailing punctuation.

Ensured consistent text formatting across columns.

Result: Clean and consistent categorical data.

🔹 Stage 3: Handling NULL and Blank Values

Converted blank values into proper NULLs.

Filled missing industry values using self-join logic based on company name.

Converted date column from text format to DATE datatype.

Removed rows where both layoff metrics were missing.

Result: Improved data completeness and reliability.

🔹 Stage 4: Removing Unnecessary Columns

Dropped the temporary row_num column after deduplication.

Result: Optimized final table structure.

✅ Final Outcome

Duplicates removed

Text fields standardized

Date column converted to proper DATE datatype

Missing values handled logically

Dataset ready for analysis and visualization

📈 Skills Demonstrated

Data Cleaning & Preparation

SQL Window Functions

CTEs

Self-Joins

Data Standardization

NULL Handling

Table Optimization

🚀 Next Steps

Perform Exploratory Data Analysis (EDA)

Create dashboards using Power BI or Tableau

Identify layoff trends by year, industry, and country

📌 Author

Maniyar Ikram
Aspiring Data Analyst

If you want, I can also:

Add EDA queries section

Make it ATS-optimized for recruiters

Create a Power BI dashboard outline

Shorten this for GitHub portfolio landing page

Just tell me 👍

I prefer this response
