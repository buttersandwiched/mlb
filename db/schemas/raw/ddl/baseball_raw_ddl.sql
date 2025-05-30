-------------------------------------------------------------------------------------------------------
--Schema:         baseball_raw
-------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------
--Table:          teams
--Description:    The `baseball_raw.teams` table provides details about baseball teams, including
--                their identifiers, names, league and division affiliations, venue information,
--                abbreviations, and other metadata related to their franchise and operational details.
-------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS baseball_raw.teams;
CREATE TABLE IF NOT EXISTS baseball_raw.teams
(
    "springLeague"      json, -- Represents the spring training league the team belongs to (e.g., Grapefruit League, Cactus League)
    "allStarStatus"     varchar, -- Indicates the all-star status of the team (e.g., if the team is part of an all-star game setup)
    id                  int, -- Unique identifier for the team
    name                varchar, -- Official name of the team
    link                varchar, -- URL or link to more information about the team
    season              int, -- The season associated with this team entry
    venue               json, -- Identifier for the venue associated with the team
    "springVenue"       json, -- Identifier for the team's spring training venue
    "teamCode"          varchar, -- Unique code used to represent the team
    "fileCode"          varchar, -- Code used internally for file or system references
    abbreviation        varchar, -- Shortened abbreviation of the team's name
    "teamName"          varchar, -- Team name without additional prefixes or suffixes
    "locationName"      varchar, -- Geographic location associated with the team
    "firstYearOfPlay"   int, -- The first year the team played in the league
    league              json, -- Identifier for the league the team belongs to (e.g., American or National League)
    division            json, -- Division to which the team is affiliated (e.g., East, West, Central)
    sport               json, -- Sport the team is associated with (e.g., baseball)
    "shortName"         varchar, -- Shortened version of the team's name
    "franchiseName"     varchar, -- The team's franchise name (e.g., Yankees, Red Sox)
    "clubName"          varchar, -- Club name associated with the team
    active              bool,  -- Indicates whether the team is currently active
    _date_created       timestamp default CURRENT_TIMESTAMP -- time the record was loaded into the db
);

-------------------------------------------------------------------------------------------------------
--Table:          schedule
-------------------------------------------------------------------------------------------------------
--Description:    The `baseball_raw.schedule` table provides information about scheduled baseball games,
--                including game identifiers, types, dates, statuses, team details, venue information, 
--                content metadata, and scheduling-related adjustments. Additional fields capture 
--                rescheduling notes and descriptions for historical tracking and analysis.
-------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS baseball_raw.schedule;
CREATE TABLE IF NOT EXISTS baseball_raw.schedule
(
    date                    date,
    "totalItems"            int,
    "totalEvents"           int,
    "totalGames"            int,
    "totalGamesInProgress"  int,
    "games"                 json,
    "events"                json,
    _date_created           timestamp default CURRENT_TIMESTAMP -- time the record was loaded into the db
);

-------------------------------------------------------------------------------------------------------
--Table:          players
-------------------------------------------------------------------------------------------------------
--Description:    The `baseball_raw.players' table gives bios of all mlb players
-------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS baseball_raw.players;
CREATE TABLE IF NOT EXISTS baseball_raw.players
(
    "id"                    INT,
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
    _date_created           TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- time the record was loaded into the db
);

-- -------------------------------------------------------------------------------------------------------
-- Table:          baseball_raw.plays
-- -------------------------------------------------------------------------------------------------------
-- Description:    The `baseball_raw.plays` table stores the outcome of plate appearances
--                 in baseball games. It contains the game identifier (gamePk) and a JSON structured
--                 column (play_outcome) to detail the events and results of every play per game.
-- -------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS baseball_raw.play;
CREATE TABLE IF NOT EXISTS baseball_raw.plays
(
    "gamePk"          varchar, -- Unique identifier for the game
    plays   json,     -- JSON field that captures detailed outcomes of plays in the given game
    _date_created   timestamp default CURRENT_TIMESTAMP -- time the record was loaded into the db
);


truncate table baseball_raw.schedule;
truncate table baseball_raw.team;
truncate table baseball_raw."game";
truncate table  baseball_raw.play;
truncate table baseball_raw.player;