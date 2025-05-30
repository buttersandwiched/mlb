 WITH
     duplicate_games AS (
     SELECT game_id,
            min(game_date)      as original_game_date,
            max(official_date)  as rescheduled_date,
            true                as was_postponed
     FROM baseball_aluminum.schedule
     group by game_id
     having count(*) > 1
     )
     ,modified_schedule as (
     SELECT dg.original_game_date               as original_game_date
          , dg.rescheduled_date                 as rescheduled_date
          , coalesce(dg.was_postponed, false)   as was_postponed
          , ps.*
     FROM duplicate_games dg
        right join baseball_aluminum.schedule ps on dg.game_id = ps.game_id
     WHERE ps.status_code in ('F', 'S') -- Completed Games or Scheduled Games
    )

MERGE INTO baseball_platinum.schedule AS target
USING modified_schedule AS source
ON target.game_id = source.game_id
WHEN MATCHED THEN
    UPDATE
    SET game_type = source.game_type,
        season = source.season,
        game_date = source.game_date,
        official_date = source.official_date,
        original_game_date = source.original_game_date,
        was_postponed = source.was_postponed,
        status_code = source.status_code,
        detailed_state = source.detailed_state,
        away_team_id = source.away_team_id,
        away_team_is_winner = source.away_team_is_winner,
        home_team_id = source.home_team_id,
        home_team_is_winner = source.home_team_is_winner,
        venue_id = source.venue_id,
        game_number = source.game_number,
        double_header = source.double_header,
        day_night = source.day_night,
        game_in_series = source.game_in_series,
        series_game_number = source.series_game_number,
        updated_by = 'db',
        date_updated = current_timestamp
    -- Add more columns as needed
WHEN NOT MATCHED THEN
    INSERT (game_id,
            game_type,
            season,
            game_date,
            official_date,
            status_code,
            detailed_state,
            away_team_id,
            away_team_is_winner,
            home_team_id,
            home_team_is_winner,
            venue_id,
            game_number,
            double_header,
            day_night,
            game_in_series,
            series_game_number,
            date_loaded,
            created_by,
            date_updated,
            updated_by
            )
    VALUES (
            game_id,
            game_type,
            season,
            game_date,
            official_date,
            status_code,
            detailed_state,
            away_team_id,
            away_team_is_winner,
            home_team_id,
            home_team_is_winner,
            venue_id,
            game_number,
            double_header,
            day_night,
            game_in_series,
            series_game_number,
            current_timestamp,
            'db',
            current_timestamp,
            'db'
           );


select  *
from baseball_aluminum.schedule