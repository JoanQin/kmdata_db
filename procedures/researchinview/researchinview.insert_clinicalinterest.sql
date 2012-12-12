CREATE OR REPLACE FUNCTION researchinview.insert_clinicalinterest (
   p_IntegrationActivityId VARCHAR(2000),
   p_IntegrationUserId VARCHAR(2000),
   p_IsPublic INTEGER,
   p_ExtendedAttribute1 VARCHAR(4000),
   p_ExtendedAttribute2 VARCHAR(4000),
   p_ExtendedAttribute3 VARCHAR(4000),
   p_ExtendedAttribute4 VARCHAR(4000),
   p_ExtendedAttribute5 VARCHAR(4000),
   p_Interest VARCHAR(2000),
   p_InterestOther VARCHAR(2000)
   ) RETURNS BIGINT AS $$
DECLARE
   v_ActivityID BIGINT;
   v_ResourceID BIGINT;
   v_ClinicalInterestID BIGINT;
   v_UserID BIGINT;
   v_ClinicalInterestMatchCount BIGINT;
   v_NarrativeTypeCount BIGINT;
   v_NarrativeTypeName VARCHAR(255);
   v_NarrativeTypeID BIGINT;
   v_Interest VARCHAR(2000);
BEGIN
   v_NarrativeTypeName := 'Clinical Interest';
   
   -- select the user ID
   --v_UserID := p_IntegrationUserId;
   SELECT user_id INTO v_UserID
     FROM kmdata.user_identifiers
    WHERE emplid = p_IntegrationUserId;
   
   IF v_UserID IS NULL THEN
      RETURN 0;
   END IF;
   
   -- insert activity information
   v_ActivityID := researchinview.insert_activity('ClinicalInterest', p_IntegrationActivityId, p_IntegrationUserId, p_IsPublic, p_ExtendedAttribute1,
	p_ExtendedAttribute2, p_ExtendedAttribute3, p_ExtendedAttribute4, p_ExtendedAttribute5);

   -- get resource ID
   SELECT resource_id INTO v_ResourceID
     FROM researchinview.activity_import_log
    WHERE id = v_ActivityID;

   IF v_ResourceID IS NULL THEN
      v_ResourceID := add_new_resource('researchinview', 'narratives');
   END IF;

   -- update activity table in the researchinview schema
   UPDATE researchinview.activity_import_log
      SET resource_id = v_ResourceID
    WHERE id = v_ActivityID;

   -- check to see if there is a record in narratives with this resource id
   SELECT COUNT(*) INTO v_ClinicalInterestMatchCount
     FROM kmdata.narratives
    WHERE resource_id = v_ResourceID;


   -- map fields here
   IF p_Interest IS NULL OR p_Interest = '' THEN
      v_Interest := p_InterestOther;
   ELSE
      v_Interest := p_Interest;
   END IF;
   
   -- get the narrative type ID
   SELECT COUNT(*) INTO v_NarrativeTypeCount
   FROM kmdata.narrative_types
   WHERE narrative_desc = v_NarrativeTypeName;

   IF v_NarrativeTypeCount > 0 THEN
   
      -- select the type id
      SELECT MIN(id) INTO v_NarrativeTypeID
      FROM kmdata.narrative_types
      WHERE narrative_desc = v_NarrativeTypeName;
      
   ELSE

      -- get the sequence number
      v_NarrativeTypeID := nextval('kmdata.narrative_types_id_seq');
      
      -- insert the narrative type
      INSERT INTO kmdata.narrative_types
         (id, narrative_desc)
      VALUES
         (v_NarrativeTypeID, v_NarrativeTypeName);
      
   END IF;
   

   IF v_ClinicalInterestMatchCount = 0 THEN
   
      -- insert activity information
      v_ClinicalInterestID := nextval('kmdata.narratives_id_seq');

      INSERT INTO kmdata.narratives
         (id, narrative_type_id, narrative_text, private_ind, user_id, 
          created_at, updated_at, resource_id)
      VALUES
         (v_ClinicalInterestID, v_NarrativeTypeID, researchinview.strip_riv_tags(v_Interest), p_IsPublic, v_UserID, 
          current_timestamp, current_timestamp, v_ResourceID);
      
      INSERT INTO kmdata.user_narratives
         (user_id, narrative_id)
      VALUES
         (v_UserID, v_ClinicalInterestID);
   
   ELSE
   
      -- get the narrative
      SELECT id INTO v_ClinicalInterestID
        FROM kmdata.narratives
       WHERE resource_id = v_ResourceID;

      -- update the narratives table
      UPDATE kmdata.narratives
         SET narrative_type_id = v_NarrativeTypeID, 
             narrative_text = researchinview.strip_riv_tags(v_Interest), 
             private_ind = p_IsPublic, 
             user_id = v_UserID, 
             updated_at = current_timestamp
       WHERE id = v_ClinicalInterestID;

   END IF;
   
   RETURN v_ClinicalInterestID;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
