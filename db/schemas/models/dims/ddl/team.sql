CREATE VIEW baseball_models.team AS
SELECT
    team_id  as "teamId",
    division_id as "divisionId",
    league_id as "leagueId",
    team_name as "teamName",
    location_name as "locationName",
    venue_name as "venueName",
    division_name as "divisionName",
    league_name as "leagueName",
    abbreviation
FROM baseball_platinum.teams;
