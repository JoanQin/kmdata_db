CREATE OR REPLACE FUNCTION researchinview.insert_consultant (
   p_IntegrationActivityId VARCHAR(2000),
   p_IntegrationUserId VARCHAR(2000),
   p_IsPublic INTEGER,
   p_ExtendedAttribute1 VARCHAR(4000),
   p_ExtendedAttribute2 VARCHAR(4000),
   p_ExtendedAttribute3 VARCHAR(4000),
   p_ExtendedAttribute4 VARCHAR(4000),
   p_ExtendedAttribute5 VARCHAR(4000),
   p_ActivityCategory VARCHAR(2000),
   p_ActivityCategoryOther VARCHAR(2000),
   p_ActivityName VARCHAR(2000),
   p_City VARCHAR(2000),
   p_Country VARCHAR(2000),
   p_DescriptionOfEffort TEXT,
   p_EndedOn VARCHAR(2000),
   p_Fee VARCHAR(2000),
   p_OneTime VARCHAR(2000),
   p_Ongoing VARCHAR(2000),
   p_Organization VARCHAR(2000),
   p_StartedOn VARCHAR(2000),
   p_StateProvince VARCHAR(2000),
   p_StateProvinceOther VARCHAR(2000),
   p_TypeOfActivity VARCHAR(2000),
   p_TypeOfActivityOther VARCHAR(2000),
   p_URL VARCHAR(4000)
   ) RETURNS BIGINT AS $$
DECLARE
   v_ActivityID BIGINT;
   v_ResourceID BIGINT;
   v_ConsultantID BIGINT;
   v_UserID BIGINT;
   v_ConsultantMatchCount BIGINT;
   v_State VARCHAR(255);
   v_Role INTEGER;
   v_RoleModifier INTEGER;
   v_ActivityCategory INTEGER;
   v_Fee SMALLINT;
   v_OneTime SMALLINT;
   v_TypeOfActivity INTEGER;
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
   v_ActivityID := researchinview.insert_activity('Consultant', p_IntegrationActivityId, p_IntegrationUserId, p_IsPublic, p_ExtendedAttribute1,
	p_ExtendedAttribute2, p_ExtendedAttribute3, p_ExtendedAttribute4, p_ExtendedAttribute5);

   -- get resource ID
   SELECT resource_id INTO v_ResourceID
     FROM researchinview.activity_import_log
    WHERE id = v_ActivityID;

   IF v_ResourceID IS NULL THEN
      v_ResourceID := add_new_resource('researchinview', 'professional_activity');
   END IF;

   -- update activity table in the researchinview schema
   UPDATE researchinview.activity_import_log
      SET resource_id = v_ResourceID
    WHERE id = v_ActivityID;

   -- check to see if there is a record in works with this resource id
   SELECT COUNT(*) INTO v_ConsultantMatchCount
     FROM kmdata.professional_activity
    WHERE resource_id = v_ResourceID;

   v_State := p_StateProvince;
   IF v_State IS NULL OR v_State = '' THEN
      v_State := p_StateProvinceOther;
   END IF;

   v_Fee := 0;
   IF UPPER(p_Fee) = 'Y' OR p_Fee = '1' THEN
      v_Fee := 1;
   END IF;

   v_OneTime := 0;
   IF UPPER(p_OneTime) = 'Y' OR p_OneTime = '1' THEN
      v_OneTime := 1;
   END IF;

   v_ActivityCategory := CAST(p_ActivityCategory AS INTEGER);
   v_TypeOfActivity := CAST(p_TypeOfActivity AS INTEGER);
   
   -- NOT MAPPED YET: p_EndedOn, p_StartedOn, 
   -- NOT IN: p_Ongoing

   IF v_ConsultantMatchCount = 0 THEN
   
      -- insert activity information
      v_ConsultantID := nextval('kmdata.professional_activity_id_seq');

      INSERT INTO kmdata.professional_activity
         (id, resource_id, user_id, activity_type_id, activity_name, city, country, key_achievements, 
          for_fee_ind, one_day_event_ind, org_name, state, activity_sub_type_id, url, 
          created_at, updated_at,
          start_year, start_month, start_day,
          end_year, end_month, end_day)
      VALUES
         (v_ConsultantID, v_ResourceID, v_UserID, v_ActivityCategory, p_ActivityName, p_City, p_Country, researchinview.strip_riv_tags(p_DescriptionOfEffort), 
          v_Fee, v_OneTime, p_Organization, v_State, v_TypeOfActivity, p_URL, 
          current_timestamp, current_timestamp,
          researchinview.get_year(p_StartedOn), researchinview.get_month(p_StartedOn), NULL,
          researchinview.get_year(p_EndedOn), researchinview.get_month(p_EndedOn), NULL);
   
   ELSE
   
      -- get the work id
      SELECT id INTO v_ConsultantID
        FROM kmdata.professional_activity
       WHERE resource_id = v_ResourceID;

      -- update the works table
      UPDATE kmdata.professional_activity
         SET user_id = v_UserID,
             activity_type_id = v_ActivityCategory, 
             activity_name = p_ActivityName, 
             city = p_City, 
             country = p_Country, 
             key_achievements = researchinview.strip_riv_tags(p_DescriptionOfEffort), 
             for_fee_ind = v_Fee, 
             one_day_event_ind = v_OneTime, 
             org_name = p_Organization, 
             state = v_State, 
             activity_sub_type_id = v_TypeOfActivity, 
             url = p_URL, 
             updated_at = current_timestamp,
             start_year = researchinview.get_year(p_StartedOn), 
             start_month = researchinview.get_month(p_StartedOn), 
             start_day = NULL,
             end_year = researchinview.get_year(p_EndedOn), 
             end_month = researchinview.get_month(p_EndedOn), 
             end_day = NULL
       WHERE id = v_ConsultantID;

   END IF;
   
   RETURN v_ConsultantID;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
