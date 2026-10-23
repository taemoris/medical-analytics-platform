SELECT count() AS rows_stg, uniqExact(patient_id) AS unique_ids FROM ehr.stg_patients;

SELECT
    (SELECT min(toDate32(BIRTHDATE)) FROM ehr.raw_patients) AS min_birth_raw,
    (SELECT min(birth_date) FROM ehr.stg_patients) AS min_birth_stg,
    (SELECT sum(toFloat64OrNull(INCOME)) FROM ehr.raw_patients) AS income_sum_raw,
    (SELECT sum(income) FROM ehr.stg_patients) AS income_sum_stg;