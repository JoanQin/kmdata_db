-- Function: researchinview.insert_university_partner(character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer)

-- DROP FUNCTION researchinview.insert_university_partner(character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer);

CREATE OR REPLACE FUNCTION researchinview.insert_university_partner(
p_Integrationactivityid VARCHAR(2000), 
p_Integrationuserid VARCHAR(2000), 
p_Ispublic integer, 
p_Extendedattribute1 VARCHAR(4000), 
p_Extendedattribute2 VARCHAR(4000), 
p_Extendedattribute3 VARCHAR(4000), 
p_Extendedattribute4 VARCHAR(4000), 
p_Extendedattribute5 VARCHAR(4000), 
p_DescriptionOfRole VARCHAR(4000),
p_PartnerIntegrationUserId VARCHAR(2000),
p_PartnerUserId integer
)
  RETURNS bigint AS
$BODY$
DECLARE
   v_ActivityID BIGINT;
   v_ResourceID BIGINT;
   v_UniversityPartnerID BIGINT;
   v_UserID BIGINT;
   v_UniversityPartnerMatchCount BIGINT;
   v_PartnerUserID BIGINT;
BEGIN
   -- maps to Papers in Proceedings
   
   -- select the user ID
   --v_UserID := p_IntegrationUserId;
   SELECT user_id INTO v_UserID
     FROM kmdata.user_identifiers
    WHERE emplid = p_IntegrationUserId;


    SELECT user_id INTO v_PartnerUserID
      FROM kmdata.user_identifiers
    WHERE emplid = p_PartnerIntegrationUserId;
   
   IF v_UserID IS NULL THEN
      RETURN 0;
   END IF;
   
   -- insert activity information
   v_ActivityID := researchinview.insert_activity('UniversityPartner', p_IntegrationActivityId, p_IntegrationUserId, p_IsPublic, p_ExtendedAttribute1,
	p_ExtendedAttribute2, p_ExtendedAttribute3, p_ExtendedAttribute4, p_ExtendedAttribute5);

   -- get resource ID
   SELECT resource_id INTO v_ResourceID
     FROM researchinview.activity_import_log
    WHERE id = v_ActivityID;

   IF v_ResourceID IS NULL THEN
      v_ResourceID := kmdata.add_new_resource('researchinview', 'university_partner');
   END IF;

   -- update activity table in the researchinview schema
   UPDATE researchinview.activity_import_log
      SET resource_id = v_ResourceID
    WHERE id = v_ActivityID;
   

   -- check to see if there is a record in grant_data with this resource id
   SELECT COUNT(*) INTO v_UniversityPartnerMatchCount
     FROM kmdata.university_partner
    WHERE resource_id = v_ResourceID;

   IF v_UniversityPartnerMatchCount = 0 THEN
   
      -- insert activity information
      v_UniversityPartnerID := nextval('kmdata.university_partner_id_seq');
      	   IF v_PartnerUserID IS NULL THEN
	      v_PartnerUserID := v_UniversityPartnerID;
	   END IF; 
   
      INSERT INTO kmdata.university_partner
         (id, resource_id, user_id, partner_user_id, description_of_role, created_at, updated_at)
      VALUES
         (v_UniversityPartnerID, v_ResourceID, v_UserID, v_PartnerUserID, p_DescriptionOfRole, current_timestamp, current_timestamp);
   
   ELSE
   
      -- get the work id
      SELECT id INTO v_UniversityPartnerID
        FROM kmdata.university_partner
       WHERE resource_id = v_ResourceID;

      -- update the works table
      UPDATE kmdata.university_partner
         SET partner_user_id = v_PartnerUserID,
	     description_of_role = p_DescriptionOfRole,
	     updated_at = current_timestamp
       WHERE id = v_UniversityPartnerID;    
      
   END IF;
   
   RETURN v_UniversityPartnerID;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER

