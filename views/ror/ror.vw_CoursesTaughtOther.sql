CREATE OR REPLACE VIEW ror.vw_CoursesTaughtOther AS
SELECT w.id, w.user_id AS person_id, course_taught_other_type_id, title, "number", length, 
       institution_id, department, credit_hour, start_year, start_month, 
       start_day, end_year, end_month, end_day, description, percent_taught, 
       role, enrollment, formal_student_evaluation, county, conference_title, 
       evaluation, conference_location, one_day_event_ind, 
       times_offered, w.created_at, w.updated_at, 
       CASE ail.is_public WHEN 1 THEN TRUE ELSE FALSE END AS is_public
  FROM kmdata.courses_taught_other w
  INNER JOIN kmdata.resources res ON w.resource_id = res.id
  INNER JOIN kmdata.sources src ON res.source_id = src.id
  INNER JOIN researchinview.activity_import_log ail ON w.resource_id = ail.resource_id
 WHERE src.source_name != 'osupro'
   AND ail.is_active = 1;
-- output_text, w.resource_id, 