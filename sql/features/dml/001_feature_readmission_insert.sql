TRUNCATE TABLE ehr.features_readmission;

INSERT INTO ehr.features_readmission
WITH main_features_with_next_start_at AS (
    SELECT
        se.patient_id,
        se.encounter_id,
        se.start_at,
        se.stop_at,
        leadInFrame(se.start_at, 1, se.start_at) OVER (
            PARTITION BY se.patient_id 
            ORDER BY se.start_at ASC
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS next_start_at
    FROM ehr.stg_encounters se
    WHERE se.encounter_class = 'inpatient'
),
main_features_with_readmitted_30d AS (
    SELECT
        f.patient_id,
        f.encounter_id,
        f.start_at,
        f.stop_at,
        if(f.next_start_at > f.stop_at
            AND dateDiff('day', f.stop_at, f.next_start_at) <= 30, 1, 0) AS readmitted_30d
    FROM main_features_with_next_start_at f
),
main_features_with_patient_demography AS (
	SELECT
		f.patient_id,
        f.encounter_id,
        f.start_at,
        f.stop_at,
        dateDiff('year', sp.birth_date, f.start_at) AS age,
        sp.gender,
        sp.race,
        ifNull(sp.marital_status, 'S') AS marital_status,
        f.readmitted_30d
	FROM main_features_with_readmitted_30d f
	JOIN ehr.stg_patients sp
		ON f.patient_id = sp.patient_id
),
main_features_with_aggregation_values_encounters AS (
	SELECT
		f.patient_id,
        f.encounter_id,
        f.start_at,
        f.stop_at,
        f.age,
        f.gender,
        f.race,
        f.marital_status,
        f.readmitted_30d
	FROM main_features_with_patient_demography f
),
encounters_cumulative AS (
	SELECT
		se.patient_id,
		se.encounter_id,
		se.encounter_class,
		se.start_at,
		se.stop_at,
		COUNT(*) OVER (
			PARTITION BY se.patient_id
			ORDER BY se.start_at
			ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
		) AS total_encounters_before,
		countIf(se.encounter_class = 'inpatient') OVER (
			PARTITION BY se.patient_id
			ORDER BY se.start_at
			ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
		) AS inpatient_count_before,
		countIf(se.encounter_class = 'emergency') OVER (
			PARTITION BY se.patient_id
			ORDER BY se.start_at
			ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
		) AS emergency_count_before,
		AVG(dateDiff('minute', se.start_at, se.stop_at)) OVER (
			PARTITION BY se.patient_id
			ORDER BY se.start_at
			ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
		) AS avg_duration_before
	FROM ehr.stg_encounters se
),
conditions_cumulative AS (
	SELECT
		se.patient_id,
		se.start_date,
		COUNT(*) OVER (
			PARTITION BY se.patient_id
			ORDER BY se.start_date
			ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
		) AS total_conditions_before,
		countIf(isNull(se.stop_date) OR (dateDiff('day', se.start_date, se.stop_date) > 90)) OVER (
			PARTITION BY se.patient_id
			ORDER BY se.start_date
			ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
		) AS chronic_conditions_before,
		uniqExact(se.code) OVER (
			PARTITION BY se.patient_id
			ORDER BY se.start_date
			ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
		) AS distinct_conditions_codes_before
	FROM ehr.stg_conditions se
)
SELECT
	f.patient_id,
	f.encounter_id,
	f.start_at,
	f.stop_at,
	f.age,
	f.gender,
	f.race,
	f.marital_status,
	e.total_encounters_before,
	e.inpatient_count_before,
	e.emergency_count_before,
	e.avg_duration_before,
	c.total_conditions_before,
	c.chronic_conditions_before,
	c.distinct_conditions_codes_before,
	f.readmitted_30d
FROM main_features_with_aggregation_values_encounters f
JOIN encounters_cumulative e
ON f.patient_id = e.patient_id AND f.encounter_id = e.encounter_id
ASOF LEFT JOIN conditions_cumulative c
ON f.patient_id = c.patient_id
AND f.start_at >= c.start_date;