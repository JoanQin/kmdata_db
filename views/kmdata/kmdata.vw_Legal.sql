create or replay view vw_legal as 
SELECT w.id, w.resource_id, w.user_id, w.enacted, c.name as enacted_val, w.enacted_on_dmy_single_date_id, 
	sd1.month as enacted_month, sd1.year as enacted_year,
	w.issuing_organization, w.legal_number, w.percent_authorship, w.role_id, e.name as role_val, w.role_designator, w.sponsor,
	w.submission_dmy_single_date_id, sd2.month as submission_month, sd2.year as submission_year, 
	w.submitted_to, w.title, w.type_of_activity, d.name as activity_type_val, w.type_of_activity_other,
	w.url, w.work_type_id,  a.work_type_name, w.created_at, w.updated_at,  	         
           b.narrative_text, al.is_public,  al.is_active
   FROM kmdata.works w
   LEFT JOIN kmdata.dmy_single_dates sd1 ON w.enacted_on_dmy_single_date_id = sd1.id
   left join kmdata.dmy_single_dates sd2 on w.submission_dmy_single_date_id = sd2.id
   LEFT JOIN kmdata.work_narratives wn ON w.id = wn.work_id
      LEFT JOIN kmdata.narratives b on wn.narrative_id = b.id
      left join researchinview.activity_import_log al on al.resource_id = w.resource_id
      left join kmdata.work_types a on a.id = w.work_type_id
      left join researchinview.riv_yes_no c on c.value = cast(w.enacted as int)
      left join researchinview.riv_legal_publication_types d on d.id = cast(w.type_of_activity as int)
      left join researchinview.riv_legal_roles e on e.id = w.role_id
  WHERE a.work_type_name = 'Legal'