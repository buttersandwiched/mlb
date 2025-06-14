    with lastPitchOfAtBat as (
            select "gamePk",
                   "atBatId",
                   "pitcherId",
                   max("resultEvent")                  as "resultEvent",
                   max("resultEventDescription")       as "resultEventDescription",
                   max("batterPlayIndex")              as "lastPlayIndex"
            from baseball_platinum.play
            where "pitcherId" = 694973
            group by "atBatId", "gamePk", "pitcherId"
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
    select g."gamePk",
           g."gameDate",
           p."fullName" as "pitcher",
           r."pitcherId" as "pitcherId",
           sum(r.runs) as "runs",
           sum(r."earnedRuns" )as "earnedRuns",
           (sum(r."inningsPitched")::numeric(5,2)) as "inningsPitched"
    from runnerMovement r
    inner join baseball_platinum.game g on r."gamePk" = g."gamePk"
    inner join baseball_platinum.player p on p."playerId" = r."pitcherId"
    where r."pitcherId"= 694973
    group by g."gamePk", g."gameDate", r."pitcherId", p."fullName"
    order by "gameDate";

select distinct "playCallDescription", "playCode", "countBalls", "countStrikes"
from baseball_platinum.play