DROP VIEW IF EXISTS  baseball_models.v_pitchers;

CREATE VIEW baseball_models.v_pitchers
AS
SELECT
    *
FROM baseball_models.players
WHERE primary_position_code = 1;
