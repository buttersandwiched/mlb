CREATE VIEW baseball_models.game AS
SELECT
    "gamePk"                                                      AS "gameId",
    "awayTeamId",
    "homeTeamId",
    "venueId",
    t.team_name                                                   AS "homeTeam",
    t2.team_name                                                  AS "awayTeam",
    s.game_in_series                                              AS "gameInSeries",
    s.game_number                                                 AS "gameNumber",
    s.game_type                                                   AS "gameType",
    CAST("officialGameDate" as DATE) || ' ' || "officialGameTime" as "officialGameTime",
    "firstPitchDateTime",
    g."originalGameDate",
    s.season,
    "weatherCondition",
    "temperature",
    "gameAttendance",
    "gameDurationMinutes"
FROM baseball_platinum.game g
INNER JOIN baseball_platinum.teams t on g."homeTeamId" = t.team_id
INNER JOIN baseball_platinum.teams t2 on t2.team_id = g."awayTeamId"
INNER JOIN baseball_platinum.schedule s on g."gamePk" = s.game_id

SELECT *
from baseball_models.game
