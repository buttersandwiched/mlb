MERGE INTO baseball_models."playCall" target
USING
    (
    SELECT DISTINCT
            play_outcome_details_call_code,
            play_outcome_details_call_description
    FROM baseball_aluminum.plays
     ) AS source
    ON source.play_outcome_details_call_code = target."playCallCode"

WHEN MATCHED THEN
    UPDATE SET
            "playCallDescription" = source.play_outcome_details_call_description

WHEN NOT MATCHED THEN
    INSERT ("playCallCode",
            "playCallDescription")
    VALUES (play_outcome_details_call_code,
            play_outcome_details_call_description)

select *
from baseball_models."playCall";