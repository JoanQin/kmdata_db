CREATE OR REPLACE VIEW vw_advising AS
SELECT adv.id, adv.user_id, adv.institution_id, ins.name AS inst_name, ins.college_university_code, adv.advisee_type_id, adv.username, adv.first_name, 
       adv.last_name, adv.level_id, adv.role_id, adv.start_year, adv.start_month, adv.start_day, 
       adv.end_year, adv.end_month, adv.end_day, adv.graduated, adv.graduation_year, adv.student_group, 
       adv.title, adv.advisee_current_position, adv.notes, adv.output_text, adv.graduate_completed, 
       adv.table_type, adv.resource_id, adv.created_at, adv.updated_at,          
       adv.description_of_effort, b.name as rolename, c.name as levelname, adv.ongoing, e.name as ongoing_ind,
       adv.role_other, adv.type_of_group, d.name as grouptype, adv.type_of_group_other, adv.url, 
       al.is_public, al.is_active
  FROM kmdata.advising adv
  left JOIN kmdata.institutions ins ON adv.institution_id = ins.id
  left join researchinview.activity_import_log al on al.resource_id = adv.resource_id
  left join researchinview.riv_advising_student_group_roles b on b.id = adv.role_id
  left join researchinview.riv_advising_student_group_academic_levels c on c.id = adv.level_id
  left join researchinview.riv_advising_student_group_type d on d.id = cast(adv.type_of_group as int)
  left join researchinview.riv_yes_no e on e.value = cast(adv.ongoing as int);
