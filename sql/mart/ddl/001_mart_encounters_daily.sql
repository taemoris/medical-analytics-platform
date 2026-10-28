CREATE TABLE IF NOT EXISTS mart_encounters_daily (
    `date`               Date,
    encounter_class      LowCardinality(String),
    encounter_count      UInt32,
    avg_duration_minutes Float32,
    total_cost           Decimal(12, 2),
    avg_cost             Decimal(12, 2)
) ENGINE = MergeTree
ORDER BY (`date`, encounter_class);