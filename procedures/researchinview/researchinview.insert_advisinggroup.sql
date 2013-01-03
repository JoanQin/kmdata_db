CREATE OR REPLACE FUNCTION researchinview.insert_advisinggroup (
   p_IntegrationActivityId VARCHAR(2000),
   p_IntegrationUserId VARCHAR(2000),
   p_IsPublic INTEGER,
   p_ExtendedAttribute1 VARCHAR(4000),
   p_ExtendedAttribute2 VARCHAR(4000),
   p_ExtendedAttribute3 VARCHAR(4000),
   p_ExtendedAttribute4 VARCHAR(4000),
   p_ExtendedAttribute5 VARCHAR(4000),
   p_AcademicLevel VARCHAR(2000),
   p_DescriptionOfEffort TEXT, 
   p_EndedOn VARCHAR(2000),
   p_InstitutionCommonNameID INTEGER,
   p_NoteworthyAccomplishments TEXT,
   p_Ongoing VARCHAR(2000),
   p_Role VARCHAR(2000),
   p_RoleOther VARCHAR(2000),
   p_StartedOn VARCHAR(2000),
   p_StudentGroup VARCHAR(2000),
   p_TypeOfGroup VARCHAR(2000),
   p_TypeOfGroupOther VARCHAR(2000),
   p_URL VARCHAR(4000)
   ) RETURNS BIGINT AS $$
DECLARE
   v_ActivityID BIGINT;
   v_ResourceID BIGINT;
   v_AdvisingGroupID BIGINT;
   v_UserID BIGINT;
   v_AdvisingMatchCount BIGINT;
   v_RoleTypeID INTEGER;
   v_Inst BIGINT;
   v_WorkDescrID BIGINT;
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
   v_ActivityID := researchinview.insert_activity('AdvisingGroup', p_IntegrationActivityId, p_IntegrationUserId, p_IsPublic, p_ExtendedAttribute1,
	p_ExtendedAttribute2, p_ExtendedAttribute3, p_ExtendedAttribute4, p_ExtendedAttribute5);

   -- get resource ID
   SELECT resource_id INTO v_ResourceID
     FROM researchinview.activity_import_log
    WHERE id = v_ActivityID;

   IF v_ResourceID IS NULL THEN
      v_ResourceID := add_new_resource('researchinview', 'advising');
   END IF;

   -- update activity table in the researchinview schema
   UPDATE researchinview.activity_import_log
      SET resource_id = v_ResourceID
    WHERE id = v_ActivityID;

   -- check to see if there is a record in advising with this resource id
   SELECT COUNT(*) INTO v_AdvisingMatchCount
     FROM kmdata.advising
    WHERE resource_id = v_ResourceID;


   -- map fields here

   v_RoleTypeID := CAST(p_Role AS INTEGER);

   -- fields not used: p_DescriptionOfEffort, p_Ongoing, p_RoleOther, p_TypeOfGroup, p_TypeOfGroupOther, p_URL
   -- skipped:  p_EndedOn, p_StartedOn

   v_Inst := researchinview.insert_institution(p_InstitutionCommonNameID);

   IF v_AdvisingMatchCount = 0 THEN
   
      -- insert activity information
      v_AdvisingGroupID := nextval('kmdata.advising_id_seq');

      INSERT INTO kmdata.advising
         (id, user_id, level_id, institution_id, notes, role_id, 
          student_group, start_year, start_month, end_year, end_month, 
          created_at, updated_at, resource_id, description_of_effort, ongoing, role_other, type_of_group, type_of_group_other, url)
      VALUES
         (v_AdvisingGroupID, v_UserID, CAST(p_AcademicLevel AS INTEGER), v_Inst, researchinview.strip_riv_tags(p_NoteworthyAccomplishments), v_RoleTypeID, 
          researchinview.strip_riv_tags(p_StudentGroup), researchinview.get_year(p_StartedOn), researchinview.get_month(p_StartedOn), researchinview.get_year(p_EndedOn), researchinview.get_month(p_EndedOn), 
          current_timestamp, current_timestamp, v_ResourceID, p_DescriptionOfEffort, p_Ongoing, p_RoleOther, p_TypeOfGroup, p_TypeOfGroupOther, p_URL);

   ELSE
   
      -- get the narrative
      SELECT id INTO v_AdvisingGroupID
        FROM kmdata.advising
       WHERE resource_id = v_ResourceID;

      -- update the advising table
      UPDATE kmdata.advising
         SET user_id = v_UserID, 
             level_id = CAST(p_AcademicLevel AS INTEGER), 
             institution_id = v_Inst, 
             notes = researchinview.strip_riv_tags(p_NoteworthyAccomplishments), 
             role_id = v_RoleTypeID, 
             description_of_effort = p_DescriptionOfEffort, 
             ongoing = p_Ongoing, 
             role_other = p_RoleOther, 
             type_of_group = p_TypeOfGroup, 
             type_of_group_other = p_TypeOfGroupOther, 
             url = p_URL,
             student_group = researchinview.strip_riv_tags(p_StudentGroup), 
             start_year = researchinview.get_year(p_StartedOn), 
             start_month = researchinview.get_month(p_StartedOn), 
             end_year = researchinview.get_year(p_EndedOn), 
             end_month = researchinview.get_month(p_EndedOn),
             updated_at = current_timestamp
       WHERE id = v_AdvisingGroupID;

   END IF;
   
   RETURN v_AdvisingGroupID;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
