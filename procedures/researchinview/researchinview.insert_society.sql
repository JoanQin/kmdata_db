CREATE OR REPLACE FUNCTION researchinview.insert_society (
   p_IntegrationActivityId VARCHAR(2000),
   p_IntegrationUserId VARCHAR(2000),
   p_IsPublic INTEGER,
   p_ExtendedAttribute1 VARCHAR(4000),
   p_ExtendedAttribute2 VARCHAR(4000),
   p_ExtendedAttribute3 VARCHAR(4000),
   p_ExtendedAttribute4 VARCHAR(4000),
   p_ExtendedAttribute5 VARCHAR(4000),
   p_City VARCHAR(2000),
   p_Country VARCHAR(2000),
   p_DescriptionOfEffort TEXT,
   p_EndedOn VARCHAR(2000),
   p_GroupSection VARCHAR(2000),
   p_InstitutionCommonNameID INTEGER,
   p_Ongoing VARCHAR(2000),
   p_OrganizationID INTEGER,
   p_Role VARCHAR(2000),
   p_RoleModifier VARCHAR(2000),
   p_StartedOn VARCHAR(2000),
   p_StateProvince VARCHAR(2000),
   p_StateProvinceOther VARCHAR(2000),
   p_URL VARCHAR(4000)
   ) RETURNS BIGINT AS $$
DECLARE
   v_ActivityID BIGINT;
   v_ResourceID BIGINT;
   v_MembershipID BIGINT;
   v_UserID BIGINT;
   v_MembershipMatchCount BIGINT;
   v_State VARCHAR(255);
   v_Role INTEGER;
   v_RoleModifier INTEGER;
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
   v_ActivityID := researchinview.insert_activity('Society', p_IntegrationActivityId, p_IntegrationUserId, p_IsPublic, p_ExtendedAttribute1,
	p_ExtendedAttribute2, p_ExtendedAttribute3, p_ExtendedAttribute4, p_ExtendedAttribute5);

   -- get resource ID
   SELECT resource_id INTO v_ResourceID
     FROM researchinview.activity_import_log
    WHERE id = v_ActivityID;

   IF v_ResourceID IS NULL THEN
      v_ResourceID := add_new_resource('researchinview', 'membership');
   END IF;

   -- update activity table in the researchinview schema
   UPDATE researchinview.activity_import_log
      SET resource_id = v_ResourceID
    WHERE id = v_ActivityID;

   -- check to see if there is a record in works with this resource id
   SELECT COUNT(*) INTO v_MembershipMatchCount
     FROM kmdata.membership
    WHERE resource_id = v_ResourceID;

   v_State := p_StateProvince;
   IF v_State IS NULL OR v_State = '' THEN
      v_State := p_StateProvinceOther;
   END IF;

   v_Role := CAST(p_Role AS INTEGER);
   v_RoleModifier := CAST(p_RoleModifier AS INTEGER);
   
   -- NOT MAPPED YET: p_EndedOn, p_StartedOn, 
   -- NOT IN: p_Ongoing, p_OrganizationID (not used), 

   IF v_MembershipMatchCount = 0 THEN
   
      -- insert activity information
      v_MembershipID := nextval('kmdata.membership_id_seq');

      INSERT INTO kmdata.membership
         (id, resource_id, user_id, organization_city, organization_country, notes, group_name, 
          organization_name, membership_role_id, membership_role_modifier_id, organization_state, organization_website, 
          start_year, start_month, start_day, ongoing, organization_id,
          end_year, end_month, end_day,
          created_at, updated_at)
      VALUES
         (v_MembershipID, v_ResourceID, v_UserID, p_City, p_Country, researchinview.strip_riv_tags(p_DescriptionOfEffort), p_GroupSection, 
          p_InstitutionCommonNameID, v_Role, v_RoleModifier, v_State, p_URL, 
          researchinview.get_year(p_StartedOn), researchinview.get_month(p_StartedOn), NULL, p_Ongoing, p_OrganizationID,
          researchinview.get_year(p_EndedOn), researchinview.get_month(p_EndedOn), NULL,
          current_timestamp, current_timestamp);
   
   ELSE
   
      -- get the work id
      SELECT id INTO v_MembershipID
        FROM kmdata.membership
       WHERE resource_id = v_ResourceID;

      -- update the works table
      UPDATE kmdata.membership
         SET user_id = v_UserID,
             organization_city = p_City, 
             organization_country = p_Country, 
             notes = researchinview.strip_riv_tags(p_DescriptionOfEffort), 
             group_name = p_GroupSection, 
             organization_name = p_InstitutionCommonNameID, 
             membership_role_id = v_Role, 
             membership_role_modifier_id = v_RoleModifier, 
             organization_state = v_State, 
             organization_website = p_URL,
             start_year = researchinview.get_year(p_StartedOn), 
             start_month = researchinview.get_month(p_StartedOn), 
             start_day = NULL,
             ongoing = p_Ongoing,
             organization_id = p_OrganizationID,
             end_year = researchinview.get_year(p_EndedOn), 
             end_month = researchinview.get_month(p_EndedOn), 
             end_day = NULL,
             updated_at = current_timestamp
       WHERE id = v_MembershipID;

   END IF;
   
   RETURN v_MembershipID;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
