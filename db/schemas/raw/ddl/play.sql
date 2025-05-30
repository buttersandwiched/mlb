-- -------------------------------------------------------------------------------------------------------
-- Table:          baseball_raw.plays
-- -------------------------------------------------------------------------------------------------------
-- Description:    The `baseball_raw.plays` table stores the outcome of plate appearances
--                 in baseball games. It contains the game identifier (gamePk) and a JSON structured
--                 column (play_outcome) to detail the events and results of every play per game.
-- -------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS baseball_raw.play;
CREATE TABLE IF NOT EXISTS baseball_raw.play
(
    "gamePk"        varchar, -- Unique identifier for the game
    plays           json,     -- JSON field that captures detailed outcomes of plays in the given game
    "_createdAt"   timestamp default CURRENT_TIMESTAMP -- time the record was loaded into the db
);

select * from baseball_raw.play;