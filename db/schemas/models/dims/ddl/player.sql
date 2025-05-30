DROP VIEW IF EXISTS baseball_models.player;

CREATE VIEW baseball_models.player
AS
    SELECT player_id                        as "playerId",
           t.team_id                        as "teamId",
           t.team_name                      AS "teamName",
           full_name                        as "fullName",
           p.primary_position_abbreviation  as "position",
           p.bat_side_code                  as "batSide",
           p.primary_number                 as "number",
           p.current_age                    as "age",
           p.mlb_debut_date                 as "mlbDebutDate"
    FROM  baseball_platinum.players p
        INNER JOIN baseball_platinum.teams t on p.team_id = t.team_id
    ORDER BY t.league_id, t.division_id, t.team_name, p.primary_position_code, p.last_first_name;

SELECT * from baseball_models.player;
/*
CREATE view baseball_models.player
(
    "playerId"                       INT PRIMARY KEY,
    "teamId"                         INT,
    "fullName"                       VARCHAR,
    "firstName"                      VARCHAR,
    "middleName"                     VARCHAR,
    "lastName"                       VARCHAR,
    "birthCity"                      VARCHAR,
    "birthStateProvince"             VARCHAR,
    "birthCountry"                   VARCHAR,
    "useName"                        VARCHAR,
    "useLastName"                    VARCHAR,
    "boxScoreName"                   VARCHAR,
    "nickName"                       VARCHAR,
    "nameTitle"                      VARCHAR,
    "nameSuffix"                     VARCHAR,
    "nameMatrilineal"                VARCHAR,
    "nameFirstLast"                  VARCHAR,
    "nameSlug"                       VARCHAR,
    "firstLastName"                  VARCHAR,
    "lastFirstName"                  VARCHAR,
    "lastInitName"                   VARCHAR,
    "initLastName"                   VARCHAR,
    "fullFMLName"                    VARCHAR,
    "fullFMName"                     VARCHAR,
    "pronunciation"                  VARCHAR,
    "birthDate"                      VARCHAR,
    "currentAge"                     INT,
    "gender"                         VARCHAR,
    "height"                         VARCHAR,
    "weight"                         INT,
    "draftYear"                      INT,
    "mlbDebutDate"                   DATE,
    "primaryNumber"                  INT,
    "primaryPositionCode"            VARCHAR,
    "primaryPositionName"            VARCHAR,
    "primaryPositionType"            VARCHAR,
    "primaryPositionAbbreviation"    VARCHAR,
    "batSideCode"                    VARCHAR,
    "batSideDescription"             VARCHAR,
    "pitchHandCode"                  VARCHAR,
    "pitchHandDescription"           VARCHAR,
    "isPlayer"                       BOOLEAN,
    "isVerified"                     BOOLEAN,
    "isActive"                       BOOLEAN,
    "strikeZoneTop"                  NUMERIC,
    "strikeZoneBottom"               NUMERIC,
    "apiLink"                        VARCHAR,
    "createdAt"                      TIMESTAMP,
    "createdBy"                      VARCHAR
);

 */

select *
from baseball_models.player;