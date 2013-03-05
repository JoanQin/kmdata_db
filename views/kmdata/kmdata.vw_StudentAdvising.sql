create or replace view vw_StudentAdvising as
 select a.id, a.resource_id, a.user_id, a.level_id, e.name as level_val, a.first_name, a.last_name,
	a.end_year, a.end_month, a.end_day, a.accomplishments, 
	kmd_dev_riv_user.getadvisingaccomplishments(a.accomplishments) as accomplishments_val, a.accomplishments_other,
	a.start_year, a.start_month, a.start_day, a.advisee_advisor_codepartment, f.name as codepartment_val, a.student_id,
	a.role_id, g.name as role_val, a.graduated, h.name as graduated_val, a.advisee_current_position, i.name as position_val, a.graduation_year,
	a.institution_id, j.name as institution_val, a.title, a.ongoing, k.name as ongoing_val, a.major, 
	kmd_dev_riv_user.getadvisingciplookup(a.major) as major_val,  a.minor, 
	kmd_dev_riv_user.getadvisingciplookup(a.minor) as minor_val,
	a.university_id, a.current_position_other, a.created_at, a.updated_at, d.is_active, d.is_public
  FROM kmdata.advising a
  left join researchinview.activity_import_log d on d.resource_id = a.resource_id
  left join researchinview.riv_advising_academic_levels e on e.id = a.level_id
  left join researchinview.riv_yes_no f on f.value = cast(a.advisee_advisor_codepartment as int)
  left join researchinview.riv_advising_roles g on g.id = a.role_id
  left join researchinview.riv_yes_no_unknown h on h.value = a.graduated
  left join researchinview.riv_advisee_positions i on i.id = cast(a.advisee_current_position as int)
  left join kmdata.institutions j on j.id = a.institution_id
  left join researchinview.riv_yes_no k on k.value = cast(a.ongoing as int)
  where d.riv_activity_name = 'StudentAdvising';