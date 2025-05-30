MERGE INTO baseball_models."pitchType" target
USING
    (
     SELECT DISTINCT play_outcome_type_code,
                     play_outcome_type_description
     FROM baseball_platinum.plays source
     ) AS source
ON source.play_outcome_type_code = target."pitchTypeCode"
WHEN MATCHED THEN
    UPDATE SET
               "pitchTypeDescription" = source.play_outcome_type_description
WHEN NOT MATCHED THEN
    INSERT ("pitchTypeCode", "pitchTypeDescription")
    VALUES(play_outcome_type_code, play_outcome_type_description);
