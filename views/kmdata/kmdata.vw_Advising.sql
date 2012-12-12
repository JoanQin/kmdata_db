CREATE OR REPLACE VIEW vw_advising AS
SELECT adv.id, adv.user_id, adv.institution_id, ins.name AS inst_name, ins.college_university_code, adv.advisee_type_id, adv.username, adv.first_name, 
       adv.last_name, adv.level_id, adv.role_id, adv.start_year, adv.start_month, adv.start_day, 
       adv.end_year, adv.end_month, adv.end_day, adv.graduated, adv.graduation_year, adv.student_group, 
       adv.title, adv.advisee_current_position, adv.notes, adv.output_text, adv.graduate_completed, 
       adv.table_type, adv.resource_id, adv.created_at, adv.updated_at
  FROM kmdata.advising adv
  INNER JOIN kmdata.institutions ins ON adv.institution_id = ins.id;
