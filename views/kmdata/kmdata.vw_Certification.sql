CREATE OR REPLACE VIEW vw_certification AS 
SELECT a.id, a.user_id, a.institution_id, ins.name as institution_name, a.resource_id, a.title, 
       a.license_number, a.abbreviation, a.subspecialty, a.active, c.name as active_val,
       a.start_year, a.start_month, a.end_year, a.end_month, a.created_at, a.updated_at
   FROM kmdata.degree_certifications a
   left join researchinview.activity_import_log b on a.resource_id = b.resource_id
  left join researchinview.riv_yes_no c on cast(a.active as int) = c.value
  left JOIN kmdata.institutions ins ON a.institution_id = ins.id
   where b.riv_activity_name = 'Certification'