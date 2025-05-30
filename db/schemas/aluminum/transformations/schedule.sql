-- Grab the needed columns
-- cast columns into proper data types

TRUNCATE TABLE baseball_aluminum.schedule;
WITH schedule_flattened AS
    (
      SELECT
           (game->>'gamePk')::int                       AS game_id,
           (game->>'gameNumber')::int                   AS game_number,
           game->>'gameType'                            AS game_type,
           (game->>'seriesGameNumber')::int             AS series_game_number,
           (game->>'gamesInSeries')::int                AS games_in_series,
           game->>'dayNight'                            as day_night,
           game->>'doubleHeader'                        AS double_header,
           (game->>'season')::int                       AS season,
           (game->'venue'->>'id')::int                  AS venue_id,
           (game->'teams'->'away'->'team'->>'id')::int  AS away_team_id,
           (game->'teams'->'home'->'team'->>'id')::int  AS home_team_id,
           (game->>'gameDate')::timestamptz             AS game_date,
           (game->>'officialDate')::date                AS official_date,
           game->'status'->>'statusCode'                AS status_code,
           game->'status'->>'detailedState'             AS detailed_state,
           game->>'link'                                AS api_link,
           (game->'teams'->'away'->> 'isWinner')::bool  AS away_team_is_winner,
           (game->'teams'->'home'->> 'isWinner')::bool  AS home_team_is_winner
     FROM baseball_raw.schedule s,
          json_array_elements(s.games::json) AS game
    )
INSERT INTO baseball_aluminum.schedule
    (game_id,
     game_number,
     series_game_number,
     game_in_series,
     season,
     venue_id,
     away_team_id,
     away_team_is_winner,
     home_team_id,
     home_team_is_winner,
     game_date,
     official_date,
     game_type,
     double_header,
     day_night,
     status_code,
     detailed_state,
     date_loaded,
     created_by)
SELECT
    game_id,
    game_number,
    series_game_number,
    games_in_series,
    season,
    venue_id,
    away_team_id,
    away_team_is_winner,
    home_team_id,
    home_team_is_winner,
    game_date,
    official_date,
    game_type,
    double_header,
    day_night,
    status_code,
    detailed_state,
    CURRENT_TIMESTAMP               AS date_loaded,
    'db'                            AS loaded_by
FROM schedule_flattened;

select *
from baseball_aluminum.schedule