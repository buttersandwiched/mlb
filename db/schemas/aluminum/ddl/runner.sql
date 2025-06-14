DROP TABLE IF EXISTS baseball_aluminum.runner;
CREATE TABLE baseball_aluminum.runner
(
    "runnerPk"              SERIAL PRIMARY KEY,
    "gamePk"                INT,
    "runnerId"              INT,
    "pitcherId"             INT,
    "responsiblePitcherId"  INT,
    "postOnFirstId"         INT,
    "postOnSecondId"        INT,
    "postOnThirdId"         INT,
    "atBatId"               INT,
    "batterPlayId"          INT,
    "event"                 TEXT,
    "eventType"             TEXT,
    "movementReason"        TEXT,
    "originBase"            TEXT,
    "startBase"             TEXT,
    "endBase"               TEXT,
    "outBase"               TEXT,
    "outNumber"             INT,
    "isStolenBase"          BOOLEAN,
    "isCaughtStealing"      BOOLEAN,
    "isOut"                 BOOLEAN,
    "isRBI"                 BOOLEAN,
    "isEarnedRun"           BOOLEAN,
    "isUnearnedRun"         BOOLEAN,
    "_createdAt"            TIMESTAMP
    );