/*
SELECT *
FROM baseball_raw.team
*/

TRUNCATE TABLE baseball_aluminum.team;
INSERT INTO baseball_aluminum.team ("teamId", "venueId", "springVenueId", "divisionId", "leagueId", "springLeagueId",
                                    "sportId", "franchiseName", "teamName", "shortName", abbreviation, "clubName",
                                    "venueName", "locationName", "divisionName", "leagueName", "springLeagueName",
                                    "springLeagueAbbreviation", "sportLink", season, "firstYearOfPlay",
                                    "allStarStatus", "isActive", "_createdAt")
SELECT
    id,
    ("venue"->>'id')::int as "venueId",
    ("springVenue"->>'id')::int as spring_venue_id,
    ("division"->>'id')::int as division_id,
    ("league"->> 'id')::int as league_id,
    ("springLeague"->> 'id')::int as spring_league_id,
    ("sport"->> 'id')::int as sport_id,
    "franchiseName" as franchise_name,
    "teamName" as team_name,
    "shortName" as short_name,
    abbreviation,
    "clubName" as club_name,
    venue->>'name' as venue_name,
    "locationName" as location_name,
    division->> 'name' as division_name,
    league->> 'name' as league_name,
    "springLeague"->> 'name' as spring_league_name,
    "springLeague" ->> 'abbreviation' as spring_league_abbreviation,
    "sport" ->> 'name' as sport_name,
    season::int as season,
    "firstYearOfPlay"::int as first_year_of_play,
    "allStarStatus" as all_star_status,
    "active"::bool as is_active,
    CURRENT_TIMESTAMP
FROM baseball_raw.team;

select *
from baseball_aluminum.team
