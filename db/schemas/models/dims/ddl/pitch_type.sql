/*
    Use Case: drop and rebuild
 */
DROP TABLE IF EXISTS baseball_models."pitchType";

CREATE TABLE IF NOT EXISTS baseball_models."pitchType"
(
    "pitchTypeId"           SERIAL PRIMARY KEY,
    "pitchTypeCode"         VARCHAR,
    "pitchTypeDescription"  VARCHAR,
    "createdAt"             TIMESTAMP,
    "createdBy"             VARCHAR
)