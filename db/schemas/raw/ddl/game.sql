DROP TABLE IF EXISTS baseball_raw."game";
CREATE TABLE baseball_raw."game"
(
    "gamePk" Integer,
    "schedule" JSON,
    "teams" JSON,
    "venue" JSON,
    "weather" JSON,
    "gameInfo" JSON,
    "_createdAt" timestamp DEFAULT CURRENT_TIMESTAMP
);

select *
from baseball_raw."game";