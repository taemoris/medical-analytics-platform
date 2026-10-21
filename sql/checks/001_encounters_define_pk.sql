SELECT count() AS total,
       uniqExact(Id) AS unique_ids,
       countIf(Id = '') AS empty_ids
FROM ehr.raw_encounters;