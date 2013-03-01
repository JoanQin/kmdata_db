CREATE OR REPLACE VIEW kmdata.vw_advisinggroup AS 
SELECT a.id, a.user_id, a.level_id, c.name as academiclevel_val, a.institution_id, h.name as institutionname_val, a.notes, a.role_id, 
        d.name as role_val, a.student_group, a.start_year, a.start_month, a.end_year, a.end_month, 
        a.created_at, a.updated_at, a.resource_id, a.description_of_effort, a.ongoing, e.name as ongoing_val,
        a.role_other, a.type_of_group, b.name as grouptype_val, a.type_of_group_other, a.url, al.is_public, al.is_active
  FROM kmdata.advising a
  left join researchinview.activity_import_log al on a.resource_id = al.resource_id
  left join researchinview.riv_advising_student_group_type b on b.id = cast(a.type_of_group as int)
  left join researchinview.riv_advising_student_group_academic_levels c on c.id = a.level_id
  left join researchinview.riv_advising_student_group_roles d on d.id = a.role_id
  left join researchinview.riv_yes_no e on e.value = cast(a.ongoing as int)
  left join kmdata.institutions h on h.id = a.institution_id
  where riv_activity_name = 'AdvisingGroup';