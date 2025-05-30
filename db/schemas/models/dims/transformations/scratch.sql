with at_bat as
         (
         select y.full_name                                                                             AS batter_name
                 --,matchup_batter_id                                                                   as batter_id,
                 ,row_number() over
                     (partition by about_game_id, matchup_batter_id
                        order by about_at_bat_index
                     )                                                                                  AS at_bat_index
                 ,about_game_id                                                                         AS game_id
                 ,count(*)                                                                              AS number_of_pitches,
                 max(result_rbi)                                                                        AS rbis
                 ,CASE WHEN max(result_event_type) = 'strikeout' OR
                            max(result_event_type) = 'strikeout_double_play' THEN 1
                    ELSE 0
                  END                                                                                   AS is_strikeout
                , CASE WHEN max(result_event_type) = 'walk' OR
                            max(result_event_type) = 'intent_walk' then 1
                    ELSE 0
                    END                                                                                 AS is_walk
                , CASE WHEN max(result_event_type) in ('single'
                                                       ,'double'
                                                       ,'triple'
                                                       ,'home_run')   then 1
                    ELSE 0
                    END                                                                                 AS is_hit
                --, CASE WHEN play_outcome_is_out then 1 else 0  end                                 AS out
          from baseball_platinum.plays p
                   inner join baseball_platinum.players y on p.matchup_batter_id = y.player_id
          where play_outcome_is_pitch
          group by y.full_name,
                   matchup_batter_id,
                   about_game_id,
                   about_at_bat_index
          order by about_game_id, full_name, 2
          )
select *
from at_bat;

select *
from crosstab(
             $$
   select about_game_id, matchup_batter_id, play_outcome_details_call_code, count(*)
   from sports_analytics.baseball_platinum.plays
   group by about_game_id, play_outcome_details_call_code, matchup_batter_id
   order by about_game_id, play_outcome_details_call_code, matchup_batter_id
   $$,
             $$
   select distinct play_outcome_details_call_code from sports_analytics.public.plays order by play_outcome_details_call_code
   $$
     ) as pivot_table(
                      game_id integer,
                      "call_code_1" integer,
                      "call_code_2" integer,
                      "call_code_3" integer,
                      "call_code_n" integer
    );



select *
from baseball_platinum.plays

select distinct p.play_outcome_code, pt.play_call_description
from baseball_platinum.plays p
    left join baseball_models.play_calls pt on pt.play_call_code = p.play_outcome_code;