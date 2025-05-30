TRUNCATE TABLE baseball_aluminum.plays;

WITH gameplays as
(
    SELECT
        "gamePk" as game_id
        ,(json_array_elements_text(play))::json as plays
    FROM baseball_raw.play
),
play_by_play as
(
    select game_id,
           plays,
           (json_array_elements_text(gp.plays->'playOutcome'))::json as playoutcome
     from gameplays gp
)
INSERT INTO baseball_aluminum.plays(about_game_id, about_at_bat_index, about_half_inning, about_is_top_inning, about_inning, about_start_time, about_end_time, about_is_complete, about_is_scoring_play, about_has_review, about_has_out, about_captivating_index, matchup_batter_id, matchup_batter_full_name, matchup_batter_link, matchup_bat_side_code, matchup_bat_side_description, matchup_pitcher_id, matchup_pitcher_full_name, matchup_pitcher_link, matchup_pitch_hand_code, matchup_pitch_hand_description, matchup_post_on_first_id, matchup_post_on_first_full_name, matchup_post_on_first_link, matchup_post_on_second_id, matchup_post_on_second_full_name, matchup_post_on_second_link, matchup_post_on_third_id, matchup_post_on_third_full_name, matchup_post_on_third_link, matchup_batter_hot_cold_zones, matchup_pitcher_hot_cold_zones, matchup_splits_batter, matchup_splits_pitcher, matchup_splits_men_on_base, result_type, result_event, result_event_type, result_event_description, result_rbi, result_away_score, result_home_score, result_is_out, runners, play_outcome_details_call_code, play_outcome_details_call_description, play_outcome_description, play_outcome_code, play_outcome_ball_color, play_outcome_trail_color, play_outcome_is_in_play, play_outcome_is_strike, play_outcome_is_ball, play_outcome_type_code, play_outcome_type_description, play_outcome_is_out, play_outcome_has_review, play_outcome_count_balls, play_outcome_count_strikes, play_outcome_count_outs, play_outcome_pitch_data_start_speed, play_outcome_pitch_data_end_speed, play_outcome_pitch_data_strike_zone_top, play_outcome_pitch_data_strike_zone_bottom, play_outcome_pitch_data_coordinates_ay, play_outcome_pitch_data_coordinates_az, play_outcome_pitch_data_coordinates_pfxx, play_outcome_pitch_data_coordinates_pfxz, play_outcome_pitch_data_coordinates_px, play_outcome_pitch_data_coordinates_pz, play_outcome_pitch_data_coordinates_vx0, play_outcome_pitch_data_coordinates_vy0, play_outcome_pitch_data_coordinates_vz0, play_outcome_pitch_data_coordinates_x, play_outcome_pitch_data_coordinates_y, play_outcome_pitch_data_coordinates_x0, play_outcome_pitch_data_coordinates_y0, play_outcome_pitch_data_coordinates_z0, play_outcome_pitch_data_coordinates_ax, play_outcome_pitch_data_breaks_break_angle, play_outcome_pitch_data_breaks_break_length, play_outcome_pitch_data_breaks_break_y, play_outcome_pitch_data_breaks_break_vertical, play_outcome_pitch_data_breaks_break_vertical_induced, play_outcome_pitch_data_breaks_break_horizontal, play_outcome_pitch_data_breaks_spin_rate, play_outcome_pitch_data_breaks_spin_direction, play_outcome_pitch_data_zone, play_outcome_pitch_data_type_confidence, play_outcome_pitch_data_plate_time, play_outcome_pitch_data_extension, play_outcome_hit_data_launch_speed, play_outcome_hit_data_launch_angle, play_outcome_hit_data_total_distance, play_outcome_hit_data_trajectory, play_outcome_hit_data_hardness, play_outcome_hit_data_location, play_outcome_hit_data_coordinates_coordx, play_outcome_hit_data_coordinates_coordy, play_outcome_index, play_outcome_play_id, play_outcome_pitch_number, play_outcome_start_time, play_outcome_end_time, play_outcome_is_pitch, play_outcome_type, date_loaded, loaded_by)
       SELECT  p.game_id::int                                                      AS about_game_id,
        (p.plays->'about'->>'atBatIndex')::int                          AS about_at_bat_index,
        (p.plays->'about'->>'halfInning')::varchar                      AS about_half_inning,
        (p.plays->'about'->>'isTopInning')::bool                        AS about_is_top_inning,
        (p.plays->'about'->>'inning')::int                              AS about_inning,
        (p.plays->'about'->>'startTime')::timestamptz                   AS about_start_time,
        (p.plays->'about'->>'endTime')::timestamptz                     AS aboout_end_time,
        (p.plays->'about'->>'isComplete')::bool                         AS about_is_complete,
        (p.plays->'about'->>'isScoringPlay')::bool                      AS about_is_scoring_play,
        (p.plays->'about'->>'hasReview')::bool                          AS about_has_review,
        (p.plays->'about'->>'hasOut')::bool                             AS about_has_review,
        (p.plays->'about'->>'captivatingIndex')::int                    AS about_captivating_index,
        (p.plays->'matchup'->'batter'->>'id')::int                      AS matchup_batter_id,
        (p.plays->'matchup'->'batter'->>'fullName')::varchar            AS matchup_batter_full_name,
        (p.plays->'matchup'->'batter'->>'link')::varchar                AS matchup_batter_link,
        (p.plays->'matchup'->'batSide'->>'code')::varchar               AS matchup_bat_side_code,
        (p.plays->'matchup'->'batSide'->>'description')::varchar        AS matchup_bat_side_description,
        (p.plays->'matchup'->'pitcher'->>'id')::int                     AS matchup_pitcher_id,
        (p.plays->'matchup'->'pitcher'->>'fullName')::varchar           AS matchup_pitcher_full_name,
        (p.plays->'matchup'->'pitcher'->>'link')::varchar               AS matchup_pitcher_link,
        (p.plays->'matchup'->'pitchHand'->>'code')::varchar             AS matchup_pitch_hand_code,
        (p.plays->'matchup'->'pitchHand'->>'description')::varchar      AS matchup_pitch_hand_description,
        (p.plays->'matchup'->'postOnFirst'->>'id')::int                 AS matchup_post_on_first_id,
        (p.plays->'matchup'->'postOnFirst'->>'fullName')::varchar           AS matchup_post_on_first_full_name,
        (p.plays->'matchup'->'postOnFirst'->>'link')::varchar               AS matchup_post_on_first_link,
        (p.plays->'matchup'->'postOnSecond'->>'id')::int                 AS matchup_post_on_second_id,
        (p.plays->'matchup'->'postOnSecond'->>'fullName')::varchar           AS matchup_post_on_second_full_name,
        (p.plays->'matchup'->'postOnSecond'->>'link')::varchar               AS matchup_post_on_second_link,
        (p.plays->'matchup'->'postOnSecond'->>'id')::int                 AS matchup_post_on_third_id,
        (p.plays->'matchup'->'postOnThird'->>'fullName')::varchar           AS matchup_post_on_third_full_name,
        (p.plays->'matchup'->'postOnThird'->>'link')::varchar               AS matchup_post_on_third_link,
        (p.plays->'matchup'->'batterHotColdZones')::json                AS matchup_batter_hot_cold_zones,
        (p.plays->'matchup'->'pitcherHotColdZones')::json               AS matchup_pitcher_hot_cold_zones,
        (p.plays->'matchup'->'splits'->>'batter')::varchar              AS matchup_splits_batter,
        (p.plays->'matchup'->'splits'->>'pitcher')::varchar             AS matchup_splits_pitcher,
        (p.plays->'matchup'->'splits'->>'menOnBase')::varchar           AS matchup_splits_men_on_base,
        (p.plays->'result'->>'type')::varchar                           AS result_type,
        (p.plays->'result'->>'event')::varchar                          AS result_event,
        (p.plays->'result'->>'eventType')::varchar                      AS result_event_type,
        (p.plays->'result'->>'description')::varchar                    AS result_description,
        (p.plays->'result'->>'rbi')::INT                                AS result_rbi,
        (p.plays->'result'->>'awayScore')::int                          AS result_away_score,
        (p.plays->'result'->>'homeScore')::int                      AS result_home_score,
        (p.plays->'result'->>'isOut')::bool                                      AS result_is_out,
        (p.plays->>'runners')::json                                              AS runners,
        (playoutcome->'details'->'call'->>'code')::varchar           AS play_outcome_details_call_code,
        (playoutcome->'details'->'call'->>'description')::varchar    AS play_outcome_details_call_description,
        (playoutcome->'details'->>'description')::varchar             AS play_outcome_details_description,
        (playoutcome->'details'->>'code')::varchar                    AS play_outcome_details_code,
        (playoutcome->'details'->>'ballColor')::varchar               AS play_outcome_details_ball_color,
        (playoutcome->'details'->>'trailColor')::varchar              AS play_outcome_details_trail_color,
        (playoutcome->'details'->>'isInPlay')::bool                          AS play_outcome_details_is_in_play,
        (playoutcome->'details'->>'isStrike')::bool                          AS play_outcome_details_is_strike,
        (playoutcome->'details'->>'isBall')::bool                            AS play_outcome_details_is_ball,
        (playoutcome->'details'->'type'->>'code')::varchar                   AS play_outcome_details_type_code,
        (playoutcome->'details'->'type'->>'description')::varchar            AS play_outcome_details_type_description,
        (playoutcome->'details'->>'isOut')::bool                             AS play_outcome_details_is_out,
        (playoutcome->'details'->>'hasReview')::bool                         AS play_outcome_details_has_review,
        (playoutcome->'count'->>'balls')::int                                AS play_outcome_count_balls,
        (playoutcome->'count'->>'strikes')::int                              AS play_outcome_count_strikes,
        (playoutcome->'count'->>'outs')::int                                AS play_outcome_count_outs,
        (playoutcome->'pitchData'->>'startSpeed')::numeric              AS play_outcome_pitch_data_start_speed,
        (playoutcome->'pitchData'->>'endSpeed')::numeric              AS play_outcome_pitch_data_end_speed,
        (playoutcome->'pitchData'->>'strikeZoneTop')::numeric           AS play_outcome_pitch_data_strikezone_top,
        (playoutcome->'pitchData'->>'strikeZoneBottom')::numeric        AS play_outcome_pitch_data_strikezone_bottom,
        (playoutcome->'pitchData'->'coordinates'->>'aY')::numeric     AS play_outcome_pitch_data_coordinates_ay,
        (playoutcome->'pitchData'->'coordinates'->>'aZ')::numeric     AS play_outcome_pitch_data_start_speed,
        (playoutcome->'pitchData'->'coordinates'->>'pfxX')::numeric   AS play_outcome_pitch_data_start_speed,
        (playoutcome->'pitchData'->'coordinates'->>'pfxZ')::numeric  AS play_outcome_pitch_data_start_speed,
        (playoutcome->'pitchData'->'coordinates'->>'pX')::numeric   AS play_outcome_pitch_data_start_speed,
        (playoutcome->'pitchData'->'coordinates'->>'pZ')::numeric    AS play_outcome_pitch_data_start_speed,
        (playoutcome->'pitchData'->'coordinates'->>'vX0')::numeric    AS play_outcome_pitch_data_start_speed,
        (playoutcome->'pitchData'->'coordinates'->>'vY0')::numeric   AS play_outcome_pitch_data_start_speed,
        (playoutcome->'pitchData'->'coordinates'->>'vZ0')::numeric    AS play_outcome_pitch_data_start_speed,
        (playoutcome->'pitchData'->'coordinates'->>'x')::numeric     AS play_outcome_pitch_data_start_speed,
        (playoutcome->'pitchData'->'coordinates'->>'y')::numeric        AS play_outcome_pitch_data_start_speed,
        (playoutcome->'pitchData'->'coordinates'->>'x0')::numeric     AS play_outcome_pitch_data_start_speed,
        (playoutcome->'pitchData'->'coordinates'->>'y0')::numeric     AS play_outcome_pitch_data_start_speed,
        (playoutcome->'pitchData'->'coordinates'->>'z0')::numeric     AS play_outcome_pitch_data_start_speed,
        (playoutcome->'pitchData'->'coordinates'->>'aX')::numeric     AS play_outcome_pitch_data_coordinates_ax,
        (playoutcome->'pitchData'->'breaks'->>'breakAngle')::numeric   AS play_outcome_pitch_data_breaks_break_angle,
        (playoutcome->'pitchData'->'breaks'->>'breakLength')::numeric  AS play_outcome_pitch_data_breaks_break_length,
        (playoutcome->'pitchData'->'breaks'->>'breakY')::numeric                AS play_outcome_pitch_data_breaks_breaky,
        (playoutcome->'pitchData'->'breaks'->>'breakVertical')::numeric        AS play_outcome_pitch_data_breaks_break_vertical,
        (playoutcome->'pitchData'->'breaks'->>'breakVerticalInduced')::numeric  AS play_outcome_pitch_data_breaks_break_vertical_induced,
        (playoutcome->'pitchData'->'breaks'->>'breakHorizontal')::numeric       AS play_outcome_pitch_data_breaks_break_horizontal,
        (playoutcome->'pitchData'->'breaks'->>'spinRate')::int                       AS play_outcome_pitch_data_breaks_spin_rate,
        (playoutcome->'pitchData'->'breaks'->>'spinDirection')::int                  AS play_outcome_pitch_data_breaks_spin_direction,
        (playoutcome->'pitchData'->>'zone')::int                                     AS play_outcome_pitch_data_zone,
        (playoutcome->'pitchData'->>'typeConfidence')::numeric                  AS play_outcome_pitch_data_type_confidence,
        (playoutcome->'pitchData'->>'plateTime')::NUMERIC                    AS play_outcome_pitch_data_plate_time,
        (playoutcome->'pitchData'->>'extension')::numeric                    AS play_outcome_pitch_data_extension,
        (playoutcome->'hitData'->>'launchSpeed')::numeric                      AS play_outcome_hit_data_launch_speed,
        (playoutcome->'hitData'->>'launchAngle')::numeric                       AS play_outcome_hit_data_launch_angle,
        (playoutcome->'hitData'->>'totalDistance')::numeric                    AS play_outcome_hit_data_total_distance,
        (playoutcome->'hitData'->>'trajectory')::varchar                             AS play_outcome_hit_data_trajectory,
        (playoutcome->'hitData'->>'hardness')::varchar                               AS play_outcome_hit_data_hardness,
        (playoutcome->'hitData'->>'location')::varchar                               AS play_outcome_hit_data_location,
        (playoutcome->'hitData'->'coordinates'->>'coordX')::numeric                     AS play_outcome_hit_data_coordinates_x,
        (playoutcome->'hitData'->'coordinates'->>'coordY')::numeric                     AS play_outcome_hit_data_coordinates_y,
        (playoutcome->>'index')::int                                                                 AS index,
        (playoutcome->>'playId')::varchar                                                            AS play_id,
        (playoutcome->>'pitchNumber')::int                                                           AS pitch_number,
        (playoutcome->>'startTime')::timestamptz                                                     AS start_time,
        (playoutcome->>'endTime')::timestamptz                                                       AS end_time,
        (playoutcome->>'isPitch')::bool                                                              AS is_pitch,
        (playoutcome->>'type')::varchar                                                              AS type,
        CURRENT_TIMESTAMP                                                                       AS date_loaded,
        'db'                                                                                    AS created_by
FROM play_by_play p ;


select count(*) from baseball_aluminum.plays;





WITH game AS
    (
        SELECT
            p."gamePk"::INT                     AS "gamePk",
            p.plays::JSON                       AS "plays",
            json_array_length(p.plays::JSON)    AS "numberOfAtBats"
        FROM baseball_raw.play p
    )

, atBat AS
    (
        SELECT
            "gamePk",
            ("atBat"->'about'->>'atBatIndex')::INT              AS "atBatId",
            ("atBat"->'matchup'->'batter'->>'id')::INT          AS "batterId",
            ("atBat"->'matchup'->'pitcher'->>'id')::INT         AS "pitcherId",
            ("atBat"->'about'->>'inning')::INT                  AS "inning",
            "atBat"->'about'->> 'halfInning'                    AS "halfInning",
            ("atBat"->'about'->>'startTime')::timestamptz       AS "atBatStartTime",
            ("atBat"->'about'->>'endTime')::timestamptz         AS "atBatEndTime",
            ("atBat"->'about'->>'captivatingIndex')::INT        AS "captivatingIndex",
            ("atBat"->'about'->>'isTopInning')::BOOL            AS "isTopInning",
            ("atBat"->'about'->>'isScoringPlay')::BOOL          AS "isScoringPlay",
            ("atBat"->'about'->>'hasReview')::BOOL              AS "atBatHasReview",
            ("atBat"->'about'->>'hasOut')::BOOL                 AS "hasOutRecorded",
            ("atBat"->'about'->>'isComplete')::BOOL             AS "isAtBatComplete",
            ("atBat"->'matchup'->>'batterHotColdZones')::JSON            AS "batterHotColdZones",
            ("atBat"->'matchup'->>'pitcherHotColdZones')::JSON           AS "pitcherHotColdZones",
            "atBat"->'matchup'->'splits'->>'batter'             AS "batterSplits",
            "atBat"->'matchup'->'splits'->>'pitcher'            AS "pitcherSplits",
            "atBat"->'matchup'->'splits'->>'menOnBase'          AS "runnersSplits",
            "atBat"->'result'->>'type'                          AS "resultType",
            "atBat"->'result'->>'event'                         AS "resultEvent",
            "atBat"->'result'->>'eventType'                     AS "resultEventType",
            "atBat"->'result'->>'description'                   AS "resultEventDescription",
            ("atBat"->'result'->>'rbi')::INT                    AS "RBIs",
            ("atBat"->'result'->>'awayScore')::INT              AS "awayScore",
            ("atBat"->'result'->>'homeScore')::INT              AS "homeScore",
            ("atBat"->'result'->>'isOut')::BOOL                 AS "isBatterOut",
            ("game".plays)::JSON                                as plays,
            ("atBat"->>'runners')::JSON                                 AS "runners",
            "atBat"->'playOutcome'                              AS "playOutcome",
            json_array_length("atBat"->'playOutcome')           AS "numberOfPlays"
        FROM game,
            LATERAL json_array_elements(game.plays) as "atBat"
    )

   SELECT *
        FROM atBat;

