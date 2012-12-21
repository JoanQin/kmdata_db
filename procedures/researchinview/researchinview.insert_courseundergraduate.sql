CREATE OR REPLACE FUNCTION researchinview.insert_courseundergraduate (
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
   p_CourseNumber VARCHAR(2000),
   p_CourseType VARCHAR(2000),
   p_CreditHours VARCHAR(2000),
   p_Description TEXT,
   p_DescriptionOfRole VARCHAR(3000),
   p_EndedOn VARCHAR(2000),
   p_Enrollment BIGINT,
   p_Frequencey INTEGER,
   p_InstitutionCommonNameId INTEGER,
   p_InstitutionGroupOther VARCHAR(2000),
   p_InstructionMethod VARCHAR(2000),
   p_IntegrationGroupId VARCHAR(2000),
   p_LengthOfClass BIGINT,
   p_NumberOfTimes BIGINT,
   p_OtherEvaluationInfo TEXT,
   p_PeerEvaluated VARCHAR(2000),
   p_PercentTaught INTEGER,
   p_PeriodOffered VARCHAR(2000),
   p_PeriodOfferedOther VARCHAR(2000),
   p_StartedOn VARCHAR(2000),
   p_StudentEvaluated VARCHAR(2000),
   p_SubjectArea VARCHAR(2000),
   p_Title VARCHAR(2000)
) RETURNS BIGINT AS $$
DECLARE
   v_ActivityID BIGINT;
   v_ResourceID BIGINT;
   v_CourseTaughtID BIGINT;
   v_CoursesTaughtMatchCount BIGINT;
   v_UserID BIGINT;
   v_InstitutionID BIGINT;
   v_PeerEvaluated SMALLINT;
   v_StudentEvaluated SMALLINT;
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
   v_ActivityID := researchinview.insert_activity('CourseUndergraduate', p_IntegrationActivityId, p_IntegrationUserId, p_IsPublic, p_ExtendedAttribute1,
	p_ExtendedAttribute2, p_ExtendedAttribute3, p_ExtendedAttribute4, p_ExtendedAttribute5);

   -- get resource ID
   SELECT resource_id INTO v_ResourceID
     FROM researchinview.activity_import_log
    WHERE id = v_ActivityID;

   IF v_ResourceID IS NULL THEN
      v_ResourceID := add_new_resource('researchinview', 'courses_taught');
   END IF;

   -- update activity table in the researchinview schema
   UPDATE researchinview.activity_import_log
      SET resource_id = v_ResourceID
    WHERE id = v_ActivityID;

   -- missing 
   -- p_AcademicCalendar, p_AcademicCalendarOther, p_Frequencey, p_InstitutionGroupOther, p_IntegrationGroupId, p_NumberOfTimes, 
   -- p_PeriodOfferedOther, p_SubjectArea, 
   -- *** Split to year,month,day: p_EndedOn, p_StartedOn

   v_InstitutionID := researchinview.insert_institution(p_InstitutionCommonNameId);

   v_PeerEvaluated := 0;
   IF upper(p_PeerEvaluated) = 'Y' OR p_PeerEvaluated = '1' THEN
      v_PeerEvaluated := 1;
   END IF;

   v_StudentEvaluated := 0;
   IF upper(p_StudentEvaluated) = 'Y' OR p_StudentEvaluated = '1' THEN
      v_StudentEvaluated := 1;
   END IF;

   -- check to see if there is a record in grant_data with this resource id
   SELECT COUNT(*) INTO v_CoursesTaughtMatchCount
     FROM kmdata.courses_taught
    WHERE resource_id = v_ResourceID;

   IF v_CoursesTaughtMatchCount = 0 THEN
   
      -- insert activity information
      v_CourseTaughtID := nextval('kmdata.courses_taught_id_seq');
   
      INSERT INTO kmdata.courses_taught
         (id, resource_id, user_id, course_taught_type_id, "number", professional_type_id, credit_hour, description, "role", 
          enrollment, institution_id, instructional_method_id, length, evaluation, formal_peer_evaluation_ind, 
          percent_taught, period_offered_id, formal_student_evaluation_ind, title, year_offered, 
          created_at, updated_at, academic_calendar, academic_calendar_other, frequency, institution_group_other,
          integration_group_id, number_of_times, period_offered_other, subject_area, ended_on )
      VALUES
         (v_CourseTaughtID, v_ResourceID, v_UserID, 1, p_CourseNumber, CAST(split_part(p_CourseType, ',', 1) AS INTEGER), p_CreditHours, researchinview.strip_riv_tags(p_Description), researchinview.strip_riv_tags(p_DescriptionOfRole), 
          p_Enrollment, v_InstitutionID, CAST(split_part(p_InstructionMethod, ',', 1) AS INTEGER), p_LengthOfClass, p_OtherEvaluationInfo, v_PeerEvaluated, 
          p_PercentTaught, CAST(split_part(p_PeriodOffered, ',', 1) AS INTEGER), v_StudentEvaluated, researchinview.strip_riv_tags(p_Title), researchinview.get_year(p_StartedOn),
          current_timestamp, current_timestamp, p_AcademicCalendar, p_AcademicCalendarOther, p_Frequencey, p_InstitutionGroupOther,
          p_IntegrationGroupId, p_NumberOfTimes, p_PeriodOfferedOther, p_SubjectArea, p_EndedOn);

   ELSE
   
      -- get the work id
      SELECT id INTO v_CourseTaughtID
        FROM kmdata.courses_taught
       WHERE resource_id = v_ResourceID;

      -- update the works table
      UPDATE kmdata.courses_taught
         SET user_id = v_UserID, 
             course_taught_type_id = 1,
             "number" = p_CourseNumber, 
             professional_type_id = CAST(split_part(p_CourseType, ',', 1) AS INTEGER), 
             credit_hour = p_CreditHours, 
             academic_calendar = p_AcademicCalendar,
             academic_calendar_other = p_AcademicCalendarOther,
             frequency = p_Frequencey,  
             institution_group_other = p_InstitutionGroupOther,
             integration_group_id = p_IntegrationGroupId, 
             number_of_times = p_NumberOfTimes, 
             period_offered_other = p_PeriodOfferedOther, 
             subject_area = p_SubjectArea,
             ended_on = p_EndedOn,
             description = researchinview.strip_riv_tags(p_Description), 
             "role" = researchinview.strip_riv_tags(p_DescriptionOfRole), 
             enrollment = p_Enrollment, 
             institution_id = v_InstitutionID, 
             instructional_method_id = CAST(split_part(p_InstructionMethod, ',', 1) AS INTEGER), 
             length = p_LengthOfClass, 
             evaluation = p_OtherEvaluationInfo, 
             formal_peer_evaluation_ind = v_PeerEvaluated, 
             percent_taught = p_PercentTaught, 
             period_offered_id = CAST(split_part(p_PeriodOffered, ',', 1) AS INTEGER), 
             formal_student_evaluation_ind = v_StudentEvaluated, 
             title = researchinview.strip_riv_tags(p_Title),
             year_offered = researchinview.get_year(p_StartedOn),
             updated_at = current_timestamp
       WHERE id = v_CourseTaughtID;

   END IF;
   
   RETURN v_CourseTaughtID;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
