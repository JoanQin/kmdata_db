CREATE OR REPLACE VIEW kmdata.vw_ProfessionalActivity AS
SELECT id, user_id, activity_type_id, activity_sub_type_id, activity_name, 
       other, org_name, start_date, end_date, start_year, start_month, 
       start_day, end_year, end_month, end_day, for_fee_ind, site_name, 
       city, state, country, url, key_achievements, output_text, one_day_event_ind, 
       resource_id, created_at, updated_at
  FROM kmdata.professional_activity;


ALTER TABLE vw_professionalactivity
  OWNER TO kmdata;
GRANT ALL ON TABLE vw_professionalactivity TO kmdata;
GRANT SELECT ON TABLE vw_professionalactivity TO kmd_data_read_user;
GRANT SELECT ON TABLE vw_professionalactivity TO ceti;
GRANT SELECT ON TABLE vw_professionalactivity TO kmd_riv_tr_import_user;
GRANT SELECT ON TABLE vw_professionalactivity TO kmd_dev_riv_user;
--GRANT SELECT ON TABLE vw_professionalactivity TO kmd_report_user;

