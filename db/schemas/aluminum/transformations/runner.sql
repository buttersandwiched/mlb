/* Usage:   Staging Table for Runners
   Purpose: Tracks the movement of every runner after each play.
            runner includes the batter.
   Metrics: RBIs, Outs, Unearned Runs, Earned Runs
*/

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
                                      "event",
                                      "eventType",
                                      "movementReason",
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
       (runner.value->'details'->'runner'->>'id')::int                                  as "runnerId",
       p."pitcherId"                                                                    as "pitcherId",
       (runner.value->'details'->'responsiblePitcher'->>'id')::int                      as "responsiblePitcherId",
       p."postOnFirstId",
       p."postOnSecondId",
       p."postOnThirdId",
       p."atBatId",
       p."batterPlayIndex",
       runner.value->'details'->>'event'                                                as "event",
       runner.value->'details'->>'eventType'                                            as "eventType",
       runner.value->'details'->>'movementReason'                                       as "movementReason",
       runner.value->'movement'->>'originBase'                                          as "originBase",
       runner.value->'movement'->>'startBase'                                           as "startBase",
       runner.value->'movement'->>'endBase'                                             as "endBase",
       runner.value->'movement'->>'outBase'                                             as "outBase",
       (runner.value->'movement'->>'outNumber')::int                                    as "outNumber",
       case
           when runner.value->'details'->>'eventType' like 'stolen_base_%' then TRUE
           ELSE FALSE
           END                                                                          AS "isStolenBase",
        case
           when runner.value->'details'->>'eventType' like 'caught_stealing%' then TRUE
           ELSE FALSE
           END                                                                          AS "isCaughtStealing",
       (runner.value->'movement'->>'isOut')::BOOLEAN                   as "isOut",
       (runner.value->'details'->>'rbi')::BOOLEAN                     as "isRBI",
       (runner.value->'details'->>'earned')::BOOLEAN                   as "isEarnedRun",
       (runner.value->'details'->>'teamUnearned')::BOOLEAN             as "isUnearnedRun",
       CURRENT_TIMESTAMP
from baseball_aluminum.play p,
    LATERAL json_array_elements(p."runnerData") as runner
where (runner.value->'details'->>'playIndex')::int = p."batterPlayIndex"
order by "gamePk", "atBatId", "batterPlayIndex";