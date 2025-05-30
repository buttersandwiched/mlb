-------------------------------------------------------------------------------------------------------
--Table:          schedule
-------------------------------------------------------------------------------------------------------
--Description:    The `baseball_raw.schedule` table provides information about scheduled baseball games,
--                including game identifiers, types, dates, statuses, team details, venue information,
--                content metadata, and scheduling-related adjustments. Additional fields capture
--                rescheduling notes and descriptions for historical tracking and analysis.
-------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS baseball_raw.schedule;
CREATE TABLE IF NOT EXISTS baseball_raw.schedule
(
    date                    date,
    "totalItems"            int,
    "totalEvents"           int,
    "totalGames"            int,
    "totalGamesInProgress"  int,
    "games"                 json,
    "events"                json,
    "_createdAt"           timestamp default CURRENT_TIMESTAMP -- time the record was loaded into the db
);

select *
from baseball_raw.team