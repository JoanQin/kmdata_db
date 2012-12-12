CREATE OR REPLACE VIEW kmdata.vw_CoursesTaughtOther AS
SELECT id, user_id, course_taught_other_type_id, title, "number", length, 
       institution_id, department, credit_hour, start_year, start_month, 
       start_day, end_year, end_month, end_day, description, percent_taught, 
       role, enrollment, formal_student_evaluation, county, conference_title, 
       evaluation, output_text, conference_location, one_day_event_ind, 
       times_offered, resource_id, created_at, updated_at
  FROM kmdata.courses_taught_other;
