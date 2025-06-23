DROP VIEW IF EXISTS baseball_models."plateAppearance" CASCADE ;

CREATE VIEW baseball_models."plateAppearance"
            (
                "gameDate",
                "awayTeamId",
                "homeTeamId",
                "gameId",
                "batterId",
                "pitcherId",
                "awayTeam",
                "homeTeam",
                "batter",
                "pitcher",
                inning,
                rbis,
                "isHomerun",
                "isStrikeout",
                "isWalk",
                "isHit",
                "isAtBat",
                "batterFantasyPoints",
                "pitcherFantasyPoints"
            )
AS
SELECT g."officialGameDate" AS "gameDate",
       g."awayTeamId"       AS "awayTeamId",
       g."homeTeamId"       AS "homeTeamId",
       p."gamePk"           AS "gameId",
       p."batterId"         AS "batterId",
       p."pitcherId"        AS "pitcherId",
       t."teamName"         AS "awayTeam",
       t2."teamName"        AS "homeTeam",
       b."fullName"         AS "batter",
       r."fullName"         AS "pitcher",
       p.inning             AS inning,
       MAX(p."RBIs")        AS rbis,
       MAX(
            CASE
                WHEN p."resultEvent" = 'Home Run' THEN 1
                ELSE 0
                END
        )                   AS "isHomerun",
       MAX(
               CASE
                   WHEN p."resultEvent"::text ~~ 'Strikeout%'::text THEN 1
                   ELSE 0
                   END)     AS "isStrikeout",
       MAX(
               CASE
                   WHEN p."resultEvent"::text = ANY
                        (ARRAY ['Walk'::character varying, 'Intent Walk'::character varying]::text[]) THEN 1
                   ELSE 0
                   END)     AS "isWalk",
       max(
               CASE
                   WHEN p."resultEvent"::text = ANY
                        (ARRAY ['Double'::character varying, 'Home Run'::character varying, 'Single'::character varying, 'Triple'::character varying]::text[])
                       THEN 1
                   ELSE 0
                   END)     AS "isHit",
       max(
               CASE
                   WHEN p."resultEvent"::text ~~ 'Sac %'::text OR (p."resultEvent"::text = ANY
                                                                  (ARRAY ['Walk'::character varying, 'Intent Walk'::character varying]::text[]))
                       THEN 0
                   ELSE 1
                   END)     AS "isAtBat",
    MAX(p."RBIs"
            + CASE
                        WHEN p."resultEvent" like 'Strikeout%' then -1
                        WHEN p."resultEvent" in ('Walk', 'Single', 'Intent Walk', 'Hit By Pitch') THEN 1
                        WHEN p."resultEvent" = 'Double' then 2
                        WHEN p."resultEvent" = 'Triple' then 3
                        WHEN p."resultEvent" = 'Home Run' THEN 4
                        ELSE 0
                    END),
    MAX(
               CASE WHEN p."isBatterOut" or p."hasOutRecorded" then 0.33 ELSE 0 END
                + CASE
                    WHEN p."resultEvent" like 'Strikeout%' then 1
                    WHEN p."resultEvent" = 'Hit By Pitch' then -1
                    WHEN p."resultEvent" in ('Walk', 'Intent Walk', 'Single', 'Double', 'Triple', 'Home Run') then -0.5
                    ELSE 0
                    END
                - p."RBIs"
    )
FROM baseball_platinum.play p
    JOIN baseball_platinum.game g ON g."gamePk" = p."gamePk"
    JOIN baseball_platinum.team t on t."teamId" = g."homeTeamId"
    JOIN baseball_platinum.team t2 on t2."teamId" = g."awayTeamId"
    JOIN baseball_platinum.player b on b."playerId" = p."batterId"
    JOIN baseball_platinum.player r on r."playerId" = p."pitcherId"
GROUP BY g."officialGameDate",
         g."awayTeamId",
         g."homeTeamId",
         p."gamePk",
         p."batterId",
         p."pitcherId",
         t."teamName",
         t2."teamName",
         b."fullName",
         r."fullName",
         p.inning
ORDER BY g."officialGameDate", p."gamePk";

Select *
from baseball_models."plateAppearance"
