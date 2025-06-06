drop view if exists baseball_models."batterFaced" cascade;
create view baseball_models."batterFaced"
(
    "gameId",
    "pitcherId",
    "atBatId",
    "gameDate",
    "atBatResult",
    "isBatterOut",
    "isStrikeout",
    "isHit",
    "isHomeRun",
    "isDouble",
    "isTriple",
    "isWalk",
    "isSacrifice",
    "outsRecorded",
    "runnersOn",
    "runnersInScoringPosition",
    pitches,
    strikes,
    balls,
    "runsAllowed",
    "earnedRunsAllowed",
    "numChangeUps",
    "numCutters",
    "numCurveballs",
    "numFastBalls",
    "numSliders",
    "numSinkers",
    "numSplitters",
    "numSweepers",
    "avgChangeUpSpeed",
    "minChangeUpSpeed",
    "maxChangeUpSpeed",
    "avgCurveballSpeed",
    "minCurveballSpeed",
    "maxCurveballSpeed",
    "avgCutterSpeed",
    "minCutterSpeed",
    "maxCutterSpeed",
    "avgFastballSpeed",
    "minFastballSpeed",
    "maxFastballSpeed",
    "avgSinkerSpeed",
    "minSinkerSpeed",
    "maxSinkerSpeed",
    "avgSliderSpeed",
    "minSliderSpeed",
    "maxSliderSpeed",
    "avgSplitterSpeed",
    "minSplitterSpeed",
    "maxSplitterSpeed",
    "avgSweeperSpeed",
    "minSweeperSpeed",
    "maxSweeperSpeed"
    )
as
select p."gameId"                       as "gameId",
       p."pitcherId"                    as "pitcherId",
       p."atBatId"                      as "atBatId",
       p."gameDate"                     as "gameDate",
       NULL                             as "atBatResult",
       max(
            case
                when p."isBatterOut" then 1
                else 0
                end
       )                                                                                as "isBatterOut",
       max(
            case
                when p."playCall" like 'strikeout%' then 1
                else 0
                end
       )                                                                                as "isStrikeout",
       max(
            case
                when p."playCall" like '%single'
                    or p."playCall" like '%double'
                    or p."playCall" like '%triple'
                    or p."playCall" like '%home_run' then 1
                else 0
                end
       )                                                                                as "isHit",
       max(
            CASE
                WHEN p."playCall"::text like '%home_run' THEN 1
                ELSE 0
                END
       )                                                                                as "isHomerun",
        max(
            case
                when p."playCall" like '%double'  then 1
                else 0
                end
       )                                                                                as "isDouble",
       max(
            case
                when p."playCall" like '%triple'  then 1
                else 0
                end
       )                                                                                as "isTriple",
       max(
            case
                when p."playCall" like '%walk'
                     or p."playCall" like '%hit_by_pitch%' then 1
                else 0
                end
       )                                                                                as "isWalk",
       max(
            case
                when p."playCall" like '%sac%'  then 1
                else 0
                end
       )                                                                                as "isSacrifice",
       sum(p."outsRecorded")                                                            as "outsRecorded",
       NULL                                                                             as "runnersOn",
       NULL                                                                             as "runnersInScoringPosition",
       count(*)                                                                         as pitches,
       sum(
            case
                when p."isStrike" then 1
                else 0
                end
       )                                                                                as strikes,
       sum(
            case when p."isBall" then 1
                 else 0
                 end
       )                                                                                as balls,
       sum(p."runsSurrendered")                                                         as "runsAllowed",
       0                                                                                as "earnedRunsAllowed",
       sum("isChangeup")                                                                as "numChangeups",
       sum("isCurveball")                                                               as "numCurveballs",
       sum("isCutter")                                                                  as "numCutters",
       sum("isFastball")                                                                as "numFastballs",
       sum("isSlider")                                                                  as "numSliders",
       sum("isSinker")                                                                  as "numSinkers",
       sum("isSplitter")                                                                as "numSplitters",
       sum("isSweeper")                                                                 as "numSweepers",
       case when sum("isChangeup") = 0 then NULL
            else sum( case when "isChangeup" = 1 then "pitchStartSpeed"::numeric end)
                     / sum(case when "isChangeup" = 1 then 1 end)
            end::numeric(4,1)                                                           as "avgChangeUpSpeed",
      min(case when "isChangeup" = 1 then "pitchStartSpeed" end)                        as minChangeUpSpeed,
      max(case when "isChangeup" = 1 then "pitchStartSpeed" end)                        as maxChangeUpSpeed,
      case when sum("isCurveball") = 0 then NULL
            else sum(case when "isCurveball" = 1 then "pitchStartSpeed"::numeric end)
                 / sum(case when "isCurveball" = 1 then 1 end)
            end::numeric(4,1)                                                           as "avgCurveballSpeed",
      min(case when "isCurveball" = 1 then "pitchStartSpeed" end)                       as minCurveballSpeed,
      max(case when "isCurveball" = 1 then "pitchStartSpeed" end)                       as maxCurveballSpeed,
      case when sum("isCutter") = 0 then NULL
            else   sum(case when "isCutter" = 1 then "pitchStartSpeed"::numeric end)
                 / sum(case when "isCutter" = 1 then 1 end)
            end::numeric(4,1)                                                           as "avgCutterSpeed",
      min(case when "isCutter" = 1 then "pitchStartSpeed" end)                          as minCutterSpeed,
      max(case when "isCutter" = 1 then "pitchStartSpeed" end)                          as maxCutterSpeed,
      case when sum("isFastball") = 0 then NULL
            else   sum(case when "isFastball" = 1 then "pitchStartSpeed"::numeric end)
                 / sum(case when "isFastball" = 1 then 1 end)
            end::numeric(4,1)                                                           as "avgFastballSpeed",
      min(case when "isFastball" = 1 then "pitchStartSpeed" end)                        as "minFastballSpeed",
      max(case when "isFastball" = 1 then "pitchStartSpeed" end)                        as "maxFastballSpeed",
      case when sum("isSinker") = 0 then NULL
            else   sum(case when "isSinker" = 1 then "pitchStartSpeed"::numeric end)
                 / sum(case when "isSinker" = 1 then 1 end)
            end::numeric(4,1)                                                           as "avgSinkerSpeed",
      min(case when "isSinker" = 1 then "pitchStartSpeed" end)                          as "minSinkerSpeed",
      max(case when "isSinker" = 1 then "pitchStartSpeed" end)                          as "maxSinkerSpeed",
      case when sum("isSlider") = 0 then NULL
            else   sum(case when "isSlider" = 1 then "pitchStartSpeed"::numeric end)
                 / sum(case when "isSlider" = 1 then 1 end)
            end::numeric(4,1)                                                           as "avgSliderSpeed",
      min(case when "isSlider" = 1 then "pitchStartSpeed" end)                          as "minSliderSpeed",
      max(case when "isSlider" = 1 then "pitchStartSpeed" end)                          as "maxSliderSpeed",
      case when sum("isSplitter") = 0 then NULL
            else   sum(case when "isSplitter" = 1 then "pitchStartSpeed"::numeric end)
                 / sum(case when "isSplitter" = 1 then 1 end)
            end::numeric(4,1)                                                           as "avgSplitterSpeed",
      min(case when "isSplitter" = 1 then "pitchStartSpeed" end)                        as "minSplitterSpeed",
      max(case when "isSplitter" = 1 then "pitchStartSpeed" end)                        as "maxSplitterSpeed",
      case when sum("isSweeper") = 0 then NULL
            else   sum(case when "isSweeper" = 1 then "pitchStartSpeed"::numeric end)
                 / sum(case when "isSweeper" = 1 then 1 end)
            end::numeric(4,1)                                                           as "avgSweeperSpeed",
      min(case when "isSweeper" = 1 then "pitchStartSpeed" end)                         as "minSweeperSpeed",
      max(case when "isSweeper" = 1 then "pitchStartSpeed" end)                         as "maxSweeperSpeed"
FROM baseball_models.pitch p
GROUP BY  "gameId",
    "pitcherId",
    "atBatId",
    "gameDate";


select *
from baseball_models.pitch p
where p."playCall" like '%auto%'

