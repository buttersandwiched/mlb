with countGames as
(
    SELECT COUNT(*) totalGames
    FROM baseball_aluminum.game
),
countDisitnctGames AS
(
    SELECT  COUNT (DISTINCT "gamePk") as distinctGames
    from baseball_aluminum.game
)

SELECT *
FROM countDisitnctGames d