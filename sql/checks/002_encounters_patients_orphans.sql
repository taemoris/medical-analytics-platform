SELECT count() AS orphans
FROM ehr.raw_encounters e
LEFT JOIN ehr.raw_patients p ON e.PATIENT = p.Id
WHERE p.Id = '';