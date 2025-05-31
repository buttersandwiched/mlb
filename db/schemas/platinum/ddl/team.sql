DROP TABLE IF EXISTS baseball_platinum.team;

CREATE TABLE IF NOT EXISTS baseball_platinum.team
(
    "teamId"                     int PRIMARY KEY,
    "venueId"                    int,
    "springVenueId"              int,
    "divisionId"                 int,
    "leagueId"                   int,
    "springLeagueId"             int,
    "sportId"                    int,
    "franchiseName"              varchar,
    "teamName"                   varchar,
    "shortName"                  varchar,
    "abbreviation"                varchar,
    "clubName"                   varchar,
    "venueName"                  varchar,
    "locationName"               varchar,
    "divisionName"               varchar,
    "leagueName"                 varchar,
    "springLeagueName"          varchar,
    "springLeagueAbbreviation"  varchar,
    "sportName"                  varchar,
    season                      int,
    "firstYearOfPlay"          int,
    "allStarStatus"             varchar,
    "isActive"                   bool,
    "_createdAt"                timestamp,
    "_updatedAt"                timestamp
);