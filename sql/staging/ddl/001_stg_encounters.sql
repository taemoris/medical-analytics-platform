CREATE TABLE IF NOT EXISTS ehr.stg_encounters (
    encounter_id        String,
    start_at            DateTime('UTC'),
    stop_at             DateTime('UTC'),
    patient_id          String,
    organization_id     String,
    provider_id         String,
    payer_id            String,
    encounter_class     LowCardinality(String),
    code                String,
    description         String,
    base_encounter_cost Decimal(12, 2),
    total_claim_cost    Decimal(12, 2),
    payer_coverage      Decimal(12, 2),
    reason_code         Nullable(String),
    reason_description  Nullable(String)
) ENGINE = MergeTree
ORDER BY (toDate(start_at), encounter_id);