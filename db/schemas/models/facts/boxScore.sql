DROP VIEW IF EXISTS baseball_models."playerBoxScore" CASCADE;
CREATE VIEW baseball_models."playerBoxScore"
            (
                "gameDate",
                "gameId",
                "awayTeamId",
                "homeTeamId",
                "batterId",
                "avg",
                hits,
                "atBats",
                rbis,
                walks,
                strikeouts,
                homeruns
            )
    AS
    SELECT "gameDate"::DATE,
           "gameId",
           "awayTeamId",
           "homeTeamId",
           "batterId"                               AS "batterId",
           CASE
               WHEN SUM("isAtBat") = 0 then 0.000
               ELSE (
                     SUM("isHit")::numeric(4,3) /
                     SUM("isAtBat"):: numeric(4,3)
                    )::numeric(4,3)
               END                                  AS "avg",
           sum("isHit")                             AS hits,
           sum("isAtBat")                           AS "atBats",
           sum(rbis)                                AS rbis,
           sum("isWalk")                            AS walks,
           sum("isStrikeout")                       AS strikeouts,
           sum("isHomerun")                         AS homeruns
    FROM baseball_models."plateAppearance"
    GROUP BY "gameDate", "gameId", "awayTeamId", "homeTeamId", "batterId"
    ORDER BY "gameDate" DESC, "batterId";

SELECT "gameDate", "awayTeamId", "homeTeamId", "gameId", "batterId", "rbis", "strikeouts", "walks", "hits", "atBats", "homeruns" FROM "baseball_models"."playerBoxScore" AS "PlayerBoxScore" WHERE "PlayerBoxScore"."batterId" = '596146';

