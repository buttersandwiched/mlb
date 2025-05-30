/* DESCRIPTION:
                Describes the call of the play by the home plate umpire
                Possible Outputs:
                    Automatic Ball
                    Automatic Ball - Intentional
                    Automatic Ball - Pitcher Pitch Timer Violation
                    Automatic Strike - Batter Pitch Timer Violation
                    Automatic Strike - Batter Timeout Violation
                    Ball
                    Ball In Dirt
                    Called Strike
                    Foul
                    Foul Bunt
                    Foul Pitchout
                    Foul Tip
                    Hit By Pitch
                    "In play, no out"
                    "In play, out(s)"
                    "In play, run(s)"
                    Intent Ball
                    Missed Bunt
                    Pitchout
                    Swinging Strike
                    Swinging Strike (Blocked)
                    <null> [[this *typically* indicates no pitch -- need to confirm this]]
 */
 DROP TABLE IF EXISTS baseball_models."playCall";

CREATE TABLE IF NOT EXISTS baseball_models."playCall"
(
    "playCallId"              SERIAL PRIMARY KEY,
    "playCallCode"            VARCHAR,
    "playCallDescription"     VARCHAR,
    "createdAt"               VARCHAR,
    "createdBy"               VARCHAR
);
