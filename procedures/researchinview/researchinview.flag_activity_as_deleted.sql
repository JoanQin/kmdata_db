CREATE OR REPLACE FUNCTION researchinview.flag_activity_as_deleted (
   p_IntegrationActivityId VARCHAR(2000),
   p_IntegrationUserId VARCHAR(2000),
   p_RIVActivityName VARCHAR(2000)
) RETURNS BIGINT AS $$
DECLARE
   v_MatchCount BIGINT;
BEGIN

   -- mark this record as deleted
   UPDATE researchinview.activity_import_log
   SET is_active = 0,
       change_type = 'DELETE'
   WHERE integration_activity_id = p_IntegrationActivityId
     AND integration_user_id = p_IntegrationUserId
     AND riv_activity_name = p_RIVActivityName;

   -- log this item in the activity table
   v_MatchCount := 0;
   
   RETURN v_MatchCount;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
