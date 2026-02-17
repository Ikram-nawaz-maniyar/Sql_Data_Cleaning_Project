📊 SQL Data Cleaning Project – Layoffs Dataset
📌 Project Objective

The goal of this project was to clean and transform a raw layoffs dataset using MySQL.
The dataset contained duplicates, inconsistent formatting, missing values, and incorrect data types.

The cleaning process was divided into 4 major stages:

Finding and Removing Duplicates

Standardizing Data

Handling NULL / Blank Values

Removing Unnecessary Columns

🗂 Initial Dataset
SELECT * 
FROM layoffs_staging;


This table contains the raw uncleaned data.

🔹 Stage 1: Finding and Removing Duplicates
Step 1: Identify Duplicate Rows
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,
location,
industry,
total_laid_off,
percentage_laid_off,
date,
stage,
country,
funds_raised_millions
) AS row_num
FROM layoffs_staging;

🔎 Explanation:

ROW_NUMBER() assigns a number to rows within identical groups.

If row_num > 1, the row is a duplicate.

Step 2: Use CTE to View Duplicates
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,
location,
industry,
total_laid_off,
percentage_laid_off,
date,
stage,
country,
funds_raised_millions
) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;


This displays only duplicate rows.

Step 3: Create New Staging Table
CREATE TABLE layoffs_staging2 (
  company TEXT,
  location TEXT,
  industry TEXT,
  total_laid_off INT DEFAULT NULL,
  percentage_laid_off TEXT,
  date TEXT,
  stage TEXT,
  country TEXT,
  funds_raised_millions INT DEFAULT NULL,
  row_num INT
);


We create a new table to safely remove duplicates.

Step 4: Insert Data with Row Numbers
INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,
location,
industry,
total_laid_off,
percentage_laid_off,
date,
stage,
country,
funds_raised_millions
) AS row_num
FROM layoffs_staging;

Step 5: Delete Duplicate Records
DELETE
FROM layoffs_staging2
WHERE row_num > 1;


Now the dataset is duplicate-free.

🔹 Stage 2: Standardizing Data
Step 1: Trim Extra Spaces
UPDATE layoffs_staging2
SET company = TRIM(company);


Removes leading and trailing spaces.

Step 2: Standardize Industry Values
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';


Ensures consistent industry naming.

Step 3: Clean Country Names
UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';


Removes trailing punctuation from country names.

🔹 Stage 3: Handling NULL and Blank Values
Step 1: Convert Blank Industry to NULL
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';


Ensures proper NULL handling.

Step 2: Fill Missing Industry Using Self Join
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
  ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;


This fills missing industry values using existing company data.

Step 3: Convert Date from Text to Proper Date Format
UPDATE layoffs_staging2
SET date = STR_TO_DATE(date,'%m/%d/%Y');


Converts text date to MySQL date format.

Step 4: Modify Column Data Type to DATE
ALTER TABLE layoffs_staging2
MODIFY COLUMN date DATE;


Ensures correct datatype for analysis.

Step 5: Remove Rows with No Layoff Data
DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


Removes irrelevant records.

🔹 Stage 4: Remove Unnecessary Columns

After cleaning, row_num is no longer needed.

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;


Final cleaned dataset is ready.

✅ Final Output

The dataset now:

✔ Contains no duplicates
✔ Has standardized text fields
✔ Uses proper DATE datatype
✔ Handles NULL values properly
✔ Removes unnecessary helper columns

📈 Future Enhancements

Perform Exploratory Data Analysis (EDA)

Create dashboards in Power BI

Analyze layoff trends by year and country

Identify top affected industries

🎯 Skills Demonstrated

Window Functions

CTEs

Self Joins

Data Cleaning Techniques

Data Type Conversion

SQL Data Transformation

If you want, I can now:

Add an EDA section to make this project stronger

Make it more advanced-level impressive

Or tailor it specifically for data analyst job applications 🚀
