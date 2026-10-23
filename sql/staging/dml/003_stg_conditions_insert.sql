SELECT count() FROM ehr.stg_conditions;                           -- 3990
SELECT * FROM ehr.stg_conditions LIMIT 5;
SELECT count() FROM ehr.stg_conditions WHERE stop_date IS NULL;   -- сколько активных
SELECT min(start_date), max(start_date) FROM ehr.stg_conditions;  -- 1933?
SELECT count() FROM ehr.stg_conditions c
LEFT JOIN ehr.stg_patients p ON c.patient_id = p.patient_id
WHERE p.patient_id IS NULL;                                       -- 0 (нет сирот)