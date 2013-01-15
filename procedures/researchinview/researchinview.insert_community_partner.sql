-- Function: researchinview.insert_community_partner(character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying)

-- DROP FUNCTION researchinview.insert_community_partner(character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying);

CREATE OR REPLACE FUNCTION researchinview.insert_community_partner(
p_integrationactivityid character varying, 
p_integrationuserid character varying, 
p_ispublic integer, 
p_extendedattribute1 character varying, 
p_extendedattribute2 character varying, 
p_extendedattribute3 character varying, 
p_extendedattribute4 character varying, 
p_extendedattribute5 character varying, 
p_city character varying, 
p_contactwithinorganization character varying, 
p_country character varying, 
p_descriptionofrole character varying, 
p_organization character varying, 
p_stateprovince character varying, 
p_stateprovinceother character varying, 
p_title character varying, 
p_url character varying
)
  RETURNS bigint AS
$BODY$
DECLARE
   v_ActivityID BIGINT;
   v_ResourceID BIGINT;
   v_CommunityPartnerID BIGINT;
   v_UserID BIGINT;
   v_CommunityPartnerMatchCount BIGINT;
   v_State VARCHAR(100);
BEGIN
   -- maps to Papers in Proceedings
   
   -- select the user ID
   --v_UserID := p_IntegrationUserId;
   SELECT user_id INTO v_UserID
     FROM kmdata.user_identifiers
    WHERE emplid = p_IntegrationUserId;
   
   IF v_UserID IS NULL THEN
      RETURN 0;
   END IF;
   
   -- insert activity information
   v_ActivityID := researchinview.insert_activity('CommunityPartner', p_IntegrationActivityId, p_IntegrationUserId, p_IsPublic, p_ExtendedAttribute1,
	p_ExtendedAttribute2, p_ExtendedAttribute3, p_ExtendedAttribute4, p_ExtendedAttribute5);

   -- get resource ID
   SELECT resource_id INTO v_ResourceID
     FROM researchinview.activity_import_log
    WHERE id = v_ActivityID;

    v_State := p_StateProvince;
   IF v_State IS NULL OR v_State = '' THEN
      v_State := p_StateProvinceOther;
   END IF;

   IF v_ResourceID IS NULL THEN
      v_ResourceID := kmdata.add_new_resource('researchinview', 'community_partner');
   END IF;

   -- update activity table in the researchinview schema
   UPDATE researchinview.activity_import_log
      SET resource_id = v_ResourceID
    WHERE id = v_ActivityID;
   

   -- check to see if there is a record in grant_data with this resource id
   SELECT COUNT(*) INTO v_CommunityPartnerMatchCount
     FROM kmdata.community_partner
    WHERE resource_id = v_ResourceID;

   IF v_CommunityPartnerMatchCount = 0 THEN
   
      -- insert activity information
      v_CommunityPartnerID := nextval('kmdata.community_partner_id_seq');
   
      INSERT INTO kmdata.community_partner
         (id, resource_id, user_id, title, organization, contact_within_organization, description_of_role, city,
          state, country, url, created_at, updated_at)
      VALUES
         (v_CommunityPartnerID, v_ResourceID, v_UserID, p_Title, p_Organization, p_ContactWithinOrganization, p_DescriptionOfRole,
           p_City, v_State, p_Country, p_URL, current_timestamp, current_timestamp);
   
   ELSE
   
      -- get the work id
      SELECT id INTO v_CommunityPartnerID
        FROM kmdata.community_partner
       WHERE resource_id = v_ResourceID;

      -- update the works table
      UPDATE kmdata.community_partner
         SET title = p_Title,
             organization = p_Organization,
             contact_within_organization = p_ContactWithinOrganization,
             description_of_role = p_DescriptionOfRole,
             city = p_City,
             state = v_State,
             country = p_Country,
             url = p_URL,
	     updated_at = current_timestamp
       WHERE id = v_CommunityPartnerID;    
      
   END IF;
   
   RETURN v_CommunityPartnerID;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;
ALTER FUNCTION researchinview.insert_community_partner(character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying)
  OWNER TO kmdata;
GRANT EXECUTE ON FUNCTION researchinview.insert_community_partner(character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying) TO public;
--GRANT EXECUTE ON FUNCTION researchinview.insert_community_partner(character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying) TO kmdata_admin;
GRANT EXECUTE ON FUNCTION researchinview.insert_community_partner(character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying) TO kmd_dev_riv_user;
GRANT EXECUTE ON FUNCTION researchinview.insert_community_partner(character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying) TO kmd_riv_tr_export_user;
