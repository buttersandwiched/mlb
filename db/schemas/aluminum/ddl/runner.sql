select
    "gamePk",
    "atBatId",
    max("batterPlayIndex") as lastPlayIndex
from baseball_aluminum.play
group by "gamePk", "atBatId"
order by 1,2