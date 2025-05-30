CREATE VIEW baseball_models.play    AS
SELECT home."team_name"             AS "homeTeam",
       away.team_name               AS "awayTeam",
       pb.full_name                 as batter,
       pp.full_name                 as pitcher,
       p."playPk",
       p."gamePk",
       p."atBatId",
       p."pitcherId",
       p."batterId",
       CASE
            WHEN (json_array_element(p."runnerData",0)->'movement')->>'originBase' = '1B'
            THEN  (json_array_element(p."runnerData",0)->'details')->'runner'->>'id'
            WHEN (json_array_element(p."runnerData",1)->'movement')->>'originBase' = '1B'
            THEN  (json_array_element(p."runnerData",1)->'details')->'runner'->>'id'
            WHEN (json_array_element(p."runnerData",2)->'movement')->>'originBase' = '1B'
            THEN  (json_array_element(p."runnerData",2)->'details')->'runner'->>'id'
            WHEN (json_array_element(p."runnerData",3)->'movement')->>'originBase' = '1B'
            THEN  (json_array_element(p."runnerData",3)->'details')->'runner'->>'id'
        END AS "runnerOnFirstID",
        CASE
            WHEN (json_array_element(p."runnerData",0)->'movement')->>'originBase' = '2B'
            THEN  (json_array_element(p."runnerData",0)->'details')->'runner'->>'id'
            WHEN (json_array_element(p."runnerData",1)->'movement')->>'originBase' = '2B'
            THEN  (json_array_element(p."runnerData",1)->'details')->'runner'->>'id'
            WHEN (json_array_element(p."runnerData",2)->'movement')->>'originBase' = '2B'
            THEN  (json_array_element(p."runnerData",2)->'details')->'runner'->>'id'
            WHEN (json_array_element(p."runnerData",3)->'movement')->>'originBase' = '2B'
            THEN  (json_array_element(p."runnerData",3)->'details')->'runner'->>'id'
        end AS "runnerOnSecondID",
        CASE
            WHEN (json_array_element(p."runnerData",0)->'movement')->>'originBase' = '3B'
            THEN  (json_array_element(p."runnerData",0)->'details')->'runner'->>'id'
            WHEN (json_array_element(p."runnerData",1)->'movement')->>'originBase' = '3B'
            THEN  (json_array_element(p."runnerData",1)->'details')->'runner'->>'id'
            WHEN (json_array_element(p."runnerData",2)->'movement')->>'originBase' = '3B'
            THEN  (json_array_element(p."runnerData",2)->'details')->'runner'->>'id'
            WHEN (json_array_element(p."runnerData",3)->'movement')->>'originBase' = '3B'
            THEN  (json_array_element(p."runnerData",3)->'details')->'runner'->>'id'
        END AS "runnerOnThirdID",
       p.inning,
       p."halfInning",
       p."playCode",
       case when p."playCode" in ('D', 'X', 'E') or "countStrikes" = 3 or "countBalls" = 4
           then p."playDescription" || ': ' || p."resultEventDescription"
           ELSE p."playDescription" END,
       p."pitchTypeCode",
       p."pitchTypeDescription",
       p."playStartTime",
       p."playEndTime",
       p."batterPlayIndex" as "batterPlayCount",
       p."batterPitchNumber",
       p."countBalls",
       p."countStrikes",
       p."countOuts",
      p."runnerData"
FROM baseball_platinum.play p
    INNER JOIN baseball_platinum.game g on p."gamePk" = g."gamePk"
    INNER JOIN baseball_platinum.teams away on away.team_id = g."awayTeamId"
    INNER JOIN baseball_platinum.teams home on home.team_id = g."homeTeamId"
    INNER JOIN baseball_platinum.players pb on p."batterId" = pb.player_id
    INNER JOIN baseball_platinum.players pp on p."pitcherId" = pp.player_id
WHERE "playId" IS NOT NULL