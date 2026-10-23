TRUNCATE TABLE ehr.stg_patients;

INSERT INTO ehr.stg_patients(
	patient_id,
	birth_date,
	death_date,
	marital_status,
	race,
	ethnicity,
	gender,
	county,
	healthcare_expenses,
	healthcare_coverage,
	income
)
SELECT
	rp.`Id` AS patient_id,
	toDate32OrNull(rp.`BIRTHDATE`)                 AS birth_date,
	toDate32OrNull(rp.`DEATHDATE`)                 AS death_date,
	NULLIF(rp.`MARITAL`, '')                       AS marital_status,
	rp.`RACE`                                      AS race,
	rp.`ETHNICITY`                                 AS ethnicity,
	rp.`GENDER`                                    AS gender,
	rp.`COUNTY`                                    AS county,
	toDecimal64OrNull(rp.`HEALTHCARE_EXPENSES`, 2) AS healthcare_expenses,
	toDecimal64OrNull(rp.`HEALTHCARE_COVERAGE`, 2) AS healthcare_coverage,
	toDecimal64OrNull(rp.`INCOME`, 2)              AS income
FROM ehr.raw_patients rp;