CREATE OR REPLACE FUNCTION researchinview.insert_coursecontinuinged (
   p_IntegrationActivityId VARCHAR(2000),
   p_IntegrationUserId VARCHAR(2000),
   p_IsPublic INTEGER,
   p_ExtendedAttribute1 VARCHAR(4000),
   p_ExtendedAttribute2 VARCHAR(4000),
   p_ExtendedAttribute3 VARCHAR(4000),
   p_ExtendedAttribute4 VARCHAR(4000),
   p_ExtendedAttribute5 VARCHAR(4000),
   p_AcademicCalendar VARCHAR(2000),
   p_AcademicCalendarOther VARCHAR(2000),
   p_City VARCHAR(2000),
   p_Country VARCHAR(2000),
   p_CourseNumber VARCHAR(2000),
   p_CourseTitle VARCHAR(2000),
   p_CourseType VARCHAR(2000),
   p_CreditHours VARCHAR(2000),
   p_Description TEXT,
   p_DescriptionOfRole VARCHAR(3000),
   p_EndedOn VARCHAR(2000),
   p_Enrollment BIGINT,
   p_InstitutionCommonNameId INTEGER,
   p_InstitutionGroupOther VARCHAR(2000),
   p_IntegrationGroupId VARCHAR(2000),
   p_LengthOfClass BIGINT,
   p_NumberOfTimes BIGINT,
   p_OneDay VARCHAR(2000),
   p_OtherEvaluationInfo TEXT,
   p_PeerEvaluated VARCHAR(2000),
   p_PercentTaught INTEGER,
   p_PeriodOffered VARCHAR(2000),
   p_PeriodOfferedOther VARCHAR(2000),
   p_Sponsor VARCHAR(2000),
   p_StartedOn VARCHAR(2000),
   p_StateProvince VARCHAR(2000),
   p_StateProvinceOther VARCHAR(2000),
   p_StudentEvaluated VARCHAR(2000),
   p_SubjectArea VARCHAR(2000)
) RETURNS BIGINT AS $$
DECLARE
   v_ActivityID BIGINT;
   v_ResourceID BIGINT;
   v_CourseTaughtOtherID BIGINT;
   v_CoursesTaughtOtherMatchCount BIGINT;
   v_UserID BIGINT;
   v_InstitutionID BIGINT;
   --v_PeerEvaluated SMALLINT;
   v_StudentEvaluated SMALLINT;
   v_OneDay SMALLINT;
   v_State VARCHAR(255);
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
   v_ActivityID := researchinview.insert_activity('CourseContinuingEd', p_IntegrationActivityId, p_IntegrationUserId, p_IsPublic, p_ExtendedAttribute1,
	p_ExtendedAttribute2, p_ExtendedAttribute3, p_ExtendedAttribute4, p_ExtendedAttribute5);

   -- get resource ID
   SELECT resource_id INTO v_ResourceID
     FROM researchinview.activity_import_log
    WHERE id = v_ActivityID;

   IF v_ResourceID IS NULL THEN
      v_ResourceID := add_new_resource('researchinview', 'courses_taught_other');
   END IF;

   -- update activity table in the researchinview schema
   UPDATE researchinview.activity_import_log
      SET resource_id = v_ResourceID
    WHERE id = v_ActivityID;

   -- missing 
   -- p_AcademicCalendar, p_AcademicCalendarOther, p_City, p_Country, p_InstitutionGroupOther, p_IntegrationGroupId, 
   -- p_NumberOfTimes, p_PeerEvaluated, p_PeriodOffered, p_PeriodOfferedOther, v_State, p_SubjectArea
   -- *** Split to year,month,day: p_EndedOn, p_StartedOn

   v_InstitutionID := researchinview.insert_institution(p_InstitutionCommonNameId);

   --v_PeerEvaluated := 0;
   --IF upper(p_PeerEvaluated) = 'Y' OR p_PeerEvaluated = '1' THEN
   --   v_PeerEvaluated := 1;
   --END IF;

   v_StudentEvaluated := 0;
   IF upper(p_StudentEvaluated) = 'Y' OR p_StudentEvaluated = '1' THEN
      v_StudentEvaluated := 1;
   END IF;

   v_OneDay := 0;
   IF upper(p_OneDay) = 'Y' OR p_OneDay = '1' THEN
      v_OneDay := 1;
   END IF;

   v_State := p_StateProvince;
   IF v_State IS NULL OR v_State = '' THEN
      v_State := p_StateProvinceOther;
   END IF;

   -- check to see if there is a record in grant_data with this resource id
   SELECT COUNT(*) INTO v_CoursesTaughtOtherMatchCount
     FROM kmdata.courses_taught_other
    WHERE resource_id = v_ResourceID;

   IF v_CoursesTaughtOtherMatchCount = 0 THEN
   
      -- insert activity information
      v_CourseTaughtOtherID := nextval('kmdata.courses_taught_other_id_seq');

      --p_CourseType
      INSERT INTO kmdata.courses_taught_other
         (id, resource_id, user_id, course_taught_other_type_id, "number", credit_hour, description, "role", 
          enrollment, institution_id, length, evaluation, percent_taught, formal_student_evaluation, title, 
          one_day_event_ind, department, 
          start_year, start_month, start_day,
          end_year, end_month, end_day,
          created_at, updated_at, academic_calendar, academic_calendar_other, city, country, course_type,
          institution_group_other, integration_group_id, number_of_times, peer_evaluated, period_offered,
          period_offered_other, state_province, subject_area)
      VALUES
         (v_CourseTaughtOtherID, v_ResourceID, v_UserID, 3, p_CourseNumber, p_CreditHours, researchinview.strip_riv_tags(p_Description), researchinview.strip_riv_tags(p_DescriptionOfRole), 
          p_Enrollment, v_InstitutionID, p_LengthOfClass, p_OtherEvaluationInfo, p_PercentTaught, v_StudentEvaluated, p_CourseTitle, 
          v_OneDay, p_Sponsor,  
          researchinview.get_year(p_StartedOn), researchinview.get_month(p_StartedOn), NULL,
          researchinview.get_year(p_EndedOn), researchinview.get_month(p_EndedOn), NULL,
          current_timestamp, current_timestamp, p_AcademicCalendar, p_AcademicCalendarOther, p_City, p_Country, p_CourseType,
          p_InstitutionGroupOther, p_IntegrationGroupId, p_NumberOfTimes, p_PeerEvaluated, p_PeriodOffered,
          p_PeriodOfferedOther, v_State, p_SubjectArea);

   ELSE
   
      -- get the work id
      SELECT id INTO v_CourseTaughtOtherID
        FROM kmdata.courses_taught_other
       WHERE resource_id = v_ResourceID;

      -- update the works table
      UPDATE kmdata.courses_taught_other
         SET user_id = v_UserID, 
             course_taught_other_type_id = 3,
             "number" = p_CourseNumber, 
             credit_hour = p_CreditHours, 
             description = researchinview.strip_riv_tags(p_Description), 
             "role" = researchinview.strip_riv_tags(p_DescriptionOfRole), 
             enrollment = p_Enrollment, 
             institution_id = v_InstitutionID, 
             length = p_LengthOfClass, 
             evaluation = p_OtherEvaluationInfo, 
             percent_taught = p_PercentTaught, 
             formal_student_evaluation = v_StudentEvaluated, 
             title = p_CourseTitle, 
             academic_calendar = p_AcademicCalendar,  
             academic_calendar_other = p_AcademicCalendarOther,
             city = p_City,
             country = p_Country, 
             course_type = p_CourseType,
	     institution_group_other = p_InstitutionGroupOther,
	     integration_group_id = p_IntegrationGroupId,
	     number_of_times = p_NumberOfTimes, 
	     peer_evaluated = p_PeerEvaluated,
	     period_offered = p_PeriodOffered,
             period_offered_other = p_PeriodOfferedOther,
             state_province = v_State,
             subject_area = p_SubjectArea,
             one_day_event_ind = v_OneDay, 
             department = p_Sponsor,
             start_year = researchinview.get_year(p_StartedOn), 
             start_month = researchinview.get_month(p_StartedOn), 
             start_day = NULL,
             end_year = researchinview.get_year(p_EndedOn), 
             end_month = researchinview.get_month(p_EndedOn), 
             end_day = NULL,
             updated_at = current_timestamp
       WHERE id = v_CourseTaughtOtherID;

   END IF;
   
   RETURN v_CourseTaughtOtherID;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
