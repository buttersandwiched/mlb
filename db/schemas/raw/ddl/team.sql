-------------------------------------------------------------------------------------------------------
--Schema:         baseball_raw
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
--Table:          teams
--Description:    The `baseball_raw.teams` table provides details about baseball teams, including
--                their identifiers, names, league and division affiliations, venue information,
--                abbreviations, and other metadata related to their franchise and operational details.
-------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS baseball_raw.team;
CREATE TABLE IF NOT EXISTS baseball_raw.team
(
    id                  int, -- Unique identifier for the team
    "springLeague"      json, -- Represents the spring training league the team belongs to (e.g., Grapefruit League, Cactus League)
    "allStarStatus"     varchar, -- Indicates the all-star status of the team (e.g., if the team is part of an all-star game setup)
    name                varchar, -- Official name of the team
    link                varchar, -- URL or link to more information about the team
    season              int, -- The season associated with this team entry
    venue               json, -- Identifier for the venue associated with the team
    "springVenue"       json, -- Identifier for the team's spring training venue
    "teamCode"          varchar, -- Unique code used to represent the team
    "fileCode"          varchar, -- Code used internally for file or system references
    abbreviation        varchar, -- Shortened abbreviation of the team's name
    "teamName"          varchar, -- Team name without additional prefixes or suffixes
    "locationName"      varchar, -- Geographic location associated with the team
    "firstYearOfPlay"   int, -- The first year the team played in the league
    league              json, -- Identifier for the league the team belongs to (e.g., American or National League)
    division            json, -- Division to which the team is affiliated (e.g., East, West, Central)
    sport               json, -- Sport the team is associated with (e.g., baseball)
    "shortName"         varchar, -- Shortened version of the team's name
    "franchiseName"     varchar, -- The team's franchise name (e.g., Yankees, Red Sox)
    "clubName"          varchar, -- Club name associated with the team
    active              bool,  -- Indicates whether the team is currently active
    "createdAt"       timestamp default CURRENT_TIMESTAMP -- time the record was loaded into the db
);


select *
FROM baseball_raw.team;