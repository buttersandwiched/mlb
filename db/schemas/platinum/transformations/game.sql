MERGE INTO baseball_platinum.game  target
USING baseball_aluminum.game as source
ON source."gamePk" = target."gamePk"
WHEN MATCHED THEN
    UPDATE SET
               "homeTeamId"             = source."homeTeamId",
               "awayTeamId"             = source."awayTeamId",
               "venueId"                = source."venueId",
               "gameDate"               = source."gameDate",
               "originalGameDate"       = source."originalGameDate",
               "officialGameDate"       = source."officialGameDate",
               "officialGameTime"       = source.time,
               "firstPitchDateTime"     = source."firstPitch",
               "weatherCondition"       = source."weatherCondition",
               "temperature"            = source."weatherTemp",
               "WindSpeedDirection"     = source."weatherWind",
               "gameAttendance"         = source."gameAttendance",
               "gameDurationMinutes"    = source."gameDurationMinutes",
               "_updatedAt"             = CURRENT_TIMESTAMP,
               "_updatedBy"             = 'db_user'
WHEN NOT MATCHED THEN
INSERT ("gamePk", "awayTeamId","homeTeamId", "venueId", "gameDate", "originalGameDate", "officialGameDate", "officialGameTime", "firstPitchDateTime", "weatherCondition", "temperature",
        "WindSpeedDirection", "gameAttendance", "gameDurationMinutes", "_createdAt", "_createdBy", "_updatedAt", "_updatedBy")
VALUES (
        "gamePk",
        "awayTeamId",
        "homeTeamId",
        "venueId",
        "gameDate",
        "originalGameDate",
        "officialGameDate",
        "time",
        "firstPitch",
        "weatherCondition",
        "weatherTemp",
        "weatherWind",
        "gameAttendance",
        "gameDurationMinutes",
        CURRENT_TIMESTAMP,
        'db_user',
        current_timestamp,
        'db_user'
       );

SELECT *
FROM baseball_platinum.game;