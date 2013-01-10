﻿-- Function: researchinview.insert_partnershipsnarrative(character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, text)

-- DROP FUNCTION researchinview.insert_partnershipsnarrative(character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, text);

CREATE OR REPLACE FUNCTION researchinview.insert_partnershipsnarrative(
p_integrationactivityid character varying, 
p_integrationuserid character varying, 
p_ispublic integer, 
p_extendedattribute1 character varying, 
p_extendedattribute2 character varying, 
p_extendedattribute3 character varying, 
p_extendedattribute4 character varying, 
p_extendedattribute5 character varying, 
p_narrativetext text
)
  RETURNS bigint AS
$BODY$
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
   v_ActivityID := researchinview.insert_activity('PartnershipsNarrative', p_IntegrationActivityId, p_IntegrationUserId, p_IsPublic, p_ExtendedAttribute1,
	p_ExtendedAttribute2, p_ExtendedAttribute3, p_ExtendedAttribute4, p_ExtendedAttribute5);

   -- get resource ID
   SELECT resource_id INTO v_ResourceID
     FROM researchinview.activity_import_log
    WHERE id = v_ActivityID;

   IF v_ResourceID IS NULL THEN

      -- resource ID was not found so add the narrative
      v_NarrativeID := kmdata.add_new_narrative('researchinview', 'Partnership Narrative', researchinview.strip_riv_tags(p_NarrativeText), p_IsPublic);

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
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;
ALTER FUNCTION researchinview.insert_partnershipsnarrative(character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, text)
  OWNER TO kmdata;
GRANT EXECUTE ON FUNCTION researchinview.insert_partnershipsnarrative(character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, text) TO public;
GRANT EXECUTE ON FUNCTION researchinview.insert_partnershipsnarrative(character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, text) TO kmdata;
GRANT EXECUTE ON FUNCTION researchinview.insert_partnershipsnarrative(character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, text) TO kmd_riv_tr_export_user;
