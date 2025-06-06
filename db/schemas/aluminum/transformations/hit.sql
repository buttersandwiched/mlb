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


SELECT *
FROM baseball_aluminum.hit