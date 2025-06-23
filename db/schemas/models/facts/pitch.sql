DROP VIEW IF EXISTS baseball_models.pitch cascade ;
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
    "batterPlayIndex",
    "pitchIndex",
    inning,
    "playCode",
    "playCall",
    "playCallDescription",
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
    "runsSurrendered",
    "earnedRuns",
    "unearnedRuns",
    "caughtStealing",
    "stolenBases"
)
AS
WITH runnersOnBase
    AS (
        SELECT "gamePk",
               "atBatId",
               "batterPlayId",
               coalesce("responsiblePitcherId", "pitcherId")        as "responsiblePitcherId",
               sum(case when "isUnearnedRun" then 1 else 0 end)     as "unearnedRuns",
               sum(case when "isEarnedRun" then 1 else 0 end)       as "earnedRuns",
               sum(case when "isStolenBase" then 1 else 0 end)      as "stolenBases",
               sum(case when "isCaughtStealing" then 1 else 0 end)  as "caughtStealing",
               sum(case when "isOut" then 1 else 0 end)             as "outs"
        FROM baseball_platinum.runner
        GROUP by "gamePk", coalesce("responsiblePitcherId", "pitcherId"),"atBatId","batterPlayId"
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
       p."batterPlayIndex"                                  AS "batterPlayId",
       row_number() over (partition by p."gamePk",
                                       p."pitcherId",
                                       p."atBatId")         AS pitchId,
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
        CASE
           WHEN p."isInPlay"
                OR p."playCode" = 'H'
                OR (p."playCode" in ('B', 'VB') AND "countBalls" = 4)
                OR "countStrikes" = 3
                    then p."resultEventDescription"
           ELSE p."playDescription"
           END                                              AS "playCallDescription",
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
       (p."pitchData"->>'coordinates')::json                AS "pitchCoordinates",
       coalesce(rob.outs,0)                                 AS "outsRecorded",
       p."RBIs"                                             AS "runsSurrendered",
       coalesce(rob."earnedRuns", 0),
       coalesce(rob."unearnedRuns",0),
       coalesce(rob."caughtStealing",0),
       coalesce(rob."stolenBases", 0)
FROM baseball_platinum.play p
    JOIN baseball_platinum.game g       ON g."gamePk"       = p."gamePk"
    JOIN baseball_models.player sp      ON sp."playerId"    = p."pitcherId"
    JOIN baseball_models.player b       ON b."playerId"     = p."batterId"
    LEFT JOIN runnersOnBase rob         on rob."responsiblePitcherId" = p."pitcherId"
                                        and p."gamePk" = rob."gamePk"
                                            and p."atBatId" = rob."atBatId"
                                            and p."batterPlayIndex" = rob."batterPlayId";