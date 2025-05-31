CREATE TABLE baseball_platinum.game
(
    "gamePk"                INT NOT NULL PRIMARY KEY,
    "homeTeamId"            INT,
    "awayTeamId"            INT,
    "venueId"               INT,
    "gameDate"              timestamptz,
    "originalGameDate"      timestamptz,
    "officialGameDate"      timestamptz,
    "officialGameTime"      TEXT,
    "firstPitchDateTime"    timestamp,
    "weatherCondition"      TEXT,
    "temperature"           TEXT,
    "windSpeedDirection"    Text,
    "gameAttendance"        INT,
    "gameDurationMinutes"   INT,
    "_createdAt"            timestamp,
    "_updatedAt"            timestamp,
    "_createdBy"            TEXT,
    "_updatedBy"            TEXT
)