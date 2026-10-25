CREATE TABLE IF NOT EXISTS ehr.features_readmission (
    patient_id String,
    encounter_id String,
    start_at DateTime,
    stop_at DateTime,
    age UInt8,
    gender LowCardinality(String),
    race LowCardinality(String),
    marital_status LowCardinality(String),
    total_encounters_before Int32,
    inpatient_count_before Int32,   
    emergency_count_before Int32,
    avg_duration_before Float32,
    total_conditions_before Int32,
    chronic_conditions_before Int32,
    distinct_conditions_codes_before UInt8,
    readmitted_30d UInt8
) ENGINE = MergeTree
ORDER BY (start_at, patient_id)