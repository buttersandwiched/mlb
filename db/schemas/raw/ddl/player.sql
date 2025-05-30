-------------------------------------------------------------------------------------------------------
--Table:          player
-------------------------------------------------------------------------------------------------------
--Description:    The `baseball_raw.player' table gives bios of all mlb players
-------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS baseball_raw.player;
CREATE TABLE IF NOT EXISTS baseball_raw.player
(
    "id"                    INT,
    "teamId"                INT,
    "fullName"              VARCHAR,
    "link"                  VARCHAR,
    "firstName"             VARCHAR,
    "lastName"              VARCHAR,
    "primaryNumber"         INT,
    "birthDate"             DATE,
    "currentAge"            INT,
    "birthCity"             VARCHAR,
    "birthStateProvince"    VARCHAR,
    "birthCountry"          VARCHAR,
    "height"                VARCHAR,
    "weight"                INT,
    "active"                BOOLEAN,
    "primaryPosition"       JSON,
    "useName"               VARCHAR,
    "useLastName"           VARCHAR,
    "middleName"            VARCHAR,
    "boxscoreName"          VARCHAR,
    "nickName"              VARCHAR,
    "nameTitle"             VARCHAR,
    "nameSuffix"            VARCHAR,
    "nameMatrilineal"       VARCHAR,
    "gender"                VARCHAR,
    "isPlayer"              BOOLEAN,
    "isVerified"            BOOLEAN,
    "draftYear"             INT,
    "pronunciation"         VARCHAR,
    "mlbDebutDate"          DATE,
    "batSide"               JSON,
    "pitchHand"             JSON,
    "nameFirstLast"         VARCHAR,
    "nameSlug"              VARCHAR,
    "firstLastName"         VARCHAR,
    "lastFirstName"         VARCHAR,
    "lastInitName"          VARCHAR,
    "initLastName"          VARCHAR,
    "fullFMLName"           VARCHAR,
    "fullLFMName"           VARCHAR,
    "strikeZoneTop"         NUMERIC(3,2),
    "strikeZoneBottom"      NUMERIC(3,2),
    "_createdAt"          TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- time the record was loaded into the db
);

SELECT *
FROM baseball_raw.schedule;

INSERT INTO baseball_raw.player
SELECT *
FROM baseball_raw.players