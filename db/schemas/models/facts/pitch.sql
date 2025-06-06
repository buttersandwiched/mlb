DROP VIEW IF EXISTS baseball_models.pitch;
CREATE VIEW baseball_models.pitch(
    "gameId",
    "pitcherId",
    "batterId",
    "awayTeamId",
    "homeTeamId",
    "runnerOnFirstId",
    "runnerOnSecondId",
    "runnerOnThirdId",
    "gameDate",
    "atBatId",
    inning,
    "playCode",
    "playCall",
    "pitchTypeCode",
    "pitchTypeDescription",
    "splitsPitcher",
    "isStrike",
    "isBall",
    "isInPlay",
    "isBatterOut",
    "hasOut",
    "isFastball",
    "isCutter",
    "isSweeper",
    "isCurveball",
    "isChangeup",
    "isSlider",
    "isKnuckleCurve",
    "isSinker",
    "isSplitter",
    "ballCount",
    "strikeCount",
    "pitchStartSpeed",
    "pitchEndSpeed",
    "pitchSpinRate",
    "pitchCoordinates",
    "outsRecorded",
    "runsSurrendered"
)
AS
with runnersOnBase
    as (
        select "gamePk",
               "pitcherId",
               "responsiblePitcherId",
               "atBatId",
               "batterPlayId",
               sum(case when "isUnearnedRun" then 1 else 0 end)     as "unearnedRuns",
               sum(case when "isEarnedRun" then 1 else 0 end)       as "earnedRuns",
               sum(case when "isStolenBase" then 1 else 0 end)      as "stolenBases",
               sum(case when "isCaughtStealing" then 1 else 0 end)  as "caughtStealing"
        from baseball_platinum.runner
        group by "gamePk", runner."pitcherId", "responsiblePitcherId","atBatId","batterPlayId"
    )
SELECT p."gamePk"                                           AS "gameId",
       sp."playerId"                                        AS "pitcherId",
       b."playerId"                                         AS "batterId",
       g."awayTeamId"                                       AS "awayTeamId",
       g."homeTeamId"                                       AS "homeTeamId",
       p."postOnFirstId"                                    AS "runnerOnFirstId",
       p."postOnSecondId"                                   AS "runnerOnSecondId",
       p."postOnThirdId"                                    AS "postOnThirdId",
       g."gameDate"                                         AS "gameDate",
       p."atBatId"                                          AS "atBatId",
       p.inning                                             AS inning,
       p."playCode"                                         AS "playCode",
       CASE
           WHEN p."isInPlay"
                OR p."playCode" = 'H'
                OR (p."playCode" in ('B', 'VB') AND "countBalls" = 4)
                OR "countStrikes" = 3
                    then p."playDescription" || ': ' || p."resultEventType"
           ELSE p."playDescription"
           END                                              AS "playCall",
       p."pitchTypeCode"                                    AS "pitchTypeCode",
       p."pitchTypeDescription"                             AS "pitchTypeDescription",
       p."pitcherSplits"                                    AS "splitsPitcher",
       p."isStrike"                                         AS "isStrike",
       p."isBall"                                           AS "isBall",
       p."isInPlay"                                         AS "isInPlay",
       p."isBatterOut"                                      AS "isBatterOut",
       p."hasOutRecorded"                                   AS "hasOut",
       CASE
           WHEN p."pitchTypeCode" = 'FF' THEN 1
           ELSE 0
           END                                              AS "isFastball",
       CASE
           WHEN p."pitchTypeCode" = 'FC' THEN 1
           ELSE 0
           END                                              AS "isCutter",
       CASE
           WHEN p."pitchTypeCode" = 'ST' THEN 1
           ELSE 0
           END                                              AS "isSweeper",
       CASE
           WHEN p."pitchTypeCode" = 'CU' THEN 1
           ELSE 0
           END                                              AS "isCurveball",
       CASE
           WHEN p."pitchTypeCode" = 'CH' THEN 1
           ELSE 0
           END                                              AS "isChangeup",
       CASE
           WHEN p."pitchTypeCode" = 'SL' THEN 1
           ELSE 0
           END                                              AS "isSlider",
       CASE
           WHEN p."pitchTypeCode" = 'KC' THEN 1
           ELSE 0
           END                                              AS "isKnuckleCurve",
       CASE
           WHEN p."pitchTypeCode" = 'SI' THEN 1
           ELSE 0
           END                                              AS "isSinker",
       CASE
           WHEN p."pitchTypeCode" = 'FS' THEN 1
           ELSE 0
           END                                              AS "isSplitter",
       p."countBalls"                                       AS "ballCount",
       p."countStrikes"                                     AS "strikeCount",
       p."pitchData"->>'startSpeed'                         AS "ballStartSpeed",
       p."pitchData"->>'endSpeed'                           AS "ballEndSpeed",
       p."pitchData"->'breaks'->>'spinRate'                 AS "ballSpinRate",
       p."pitchData"->>'coordinates'                        AS "pitchCoordinates",
       CASE
           WHEN p."playCode" = 'X' and p."resultEventType" like '%triple_play' then 3
           WHEN p."playCode" = 'X' and p."resultEventType" like '%double_play' then 2
           WHEN p."playCode" = 'X'                                             then 1
           ELSE 0
           END                                              AS  "outsRecorded",
       p."RBIs"                                             AS "runsSurrendered"
FROM baseball_platinum.play p
    JOIN baseball_platinum.game g       ON g."gamePk"       = p."gamePk"
    JOIN baseball_models.player sp      ON sp."playerId"    = p."pitcherId"
    JOIN baseball_models.player b       ON b."playerId"     = p."batterId"
WHERE p."isPitch";


select *
from baseball_platinum.play
where "hasOutRecorded" and not "isBatterOut"