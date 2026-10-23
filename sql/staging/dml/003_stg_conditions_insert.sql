TRUNCATE TABLE ehr.stg_conditions;

INSERT INTO ehr.stg_conditions (
    start_date, stop_date, patient_id, encounter_id, code, description
)
SELECT
    toDate32(rc.`START`)            AS start_date,
    toDate32OrNull(rc.`STOP`)       AS stop_date,
    rc.`PATIENT`                    AS patient_id,
    rc.`ENCOUNTER`                  AS encounter_id,
    rc.`CODE`                       AS code,
    rc.`DESCRIPTION`                AS description
FROM ehr.raw_conditions AS rc;