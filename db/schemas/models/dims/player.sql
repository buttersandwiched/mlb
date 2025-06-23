DROP VIEW IF EXISTS baseball_models.player ;
CREATE VIEW baseball_models.player as
SELECT
    "playerId",
    t."teamId",
    t."teamName",
    "fullName",
    p."primaryPositionAbbreviation" as "position",
    p."batSideCode" as "batSide",
    p."primaryNumber" as "number",
    "age",
    "mlbDebutDate"
FROM  baseball_platinum.player p
    INNER JOIN baseball_platinum.team t on p."teamId" = t."teamId";


CREATE VIEW baseball_models.team
as SELECT *
FROM baseball_platinum.team