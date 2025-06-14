drop view if exists baseball_models."batterFaced" cascade;
create view baseball_models."batterFaced"
(
    "gameId",
    "pitcherId",
    "batterId",
    "atBatId",
    "gameDate",
    "atBatResult",
    "atBatResultDescription",
    "isBatterOut",
    "isStrikeout",
    "isHit",
    "isHomeRun",
    "isDouble",
    "isTriple",
    "isWalk",
    "isSacrifice",
    pitches,
    strikes,
    balls,
    "outsRecorded",
    "runs",
    "earnedRuns",
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
    with lastPitchOfAtBat as (
        select "gamePk",
               "atBatId",
               max("resultEvent")                  as "resultEvent",
               max("resultEventDescription")       as "resultEventDescription",
               max("batterPlayIndex")              as "lastPlayIndex"
        from baseball_platinum.play
        group by "atBatId", "gamePk"
    ),
    runnerMovement as (
        select
            g."gamePk",
            g."gameDate",
            p."fullName" as "pitcher",
            coalesce("responsiblePitcherId", y."pitcherId") as "pitcherId",
            y."atBatId",
            y."batterPlayIndex",
            sum(case when "isEarnedRun" then 1 else 0 end)
                + sum(case when "isUnearnedRun" then 1 else 0 end) as "runs",
            sum(case when "isEarnedRun" then 1 else 0 end) as "earnedRuns",
            (sum(case when "isOut" then 1 else 0 end) / 3.0)::numeric as "inningsPitched"
        from baseball_platinum.play y
            inner join baseball_platinum.runner r on y."gamePk" = r."gamePk"
                                                  and y."atBatId" = r."atBatId"
                                                  and y."batterPlayIndex" = r."batterPlayId"
                                                  and y."pitcherId" = coalesce("responsiblePitcherId", y."pitcherId")
            inner join baseball_platinum.game g on y."gamePk" = g."gamePk"
            inner join baseball_platinum.player p on p."playerId" = coalesce("responsiblePitcherId", y."pitcherId")
            group by g."gamePk", g."gameDate", coalesce("responsiblePitcherId", y."pitcherId"), p."fullName", y."atBatId", y."batterPlayIndex"
    )

select p."gameId",
       p."pitcherId",
       p."batterId",
       p."atBatId",
       g."officialGameTime" as "gameDate",
       max(ab."resultEvent") as "result",
       max(ab."resultEventDescription") as "resultDescription",
       max(
            case
                when p."isBatterOut" then 1
                else 0
                end
       )    as "isBatterOut",
       max(
            case
                when p."playCall" like '%strikeout%' then 1
                else 0
                end
       )  "isStrikeout",
       max(
            case
                when   p."playCall" like '% single'
                    or p."playCall" like '% double'
                    or p."playCall" like '% triple'
                    or p."playCall" like '% home_run' then 1
                else 0
                end
       ) as "isHit",
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
       max("pitchIndex")                                                                as "numPitches",
       sum(
            case
                when p."isStrike" then 1
                else 0
                end
       )                                                                                as strikes,
       sum(
            case
                when p."isBall" then 1
                else 0
                end
       )                                                                                as balls,
       sum(p."outsRecorded")                                                            as "outsRecorded",
       sum(rM."runs")                                                                   as "runs",
       sum(rM."earnedRuns")                                                             as "earnedRuns",
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
      min(case when "isChangeup" = 1 then "pitchStartSpeed" end)                        as "minChangeUpSpeed",
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
from baseball_models.pitch p
    inner join baseball_models.game g on p."gameId" = g."gameId"
    left join runnerMovement rM on rm."gamePk" = g."gameId"
                                 and rm."atBatId" = p."atBatId"
                                 and rM."batterPlayIndex" = p."batterPlayIndex"
                                 and rM."pitcherId" = p."pitcherId"
    left join lastPitchOfAtBat ab on ab."gamePk" = p."gameId"
                                  and ab."atBatId" = p."atBatId"
                                  and ab."lastPlayIndex" = p."batterPlayIndex"
group by p."gameId", g."officialGameTime", p."pitcherId",p."batterId", p."atBatId";

select "gameId", "gameDate", "pitcherId",
       sum(runs) as runs,
       sum("earnedRuns") as "earnedRuns",
       sum("isHit") as hits
from baseball_models."batterFaced" bf
inner join baseball_platinum.player p on bf."pitcherId" = p."playerId"
where "fullName" = 'Paul Skenes'
group by "pitcherId", "gameId", "gameDate"
order by "gameDate";