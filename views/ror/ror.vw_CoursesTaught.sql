CREATE OR REPLACE VIEW ror.vw_CoursesTaught AS
SELECT w.id, w.user_id AS person_id, course_taught_type_id, professional_type_id, instructional_method_id, 
       instructional_method_other, title, "number", length, institution_id, 
       department, credit_hour, year_offered, period_offered_id, description, 
       percent_taught, role, enrollment, formal_student_evaluation_ind, 
       evaluation, formal_peer_evaluation_ind, 
       w.created_at, w.updated_at, 
       CASE ail.is_public WHEN 1 THEN TRUE ELSE FALSE END AS is_public
  FROM kmdata.courses_taught w
  INNER JOIN kmdata.resources res ON w.resource_id = res.id
  INNER JOIN kmdata.sources src ON res.source_id = src.id
  INNER JOIN researchinview.activity_import_log ail ON w.resource_id = ail.resource_id
  WHERE src.source_name != 'osupro'
    AND ail.is_active = 1;
-- output_text, w.resource_id, 

ALTER TABLE ror.vw_CoursesTaught
  OWNER TO kmdata;
GRANT ALL ON TABLE ror.vw_CoursesTaught TO kmdata;
GRANT SELECT ON TABLE ror.vw_CoursesTaught TO kmd_ror_app_user;
GRANT SELECT ON TABLE ror.vw_CoursesTaught TO kmd_dev_riv_user;
--GRANT SELECT ON TABLE ror.vw_CoursesTaught TO kmd_report_user;
