CREATE OR REPLACE VIEW vw_Committees AS 
SELECT a.id, a.user_id, a.group_name, a.service_unit_id, b.name as committeeLevel, a.institution_id,
	f.name as institutionName, a.active_ind, a.service_role_id, c.name as committeeRoles,
          a.service_role_modifier_id, d.name as roleModifier, a.subcommittee_name, a.workgroup_name, 
          a.start_year, a.end_year, a.percent_effort, a.url,
          a.created_at, a.updated_at, a.resource_id, al.is_public, al.is_active, kn.narrative_text,
          g.name as onCommittee
  FROM kmdata.user_services a
  left join researchinview.activity_import_log al on al.resource_id = a.resource_id
  left join kmdata.user_service_narratives sn on sn.user_service_id = a.id
  left join kmdata.narratives kn on kn.id = sn.narrative_id
  left join researchinview.riv_committee_levels b on a.service_unit_id = b.id
  left join researchinview.riv_committee_roles c on a.service_role_id = c.id
  left join researchinview.riv_committee_role_modifiers d on a.service_role_modifier_id = d.id
  left join kmdata.institutions f on a.institution_id = f.id
  left join researchinview.riv_yes_no g on g.value = a.active_ind;