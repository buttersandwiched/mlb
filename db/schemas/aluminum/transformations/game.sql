/* Table:   Game
   Purpose: Overview of a game, including game time, teams playing, venue, weather and attendance
   Metrics: gameDuration, attendance
*/
TRUNCATE TABLE baseball_aluminum.game;

INSERT INTO baseball_aluminum.game ("gamePk", "gameDate", "originalGameDate", "officialGameDate", time, "awayTeamId",
                                    "homeTeamId", "venueId", "weatherCondition", "weatherTemp", "weatherWind",
                                    "gameAttendance", "firstPitch", "gameDurationMinutes", "_createdAt")
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
    CURRENT_TIMESTAMP
FROM baseball_raw."game" as game;
