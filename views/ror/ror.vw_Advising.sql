CREATE OR REPLACE VIEW ror.vw_advising AS
SELECT adv.id, adv.user_id AS person_id, adv.institution_id, ins.name AS inst_name, ins.college_university_code, adv.advisee_type_id, adv.username, adv.first_name, 
       adv.last_name, adv.level_id, adv.role_id, adv.start_year, adv.start_month, adv.start_day, 
       adv.end_year, adv.end_month, adv.end_day, adv.graduated, adv.graduation_year, adv.student_group, 
       adv.title, adv.advisee_current_position, adv.notes, adv.graduate_completed, 
       adv.table_type, adv.created_at, adv.updated_at, 
       CASE ail.is_public WHEN 1 THEN TRUE ELSE FALSE END AS is_public
  FROM kmdata.advising adv
  INNER JOIN kmdata.institutions ins ON adv.institution_id = ins.id
  INNER JOIN kmdata.resources res ON adv.resource_id = res.id
  INNER JOIN kmdata.sources src ON res.source_id = src.id
  INNER JOIN researchinview.activity_import_log ail ON adv.resource_id = ail.resource_id
 WHERE src.source_name != 'osupro'
   AND ail.is_active = 1;
-- adv.output_text, adv.resource_id, 