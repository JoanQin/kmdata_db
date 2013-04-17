CREATE OR REPLACE FUNCTION researchinview.insert_extensioncurriculumdevelopmentnarrative (
   p_IntegrationActivityId VARCHAR(2000),
   p_IntegrationUserId VARCHAR(2000),
   p_IsPublic INTEGER,
   p_ExtendedAttribute1 VARCHAR(4000),
   p_ExtendedAttribute2 VARCHAR(4000),
   p_ExtendedAttribute3 VARCHAR(4000),
   p_ExtendedAttribute4 VARCHAR(4000),
   p_ExtendedAttribute5 VARCHAR(4000),
   p_NarrativeText TEXT
) RETURNS BIGINT AS $$
DECLARE
   v_ActivityID BIGINT;
   v_ResourceID BIGINT;
   v_UserID BIGINT;
   v_NarrativeID BIGINT;
   v_NarrativeCount BIGINT;
   v_UserNarrCount BIGINT;
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
   v_ActivityID := researchinview.insert_activity('ExtensionCurriculumDevelopmentNarrative', p_IntegrationActivityId, p_IntegrationUserId, p_IsPublic, p_ExtendedAttribute1,
  p_ExtendedAttribute2, p_ExtendedAttribute3, p_ExtendedAttribute4, p_ExtendedAttribute5);

   -- get resource ID
   SELECT resource_id INTO v_ResourceID
     FROM researchinview.activity_import_log
    WHERE id = v_ActivityID;

   IF v_ResourceID IS NULL THEN

      -- resource ID was not found so add the narrative
      v_NarrativeID := kmdata.add_new_narrative('researchinview', 'Extension Curriculum Development', researchinview.strip_riv_tags(p_NarrativeText), p_IsPublic);

      -- get the resource ID
      SELECT resource_id INTO v_ResourceID
        FROM kmdata.narratives
       WHERE id = v_NarrativeID;
      
      -- update the activities table
      UPDATE researchinview.activity_import_log
         SET resource_id = v_ResourceID
       WHERE id = v_ActivityID;
      
   ELSE

      -- select the narrative ID
      SELECT id INTO v_NarrativeID
        FROM kmdata.narratives
       WHERE resource_id = v_ResourceID;

      -- update the narrative text
      UPDATE kmdata.narratives
         SET narrative_text = researchinview.strip_riv_tags(p_NarrativeText),
             private_ind = p_IsPublic,
             updated_at = current_timestamp
       WHERE id = v_NarrativeID;
      
   END IF;

   -- update narrative resource ID
   UPDATE kmdata.narratives
      SET resource_id = v_ResourceID
    WHERE id = v_NarrativeID;

   -- check count in users table
   SELECT COUNT(*) INTO v_UserNarrCount
     FROM kmdata.user_narratives
    WHERE user_id = v_UserID
      AND narrative_id = v_NarrativeID;

   IF v_UserNarrCount = 0 THEN
      INSERT INTO kmdata.user_narratives
         (user_id, narrative_id)
      VALUES
         (v_UserID, v_NarrativeID);
   END IF;

   -- return the narrative
   RETURN v_NarrativeID;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
