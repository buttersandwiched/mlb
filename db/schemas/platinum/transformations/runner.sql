MERGE INTO baseball_platinum.runner  target
USING baseball_aluminum.runner as source
ON source."runnerId" = target."runnerId"
    and source."gamePk" = target."gamePk"
    and source."atBatId" = target."atBatId"
    and source."batterPlayId" = target."batterPlayId"
WHEN MATCHED THEN
    UPDATE SET
               "eventType"              = source."eventType",
               "originBase"             = source."originBase",
               "startBase"              = source."startBase",
               "endBase"                = source."endBase",
               "outBase"                = source."outBase",
               "outNumber"              = source."outNumber",
               "isStolenBase"           = source."isStolenBase",
               "isEarnedRun"            = source."isEarnedRun",
               "isUnearnedRun"          = source."isUnearnedRun",
               "isRBI"                  = source."isRBI",
               "isOut"                  = source."isOut",
               "isCaughtStealing"       = source."isCaughtStealing",
               "_updatedAt"             = CURRENT_TIMESTAMP
WHEN NOT MATCHED THEN
INSERT ("gamePk",
        "runnerId",
        "pitcherId",
        "responsiblePitcherId",
        "postOnFirstId",
        "postOnSecondId",
        "postOnThirdId",
        "atBatId",
        "batterPlayId",
        "eventType",
        "originBase",
        "startBase",
        "endBase",
        "outBase",
        "outNumber",
        "isStolenBase",
        "isCaughtStealing",
        "isOut",
        "isRBI",
        "isEarnedRun",
        "isUnearnedRun",
        "_createdAt",
        "_updatedAt")
VALUES (
        source."gamePk",
        source."runnerId",
        source."pitcherId",
        source."responsiblePitcherId",
        source."postOnFirstId",
        source."postOnSecondId",
        source."postOnThirdId",
        source."atBatId",
        source."batterPlayId",
        source."eventType",
        source."originBase",
        source."startBase",
        source."endBase",
        source."outBase",
        source."outNumber",
        source."isStolenBase",
        source."isCaughtStealing",
        source."isOut",
        source."isRBI",
        source."isEarnedRun",
        source."isUnearnedRun",
        current_timestamp,
        current_timestamp
       );