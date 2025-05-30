CREATE table baseball_aluminum.pitch
(
    "pitchPk"          BIGSERIAL PRIMARY KEY,
    "gamePk"                INT,
    "pitcherId"             INT,
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
\

SELECT *
FROM baseball_aluminum.pitch;

SELECT DISTINCT "pitchTypeCode", "pitchTypeDescription"
from baseball_aluminum.pitch;

Select
    "pitcherId",
    count(*) as "pitchCount",
    SUM(CASE WHEN "pitchTypeCode" = 'FF' THEN 1 ELSE 0 END) AS "Four-Seam-Fastball",
    SUM(CASE WHEN "pitchTypeCode" = 'SI' THEN 1 ELSE 0 END) AS "Sinker",
    SUM(CASE WHEN "pitchTypeCode" = 'SL' THEN 1 ELSE 0 END) AS "Slider",
    SUM(CASE WHEN "pitchTypeCode" = 'FC' THEN 1 ELSE 0 END) AS "Cutter",
    SUM(CASE WHEN "pitchTypeCode" = 'KC' THEN 1 ELSE 0 END) AS "Knuckle-Curve",
    SUM(CASE WHEN "pitchTypeCode" = 'EP' THEN 1 ELSE 0 END) AS "Eephus",
    SUM(CASE WHEN "pitchTypeCode" = 'FA' THEN 1 ELSE 0 END) AS "Fastball",
    SUM(CASE WHEN "pitchTypeCode" = 'CU' THEN 1 ELSE 0 END) AS "Curveball",
    SUM(CASE WHEN "pitchTypeCode" = 'SV' THEN 1 ELSE 0 END) AS "Slurve",
    SUM(CASE WHEN "pitchTypeCode" = 'CS' THEN 1 ELSE 0 END )AS "Slow-Curve",
    SUM(CASE WHEN "pitchTypeCode" = 'FO' THEN 1 ELSE 0 END) AS "Forkball",
    SUM(CASE WHEN "pitchTypeCode" = 'CH' THEN 1 ELSE 0 END) AS "Changeup",
    SUM(CASE WHEN "pitchTypeCode" = 'FS' THEN 1 ELSE 0 END) AS "Splitter",
    SUM(CASE WHEN "pitchTypeCode" = 'ST' THEN 1 ELSE 0 END) AS "Sweeper",
    SUM(CASE WHEN "pitchTypeCode" = 'SC' THEN 1 ELSE 0 END) AS "Screwball"
FROM baseball_aluminum.pitch
GROUP by "pitcherId"
order by 2 desc