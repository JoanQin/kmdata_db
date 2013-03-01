CREATE OR REPLACE VIEW vw_degree AS 
SELECT a.id, a.user_id, a.institution_id, e.name as institution_val, a.terminal_ind, c.name as terminal_val, a.degree_type_id, 
	b.description_abbreviation as degreetype_val, a.area_of_study, d.name as cip_val,
       a.start_year, a.start_month, a.end_year, a.end_month, a.resource_id, a.created_at,
       a.updated_at, al.is_public, al.is_active, kn.narrative_text
  FROM kmdata.degree_certifications a
  left join researchinview.activity_import_log al on a.resource_id = al.resource_id
  left join kmdata.degree_certification_narratives cn on cn.degree_certification_id = a.id
  left join kmdata.narratives kn on kn.id = cn.narrative_id
  left join kmdata.degree_types b on b.id = a.degree_type_id
  left join researchinview.riv_yes_no c on c.value = a.terminal_ind
  left join researchinview.riv_cip_lookup d on d.value = a.area_of_study
  left join kmdata.institutions e on e.id = a.institution_id
  where riv_activity_name = 'Degree';