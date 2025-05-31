CREATE VIEW baseball_models.play    AS
SELECT home."team_name"             AS "homeTeam",
       away.team_name               AS "awayTeam",
       pb.full_name                 AS batter,
       pp.full_name                 AS pitcher,
       p."playPk",
       p."gamePk",
       p."atBatId",
       p."pitcherId",
       p."batterId",
       p."postOnFirstId"            AS "runnerOnFirstId",
       p."postOnSecondId"           AS "runnerOnSecondId",
       p."postOnThirdId"            AS "runnerOnThirdId",
       p.inning,
       p."halfInning",
       p."playCode",
       CASE WHEN p."playCode" IN ('D', 'X', 'E') OR "countStrikes" = 3 OR "countBalls" = 4
           THEN p."playDescription" || ': ' || p."resultEventDescription"
           ELSE p."playDescription" END,
       p."pitchTypeCode",
       p."pitchTypeDescription",
       p."playStartTime",
       p."playEndTime",
       p."batterPlayIndex"          as "batterPlayCount",
       p."batterPitchNumber",
       p."countBalls",
       p."countStrikes",
       p."countOuts",
       p."runnerData",
       p."isPitch",
       p."isInPlay",
       p."isBatterOut",
       p."playStartTime",
       p."playEndTime",
       p."RBIs"
FROM baseball_platinum.play p
    INNER JOIN baseball_platinum.game g on p."gamePk" = g."gamePk"
    INNER JOIN baseball_platinum.teams away on away.team_id = g."awayTeamId"
    INNER JOIN baseball_platinum.teams home on home.team_id = g."homeTeamId"
    INNER JOIN baseball_platinum.players pb on p."batterId" = pb.player_id
    INNER JOIN baseball_platinum.players pp on p."pitcherId" = pp.player_id
WHERE "playId" IS NOT NULL