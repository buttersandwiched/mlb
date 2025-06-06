MERGE INTO baseball_platinum.team target
USING baseball_aluminum.team source
ON source."teamId" = target."teamId"
WHEN MATCHED THEN UPDATE 
    SET "teamName"          = source."teamName",
        "venueId"           = source."venueId",
        "venueName"         = source."venueName",
        "springLeagueId"    = source."springLeagueId",
        "springLeagueName"  = source."springLeagueName",
        "leagueId"          = source."leagueId",
        "leagueName"        = source."leagueName",
        "divisionId"        = source."divisionId",
        "divisionName"      = source."divisionName",
        "sportId"           = source."sportId"
WHEN NOT MATCHED THEN
    INSERT ("teamId",
            "teamName",
            "venueId",
            "venueName",
            "springLeagueId",
            "springLeagueName",
            "leagueId",
            "leagueName",
            "divisionId",
            "divisionName",
            "sportId")
    VALUES (source."teamId",
            source."teamName",
            source."venueId",
            source."venueName",
            source."springLeagueId",
            source."springLeagueName",
            source."leagueId",
            source."leagueName",
            source."divisionId",
            source."divisionName",
            source."sportId"
           )
