create or replace view vw_licensure as 
SELECT a.id, a.user_id, a.institution_id, b.name as institution_val, a.title, a.abbreviation, a.city, a.country, a.medicaid, a.npi, a.state, a.upin,
	a.license_number, a.active, c.name as active_val, a.start_year, a.start_month, a.end_year, a.end_month, a.resource_id, a.created_at, a.updated_at,  	         
           kn.narrative_text, al.is_public,  al.is_active
   FROM kmdata.degree_certifications a
   LEFT JOIN kmdata.degree_certification_narratives dn ON a.id = dn.degree_certification_id
      LEFT JOIN kmdata.narratives kn on dn.narrative_id = kn.id
      left join researchinview.activity_import_log al on al.resource_id = a.resource_id
      left join kmdata.institutions b on b.id = a.institution_id
      left join researchinview.riv_yes_no c on c.value = cast(a.active as int)
  WHERE al.riv_activity_name = 'Licensure'