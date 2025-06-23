create view baseball_models."pitchStats"
            ("pitcherId", "pitcherName", pitches, strikes, balls, "swingingStrikes", "calledStrikes", "foulBalls",
             "percentChangeups", "avgChangeupSpeed", "percentCurveballs", "avgCurveballSpeed", "percentCutters",
             "avgCutterSpeed", "percentFastballs", "avgFastballSpeed", "percentSinkers", "avgSinkerSpeed",
             "percentSliders", "avgSliderSpeed", "percentSweepers", "avgSweeperSpeed", "percentSplitters",
             "avgSplitterSpeed")
as
SELECT t."pitcherId",
       p."fullName"                                                       AS "pitcherName",
       count(*)                                                           AS pitches,
       sum(
               CASE
                   WHEN t."isStrike" THEN 1
                   ELSE 0
                   END)                                                   AS strikes,
       sum(
               CASE
                   WHEN t."isBall" THEN 1
                   ELSE 0
                   END)                                                   AS balls,
       sum(
               CASE
                   WHEN t."playCall" ~~ '%Swinging Strike%'::text THEN 1
                   ELSE 0
                   END)                                                   AS "swingingStrikes",
       sum(
               CASE
                   WHEN t."playCall" ~~ '%Called Strike%'::text THEN 1
                   ELSE 0
                   END)                                                   AS "calledStrikes",
       sum(
               CASE
                   WHEN t."playCall" ~~ '%Foul%'::text THEN 1
                   ELSE 0
                   END)                                                   AS "foulBalls",
       (sum(t."isChangeup")::numeric / count(*)::numeric)::numeric(4, 3)  AS "percentChangeups",
       avg(
               CASE
                   WHEN t."isChangeup" = 1 THEN t."pitchStartSpeed"::numeric
                   ELSE NULL::numeric
                   END)::numeric(4, 1)                                    AS "avgChangeupSpeed",
       (sum(t."isCurveball")::numeric / count(*)::numeric)::numeric(3, 2) AS "percentCurveballs",
       avg(
               CASE
                   WHEN t."isCurveball" = 1 THEN t."pitchStartSpeed"::numeric
                   ELSE NULL::numeric
                   END)::numeric(4, 1)                                    AS "avgCurveballSpeed",
       (sum(t."isCutter")::numeric / count(*)::numeric)::numeric(3, 2)    AS "percentCutters",
       avg(
               CASE
                   WHEN t."isCutter" = 1 THEN t."pitchStartSpeed"::numeric
                   ELSE NULL::numeric
                   END)::numeric(4, 1)                                    AS "avgCutterSpeed",
       (sum(t."isFastball")::numeric / count(*)::numeric)::numeric(3, 2)  AS "percentFastballs",
       avg(
               CASE
                   WHEN t."isFastball" = 1 THEN t."pitchStartSpeed"::numeric
                   ELSE NULL::numeric
                   END)::numeric(4, 1)                                    AS "avgFastballSpeed",
       (sum(t."isSinker")::numeric / count(*)::numeric)::numeric(3, 2)    AS "percentSinkers",
       avg(
               CASE
                   WHEN t."isSinker" = 1 THEN t."pitchStartSpeed"::numeric
                   ELSE NULL::numeric
                   END)::numeric(4, 1)                                    AS "avgSinkerSpeed",
       (sum(t."isSlider")::numeric / count(*)::numeric)::numeric(3, 2)    AS "percentSliders",
       avg(
               CASE
                   WHEN t."isSlider" = 1 THEN t."pitchStartSpeed"::numeric
                   ELSE NULL::numeric
                   END)::numeric(4, 1)                                    AS "avgSliderSpeed",
       (sum(t."isSweeper")::numeric / count(*)::numeric)::numeric(3, 2)   AS "percentSweepers",
       avg(
               CASE
                   WHEN t."isSweeper" = 1 THEN t."pitchStartSpeed"::numeric
                   ELSE NULL::numeric
                   END)::numeric(4, 1)                                    AS "avgSweeperSpeed",
       (sum(t."isSplitter")::numeric / count(*)::numeric)::numeric(3, 2)  AS "percentSplitters",
       avg(
               CASE
                   WHEN t."isSplitter" = 1 THEN t."pitchStartSpeed"::numeric
                   ELSE NULL::numeric
                   END)::numeric(4, 1)                                    AS "avgSplitterSpeed"
FROM baseball_models.pitch t
         JOIN baseball_models.player p ON t."pitcherId" = p."playerId"
WHERE t."playCode" <> ALL (ARRAY ['PS0'::text, 'PS1'::text, 'PS2'::text, 'PS3'::text, '1'::text, '2'::text, '3'::text])
GROUP BY t."pitcherId", p."fullName";
