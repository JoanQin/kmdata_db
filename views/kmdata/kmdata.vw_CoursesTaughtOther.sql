CREATE OR REPLACE VIEW kmdata.vw_CoursesTaughtOther AS
SELECT a.id, user_id,  title, "number", length, 
        b.name as institution_name, department, credit_hour, start_year, start_month, 
       start_day, end_year, end_month, end_day, description, percent_taught, 
       role, enrollment, formal_student_evaluation, county, conference_title, 
       evaluation, output_text, conference_location, one_day_event_ind, 
       times_offered, a.resource_id, c.name as academic_calendar_name, academic_calendar_other,
       city, country, d.name as course_type, institution_group_other,  f.groupname,
       number_of_times, state_province,  e.name as subject_area
  FROM kmdata.courses_taught_other a
  left join kmdata.institutions b on b.id = a.institution_id 
  left join researchinview.riv_academic_calendar_types c on c.id = cast(a.academic_calendar as int)
  left join researchinview.riv_continuing_education_course_types d on d.id = cast(a.course_type as int)
  left join researchinview.riv_cip_lookup e on e.value = a.subject_area
  left join kmd_dev_riv_user.rivgroupdept f on f.groupid = a.integration_group_id