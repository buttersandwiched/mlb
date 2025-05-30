select "teamId", count(*)
from baseball_raw.player
group by "teamId";

select *
from baseball_raw.team;

select *
from baseball_raw.schedule
order by 1;

select *
from baseball_raw.play
order by 1;

select *
from baseball_raw.game