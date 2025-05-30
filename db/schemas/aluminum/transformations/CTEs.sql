CREATE table baseball_aluminum.pitch
(
    "pitchPk"          BIGSERIAL PRIMARY KEY,
    "gamePk"                INT,
    "batterId"              INT,
    "atBatId"               INT,
    "pitchNumber"           INT,
    "pitchTypeCode"         TEXT,
    "pitchTypeDescription"  TEXT,
    "pitchStartSpeed"       TEXT,
    "pitchEndSpeed"         TEXT,
    "strikeZoneTop"         TEXT,
    "strikeZoneBottom"      TEXT,
    "strikeZoneCoordinates" JSON,
    "breakAngle"            NUMERIC,
    "breakLength"           NUMERIC,
    "breakY"                NUMERIC,
    "breakVertical"         NUMERIC,
    "breakVerticalInduced"  NUMERIC,
    "breakHorizontal"       NUMERIC,
    "spinRate"              INT,
    "spinDirection"         INT,
    "zone"                  INT,
    "typeConfidence"        NUMERIC,
    "plateTime"             NUMERIC,
    "extension"             NUMERIC,
    "_dateCreated"          TIMESTAMP,
    "_createdBy"            TEXT
);

, hitData as
    (
        SELECT
            p."gamePk",
            p."batterId",
            p."pitcherId",
            p."atBatId",
            p."batterPlayIndex",
            p."batterPitchNumber",
            (p."HitData"->>'launchSpeed')::numeric      AS "launchSpeed",
            (p."HitData"->>'launchAngle')::NUMERIC      AS "launchAngle",
            (p."HitData"->>'totalDistance')::NUMERIC    AS "totalDistance",
            p."HitData"->>'trajectory'                  AS trajectory,
            p."HitData"->>'hardness'                    AS hardness,
            (p."HitData"->>'location')::INT             AS location,
            CASE (p."HitData"->>'location')::INT
                WHEN 1 then 'pitcher'
                WHEN 2 then 'catcher'
                WHEN 3 then 'first_base'
                WHEN 4 then 'second_base'
                WHEN 5 then 'third_base'
                When 6 then 'short_stop'
                WHEN 7 then 'left_field'
                WHEN 78 then 'left_center_field'
                When 8 then 'center_field'
                WHEN 89 then 'right_center_field'
                WHEN 9 then 'right_field' END           AS "locationDescription",
            (p."HitData"->>'coordinates')::json         AS coordinates
        FROM baseball_aluminum.play p
        WHERE p."isInPlay"
    )

 SELECT *
FROM hitData;


   /*
    This CTE will just get runner data, per at bat
    */
, runners as
    (
        SELECT
            p."gamePk",
            r->'details'->'runner'->>'id'    AS "runnerId",
            p."batterId",
            p."pitcherId",
            p."playIndex",
            p."pitchNumber",
            p."runnerData",
            r->'details'->>'playIndex'       AS "playIndex",
            r->'details'->>'eventType'       AS "runnerEventType",
            r->'movement'->>'start'          AS "startBase",
            r->'movement'->>'end'            AS "endBase",
            r->'movement'->>'outBase'        AS "outBase",
            (r->'movement'->>'isOut')::BOOl  AS "isRunnerOut",
            r->'details'->'earned'           AS "isEarned",
            r->'details'->'teamUnearned'     AS "isTeamUnearned"
        FROM plays p
            INNER JOIN json_array_elements(p.runnerData) AS r
                ON (r->'details'->>'playIndex')::int = p."playIndex"
                AND (r->'details'->'runner'->>'id')::int != p."batterId" --ignore the movement of the batter

    )
select * from pitchData;
/*
SELECT
    "gamePk",
    "runnerId",
    SUM (CASE WHEN "runnerEventType" like 'stolen_base_%' THEN 1 ELSE 0 END) AS "stolenBases",
    SUM (CASE WHEN "endBase" = 'score' AND "isRunnerOut" IS FALSE THEN 1 ELSE 0 END) AS "runsScored",
    SUM (CASE WHEN "isRunnerOut" THEN 0 ELSE 1 END) AS advancements

FROM runners
GROUP BY "gamePk", "runnerId"
ORDER BY 1,2,3 DESC

 */

  CREATE TABLE baseball_aluminum.play (
      "playPk"                      BIGSERIAL PRIMARY KEY,
      "gamePk"                      INT,
      "playId"                      TEXT,
      "atBatId"                     INT,
      "pitcherId"                   INT,
      "batterId"                    INT,
      "batterPlayIndex"             INT,
      "batterPitchNumber"           INT,
      "captivatingIndex"            INT,
      "inning"                      INT,
      "halfInning"                  TEXT,
      "resultType"                  TEXT,
      "resultEvent"                 TEXT,
      "resultEventType"             TEXT,
      "resultEventDescription"      TEXT,
      "playCallCode"                TEXT,
      "playCallDescription"         TEXT,
      "playCode"                    TEXT,
      "playDescription"             TEXT,
      "pitchTypeCode"               TEXT,
      "pitchTypeDescription"        TEXT,
      "pitcherSplits"               TEXT,
      "pitcherHotColdZones"         JSON,
      "pitchData"                   JSON,
      "batterSplits"                TEXT,
      "batterHotColdZones"          JSON,
      "HitData"                     JSON,
      "runnerData"                  JSON,
      "atBatStartTime"              timestamptz,
      "atBatEndTime"                timestamptz,
      "playStartTime"               timestamptz,
      "playEndTime"                 timestamptz,
      "isTopInning"                 BOOLEAN,
      "isPitch"                     BOOLEAN,
      "isStrike"                    BOOLEAN,
      "isBall"                      BOOLEAN,
      "isAtBatComplete"             BOOLEAN,
      "isInPlay"                    BOOLEAN,
      "isScoringPlay"               BOOLEAN,
      "isBatterOut"                 BOOLEAN,
      "hasOutRecorded"              BOOLEAN,
      "atBatHasReview"              BOOLEAN,
      "hasReview"                   BOOLEAN,
      "countBalls"                  INT,
      "countStrikes"                INT,
      "countOuts"                   INT,
      "awayScore"                   INT,
      "homeScore"                   INT,
      "RBIs"                        INT,
      "_createdAt"                  TIMESTAMP,
      "_createdBy"                  TEXT
  );

  select *
  from baseball_aluminum.play