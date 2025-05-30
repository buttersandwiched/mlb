CREATE TABLE baseball_aluminum.hit
(
    "hitPk" BIGSERIAL PRIMARY KEY ,
    "gamePk" INT,
    "batterId" INT,
    "pitcherId" INT,
    "atBatId" INT,
    "playIndex" INT,
    "pitchNumber" INT,
    "resultEventType" TEXT,
    "resultEventDescription" TEXT,
    "launchSpeed" NUMERIC,
    "launchAngle" NUMERIC,
    "totalDistance" NUMERIC,
    trajectory TEXT,
    hardness  TEXT,
    location    INT,
    coordinates JSON,
    "RBIs" INT,
    "_createdAt"  TIMESTAMP,
    "_createdBy" TEXT
);

SELECT
    "batterId",
    p.full_name,
    SUM(CASE WHEN "resultEventType"  in ('single', 'double', 'triple', 'home_run') then 1 ELSE 0 end) as hits,
    SUM("RBIs")  as "RBIs",
    SUM(CASE WHEN "resultEventType" in ('home_run') then 1 ELSE 0 END) as homeruns,
    SUM(CASE WHEN "resultEventType"  in ('triple') then 1 ELSE 0 end) as triples,
    SUM(CASE WHEN "resultEventType"  in ('double') then 1 ELSE 0 end) as doubles,
    SUM(CASE WHEN "resultEventType"  in ('single') then 1 ELSE 0 end) as singles,
    MAX("totalDistance") "farthestHit"
FROM baseball_aluminum.hit h
inner join baseball_platinum.players p on h."batterId" = p.player_id
GROUP BY "batterId", p.full_name
order by 9 desc;
