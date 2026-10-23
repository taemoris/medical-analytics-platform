CREATE TABLE IF NOT EXISTS ehr.stg_conditions (
	start_date   Date32,
	stop_date    Nullable(Date32),
	patient_id   String,
	encounter_id String,
	code         String,
	description  String
) ENGINE = MergeTree
ORDER BY (start_date, patient_id, encounter_id);