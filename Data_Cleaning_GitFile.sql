/* =====================================================
   SQL DATA CLEANING PROJECT – LAYOFFS DATASET
   ===================================================== */

-- =====================================================
-- STAGE 0: VIEW RAW DATA
-- =====================================================

SELECT *
FROM layoffs_staging;



-- =====================================================
-- STAGE 1: FINDING & REMOVING DUPLICATES
-- =====================================================

-- Step 1: Create a new staging table to preserve raw data

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


-- Step 2: Insert data with ROW_NUMBER to identify duplicates

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


-- Step 3: Delete duplicate rows (keep only row_num = 1)

DELETE
FROM layoffs_staging2
WHERE row_num > 1;



-- =====================================================
-- STAGE 2: STANDARDIZING DATA
-- =====================================================

-- Step 1: Trim extra spaces from company names

UPDATE layoffs_staging2
SET company = TRIM(company);


-- Step 2: Standardize industry values

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';


-- Step 3: Remove trailing period from country names

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';



-- =====================================================
-- STAGE 3: HANDLING NULL / BLANK VALUES
-- =====================================================

-- Step 1: Convert blank industry values to NULL

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';


-- Step 2: Fill missing industry using self-join

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
    ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;


-- Step 3: Convert date from TEXT to proper DATE format

UPDATE layoffs_staging2
SET date = STR_TO_DATE(date, '%m/%d/%Y');


-- Step 4: Change column datatype to DATE

ALTER TABLE layoffs_staging2
MODIFY COLUMN date DATE;


-- Step 5: Remove rows where both layoff fields are NULL

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;



-- =====================================================
-- STAGE 4: REMOVE UNNECESSARY COLUMNS
-- =====================================================

-- Drop helper column used for duplicate detection

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;



-- =====================================================
-- FINAL CLEANED DATA
-- =====================================================

SELECT *
FROM layoffs_staging2;
