CREATE TABLE IF NOT EXISTS ehr.stg_patients (
	patient_id          String,
	birth_date          Nullable(Date32),
	death_date          Nullable(Date32),
	marital_status      LowCardinality(Nullable(String)),
	race                LowCardinality(String),
	ethnicity           LowCardinality(String),
	gender              LowCardinality(String),
	county              String,
	healthcare_expenses Nullable(Decimal(12, 2)),
	healthcare_coverage Nullable(Decimal(12, 2)),
	income              Nullable(Decimal(12, 2))
) ENGINE = MergeTree
ORDER BY patient_id;