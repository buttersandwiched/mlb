TRUNCATE TABLE baseball_aluminum.game;

INSERT INTO baseball_aluminum.game ("gamePk", "gameDate", "originalGameDate", "officialGameDate", time, "awayTeamId",
                                    "homeTeamId", "venueId", "weatherCondition", "weatherTemp", "weatherWind",
                                    "gameAttendance", "firstPitch", "gameDurationMinutes", "_createdAt", "_createdBy")
SELECT
    game."gamePk",
    (game.schedule->>'dateTime')::timestamptz,
    (game.schedule->>'originalDate')::timestamptz,
    (game.schedule->>'officialDate')::timestamptz,
    ((game.schedule->>'time')::TEXT || (game.schedule->>'ampm')::TEXT)::TEXT,
    (game.teams->'away'->>'id')::INT,
    (game.teams->'home'->>'id')::INT,
    (game.venue->>'id')::INT,
    game.weather->>'condition',
    (game.weather->>'temp')::INT,
    game.weather->>'wind',
    (game."gameInfo"->>'attendance')::INT,
    (game."gameInfo"->>'firstPitch')::timestamptz,
    (game."gameInfo"->>'gameDurationMinutes')::INT,
    CURRENT_TIMESTAMP,
    'manual'
FROM baseball_raw."game" as game;

SELECT *
FROM baseball_aluminum.game
order by 2,1
