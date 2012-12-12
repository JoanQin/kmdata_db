CREATE OR REPLACE FUNCTION researchinview.insert_mediacontact (
   p_IntegrationActivityId VARCHAR(2000),
   p_IntegrationUserId VARCHAR(2000),
   p_IsPublic INTEGER,
   p_ExtendedAttribute1 VARCHAR(4000),
   p_ExtendedAttribute2 VARCHAR(4000),
   p_ExtendedAttribute3 VARCHAR(4000),
   p_ExtendedAttribute4 VARCHAR(4000),
   p_ExtendedAttribute5 VARCHAR(4000),
   p_PreferredSubject1 VARCHAR(2000),
   p_PreferredSubject2 VARCHAR(2000),
   p_SelfDefinedTopic1 VARCHAR(2000),
   p_SelfDefinedTopic2 VARCHAR(2000)
) RETURNS BIGINT AS $$
DECLARE
   v_ActivityID BIGINT;
   v_ResourceID BIGINT;
   v_MediaContactID BIGINT;
   v_MediaContactMatchCount BIGINT;
   v_UserID BIGINT;
   v_CIPArea VARCHAR(255);
   v_CIPFocus VARCHAR(255);
BEGIN
   -- select the user ID
   --v_UserID := p_IntegrationUserId;
   SELECT user_id INTO v_UserID
     FROM kmdata.user_identifiers
    WHERE emplid = p_IntegrationUserId;
   
   IF v_UserID IS NULL THEN
      RETURN 0;
   END IF;
   
   -- insert activity information
   v_ActivityID := researchinview.insert_activity('MediaContact', p_IntegrationActivityId, p_IntegrationUserId, p_IsPublic, p_ExtendedAttribute1,
	p_ExtendedAttribute2, p_ExtendedAttribute3, p_ExtendedAttribute4, p_ExtendedAttribute5);

   -- get resource ID
   SELECT resource_id INTO v_ResourceID
     FROM researchinview.activity_import_log
    WHERE id = v_ActivityID;

   IF v_ResourceID IS NULL THEN
      v_ResourceID := add_new_resource('researchinview', 'user_preferred_names');
   END IF;

   -- update activity table in the researchinview schema
   UPDATE researchinview.activity_import_log
      SET resource_id = v_ResourceID
    WHERE id = v_ActivityID;

   -- ****************************************
   -- additional field mappings and processing
   -- ****************************************
   v_CIPArea := trim(both ' ' from split_part(p_PreferredSubject1, ',', 1));
   v_CIPFocus := p_PreferredSubject1; -- trim(both ' ' from split_part(p_PreferredSubject1, ',', 2));

   -- ******************** NOT MAPPED IN PRO/KMDATA ********************************

   -- SKIPPED: p_PreferredSubject1
   -- 

   -- check to see if there is a record in user_preferred_names with this resource id
   SELECT COUNT(*) INTO v_MediaContactMatchCount
     FROM kmdata.user_preferred_names
    WHERE resource_id = v_ResourceID;

   IF v_MediaContactMatchCount = 0 THEN
   
      -- insert activity information
      v_MediaContactID := nextval('kmdata.user_preferred_names_id_seq');

      -- get the CIP code data
      

      -- NEW: cip_area, cip_focus
      INSERT INTO kmdata.user_preferred_names
         (id, resource_id, user_id, cip_area, cip_focus, created_at, updated_at)
      VALUES
         (v_MediaContactID, v_ResourceID, v_UserID, v_CIPArea, v_CIPFocus, current_timestamp, current_timestamp);

   ELSE
   
      -- get the user preferred name id
      SELECT id INTO v_MediaContactID
        FROM kmdata.user_preferred_names
       WHERE resource_id = v_ResourceID;

      -- update the user_preferred_names table
      UPDATE kmdata.user_preferred_names
         SET user_id = v_UserID,
             cip_area = v_CIPArea, 
             cip_focus = v_CIPFocus,
             updated_at = current_timestamp
       WHERE id = v_MediaContactID;

   END IF;
   
   RETURN v_MediaContactID;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
