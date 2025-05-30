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
    "_createdAt"            timestamp,
    "_updatedAt"            timestamp
);

select *
from baseball_platinum.schedule;