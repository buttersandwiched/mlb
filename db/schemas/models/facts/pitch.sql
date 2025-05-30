CREATE VIEW baseball_models.pitch
            ("pitcherID", "batterId", "gameID", "atBatId", inning, "pitchTypeCode", "pitchTypeDescription",
             "atBatResult", "splitsPitcher", "isStrike", "isBall", "isInPlay",
             "isFastball", "isCutter", "isSweeper", "isCurveball", "isChangeup", "isSlider", "isKnuckleCurve", "isSinker", "isSplitter",
             "isOut", "pitchStartSpeed", "pitchEndSpeed", "pitchSpinRate", "runsSurrendered")

as
SELECT pp."playerId"                                        AS "pitcherId",
       b."playerId"                                         AS "batterId",
       g."awayTeamId"                                       AS "awayTeamId",
       g."homeTeamId"                                       AS "homeTeamId",
       p."gamePk"                                           AS "gameID",
       p."atBatId"                                          AS "atBatId",
       p.inning                                             AS inning,
       p."playCode"                                         AS "playCode",
       p."pitchTypeCode"                                    AS "pitchTypeCode",
       p."pitchTypeDescription"                             AS "pitchTypeDescription",
       p."pitcherSplits"                                    AS "splitsPitcher",
       p."isStrike"                                         AS "isStrike",
       p."isBall"                                           AS "isBall",
       p."isInPlay"                                         AS "isInPlay",
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
       p."pitchData"->>'startSpeed'                         AS "ballStartSpeed",
       p."pitchData"->>'endSpeed'                           AS "ballEndSpeed",
       p."pitchData"->'breaks'->>'spinRate'                 AS "ballSpinRate",
       p."RBIs"                                             AS "runsSurrendered"
FROM baseball_platinum.play p
    JOIN baseball_models.game g         ON g."gameId"       = p."gamePk"
    JOIN baseball_platinum.schedule s   ON s.game_id        = p."gamePk"
    JOIN baseball_models.player pp      ON pp."playerId"    = p."pitcherId"
    JOIN baseball_models.player b       ON b."playerId"     = p."batterId"
WHERE p."isPitch"
  AND s.game_type::text = 'R'::text;

SELECT *
FROM baseball_raw.play;

