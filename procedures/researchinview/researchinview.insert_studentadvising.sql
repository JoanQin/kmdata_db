CREATE OR REPLACE FUNCTION researchinview.insert_studentadvising (
   p_IntegrationActivityId VARCHAR(2000),
   p_IntegrationUserId VARCHAR(2000),
   p_IsPublic INTEGER,
   p_ExtendedAttribute1 VARCHAR(4000),
   p_ExtendedAttribute2 VARCHAR(4000),
   p_ExtendedAttribute3 VARCHAR(4000),
   p_ExtendedAttribute4 VARCHAR(4000),
   p_ExtendedAttribute5 VARCHAR(4000),
   p_AcademicLevel VARCHAR(2000),
   p_Accomplishments VARCHAR(2000),
   p_AccomplishmentsOther VARCHAR(2000),
   p_AdviseeAdvisorCoDepartment VARCHAR(2000),
   p_AdviseeName VARCHAR(2000),
   p_AdvisingEndedOn VARCHAR(2000),
   p_AdvisingOngoing VARCHAR(2000),
   p_AdvisingRole VARCHAR(2000),
   p_AdvisingStartedOn VARCHAR(2000),
   p_Completed VARCHAR(2000),
   p_CurrentPosition VARCHAR(2000),
   p_CurrentPositionOther VARCHAR(2000),
   p_GraduatedOn VARCHAR(2000),
   p_InstitutionCommonNameId INTEGER,
   p_Major VARCHAR(2000),
   p_Minor VARCHAR(2000),
   p_StudentId INTEGER,
   p_ThesisTitle VARCHAR(4000),
   p_UniversityID VARCHAR(2000)
) RETURNS BIGINT AS $$
DECLARE
   v_ActivityID BIGINT;
   v_ResourceID BIGINT;
   v_StudentAdvisingID BIGINT;
   v_StudentAdvisingMatchCount BIGINT;
   v_UserID BIGINT;
   v_InstitutionID BIGINT;
   v_Completed SMALLINT;
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
   v_ActivityID := researchinview.insert_activity('StudentAdvising', p_IntegrationActivityId, p_IntegrationUserId, p_IsPublic, p_ExtendedAttribute1,
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

   v_InstitutionID := researchinview.insert_institution(p_InstitutionCommonNameId);

   v_Completed := 0;
   IF upper(p_Completed) = 'Y' OR p_Completed = '1' THEN
      v_Completed := 1;
   END IF;

   v_InstitutionID := researchinview.insert_institution(p_InstitutionCommonNameId);

   -- missing: p_Accomplishments, p_AdviseeAdvisorCoDepartment, p_AdvisingOngoing, p_Major, p_Minor, p_UniversityID

   -- check to see if there is a record in grant_data with this resource id
   SELECT COUNT(*) INTO v_StudentAdvisingMatchCount
     FROM kmdata.advising
    WHERE resource_id = v_ResourceID;

   IF v_StudentAdvisingMatchCount = 0 THEN
   
      -- insert activity information
      v_StudentAdvisingID := nextval('kmdata.advising_id_seq');

      --p_CourseType
      INSERT INTO kmdata.advising
         (id, resource_id, user_id, level_id, first_name, last_name, 
          end_year, end_month, end_day, accomplishments, accomplishments_other,
          start_year, start_month, start_day, advisee_advisor_codepartment, student_id,
          role_id, graduated, advisee_current_position, graduation_year, 
          institution_id, title, ongoing, major, minor, university_id, current_position_other,
          created_at, updated_at)
      VALUES
         (v_StudentAdvisingID, v_ResourceID, v_UserID, CAST(p_AcademicLevel AS INTEGER), split_part(p_AdviseeName, ' ', 1), split_part(p_AdviseeName, ' ', 2), 
          researchinview.get_year(p_AdvisingEndedOn), researchinview.get_month(p_AdvisingEndedOn), NULL, p_Accomplishments, p_AccomplishmentsOther,
          researchinview.get_year(p_AdvisingStartedOn), researchinview.get_month(p_AdvisingStartedOn), NULL, p_AdviseeAdvisorCoDepartment, p_StudentId, 
          CAST(p_AdvisingRole AS INTEGER), v_Completed, p_CurrentPosition, researchinview.get_year(p_GraduatedOn),
          v_InstitutionID, researchinview.strip_riv_tags(p_ThesisTitle), p_AdvisingOngoing, p_Major, p_Minor,p_UniversityID,p_CurrentPositionOther,
          current_timestamp, current_timestamp);

   ELSE
   
      -- get the work id
      SELECT id INTO v_StudentAdvisingID
        FROM kmdata.advising
       WHERE resource_id = v_ResourceID;

      -- update the works table
      UPDATE kmdata.advising
         SET user_id = v_UserID, 
             level_id = CAST(p_AcademicLevel AS INTEGER), 
             first_name = split_part(p_AdviseeName, ' ', 1), 
             last_name = split_part(p_AdviseeName, ' ', 2), 
             end_year = researchinview.get_year(p_AdvisingEndedOn), 
             end_month = researchinview.get_month(p_AdvisingEndedOn), 
             end_day = NULL, 
             accomplishments = p_Accomplishments,
             accomplishments_other = p_AccomplishmentsOther,
             advisee_advisor_codepartment = p_AdviseeAdvisorCoDepartment,
             student_id = p_StudentId,
             ongoing = p_AdvisingOngoing,
             major = p_Major,
             minor = p_Minor,
             university_id = p_UniversityID,
             current_position_other = p_CurrentPositionOther,
             start_year = researchinview.get_year(p_AdvisingStartedOn), 
             start_month = researchinview.get_month(p_AdvisingStartedOn), 
             start_day = NULL,
             role_id = CAST(p_AdvisingRole AS INTEGER), 
             graduated = v_Completed, 
             advisee_current_position = p_CurrentPosition, 
             graduation_year = researchinview.get_year(p_GraduatedOn), 
             institution_id = v_InstitutionID, 
             title = researchinview.strip_riv_tags(p_ThesisTitle),
             updated_at = current_timestamp
       WHERE id = v_StudentAdvisingID;

   END IF;
   
   RETURN v_StudentAdvisingID;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
