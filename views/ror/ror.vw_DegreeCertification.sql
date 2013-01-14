CREATE OR REPLACE VIEW ror.vw_DegreeCertification AS
SELECT w.id, w.user_id AS person_id, institution_id, degree_type_id, title, 
       start_year, start_month, end_year, end_month, cip_code_id, area_of_study, 
       terminal_ind, certifying_body_id, subspecialty, license_number, 
       npi, upin, medicaid, abbreviation, w.created_at, w.updated_at, city, 
       state, country, 
       CASE ail.is_public WHEN 1 THEN TRUE ELSE FALSE END AS is_public
  FROM kmdata.degree_certifications w
  INNER JOIN kmdata.resources res ON w.resource_id = res.id
  INNER JOIN kmdata.sources src ON res.source_id = src.id
  INNER JOIN researchinview.activity_import_log ail ON w.resource_id = ail.resource_id
 WHERE src.source_name != 'osupro'
   AND ail.is_active = 1;
-- w.resource_id, 

ALTER TABLE ror.vw_DegreeCertification
  OWNER TO kmdata;
GRANT ALL ON TABLE ror.vw_DegreeCertification TO kmdata;
GRANT SELECT ON TABLE ror.vw_DegreeCertification TO kmd_ror_app_user;
GRANT SELECT ON TABLE ror.vw_DegreeCertification TO kmd_dev_riv_user;
--GRANT SELECT ON TABLE ror.vw_DegreeCertification TO kmd_report_user;
