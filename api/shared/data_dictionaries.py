from sqlalchemy import JSON, String, Integer, Boolean, DATE


schemas = {
            "team": {
                "springLeague": JSON,
                "allStarStatus": String,
                "playerId": Integer,
                "name": String,
                "link": String,
                "season": Integer,
                "venue": JSON,
                "springVenue": JSON,
                "teamCode": String,
                "fileCode": String,
                "abbreviation": String,
                "teamName": String,
                "locationName": String,
                "firstYearOfPlay": String,
                "league": JSON,
                "division": JSON,
                "sport": JSON,
                "shortName": String,
                "franchiseName": String,
                "clubName": String,
                "active": Boolean
            },
            "game": {
                "gamePk": Integer,
                "schedule": JSON,
                "teams": JSON,
                "venue": JSON,
                "weather": JSON,
                "gameInfo": JSON
            },
            "player": {
                "id": Integer,
                "fullName": String,
                "link": String,
                "firstName": String,
                "lastName": String,
                "primaryNumber": Integer,
                "birthDate": DATE,
                "currentAge": Integer,
                "birthCity": String,
                "birthStateProvince": String,
                "birthCountry": String,
                "height": String,
                "weight": Integer,
                "active": Boolean,
                "primaryPosition": JSON,
                "useName": String,
                "boxScoreName": String,
                "nickName": String,
                "gender": String,
                "isPlayer": Boolean,
                "isVerified": Boolean,
                "draftYear": Integer,
                "mlbDebutDate": DATE,
                "batSide": JSON,
                "pitchHand": JSON,
                "nameFirstLast": String,
                "nameSlug": String,
                "firstLastName": String,
                "lastFirstName": String,
                "lastInitName": String,
                "initLastName": String,
                "fullFMLName": String,
                "fullLFMName": String,
                "strikezoneTop": Integer,
                "strikezoneBottom": Integer
            },
            "schedule":
            {
                "date": DATE,
                "totalItems": Integer,
                "totalEvents": Integer,
                "totalGames": Integer,
                "totalGamesInProgress": Integer,
                "games": JSON,
                "events": JSON
            },
            "schedule2":
            {
                "gamePk": Integer,
                "gameGuid": String,
                "link": String,
                "gameType": String,
                "season": Integer,
                "gameDate": DATE,
                "officialDate": DATE,
                "status": JSON,
                "teams": JSON,
                "venue": JSON,
                "content": JSON,
                "isTie": Boolean,
                "gameNumber": Integer,
                "publicFacing": Boolean,
                "doubleHeader": String,
                "gameDayType": String,
                "scheduledInnings": Integer,
                "reverseHomeAwayStatus": String,
                "inningBreakLength": String,
                "gamesInSeries": Integer,
                "seriesGameNumber": Integer,
                "seriesDescription": String,
                "recordSource": String,
                "ifNecessary": String,
                "ifNecessaryDescription": String
            },
            "play":
            {
                "gamePk": Integer,
                "plays":  JSON
            }
    
}


def get_schema(schema_name: str):
    return schemas[schema_name]
