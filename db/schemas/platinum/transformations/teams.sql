MERGE INTO baseball_platinum.teams target
USING baseball_aluminum.teams source
ON source.teams_id = target.team_id
WHEN MATCHED THEN UPDATE 
    SET team_name           = source.team_name,
        venue_id            = source.venue_id,
        venue_name          = source.venue_name,
        spring_league_id    = source.spring_league_id,
        spring_league_name  = source.spring_league_name,
        league_id           = source.league_id,
        league_name         = source.league_name,
        division_id         = source.division_id,
        division_name       = source.division_name,
        sport_id            = source.sport_id,
        sport_name          = source.sport_name
WHEN NOT MATCHED THEN
    INSERT (team_id,
            team_name,
            venue_id,
            venue_name,
            spring_league_id,
            spring_league_name,
            league_id,
            league_name,
            division_id,
            division_name,
            sport_id,
            sport_name)
    VALUES (source.teams_id,
            source.team_name,
            source.venue_id,
            source.venue_name,
            source.spring_league_id,
            source.spring_league_name,
            source.league_id,
            source.league_name,
            source.division_id,
            source.division_name,
            source.sport_id,
            source.sport_name);

