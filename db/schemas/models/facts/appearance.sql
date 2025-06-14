DROP VIEW IF EXISTS baseball_models."appearance" cascade;
CREATE VIEW baseball_models."appearance"
AS
with pitchMetrics as
(
    select
        "gameId",
        "pitcherId",
        sum("runsSurrendered") as "runsAllowed",
        sum("earnedRuns") as "earnedRuns",
        sum("unearnedRuns") as "unEarnedRuns",
        sum("stolenBases")  as "stolenBases",
        sum("caughtStealing") as "caughtStealing",
        (sum("isCutter")::numeric/count(*)::numeric)::numeric(3,2) as "percentCutter",
        (sum("isChangeup")::numeric/count(*)::numeric)::numeric(3,2) as "percentChangeup",
        (sum("isCurveball")::numeric/count(*)::numeric)::numeric(3,2) as "percentCurveball",
        (sum("isFastball")::numeric/count(*)::numeric)::numeric(3,2) as "percentFastball",
        (sum("isSinker")::numeric/count(*)::numeric)::numeric(3,2) as "percentSinker",
        (sum("isSlider")::numeric/count(*)::numeric)::numeric(3,2) as "percentSlider",
        (sum("isSplitter")::numeric/count(*)::numeric)::numeric(3,2) as "percentSplitter",
        (sum("isSweeper")::numeric/count(*)::numeric)::numeric(3,2) as "percentSweeper",
        max("pitchStartSpeed"::numeric) as "fastestPitchSpeed",
        avg(case when "isChangeup"  = 1 then "pitchStartSpeed"::numeric end) as "avgChangeupVelo",
        avg(case when "isCurveball" = 1 then "pitchStartSpeed"::numeric end) as "avgCurveballVelo",
        avg(case when "isCutter"    = 1 then "pitchStartSpeed"::numeric end) as "avgCutterVelo",
        avg(case when "isFastball"  = 1 then "pitchStartSpeed"::numeric end) as "avgFastballVelo",
        avg(case when "isSinker"    = 1 then "pitchStartSpeed"::numeric end) as "avgSinkerVelo",
        avg(case when "isSlider"    = 1 then "pitchStartSpeed"::numeric end) as "avgSliderVelo",
        avg(case when "isSweeper"   = 1 then "pitchStartSpeed"::numeric end) as "avgSweeperVelo"
    from baseball_models.pitch
    group by "gameId", "pitcherId"
),
pitcherMetrics as
    (
    Select bF."gameId",
            bF."pitcherId",
            "gameDate",
            py."fullName",
            t."teamName",
            count(*)                                            as "battersFaced",
            sum(case
                    when bf."isWalk" = 1
                        or bf."isSacrifice" = 1 then 0
                    else 1 end)                                 as "atBats",
            (sum("outsRecorded")/ 3.0)::numeric(5,2)            as "inningsPitched",
            sum(bf.pitches)                                     as "pitchCount",
            sum(bf."isHit")                                     as hits,
            sum(bf."isStrikeout")                               as strikeouts,
            sum(bf."isWalk")                                    as walks,
            sum(bf."isHomeRun")                                 as homeruns,
            sum(bf."isDouble" + bf."isTriple" + bf."isHomeRun") as "extraBaseHits",
            sum("isSacrifice")                                  as "sacrifices",
            sum(bf."numChangeUps")                              as "numChangeups",
            sum(bf."numCurveballs")                             as "numCurveballs",
            sum(bf."numCutters")                                as "numCutters",
            sum(bf."numFastBalls")                              as "numFastBalls",
            sum(bf."numSinkers")                                as "numSinkers",
            sum(bf."numSliders")                                as "numSliders",
            sum(bf."numSplitters")                              as "numSplitters",
            sum(bf."numSweepers")                               as "numSweepers",
            case
                when count(*) - sum(bf."isWalk") - sum(bf."isSacrifice") = 0 then 0.000
                else (sum("isHit")::numeric(3, 1) /
                      (count(*) - sum(bf."isWalk") - sum(bf."isSacrifice"))::numeric(3, 1))::numeric(4, 3)
                end                                             as "opponentBattingAvg"
     from baseball_models."batterFaced" bF
              inner join baseball_platinum.player py on bf."pitcherId" = py."playerId"
              inner join baseball_platinum.team t on py."teamId" = t."teamId"
     group by py."fullName", bF."pitcherId", "gameDate", bF."gameId", t."teamName"
     )
SELECT mp.*,
       pM."runsAllowed",
       pM."earnedRuns",
       pM."unEarnedRuns",
       pM."stolenBases",
       pm."caughtStealing",
       pM."percentChangeup",
       pM."percentCutter",
       pM."percentCurveball",
       pM."percentFastball",
       pM."percentSlider",
       pM."percentSinker",
       pM."percentSplitter",
       pM."percentSweeper",
       pM."fastestPitchSpeed",
       pm."avgFastballVelo"::numeric(5,2),
       pm."avgChangeupVelo"::numeric(5,2),
       pM."avgCurveballVelo"::numeric(5,2),
       pM."avgSinkerVelo"::numeric(5,2),
       pM."avgSliderVelo"::numeric(5,2),
       pm."avgSweeperVelo"::numeric(5,2)
FROM pitchMetrics pM
    INNER JOIN pitcherMetrics mp on mp."gameId" = pM."gameId"
                                        and pM."pitcherId" = mp."pitcherId";

select *
from baseball_models.appearance
order by "fastestPitchSpeed" desc