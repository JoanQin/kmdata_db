CREATE OR REPLACE VIEW ror.vw_PersonPreferredNames AS
SELECT w.id, w.user_id AS person_id, prefix, first_name, middle_name, last_name, suffix, 
       preferred_publishing_name, email, fax, phone, address, address_2, 
       city, state, zip, country, subscribe, url, cip_area, cip_focus, 
       prefix_show_ind, first_name_show_ind, middle_name_show_ind, last_name_show_ind, 
       suffix_show_ind, email_show_ind, url_show_ind, phone_show_ind, 
       fax_show_ind, address_1_show_ind, address_2_show_ind, city_show_ind, 
       state_show_ind, zip_show_ind, country_show_ind, 
       w.created_at, w.updated_at, 
       CASE ail.is_public WHEN 1 THEN TRUE ELSE FALSE END AS is_public
  FROM kmdata.user_preferred_names w
  INNER JOIN kmdata.resources res ON w.resource_id = res.id
  INNER JOIN kmdata.sources src ON res.source_id = src.id
  INNER JOIN researchinview.activity_import_log ail ON w.resource_id = ail.resource_id
 WHERE src.source_name != 'osupro'
   AND ail.is_active = 1;
-- w.resource_id, 

ALTER TABLE ror.vw_PersonPreferredNames
  OWNER TO kmdata;
GRANT ALL ON TABLE ror.vw_PersonPreferredNames TO kmdata;
GRANT SELECT ON TABLE ror.vw_PersonPreferredNames TO kmd_ror_app_user;
GRANT SELECT ON TABLE ror.vw_PersonPreferredNames TO kmd_dev_riv_user;
--GRANT SELECT ON TABLE ror.vw_PersonPreferredNames TO kmd_report_user;
