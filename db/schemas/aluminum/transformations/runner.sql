TRUNCATE TABLE baseball_aluminum.runner;
INSERT INTO baseball_aluminum.runner ("gamePk",
                                      "runnerId",
                                      "pitcherId",
                                      "responsiblePitcherId",
                                      "postOnFirstId",
                                      "postOnSecondId",
                                      "postOnThirdId",
                                      "atBatId",
                                      "batterPlayId",
                                      "eventType",
                                      "originBase",
                                      "startBase",
                                      "endBase",
                                      "outBase",
                                      "outNumber",
                                      "isStolenBase",
                                      "isCaughtStealing",
                                      "isOut",
                                      "isRBI", "isEarnedRun", "isUnearnedRun", "_createdAt")
select p."gamePk",
       (runner.value->'details'->'runner'->>'id')::int             as "runnerId",
       p."pitcherId",
       (runner.value->'details'->'responsiblePitcher'->>'id')::int as "responsiblePitcherId",
       p."postOnFirstId",
       p."postOnSecondId",
       p."postOnThirdId",
       p."atBatId",
       p."batterPlayIndex",
       runner.value->'details'->>'eventType'                as "eventType",
       runner.value->'movement'->>'originBase'              as "originBase",
       runner.value->'movement'->>'startBase'               as "startBase",
       runner.value->'movement'->>'endBase'                 as "endBase",
       runner.value->'movement'->>'outBase'                 as "outBase",
       (runner.value->'movement'->>'outNumber')::int               as "outNumber",
       case
           when runner.value->'details'->>'eventType' like 'stolen_base_%' then TRUE ELSE FALSE
           END                                              AS "isStolenBase",
        case
           when runner.value->'details'->>'eventType' like 'caught_stealing%' then TRUE ELSE FALSE
           END                                              AS "isCaughtStealing",
       (runner.value->'movement'->>'isOut')::BOOLEAN                   as "isOut",
       (runner.value->'details'->>'rbi')::BOOLEAN                     as "isRBI",
       (runner.value->'details'->>'earned')::BOOLEAN                   as "isEarnedRun",
       (runner.value->'details'->>'teamUnearned')::BOOLEAN             as "isUnearnedRun",
       CURRENT_TIMESTAMP
from baseball_aluminum.play p,
    LATERAL json_array_elements(p."runnerData") as runner
where (runner.value->'details'->>'playIndex')::int = p."batterPlayIndex";


select "gamePk",
       "responsiblePitcherId",
       sum(  case when "isEarnedRun" then 1 else 0 end
           + case when "isUnearnedRun" then 1 else 0 end
          )                                                 as "runsAllowed",
       sum(case when "isEarnedRun" then 1 else 0 end)       as "earnedRuns",
       sum(case when "isUnearnedRun" then 1 else 0 end)     as "unearnedRuns"
from baseball_aluminum.runner
where "responsiblePitcherId" is not null
group by "gamePk", "responsiblePitcherId";

select "gamePk", "runnerId", "pitcherId", runner."responsiblePitcherId", "atBatId", "batterPlayId",
       count(*),
       min("eventType"),
       max("eventType")
from baseball_aluminum.runner
group by "gamePk", "runnerId", "pitcherId", "responsiblePitcherId", "atBatId", "batterPlayId"
having count(*) > 1