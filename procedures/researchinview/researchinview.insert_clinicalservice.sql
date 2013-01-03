CREATE OR REPLACE FUNCTION researchinview.insert_clinicalservice (
   p_IntegrationActivityId VARCHAR(2000),
   p_IntegrationUserId VARCHAR(2000),
   p_IsPublic INTEGER,
   p_ExtendedAttribute1 VARCHAR(4000),
   p_ExtendedAttribute2 VARCHAR(4000),
   p_ExtendedAttribute3 VARCHAR(4000),
   p_ExtendedAttribute4 VARCHAR(4000),
   p_ExtendedAttribute5 VARCHAR(4000),
   p_ClinicalHoursPer VARCHAR(2000),
   p_Department VARCHAR(2000),
   p_DescriptionOfEffort TEXT, 
   p_EndedOn VARCHAR(2000),
   p_IndividualsServed INTEGER,
   p_Location VARCHAR(2000),
   p_Ongoing VARCHAR(2000),
   p_Role VARCHAR(2000),
   p_RoleOther VARCHAR(2000),
   p_StartedOn VARCHAR(2000),
   p_Title VARCHAR(2000),
   p_TotalHoursTeachingClinic INTEGER,
   p_TypeOfService VARCHAR(2000),
   p_URL VARCHAR(4000)
   ) RETURNS BIGINT AS $$
DECLARE
   v_ActivityID BIGINT;
   v_ResourceID BIGINT;
   v_ClinicalServiceID BIGINT;
   v_UserID BIGINT;
   v_ClinicalServiceMatchCount BIGINT;
   v_TypeOfService INTEGER;
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
   v_ActivityID := researchinview.insert_activity('ClinicalService', p_IntegrationActivityId, p_IntegrationUserId, p_IsPublic, p_ExtendedAttribute1,
	p_ExtendedAttribute2, p_ExtendedAttribute3, p_ExtendedAttribute4, p_ExtendedAttribute5);

   -- get resource ID
   SELECT resource_id INTO v_ResourceID
     FROM researchinview.activity_import_log
    WHERE id = v_ActivityID;

   IF v_ResourceID IS NULL THEN
      v_ResourceID := add_new_resource('researchinview', 'clinical_service');
   END IF;

   -- update activity table in the researchinview schema
   UPDATE researchinview.activity_import_log
      SET resource_id = v_ResourceID
    WHERE id = v_ActivityID;

   -- check to see if there is a record in clinical_service with this resource id
   SELECT COUNT(*) INTO v_ClinicalServiceMatchCount
     FROM kmdata.clinical_service
    WHERE resource_id = v_ResourceID;


   -- map fields here

   v_TypeOfService := CAST(p_TypeOfService AS INTEGER);

   -- these are not used: p_ClinicalHoursPer, p_Department, p_IndividualsServed, p_Ongoing, p_Role, p_RoleOther, p_TotalHoursTeachingClinic
   -- ommitted: p_EndedOn, p_StartedOn
   
   IF v_ClinicalServiceMatchCount = 0 THEN
   
      -- insert activity information
      v_ClinicalServiceID := nextval('kmdata.clinical_service_id_seq');

      INSERT INTO kmdata.clinical_service
         (id, user_id, description, location, title, clinical_service_type_id, url, 
          start_date, clinical_hours_per,
          end_date, department,
          created_at, updated_at, resource_id, individuals_served, ongoing, role, role_other,total_hours_teaching_clinic    )
      VALUES
         (v_ClinicalServiceID, v_UserID, researchinview.strip_riv_tags(p_DescriptionOfEffort), p_Location, researchinview.strip_riv_tags(p_Title), v_TypeOfService, p_URL, 
          date (researchinview.get_year(p_StartedOn) || '-' || researchinview.get_month(p_StartedOn) || '-1'), p_ClinicalHoursPer,
          date (researchinview.get_year(p_EndedOn) || '-' || researchinview.get_month(p_EndedOn) || '-1'), p_Department,
          current_timestamp, current_timestamp, v_ResourceID, p_IndividualsServed, p_Ongoing, p_Role, p_RoleOther, p_TotalHoursTeachingClinic);
      
   ELSE
   
      -- get the narrative
      SELECT id INTO v_ClinicalServiceID
        FROM kmdata.clinical_service
       WHERE resource_id = v_ResourceID;

      -- update the clinical_service table
      UPDATE kmdata.clinical_service
         SET user_id = v_UserID, 
             description = researchinview.strip_riv_tags(p_DescriptionOfEffort), 
             location = p_Location,
             clinical_hours_per = p_ClinicalHoursPer,
             department = p_Department,
             individuals_served = p_IndividualsServed, 
             ongoing = p_Ongoing, 
             role = p_Role, 
             role_other = p_RoleOther,
             total_hours_teaching_clinic = p_TotalHoursTeachingClinic,
             title = researchinview.strip_riv_tags(p_Title), 
             clinical_service_type_id = v_TypeOfService, 
             url = p_URL,
             start_date = date (researchinview.get_year(p_StartedOn) || '-' || researchinview.get_month(p_StartedOn) || '-1'),
             end_date = date (researchinview.get_year(p_EndedOn) || '-' || researchinview.get_month(p_EndedOn) || '-1'),
             updated_at = current_timestamp
       WHERE id = v_ClinicalServiceID;

   END IF;
   
   RETURN v_ClinicalServiceID;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
