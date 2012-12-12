CREATE OR REPLACE VIEW ror.vw_ProfessionalActivity AS
SELECT w.id, w.user_id AS person_id, activity_type_id, activity_sub_type_id, activity_name, 
       other, org_name, start_date, end_date, start_year, start_month, 
       start_day, end_year, end_month, end_day, for_fee_ind, site_name, 
       city, state, country, url, key_achievements, one_day_event_ind, 
       w.created_at, w.updated_at, 
       CASE ail.is_public WHEN 1 THEN TRUE ELSE FALSE END AS is_public
  FROM kmdata.professional_activity w
  INNER JOIN kmdata.resources res ON w.resource_id = res.id
  INNER JOIN kmdata.sources src ON res.source_id = src.id
  INNER JOIN researchinview.activity_import_log ail ON w.resource_id = ail.resource_id
 WHERE src.source_name != 'osupro'
   AND ail.is_active = 1;
-- output_text, w.resource_id, 


ALTER TABLE ror.vw_professionalactivity
  OWNER TO kmdata;
GRANT ALL ON TABLE ror.vw_professionalactivity TO kmdata;
GRANT SELECT ON TABLE ror.vw_professionalactivity TO kmd_ror_app_user;
GRANT SELECT ON TABLE ror.vw_professionalactivity TO kmd_dev_riv_user;
GRANT SELECT ON TABLE ror.vw_professionalactivity TO kmd_report_user;
