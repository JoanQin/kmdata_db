SELECT * 
FROM researchinview.activity_import_log
WHERE integration_activity_id = '90075'
AND integration_user_id = '95032485'
AND riv_activity_name = 'Journal';

SELECT * FROM kmdata.works WHERE resource_id = 4380220;


SELECT * FROM ror.vw_Journal WHERE id = 238747;


-- davis.1719; DEV=648518
SELECT * FROM kmdata.user_identifiers WHERE inst_username = 'davis.1719';

-- pre: 89 rows
-- post: 58 rows
SELECT * FROM ror.vw_Conference WHERE person_id = 648518;


