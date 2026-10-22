TRUNCATE TABLE ehr.stg_encounters;

INSERT INTO ehr.stg_encounters(
    encounter_id,
    start_at,
    stop_at,
    patient_id,
    organization_id,
    provider_id,
    payer_id,
    encounter_class,
    code,
    description,
    base_encounter_cost,
    total_claim_cost,
    payer_coverage,
    reason_code,
    reason_description
)
SELECT
    re.`Id`                                         AS encounter_id,
    parseDateTimeOrZero(re.`START`, '%Y-%m-%dT%H:%i:%SZ', 'UTC') AS start_at,
    parseDateTimeOrZero(re.`STOP`,  '%Y-%m-%dT%H:%i:%SZ', 'UTC') AS stop_at,
    re.`PATIENT`                                    AS patient_id,
    re.`ORGANIZATION`                               AS organization_id,
    re.`PROVIDER`                                   AS provider_id,
    re.`PAYER`                                      AS payer_id,
    lower(re.`ENCOUNTERCLASS`)                      AS encounter_class,
    re.`CODE`                                       AS code,
    re.`DESCRIPTION`                                AS description,
    toDecimal64OrZero(re.`BASE_ENCOUNTER_COST`, 2)  AS base_encounter_cost,
    toDecimal64OrZero(re.`TOTAL_CLAIM_COST`, 2)     AS total_claim_cost,
    toDecimal64OrZero(re.`PAYER_COVERAGE`, 2)       AS payer_coverage,
    nullIf(re.`REASONCODE`, '')                     AS reason_code,
    nullIf(re.`REASONDESCRIPTION`, '')              AS reason_description
FROM ehr.raw_encounters AS re;