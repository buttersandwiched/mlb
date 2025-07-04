MERGE INTO baseball_platinum.play target
USING baseball_aluminum.play as source
ON source."playPk" = target."playPk"
WHEN MATCHED THEN
    UPDATE SET "RBIs" = source."RBIs"
WHEN NOT MATCHED THEN
INSERT ("gamePk",
        "atBatId",
        "pitcherId",
        "batterId",
        "postOnFirstId",
        "postOnSecondId",
        "postOnThirdId",
        "batterPlayIndex",
        "playId",
        "batterPitchNumber",
        "captivatingIndex",
        "inning",
        "halfInning",
        "resultType",
        "resultEvent",
        "resultEventType",
        "resultEventDescription",
        "playCallCode",
        "playCallDescription",
        "playCode",
        "playDescription",
        "pitchTypeCode",
        "pitchTypeDescription",
        "pitcherSplits",
        "pitcherHotColdZones",
        "pitchData",
        "batterSplits",
        "batterHotColdZones",
        "hitData",
        "runnerData",
        "atBatStartTime",
        "atBatEndTime",
        "playStartTime",
        "playEndTime",
        "isTopInning",
        "isPitch",
        "isStrike",
        "isBall",
        "isAtBatComplete",
        "isInPlay",
        "isScoringPlay",
        "isBatterOut",
        "hasOutRecorded",
        "atBatHasReview",
        "hasReview",
        "countBalls",
        "countStrikes",
        "countOuts",
        "awayScore",
        "homeScore",
        "RBIs" ,
        "_createdAt",
        "_createdBy"
)
VALUES (
        source."gamePk",
        source."atBatId",
        source."pitcherId",
        source."batterId",
        source."postOnFirstId",
        source."postOnSecondId",
        source."postOnThirdId",
        source."batterPlayIndex",
        source."playId",
        source."batterPitchNumber",
        source."captivatingIndex",
        source.inning,
        source."halfInning",
        source."resultType",
        source."resultEvent",
        source."resultEventType",
        source."resultEventDescription",
        source."playCallCode",
        source."playCallDescription",
        source."playCode",
        source."playDescription",
        source."pitchTypeCode",
        source."pitchTypeDescription",
        source."pitcherSplits",
        source."pitcherHotColdZones",
        source."pitchData",
        source."batterSplits",
        source."batterHotColdZones",
        source."HitData",
        source."runnerData",
        source."atBatStartTime",
        source."atBatEndTime",
        source."playStartTime",
        source."playEndTime",
        source."isTopInning",
        source."isPitch",
        source."isStrike",
        source."isBall",
        source."isAtBatComplete",
        source."isInPlay",
        source."isScoringPlay",
        source."isBatterOut",
        source."hasOutRecorded",
        source."atBatHasReview",
        source."hasReview",
        source."countBalls",
        source."countStrikes",
        source."countOuts",
        source."awayScore",
        source."homeScore",
        source."RBIs",
        CURRENT_TIMESTAMP,
        'manual'
       );

SELECT *
FROM baseball_platinum.play
order by "gamePk" desc
