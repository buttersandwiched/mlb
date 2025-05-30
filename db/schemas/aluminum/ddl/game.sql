SELECT *
FROM baseball_raw."gameData";

CREATE TABLE baseball_aluminum.game
(
    "gamePk" INT NOT NULL,
    "gameDate" timestamptz,
    "originalGameDate" timestamptz,
    "officialGameDate" timestamptz,
    "time" text,
    "awayTeamId" INT,
    "homeTeamId" INT,
    "venueId" INT,
    "weatherCondition" TEXT,
    "weatherTemp" INT,
    "weatherWind" TEXT,
    "gameAttendance" INT,
    "firstPitch" timestamptz,
    "gameDurationMinutes" INT,
    "_createdAt" timestamptz,
    "_createdBy" TEXT
)