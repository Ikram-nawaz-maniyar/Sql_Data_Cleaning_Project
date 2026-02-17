/* ============================================================
   📊 PROJECT: SQL DATA CLEANING – LAYOFFS DATASET
   ============================================================
   👤 Author: Your Name
   🛠 Tool: MySQL
   🎯 Objective:
      Transform raw layoffs data into a clean,
      analysis-ready dataset using SQL.
   ============================================================ */



/* ============================================================
   🟢 STAGE 0: UNDERSTANDING THE RAW DATA
   ============================================================ */

-- Preview raw dataset

SELECT *
FROM layoffs_staging;



/* ============================================================
   🔵 STAGE 1: FINDING & REMOVING DUPLICATES
   ============================================================ */

-- Step 1.1: Create a staging table (to preserve raw data)

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


-- Step 1.2: Insert data with ROW_NUMBER()
-- This helps identify duplicate rows

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


-- Step 1.3: Verify duplicate records

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;


-- Step 1.4: Remove duplicates
-- Keep only the first occurrence (row_num = 1)

DELETE
FROM layoffs_staging2
WHERE row_num > 1;



/* ============================================================
   🟡 STAGE 2: STANDARDIZING DATA
   ============================================================ */

-- Step 2.1: Trim leading & trailing spaces from company names

UPDATE layoffs_staging2
SET company = TRIM(company);


-- Step 2.2: Standardize industry values
-- Example: Crypto Web3, Cryptocurrency → Crypto

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';


-- Step 2.3: Clean country names
-- Remove trailing period (United States.)

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';


-- Step 2.4: Review cleaned categorical columns

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY industry;

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY country;



/* ============================================================
   🟠 STAGE 3: HANDLING NULL & BLANK VALUES
   ============================================================ */

-- Step 3.1: Convert blank industry values to NULL

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';


-- Step 3.2: Fill missing industry using Self-Join
-- If same company has valid industry elsewhere,
-- use that value to fill NULLs

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
     ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;


-- Step 3.3: Convert date column from TEXT to DATE

UPDATE layoffs_staging2
SET date = STR_TO_DATE(date, '%m/%d/%Y');


-- Step 3.4: Modify column datatype to DATE

ALTER TABLE layoffs_staging2
MODIFY COLUMN date DATE;


-- Step 3.5: Identify rows with no layoff data

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


-- Step 3.6: Remove rows with no useful layoff information

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;



/* ============================================================
   🔴 STAGE 4: REMOVE UNNECESSARY COLUMNS
   ============================================================ */

-- Step 4.1: Drop helper column used for duplicate detection

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;



/* ============================================================
   🟣 FINAL CLEANED DATASET
   ============================================================ */

-- Preview final cleaned data

SELECT *
FROM layoffs_staging2;



/* ============================================================
   ✅ CLEANING SUMMARY
   ============================================================
   ✔ Removed duplicate records using ROW_NUMBER()
   ✔ Standardized text fields (industry, country)
   ✔ Trimmed whitespace inconsistencies
   ✔ Converted date from TEXT to DATE datatype
   ✔ Handled NULL and blank values properly
   ✔ Removed irrelevant records
   ✔ Dropped temporary helper column

   📊 Dataset is now ready for:
      - Exploratory Data Analysis (EDA)
      - Dashboarding (Power BI / Tableau)
      - Business Insights
   ============================================================ */
