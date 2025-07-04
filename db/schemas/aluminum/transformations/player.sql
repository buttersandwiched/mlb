TRUNCATE TABLE baseball_aluminum.player;
INSERT INTO baseball_aluminum.player ("playerId",
                                      "teamId",
                                      "fullName",
                                      link,
                                      "firstName",
                                      "lastName",
                                      "primaryNumber",
                                      "birthDate",
                                      "currentAge",
                                      "birthCity",
                                      "birthStateProvince",
                                      "birthCountry",
                                      height,
                                      weight,
                                      active,
                                      "primaryPosition",
                                      "useName",
                                      "useLastName",
                                      "middleName",
                                      "boxScoreName",
                                      "nickName",
                                      "nameTitle",
                                      "nameSuffix",
                                      "nameMatrilineal",
                                      gender,
                                      "isPlayer",
                                      "isVerified",
                                      "draftYear",
                                      pronunciation,
                                      "mlbDebutDate",
                                      "batSide",
                                      "pitchHand",
                                      "nameFirstLast",
                                      "nameSlug",
                                      "firstLastName",
                                      "lastFirstName",
                                      "lastInitName",
                                      "initLastName",
                                      "fullFMLName",
                                      "fullLFMName",
                                      "strikeZoneTop",
                                      "strikeZoneBottom",
                                      "_createdAt")
    (
        SELECT
            "id",
            "teamId",
            "fullName",
            "link",
            "firstName",
            "lastName",
            "primaryNumber",
            "birthDate",
            "currentAge",
            "birthCity",
            "birthStateProvince",
            "birthCountry",
            height,
            weight,
            active,
            "primaryPosition",
            "useName",
            "useLastName",
            "middleName",
            "boxscoreName",
            "nickName",
            "nameTitle",
            "nameSuffix",
            "nameMatrilineal",
            gender,
            "isPlayer",
            "isVerified",
            "draftYear",
            pronunciation,
            "mlbDebutDate",
            "batSide",
            "pitchHand",
            "nameFirstLast",
            "nameSlug",
            "firstLastName",
            "lastFirstName",
            "lastInitName",
            "initLastName",
            "fullFMLName",
            "fullLFMName",
            "strikeZoneTop",
            "strikeZoneBottom",
            "_createdAt"
        FROM baseball_raw.player
    );

select *
from baseball_aluminum.player;

