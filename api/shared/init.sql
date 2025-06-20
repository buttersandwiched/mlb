-------------------------------------------------------------------------------------------------------
-- USAGE:           To Initialize Database, tables and views to feed mlb-fantasy app
--                  Once completed, execute get_mlb_data.py to populate the tables
-------------------------------------------------------------------------------------------------------

CREATE SCHEMA IF NOT EXISTS baseball_raw;
CREATE SCHEMA IF NOT EXISTS baseball_aluminum;
CREATE SCHEMA IF NOT EXISTS baseball_platinum;
CREATE SCHEMA IF NOT EXISTS baseball_models;

-------------------------------------------------------------------------------------------------------
--Schema:           baseball_raw
--Description:      stores raw data from source (API)
-------------------------------------------------------------------------------------------------------
CREATE SCHEMA IF NOT EXISTS baseball_raw;
-------------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------------
--Table:          teams
-------------------------------------------------------------------------------------------------------
--Description:    The `baseball_raw.teams` table provides details about baseball teams, including
--                their identifiers, names, league and division affiliations, venue information,
--                abbreviations, and other metadata related to their franchise and operational details.
-------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS baseball_raw.team;
CREATE TABLE IF NOT EXISTS baseball_raw.team
(
    id                          INT, -- Unique identifier for the team
    "springLeague"              JSON, -- Represents the spring training league the team belongs to (e.g., Grapefruit League, Cactus League)
    "allStarStatus"             VARCHAR, -- Indicates the all-star status of the team (e.g., if the team is part of an all-star game setup)
    name                        VARCHAR, -- Official name of the team
    link                        VARCHAR, -- URL or link to more information about the team
    season                      INT, -- The season associated with this team entry
    venue                       JSON, -- Identifier for the venue associated with the team
    "springVenue"               JSON, -- Identifier for the team's spring training venue
    "teamCode"                  VARCHAR, -- Unique code used to represent the team
    "fileCode"                  VARCHAR, -- Code used internally for file or system references
    abbreviation                VARCHAR, -- Shortened abbreviation of the team's name
    "teamName"                  VARCHAR, -- Team name without additional prefixes or suffixes
    "locationName"              VARCHAR, -- Geographic location associated with the team
    "firstYearOfPlay"           INT, -- The first year the team played in the league
    league                      JSON, -- Identifier for the league the team belongs to (e.g., American or National League)
    division                    JSON, -- Division to which the team is affiliated (e.g., East, West, Central)
    sport                       JSON, -- Sport the team is associated with (e.g., baseball)
    "shortName"                 VARCHAR, -- Shortened version of the team's name
    "franchiseName"             VARCHAR, -- The team's franchise name (e.g., Yankees, Red Sox)
    "clubName"                  VARCHAR, -- Club name associated with the team
    active                      BOOLEAN,  -- Indicates whether the team is currently active
    "createdAt"                 TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- time the record was loaded into the db
);

-------------------------------------------------------------------------------------------------------
--Table:          player
-------------------------------------------------------------------------------------------------------
--Description:    The `baseball_raw.player' table gives bios of all mlb players
-------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS baseball_raw.player;
CREATE TABLE IF NOT EXISTS baseball_raw.player
(
    "id"                        INT,
    "teamId"                    INT,
    "fullName"                  VARCHAR,
    "link"                      VARCHAR,
    "firstName"                 VARCHAR,
    "lastName"                  VARCHAR,
    "primaryNumber"             INT,
    "birthDate"                 DATE,
    "currentAge"                INT,
    "birthCity"                 VARCHAR,
    "birthStateProvince"        VARCHAR,
    "birthCountry"              VARCHAR,
    "height"                    VARCHAR,
    "weight"                    INT,
    "active"                    BOOLEAN,
    "primaryPosition"           JSON,
    "useName"                   VARCHAR,
    "useLastName"               VARCHAR,
    "middleName"                VARCHAR,
    "boxscoreName"              VARCHAR,
    "nickName"                  VARCHAR,
    "nameTitle"                 VARCHAR,
    "nameSuffix"                VARCHAR,
    "nameMatrilineal"           VARCHAR,
    "gender"                    VARCHAR,
    "isPlayer"                  BOOLEAN,
    "isVerified"                BOOLEAN,
    "draftYear"                 INT,
    "pronunciation"             VARCHAR,
    "mlbDebutDate"              DATE,
    "batSide"                   JSON,
    "pitchHand"                 JSON,
    "nameFirstLast"             VARCHAR,
    "nameSlug"                  VARCHAR,
    "firstLastName"             VARCHAR,
    "lastFirstName"             VARCHAR,
    "lastInitName"              VARCHAR,
    "initLastName"              VARCHAR,
    "fullFMLName"               VARCHAR,
    "fullLFMName"               VARCHAR,
    "strikeZoneTop"             NUMERIC(3,2),
    "strikeZoneBottom"          NUMERIC(3,2),
    "_createdAt"                TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- time the record was loaded into the db
);

-------------------------------------------------------------------------------------------------------
--Table:          game
-------------------------------------------------------------------------------------------------------
--Description:    The `baseball_raw.game' table provides an overview of the game, including
--                matchups, venue location, date of the game, and weather
-------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS baseball_raw.game;
CREATE TABLE baseball_raw.game
(
    "gamePk"                    INTEGER,
    "schedule"                  JSON,
    "teams"                     JSON,
    "venue"                     JSON,
    "weather"                   JSON,
    "gameInfo"                  JSON,
    "_createdAt"                TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- -------------------------------------------------------------------------------------------------------
-- Table:           baseball_raw.plays
-- -------------------------------------------------------------------------------------------------------
-- Description:     The `baseball_raw.plays` table stores the outcome of plate appearances
--                  in baseball games. It contains the game identifier (gamePk) and a JSON structured
--                  column (play_outcome) to detail the events and results of every play per game.
-- -------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS baseball_raw.play;
CREATE TABLE IF NOT EXISTS baseball_raw.play
(
    "gamePk"                    VARCHAR, -- Unique identifier for the game
    plays                       JSON,     -- JSON field that captures detailed outcomes of plays in the given game
    "_createdAt"                TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- time the record was loaded into the db
);

-- -------------------------------------------------------------------------------------------------------
-- Schema:          aluminum
-- Description:     staging schema
-- -------------------------------------------------------------------------------------------------------

CREATE TABLE baseball_aluminum.team
(
    "teamId"                    INT PRIMARY KEY,
    "springLeagueId"            INT,
    "venueId"                   INT,
    "springVenueId"             INT,
    "leagueId"                  INT,
    "divisionId"                INT,
    "sportId"                   INT,
    "teamName"                  TEXT,
    "shortName"                 TEXT,
    "franchiseName"             TEXT,
    "clubName"                  TEXT,
    "locationName"              TEXT,
    "abbreviation"              TEXT,
    "teamCode"                  TEXT,
    "fileCode"                  TEXT,
    "teamLink"                  TEXT,
    "venueName"                 TEXT,
    "venueLink"                 TEXT,
    "leagueName"                TEXT,
    "leagueLink"                TEXT,
    "divisionName"              TEXT,
    "divisionLink"              TEXT,
    "springLeagueName"          TEXT,
    "springLeagueLink"          TEXT,
    "springLeagueAbbreviation"  TEXT,
    "springVenueLink"           TEXT,
    "sportLink"                 TEXT,
    "firstYearOfPlay"           INT,
    "season"                    INT,
    "allStarStatus"             TEXT,
    "isActive"                  BOOLEAN,
    "_createdAt"                TIMESTAMP
);

DROP TABLE IF EXISTS baseball_aluminum.player;
CREATE TABLE IF NOT EXISTS baseball_aluminum.player
(
    "playerId"                  INT PRIMARY KEY,
    "teamId"                    INT,
    "fullName"                  VARCHAR,
    "link"                      VARCHAR,
    "firstName"                 VARCHAR,
    "lastName"                  VARCHAR,
    "primaryNumber"             INT,
    "birthDate"                 DATE,
    "currentAge"                INT,
    "birthCity"                 VARCHAR,
    "birthStateProvince"        VARCHAR,
    "birthCountry"              VARCHAR,
    "height"                    VARCHAR,
    "weight"                    INT,
    "active"                    BOOLEAN,
    "primaryPosition"           JSON,
    "useName"                   VARCHAR,
    "useLastName"               VARCHAR,
    "middleName"                VARCHAR,
    "boxScoreName"              VARCHAR,
    "nickName"                  VARCHAR,
    "nameTitle"                 VARCHAR,
    "nameSuffix"                VARCHAR,
    "nameMatrilineal"           VARCHAR,
    "gender"                    VARCHAR,
    "isPlayer"                  BOOLEAN,
    "isVerified"                BOOLEAN,
    "draftYear"                 INT,
    "pronunciation"             VARCHAR,
    "mlbDebutDate"              DATE,
    "batSide"                   JSON,
    "pitchHand"                 JSON,
    "nameFirstLast"             VARCHAR,
    "nameSlug"                  VARCHAR,
    "firstLastName"             VARCHAR,
    "lastFirstName"             VARCHAR,
    "lastInitName"              VARCHAR,
    "initLastName"              VARCHAR,
    "fullFMLName"               VARCHAR,
    "fullLFMName"               VARCHAR,
    "strikeZoneTop"             NUMERIC(3,2),
    "strikeZoneBottom"          NUMERIC(3,2),
    "_createdAt"                TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- time the record was loaded into the db
);

DROP TABLE IF EXISTS baseball_aluminum.game;
CREATE TABLE baseball_aluminum.game
(
    "gamePk"                    INT NOT NULL,
    "gameDate"                  TIMESTAMPTZ,
    "originalGameDate"          TIMESTAMPTZ,
    "officialGameDate"          TIMESTAMPTZ,
    "time"                      TEXT,
    "awayTeamId"                INT,
    "homeTeamId"                INT,
    "venueId"                   INT,
    "weatherCondition"          TEXT,
    "weatherTemp"               INT,
    "weatherWind"               TEXT,
    "gameAttendance"            INT,
    "firstPitch"                TIMESTAMPTZ,
    "gameDurationMinutes"       INT,
    "_createdAt"                TIMESTAMPTZ
);

DROP TABLE IF EXISTS baseball_aluminum.play;
CREATE TABLE baseball_aluminum.play (
    "playPk"                    BIGSERIAL PRIMARY KEY,
    "gamePk"                    INT,
    "playId"                    TEXT,
    "atBatId"                   INT,
    "pitcherId"                 INT,
      "batterId"                INT,
      "postOnFirstId"           INT,
      "postOnSecondId"          INT,
      "postOnThirdId"           INT,
      "awayTeamId"              INT,
      "homeTeamId"              INT,
      "batterPlayIndex"         INT,
      "batterPitchNumber"       INT,
      "captivatingIndex"        INT,
      "inning"                  INT,
      "halfInning"              TEXT,
      "resultType"              TEXT,
      "resultEvent"             TEXT,
      "resultEventType"         TEXT,
      "resultEventDescription"  TEXT,
      "playCallCode"            TEXT,
      "playCallDescription"     TEXT,
      "playCode"                TEXT,
      "playDescription"         TEXT,
      "pitchTypeCode"           TEXT,
      "pitchTypeDescription"    TEXT,
      "pitcherSplits"           TEXT,
      "pitcherHotColdZones"     JSON,
      "pitchData"               JSON,
      "batterSplits"            TEXT,
      "batterHotColdZones"      JSON,
      "HitData"                 JSON,
      "runnerData"              JSON,
      "atBatStartTime"          TIMESTAMPTZ,
      "atBatEndTime"            timestamptz,
      "playStartTime"           timestamptz,
      "playEndTime"             timestamptz,
      "isTopInning"             BOOLEAN,
      "isPitch"                 BOOLEAN,
      "isStrike"                BOOLEAN,
      "isBall"                  BOOLEAN,
      "isAtBatComplete"         BOOLEAN,
      "isInPlay"                BOOLEAN,
      "isScoringPlay"           BOOLEAN,
      "isBatterOut"             BOOLEAN,
      "hasOutRecorded"          BOOLEAN,
      "atBatHasReview"          BOOLEAN,
      "hasReview"               BOOLEAN,
      "countBalls"              INT,
      "countStrikes"            INT,
      "countOuts"               INT,
      "awayScore"               INT,
      "homeScore"               INT,
      "RBIs"                    INT,
      "_createdAt"              TIMESTAMP
  );

DROP TABLE IF EXISTS baseball_aluminum.runner;
CREATE TABLE baseball_aluminum.runner
(
    "runnerPk"                  SERIAL PRIMARY KEY,
    "gamePk"                    INT,
    "runnerId"                  INT,
    "pitcherId"                 INT,
    "responsiblePitcherId"      INT,
    "postOnFirstId"             INT,
    "postOnSecondId"            INT,
    "postOnThirdId"             INT,
    "atBatId"                   INT,
    "batterPlayId"              INT,
    "event"                     TEXT,
    "eventType"                 TEXT,
    "movementReason"            TEXT,
    "originBase"                TEXT,
    "startBase"                 TEXT,
    "endBase"                   TEXT,
    "outBase"                   TEXT,
    "outNumber"                 INT,
    "isStolenBase"              BOOLEAN,
    "isCaughtStealing"          BOOLEAN,
    "isOut"                     BOOLEAN,
    "isRBI"                     BOOLEAN,
    "isEarnedRun"               BOOLEAN,
    "isUnearnedRun"             BOOLEAN,
    "_createdAt"                TIMESTAMP
    );

-- -------------------------------------------------------------------------------------------------------
-- Schema:          platinum
-- Description:     stores historical data
-- -------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS baseball_platinum.team;
CREATE TABLE IF NOT EXISTS baseball_platinum.team
(
    "teamId"                   INT PRIMARY KEY,
    "venueId"                  INT,
    "springVenueId"            INT,
    "divisionId"               INT,
    "leagueId"                 INT,
    "springLeagueId"           INT,
    "sportId"                  INT,
    "franchiseName"            VARCHAR,
    "teamName"                 VARCHAR,
    "shortName"                VARCHAR,
    "abbreviation"             VARCHAR,
    "clubName"                 VARCHAR,
    "venueName"                  varchar,
    "locationName"               varchar,
    "divisionName"               varchar,
    "leagueName"                 varchar,
    "springLeagueName"          varchar,
    "springLeagueAbbreviation"  varchar,
    "sportName"                  varchar,
    season                      int,
    "firstYearOfPlay"               int,
    "allStarStatus"             varchar,
    "isActive"                   bool,
    "_createdAt"                timestamp,
    "_updatedAt"                timestamp
);

CREATE TABLE baseball_platinum.player
(
    "playerHistoryId"               SERIAL PRIMARY KEY, -- keep track of team changes (if any)
    "playerId"                      INT NOT NULL,
    "teamId"                        INT,
    "fullName"                      VARCHAR,
    "firstName"                     VARCHAR,
    "middleName"                    VARCHAR,
    "lastName"                      VARCHAR,
    "birthCity"                     VARCHAR,
    "birthStateProvince"            VARCHAR,
    "birthCountry"                  VARCHAR,
    "useName"                       VARCHAR,
    "useLastName"                   VARCHAR,
    "boxScoreName"                  VARCHAR,
    "nickname"                      VARCHAR,
    "nameTitle"                     VARCHAR,
    "nameSuffix"                    VARCHAR,
    "nameMatrilineal"               VARCHAR,
    "namePronunciation"             VARCHAR,
    "birthDate"                     DATE,
    age                             INT,
    gender                          VARCHAR,
    height                          VARCHAR,
    weight                          INT,
    "draftYear"                     INT,
    "mlbDebutDate"                  DATE,
    "primaryNumber"                  INT,
    "primaryPositionCode"           VARCHAR,
    "primaryPositionName"           VARCHAR,
    "primaryPositionType"           VARCHAR,
    "primaryPositionAbbreviation"   VARCHAR,
    "batSideCode"                   VARCHAR,
    "batSideDescription"            VARCHAR,
    "pitchHandCode"                 VARCHAR,
    "pitchHandDescription"          VARCHAR,
    "strikeZoneTop"                 NUMERIC(3,2),
    "strikeZoneBottom"              NUMERIC(3,2),
    "apiLink"                       VARCHAR,
    "isPlayer"                      BOOLEAN,
    "isVerified"                    BOOLEAN,
    "isActive"                      BOOLEAN,
    "_createdAt"                    TIMESTAMP,
    "updatedAt"                     timestamp
);

DROP TABLE IF EXISTS baseball_platinum.game;
CREATE TABLE baseball_platinum.game
(
    "gamePk"                    INT NOT NULL PRIMARY KEY,
    "homeTeamId"                INT,
    "awayTeamId"                INT,
    "venueId"                   INT,
    "gameDate"                  TIMESTAMPTZ,
    "originalGameDate"          timestamptz,
    "officialGameDate"          timestamptz,
    "officialGameTime"          TEXT,
    "firstPitchDateTime"        TIMESTAMP,
    "weatherCondition"          TEXT,
    "temperature"               TEXT,
    "windSpeedDirection"        TEXT,
    "gameAttendance"            INT,
    "gameDurationMinutes"       INT,
    "_createdAt"                timestamp,
    "_updatedAt"                timestamp,
    "_createdBy"                TEXT,
    "_updatedBy"                TEXT
);

  CREATE TABLE baseball_platinum.play (
      "playPk"                      BIGSERIAL PRIMARY KEY,
      "gamePk"                      INT NOT NULL,
      "atBatId"                     INT NOT NULL,
      "pitcherId"                   INT NOT NULL,
      "batterId"                    INT NOT NULL,
      "postOnFirstId"               INT,
      "postOnSecondId"              INT,
      "postOnThirdId"               INT,
      "batterPlayIndex"             INT NOT NULL,
      "playId"                      TEXT,
      "batterPitchNumber"           INT,
      "captivatingIndex"            INT,
      "inning"                      INT,
      "halfInning"                  TEXT,
      "resultType"                  TEXT,
      "resultEvent"                 TEXT,
      "resultEventType"             TEXT,
      "resultEventDescription"      TEXT,
      "playCallCode"                TEXT,
      "playCallDescription"         TEXT,
      "playCode"                    TEXT,
      "playDescription"             TEXT,
      "pitchTypeCode"               TEXT,
      "pitchTypeDescription"        TEXT,
      "pitcherSplits"               TEXT,
      "pitcherHotColdZones"         JSON,
      "pitchData"                   JSON,
      "batterSplits"                TEXT,
      "batterHotColdZones"          JSON,
      "hitData"                     JSON,
      "runnerSplits"                TEXT,
      "runnerData"                  JSON,
      "atBatStartTime"              timestamptz,
      "atBatEndTime"                timestamptz,
      "playStartTime"               timestamptz,
      "playEndTime"                 timestamptz,
      "isTopInning"                 BOOLEAN,
      "isPitch"                     BOOLEAN,
      "isStrike"                    BOOLEAN,
      "isBall"                      BOOLEAN,
      "isAtBatComplete"             BOOLEAN,
      "isInPlay"                    BOOLEAN,
      "isScoringPlay"               BOOLEAN,
      "isBatterOut"                 BOOLEAN,
      "hasOutRecorded"              BOOLEAN,
      "atBatHasReview"              BOOLEAN,
      "hasReview"                   BOOLEAN,
      "countBalls"                  INT,
      "countStrikes"                INT,
      "countOuts"                   INT,
      "awayScore"                   INT,
      "homeScore"                   INT,
      "RBIs"                        INT,
      "_createdAt"                  TIMESTAMP,
      "_createdBy"                  TEXT
  );

DROP TABLE IF EXISTS baseball_platinum.runner;
CREATE TABLE baseball_platinum.runner
(
    "runPk"                 SERIAL PRIMARY KEY,
    "gamePk"                INT,
    "runnerId"              INT,
    "pitcherId"             INT,
    "responsiblePitcherId"  INT,
    "postOnFirstId"         INT,
    "postOnSecondId"        INT,
    "postOnThirdId"         INT,
    "atBatId"               INT,
    "batterPlayId"          INT,
    "eventType"             TEXT,
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
    "_createdAt"            TIMESTAMP,
    "_updatedAt"            TIMESTAMP
);

DROP TABLE IF EXISTS baseball_platinum.schedule;
CREATE TABLE baseball_platinum.schedule
(
    "schedulePk"            BIGSERIAL NOT NULL UNIQUE,
    "gamePk"                INT NOT NULL,
    "awayTeamId"            INT,
    "homeTeamId"            INT,
    "venueId"               INT,
    "gameType"              TEXT,
    "gameDate"              TIMESTAMP,
    "officialDate"          DATE,
    "statusCode"            TEXT,
    "detailedState"         TEXT,
    "isAwayTeamWinner"      BOOL,
    "isHomeTeamWinner"      BOOL,
    "gameNumber"            INT,
    "gameInSeries"          int,
    "seriesGameNumber"      int,
    "isDoubleHeader"        BOOL,
    season                  INT,
    "_createdAt"            TIMESTAMP,
    "_updatedAt"            timestamp
);

-- -------------------------------------------------------------------------------------------------------
-- Schema:          baseball_models
-- Description:     feeds mlb-fantasy app
-- -------------------------------------------------------------------------------------------------------
select * from baseball_raw.play