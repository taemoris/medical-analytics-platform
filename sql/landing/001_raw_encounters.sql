CREATE TABLE ehr.raw_encounters IF NOT EXISTS (
    Id String,
    START String,
    STOP String,
    PATIENT String,
    ORGANIZATION String,
    PROVIDER String,
    PAYER String,
    ENCOUNTERCLASS String,
    CODE String,
    DESCRIPTION String,
    BASE_ENCOUNTER_COST String,
    TOTAL_CLAIM_COST String,
    PAYER_COVERAGE String,
    REASONCODE String,
    REASONDESCRIPTION String,
    _loaded_at Datetime DEFAULT now(),
    _source_file String DEFAULT 'encounters.csv'
) ENGINE = MergeTree
ORDER BY Id;