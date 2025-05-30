/**** /
  This refresh depends on: baseball_raw.plays
/****/
 */

/* play */
TRUNCATE TABLE baseball_aluminum.play;

WITH game AS
    (
        SELECT
            p."gamePk"::INT                     AS "gamePk",
            p.plays::JSON                       AS "plays",
            json_array_length(p.plays::JSON)    AS "numberOfAtBats"
        FROM baseball_raw.plays p
    )

, atBat AS
    (
        SELECT
            "gamePk",
            ("atBat".value->'about'->>'atBatIndex')::INT              AS "atBatId",
            ("atBat".value->'matchup'->'batter'->>'id')::INT          AS "batterId",
            ("atBat".value->'matchup'->'pitcher'->>'id')::INT         AS "pitcherId",
            ("atBat".value->'about'->>'inning')::INT                  AS "inning",
            "atBat".value->'about'->> 'halfInning'                    AS "halfInning",
            ("atBat".value->'about'->>'startTime')::timestamptz       AS "atBatStartTime",
            ("atBat".value->'about'->>'endTime')::timestamptz         AS "atBatEndTime",
            ("atBat".value->'about'->>'captivatingIndex')::INT        AS "captivatingIndex",
            ("atBat".value->'about'->>'isTopInning')::BOOL            AS "isTopInning",
            ("atBat".value->'about'->>'isScoringPlay')::BOOL          AS "isScoringPlay",
            ("atBat".value->'about'->>'hasReview')::BOOL              AS "atBatHasReview",
            ("atBat".value->'about'->>'hasOut')::BOOL                 AS "hasOutRecorded",
            ("atBat".value->'about'->>'isComplete')::BOOL             AS "isAtBatComplete",
            ("atBat".value->'matchup'->>'batterHotColdZones')::JSON   AS "batterHotColdZones",
            ("atBat".value->'matchup'->>'pitcherHotColdZones')::JSON  AS "pitcherHotColdZones",
            "atBat".value->'matchup'->'splits'->>'batter'             AS "batterSplits",
            "atBat".value->'matchup'->'splits'->>'pitcher'            AS "pitcherSplits",
            "atBat".value->'matchup'->'splits'->>'menOnBase'          AS "runnersSplits",
            "atBat".value->'result'->>'type'                          AS "resultType",
            "atBat".value->'result'->>'event'                         AS "resultEvent",
            "atBat".value->'result'->>'eventType'                     AS "resultEventType",
            "atBat".value->'result'->>'description'                   AS "resultEventDescription",
            ("atBat".value->'result'->>'rbi')::INT                    AS "RBIs",
            ("atBat".value->'result'->>'awayScore')::INT              AS "awayScore",
            ("atBat".value->'result'->>'homeScore')::INT              AS "homeScore",
            ("atBat".value->'result'->>'isOut')::BOOL                 AS "isBatterOut",
            ("game".plays)::JSON                                      AS plays,
            ("atBat".value->>'runners')::JSON                         AS "runners",
            "atBat".value->'playOutcome'                              AS "playOutcome",
            json_array_length("atBat".value->'playOutcome')           AS "numberOfPlays"
        FROM game,
            LATERAL json_array_elements(game.plays) as "atBat"
    )

, plays as
    (
        SELECT
            ab."gamePk",
            ab."atBatId",
            ab."batterId",
            ab."pitcherId",
            ab."inning",
            ab."halfInning",
            ab."atBatStartTime",
            ab."atBatEndTime",
            ab."captivatingIndex",
            ab."isTopInning",
            ab."isScoringPlay",
            ab."atBatHasReview",
            ab."hasOutRecorded",
            ab."isAtBatComplete",
            ab."batterHotColdZones",
            ab."pitcherHotColdZones",
            ab."batterSplits",
            ab."pitcherSplits",
            ab."runnersSplits",
            ab."resultType",
            ab."resultEvent",
            ab."resultEventType",
            ab."resultEventDescription",
            ab."RBIs",
            ab."awayScore",
            ab."homeScore",
            ab."isBatterOut",
            plays.value->'details'->'call'->>'code'           as "playCallCode",
            plays.value->'details'->'call'->>'description'    as "playCallDescription",
            plays.value->'details'->>'description'            as "playDescription",
            plays.value->'details'->>'code'                   as "playCode",
            (plays.value->'details'->>'isInPlay')::BOOL       as "isInPlay",
            (plays.value->'details'->>'isStrike')::BOOL       as "isStrike",
            (plays.value->'details'->>'isBall')::BOOL         as "isBall",
            plays.value->'details'->'type'->>'code'           as "pitchTypeCode",
            plays.value->'details'->'type'->>'description'    as "pitchTypeDescription",
            (plays.value->'details'->>'isOut')::BOOL          as "isOut",
            (plays.value->'details'->>'hasReview')::BOOL      as "hasReview",
            (plays.value->'count'->>'balls')::INT             as "countBalls",
            (plays.value->'count'->>'strikes')::INT           as "countStrikes",
            (plays.value->'count'->>'outs')::INT              AS "countOuts",
            (plays.value->>'index')::INT                      AS "playIndex",
            plays.value->>'playId'                            AS "playId",
            (plays.value->>'pitchNumber')::INT                AS "pitchNumber",
            (plays.value->>'startTime')::timestamptz          AS "playStartTime",
            (plays.value->>'endTime')::timestamptz            AS "playEndTime",
            (plays.value->>'isPitch')::BOOL                   AS "isPitch",
            plays.value->>'type'                              AS "playType",
            ab."runners"                                        AS runnerData,
            plays.value->'pitchData'                            AS "pitchData",
            plays.value->'hitData'                               AS "hitData"
    FROM atBat AS ab,
         LATERAL json_array_elements(ab."playOutcome") AS plays
)

INSERT INTO baseball_aluminum.play
    ("gamePk", "playId", "atBatId", "pitcherId", "batterId", "batterPlayIndex", "batterPitchNumber", "captivatingIndex", inning,
     "halfInning","resultType", "resultEvent", "resultEventType", "resultEventDescription", "playCallCode",
     "playCallDescription","playCode", "playDescription", "pitchTypeCode", "pitchTypeDescription", "pitcherSplits",
     "pitcherHotColdZones", "pitchData", "batterSplits", "batterHotColdZones", "HitData", "runnerData",
     "playStartTime", "playEndTime","atBatStartTime", "atBatEndTime", "isTopInning", "isPitch", "isStrike", "isBall",
     "isAtBatComplete", "isInPlay", "isScoringPlay", "isBatterOut","hasOutRecorded", "atBatHasReview", "hasReview",
     "countBalls", "countStrikes", "countOuts", "awayScore","homeScore", "RBIs", "_createdAt", "_createdBy")
SELECT
    p."gamePk",
    p."playId",
    p."atBatId",
    p."pitcherId",
    p."batterId",
    p."playIndex",
    p."pitchNumber",
    p."captivatingIndex",
    p.inning,
    p."halfInning",
    p."resultType",
    p."resultEvent",
    p."resultEventType",
    p."resultEventDescription",
    p."playCallCode",
    p."playCallDescription",
    p."playCode",
    p."playDescription",
    p."pitchTypeCode",
    p."pitchTypeDescription",
    p."pitcherSplits",
    p."pitcherHotColdZones",
    p."pitchData",
    p."batterSplits",
    p."batterHotColdZones",
    p."hitData",
    p.runnerData,
    p."playStartTime",
    p."playEndTime",
    p."atBatStartTime",
    p."atBatEndTime",
    p."isTopInning",
    p."isPitch",
    p."isStrike",
    p."isBall",
    p."isAtBatComplete",
    p."isInPlay",
    p."isScoringPlay",
    p."isBatterOut",
    p."hasOutRecorded",
    p."atBatHasReview",
    p."hasReview",
    p."countBalls",
    p."countStrikes",
    p."countOuts",
    p."awayScore",
    p."homeScore",
    p."RBIs",
    CURRENT_TIMESTAMP,
    'manual'
from plays p;

/* pitch */
TRUNCATE TABLE baseball_aluminum.pitch;

WITH pitchData AS
    (
        SELECT
            p."gamePk",
            p."pitcherId",
            p."batterId",
            p."atBatId",
            p."batterPitchNumber",
            p."pitchTypeCode",
            p."pitchTypeDescription",
            (p."pitchData"->>'startSpeed')::NUMERIC                         AS "pitchStartSpeed",
            (p."pitchData"->>'endSpeed')::NUMERIC                           AS "pitchEndSpeed",
            (p."pitchData"->>'strikeZoneTop')::NUMERIC                      AS "strikeZoneTop",
            (p."pitchData"->>'strikeZoneBottom')::NUMERIC                   AS "strikeZoneBottom",
            (p."pitchData"->'coordinates')::JSON                            AS "strikeZoneCoordinates",
            (p."pitchData"->'breaks'->>'breakAngle')::NUMERIC               AS "breakAngle",
            (p."pitchData"->'breaks'->>'breakLength')::NUMERIC              AS "breakLength",
            (p."pitchData"->'breaks'->>'breakY')::NUMERIC                   AS "breakY",
            (p."pitchData"->'breaks'->>'breakVertical')::NUMERIC            AS "breakVertical",
            (p."pitchData"->'breaks'->>'breakVerticalInduced')::NUMERIC     AS "breakVerticalInduced",
            (p."pitchData"->'breaks'->>'breakHorizontal')::NUMERIC          AS "breakHorizontal",
            (p."pitchData"->'breaks'->>'spinRate')::INT                     AS "spinRate",
            (p."pitchData"->'breaks'->>'spinDirection')::INT                AS "spinDirection",
            (p."pitchData"->>'zone')::INT                                   AS zone,
            (p."pitchData"->>'typeConfidence')::NUMERIC                     AS "typeConfidence",
            (p."pitchData"->>'plateTime')::NUMERIC                          AS "plateTime",
            (p."pitchData"->>'extension')::NUMERIC                          AS extension
        FROM baseball_aluminum.play p
        WHERE p."isPitch"
    )
INSERT INTO baseball_aluminum.pitch ("gamePk", "pitcherId", "batterId", "atBatId", "pitchNumber", "pitchTypeCode", "pitchTypeDescription", "pitchStartSpeed", "pitchEndSpeed", "strikeZoneTop", "strikeZoneBottom", "strikeZoneCoordinates", "breakAngle", "breakLength", "breakY", "breakVertical", "breakVerticalInduced", "breakHorizontal", "spinRate", "spinDirection", zone, "typeConfidence", "plateTime", extension, "_dateCreated", "_createdBy")
    SELECT "gamePk",
           "pitcherId",
           "batterId",
           "atBatId",
           "batterPitchNumber",
           "pitchTypeCode",
           "pitchTypeDescription",
           "pitchStartSpeed",
           "pitchEndSpeed",
           "strikeZoneTop",
           "strikeZoneBottom",
           "strikeZoneCoordinates",
           "breakAngle",
           "breakLength",
           "breakY",
           "breakVertical",
           "breakVerticalInduced",
           "breakHorizontal",
           "spinRate",
           "spinDirection",
           "zone",
           "typeConfidence",
           "plateTime",
           "extension",
           CURRENT_TIMESTAMP,
           'manual'
    FROM pitchData;

/* Hit */
TRUNCATE TABLE baseball_aluminum.hit;

INSERT INTO baseball_aluminum.hit
    ("gamePk", "batterId", "pitcherId", "atBatId", "playIndex", "pitchNumber", "resultEventType",
     "resultEventDescription", "launchSpeed", "launchAngle", "totalDistance", trajectory, hardness, location,
     coordinates, "RBIs", "_createdAt", "_createdBy")
SELECT
            p."gamePk",
            p."batterId",
            p."pitcherId",
            p."atBatId",
            p."batterPlayIndex",
            p."batterPitchNumber",
            p."resultEventType",
            p."resultEventDescription",
            (p."HitData"->>'launchSpeed')::numeric      AS "launchSpeed",
            (p."HitData"->>'launchAngle')::NUMERIC      AS "launchAngle",
            (p."HitData"->>'totalDistance')::NUMERIC    AS "totalDistance",
            p."HitData"->>'trajectory'                  AS trajectory,
            p."HitData"->>'hardness'                    AS hardness,
            (p."HitData"->>'location')::INT             AS location,
            (p."HitData"->>'coordinates')::json         AS coordinates,
            (p."RBIs"),
            CURRENT_TIMESTAMP,
            'manual'
FROM baseball_aluminum.play p
WHERE p."isInPlay"; --only tracks when the ball is hit
