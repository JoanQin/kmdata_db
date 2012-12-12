CREATE OR REPLACE FUNCTION researchinview.insert_activity (
   p_RIVActivityName VARCHAR(2000),
   p_IntegrationActivityId VARCHAR(2000),
   p_IntegrationUserId VARCHAR(2000),
   p_IsPublic INTEGER,
   p_ExtendedAttribute1 VARCHAR(4000),
   p_ExtendedAttribute2 VARCHAR(4000),
   p_ExtendedAttribute3 VARCHAR(4000),
   p_ExtendedAttribute4 VARCHAR(4000),
   p_ExtendedAttribute5 VARCHAR(4000)
) RETURNS BIGINT AS $$
DECLARE
   v_MatchCount BIGINT;
   v_ResourceID BIGINT;
   v_ActivitySeqID BIGINT;
BEGIN
   -- log this item in the activity table
   v_MatchCount := 0;

   SELECT COUNT(*) INTO v_MatchCount
     FROM researchinview.activity_import_log
    WHERE riv_activity_name = p_RIVActivityName
      AND integration_activity_id = p_IntegrationActivityId
      AND integration_user_id = p_IntegrationUserId;

   IF v_MatchCount = 0 THEN

      -- create a new ID
      v_ActivitySeqID := nextval('researchinview.activity_import_log_id_seq');

      -- insert the data
      INSERT INTO researchinview.activity_import_log
         (id, integration_activity_id, integration_user_id, change_type, is_public, 
          extended_attribute_1, extended_attribute_2, extended_attribute_3, extended_attribute_4, extended_attribute_5,
          riv_activity_name, resource_id, update_date)
      VALUES
         (v_ActivitySeqID, p_IntegrationActivityId, p_IntegrationUserId, 'INSERT',  p_IsPublic,
          p_ExtendedAttribute1, p_ExtendedAttribute2, p_ExtendedAttribute3, p_ExtendedAttribute4, p_ExtendedAttribute5,
          p_RIVActivityName, NULL, current_timestamp);

   ELSE

      -- get the ID
      SELECT id INTO v_ActivitySeqID
        FROM researchinview.activity_import_log
       WHERE riv_activity_name = p_RIVActivityName
         AND integration_activity_id = p_IntegrationActivityId
         AND integration_user_id = p_IntegrationUserId;

      -- update the log entry
      UPDATE researchinview.activity_import_log
         SET change_type = 'UPDATE', -- overwrites previous actions
             is_public = p_IsPublic,
             is_active = 1, -- new JSW (this brings back an item if it were undeleted)
             extended_attribute_1 = p_ExtendedAttribute1,
             extended_attribute_2 = p_ExtendedAttribute2,
             extended_attribute_3 = p_ExtendedAttribute3,
             extended_attribute_4 = p_ExtendedAttribute4,
             extended_attribute_5 = p_ExtendedAttribute5,
             update_date = current_timestamp
       WHERE id = v_ActivitySeqID;

   END IF;
   
   RETURN v_ActivitySeqID;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
