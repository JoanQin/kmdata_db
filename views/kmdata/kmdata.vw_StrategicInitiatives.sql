CREATE OR REPLACE VIEW kmdata.vw_StrategicInitiatives AS
  SELECT a.id, a.user_id, a.institution_id, a.role_name, a.activity_id,  a.summary,
  	a.start_year, a.end_year, a.active_ind,   a.output_text, a.resource_id,
  	a.created_at, a.updated_at, a.activity_other, a.institution_group_other,
  	a.integration_group_id, i.groupname as group_val, a.url, a.ended_on, a.started_on, a.role_other,
  	d.is_active, d.is_public, e.name as institution_val, f.name as role_val, g.name as activity_val,
  	h.name as active_val
    FROM kmdata.strategic_initiatives a
    left join researchinview.activity_import_log d on d.resource_id = a.resource_id
    left join kmdata.institutions e on e.id = a.institution_id
    left join researchinview.riv_strategic_initiative_roles f on f.id = cast(a.role_name as int)
    left join researchinview.riv_strategic_initiative_activities g on g.id = a.activity_id
    left join researchinview.riv_yes_no h on h.value = a.active_ind
  left join kmd_dev_riv_user.rivgroupdept i on i.deptid = a.integration_group_id;
