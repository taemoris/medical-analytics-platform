CREATE TABLE IF NOT EXISTS ehr.mart_predictions (
    patient_id String,
    encounter_id String,
    risk_score Float32,
    prediction UInt8,
    actual UInt8
) ENGINE = MergeTree
ORDER BY (patient_id, encounter_id);