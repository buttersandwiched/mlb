DROP VIEW IF EXISTS baseball_models."appearance" cascade;
CREATE VIEW baseball_models."appearance"
AS
with pitchMetrics as
(
    select
        "gameId",
        "pitcherId",
        sum("runsSurrendered") as "runsAllowed",
        (sum("isCutter")::numeric/count(*)::numeric)::numeric(3,2) as "cutterUseRate",
        (sum("isChangeup")::numeric/count(*)::numeric)::numeric(3,2) as "changeupUseRate",
        (sum("isCurveball")::numeric/count(*)::numeric)::numeric(3,2) as "curveballUseRate",
        (sum("isFastball")::numeric/count(*)::numeric)::numeric(3,2) as "fastballUseRate",
        (sum("isSinker")::numeric/count(*)::numeric)::numeric(3,2) as "sinkerUseRate",
        (sum("isSlider")::numeric/count(*)::numeric)::numeric(3,2) as "sliderUseRate",
        (sum("isSplitter")::numeric/count(*)::numeric)::numeric(3,2) as "splitterUseRate",
        (sum("isSweeper")::numeric/count(*)::numeric)::numeric(3,2) as "sweeperUseRate",
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
            (sum("outsRecorded") / 3.0)::numeric(3, 2)          as "inningsPitched",
            sum(bf.pitches)                                     as "pitchCount",
            sum(bf."isHit")                                     as hits,
            sum(bf."isStrikeout")                               as strikeouts,
            sum(bf."isWalk")                                    as walks,
            sum(bf."isHomeRun")                                 as homeruns,
            sum(bf."isDouble" + bf."isTriple" + bf."isHomeRun") as "extraBaseHits",
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
       pM."changeupUseRate",
       pM."cutterUseRate",
       pM."curveballUseRate",
       pM."fastballUseRate",
       pM."sliderUseRate",
       pM."sinkerUseRate",
       pM."splitterUseRate",
       pM."sweeperUseRate",
       pm."avgFastballVelo"::numeric(5,2),
       pm."avgChangeupVelo"::numeric(5,2),
       pM."avgCurveballVelo"::numeric(5,2),
       pM."avgSinkerVelo"::numeric(5,2),
       pM."avgSliderVelo"::numeric(5,2),
       pm."avgSweeperVelo"::numeric(5,2)
FROM pitchMetrics pM
    INNER JOIN pitcherMetrics mp on mp."gameId" = pM."gameId"
                                        and pM."pitcherId" = mp."pitcherId"