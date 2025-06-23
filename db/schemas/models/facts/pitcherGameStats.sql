/* This view gives the results of every play involving the movement of a runner.

   Movement is defined as attempting to advance to another base.
   (Note: The batter is always considered a runner if it's the final play of the at-bat)
   each row indicates the advancement of each runner (including batter) on each base

   Metrics: earned runs, unearned runs, whether the runner is out or not
   Future enhancements: pickoffs, caught stealing, stolen bases

   Key Columns:
        - responsiblePitcherId indicates who the un/earned run is assigned to
        - pitcherId indicates the pitcher on the mound at time of the play
 */
DROP VIEW IF EXISTS baseball_models.movement cascade ;
CREATE VIEW baseball_models.movement
AS
Select
       g."gamePk",
       p."pitcherId",
       r."responsiblePitcherId",
       p."batterId",
       r."atBatId",
       r."batterPlayId",
       p."postOnFirstId",
       p."postOnSecondId",
       p."postOnThirdId",
       r."runnerId",
       "gameDate",
       t2."teamName"                as "awayTeam",
       t."teamName"                 as "homeTeam",
       y."fullName"                 as "pitcherName",
       p.inning,
       p."runnerSplits",
       p."batterSplits",
       p."pitcherSplits",
       "event",
       "eventType",
       p."resultEventDescription",
       "movementReason",
       "originBase"                 as "runnerOriginBase",
       "startBase"                  as "runnerStartBase",
       "endBase"                    as "runnerEndBase",
       "outBase"                    as "runnerOutBase",
       "isOut"                      as "isRunnerOut",
       "isUnearnedRun",
       "isEarnedRun",
       r."isStolenBase"             as "isStolenBase"
from baseball_aluminum.runner r
    inner join baseball_platinum.game g on r."gamePk" = g."gamePk"
    inner join baseball_platinum.play p on g."gamePk" = p."gamePk" and p."atBatId" = r."atBatId" and p."batterPlayIndex" = r."batterPlayId"
    inner join baseball_platinum.player y on y."playerId" = p."pitcherId"
    inner join baseball_platinum.team t on g."homeTeamId" = t."teamId"
    inner join baseball_platinum.team t2 on g."awayTeamId" = t2."teamId"
order by "pitcherId","gameDate"
;

/*
 This view summarizes the data at the plate appearance level
 */

DROP VIEW IF EXISTS baseball_models."movementPlateAppearance";
create view baseball_models."movementPlateAppearance"
as
with "responsiblePitcher" as
(
    select  "responsiblePitcherId",
            "gamePk",
            "atBatId",
            "runnerId",
            sum(case when "isEarnedRun" and "batterId" = "runnerId" then 1
                     else 0
                end) as "inheritedEarnedRuns",
            sum(case when "isUnearnedRun" and "batterId" = "runnerId" then 1
                     else 0
                end) as "inheritedUnearnedRuns"
    from baseball_models.movement
    where "responsiblePitcherId" is not null
    group by "responsiblePitcherId", "gamePk", "atBatId", "runnerId"
)
select "gameDate",
       m."gamePk",
       "pitcherId",
       "batterId",
       m."atBatId",
       inning                                                                       as "inning",
       "pitcherName",
       sum(case when m."runnerId" = m."batterId" then 1 else 0 end)                 as "battersFaced",
       sum(case when m."runnerId" = m."batterId"
                     and "resultEventDescription" not like '%sacrifice%'
                     and "eventType" not in ('walk', 'hit_by_pitch') then 1
                else 0 end
       )                                                                            as "atBats",
       sum(case when "isRunnerOut" then 1 else 0 end)                               as "outs",
       sum(case when "isUnearnedRun" then 1 + coalesce(rP."inheritedUnearnedRuns",0)
                else 0
           end)
           + sum(case when "isEarnedRun" then 1 + coalesce(rP."inheritedEarnedRuns",0)
                   else 0
                 end)                                                               as "runs",
       sum(case when "isEarnedRun" then 1 + coalesce(rP."inheritedEarnedRuns",0)
                else 0
            end)                                                                    as "earnedRuns",
       sum(case when m."runnerId" = m."batterId" and "eventType" in ('single',
                                                                 'double',
                                                                 'triple',
                                                                 'home_run')
                then 1
                else 0
           end)                                                                     as "hits",
       sum(case when m."runnerId" = "batterId"
                    AND "eventType" = 'home_run' then 1 else 0 end)                 as "homeruns",
       sum(case when m."runnerId" = "batterId"
                    AND "eventType" like '%strikeout%' then 1 else 0 end)           as "strikeouts",
       sum(case when m."runnerId" = m."batterId"
                    AND "eventType" = 'walk' then 1 else 0 end)                     as "walks",
       sum(case when m."runnerId" = m."batterId"
                    AND "eventType" = 'hit_by_pitch' then 1 else 0 end)             as "hitBatters"
from baseball_models.movement m
    left join "responsiblePitcher" rP on m."pitcherId" = rP."responsiblePitcherId"
                                         and m."gamePk" = rP."gamePk"
                                         and m."atBatId" = rP."atBatId"
                                         and m."runnerId" = rP."runnerId"
group by "gameDate", m."gamePk", "pitcherId", "pitcherName", m."batterId", m."atBatId", inning;
;

DROP VIEW IF EXISTS baseball_models."movementGame" cascade ;
CREATE VIEW baseball_models."movementGame"
AS
SELECT "pitcherId",
       "pitcherName",
       "gamePk",
        "gameDate",
        sum("battersFaced")                                            as "battersFaced",
        sum("atBats")                                                  as "atBats",
        sum("outs")                                                    as "outs",
        (sum("outs") / 3.0)::numeric(4,1)                              as "inningsPitched",
        sum("runs")                                                    as "runs",
        sum("earnedRuns")                                              as "earnedRuns",
        sum("hits")                                                    as "hits",
        sum("strikeouts")                                              as "strikeouts",
        sum("homeruns")                                                as "homeruns",
        sum("walks")                                                   as "walks",
        sum("hitBatters")                                              as "hitBatters",
        case when sum("outs") = 0 then 0 else
            (sum("earnedRuns") / sum("outs") / 3 * 9)::numeric(4, 2)
            end                                                        as "ERA",
        case when sum("atBats") = 0 then 0 else
            (sum("hits")::numeric / sum("atBats")::numeric)::numeric(4, 3)
             end                                                       as "opponentBA"
FROM baseball_models."movementPlateAppearance" pa
group by "pitcherId", "pitcherName", "gameDate", "gamePk";

DROP VIEW IF EXISTS baseball_models."movementSeason";
CREATE VIEW baseball_models."movementSeason"
AS
SELECT "pitcherId",
       "pitcherName",
        count(*)                                                       as "games",
        sum("battersFaced")                                            as "battersFaced",
        sum("atBats")                                                  as "atBats",
        (sum("outs") / 3)::numeric(4,1)                                as "inningsPitched",
        sum("runs")                                                    as "runs",
        sum("earnedRuns")                                              as "earnedRuns",
        sum("hits")                                                    as "hits",
        sum("strikeouts")                                              as "strikeouts",
        sum("walks")                                                   as "walks",
        sum("hitBatters")                                              as "hitBatters",
        case when sum("outs") = 0 then 0 else
            (sum("earnedRuns") / (sum("outs") / 3) * 9)::numeric(4, 2)
            end                                                        as "ERA",
        case when sum("atBats") = 0 then 0 else
            (sum("hits")::numeric / sum("atBats")::numeric)::numeric(4, 3)
            end                                                        as "opponentBA",
       ((sum(walks) + sum(hits)) / (sum(outs)/3))::numeric(4,2)        as "WHIP"
FROM baseball_models."movementGame" pa
group by "pitcherId", "pitcherName";

select *
from baseball_models."movementSeason"



