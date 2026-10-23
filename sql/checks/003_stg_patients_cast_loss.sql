SELECT 'birth_date' AS check_name, birth_date_lost AS lost FROM (SELECT
    (SELECT countIf(BIRTHDATE != '') FROM ehr.raw_patients) AS birth_date_raw,
    (SELECT countIf(birth_date IS NOT NULL) FROM ehr.stg_patients) AS birth_date_stg,
    toInt64(birth_date_raw) - toInt64(birth_date_stg) AS birth_date_lost)
UNION ALL
SELECT 'death_date' AS check_name, death_date_lost FROM (SELECT
    (SELECT countIf(DEATHDATE != '') FROM ehr.raw_patients) AS death_date_raw,
    (SELECT countIf(death_date IS NOT NULL) FROM ehr.stg_patients) AS death_date_stg,
    toInt64(death_date_raw) - toInt64(death_date_stg) AS death_date_lost)
UNION ALL
SELECT 'marital_status' AS check_name, marital_lost FROM (SELECT
    (SELECT countIf(MARITAL != '') FROM ehr.raw_patients) AS marital_raw,
    (SELECT countIf(marital_status IS NOT NULL) FROM ehr.stg_patients) AS marital_stg,
    toInt64(marital_raw) - toInt64(marital_stg) AS marital_lost)
UNION ALL
SELECT 'income' AS check_name, income_lost FROM (SELECT
    (SELECT countIf(INCOME != '') FROM ehr.raw_patients) AS income_raw,
    (SELECT countIf(income IS NOT NULL) FROM ehr.stg_patients) AS income_stg,
    toInt64(income_raw) - toInt64(income_stg) AS income_lost)
UNION ALL
SELECT 'healthcare_expenses' AS check_name, healthcare_expenses_lost FROM (SELECT
    (SELECT countIf(HEALTHCARE_EXPENSES != '') FROM ehr.raw_patients) AS healthcare_expenses_raw,
    (SELECT countIf(healthcare_expenses  IS NOT NULL) FROM ehr.stg_patients) AS healthcare_expenses_stg,
    toInt64(healthcare_expenses_raw) - toInt64(healthcare_expenses_stg) AS healthcare_expenses_lost)
UNION ALL
SELECT 'healthcare_coverage' AS check_name, healthcare_coverage_lost FROM (SELECT
    (SELECT countIf(HEALTHCARE_COVERAGE  != '') FROM ehr.raw_patients) AS healthcare_coverage_raw,
    (SELECT countIf(healthcare_coverage  IS NOT NULL) FROM ehr.stg_patients) AS healthcare_coverage_stg,
    toInt64(healthcare_coverage_raw) - toInt64(healthcare_coverage_stg) AS healthcare_coverage_lost);