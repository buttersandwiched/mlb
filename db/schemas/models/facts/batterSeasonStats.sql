DROP VIEW IF EXISTS baseball_models."batterSeasonStats" cascade;
CREATE VIEW baseball_models."batterSeasonStats"
            (
                "batterId",
                "fullName",
                "teamId",
                "gamesPlayed",
                "atBats",
                hits,
                walks,
                strikeouts,
                homeruns,
                rbis,
                "battingAverage"
            )
AS
SELECT p."playerId"         AS "batterId",
       p."fullName",
       p."teamId",
       count(*)             AS "gamesPlayed",
       sum(pa."atBats")     AS "atBats",
       sum(pa.hits)         AS hits,
       sum(pa.walks)        AS walks,
       sum(pa.strikeouts)   AS strikeouts,
       sum(pa.homeruns)     AS homeruns,
       sum(pa.rbis)         AS rbis,
       CASE
           WHEN sum(pa."atBats") = 0 THEN 0
           ELSE sum(pa.hits) / sum(pa."atBats")
           END::numeric(4, 3) AS "battingAverage"
FROM baseball_models."playerBoxScore" pa
         JOIN baseball_models.player p ON pa."batterId" = p."playerId"
GROUP BY p."playerId", p."fullName", p."teamId";