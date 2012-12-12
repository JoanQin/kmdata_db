CREATE OR REPLACE VIEW kmdata.vw_DegreeCertification AS
SELECT id, user_id, institution_id, degree_type_id, resource_id, title, 
       start_year, start_month, end_year, end_month, cip_code_id, area_of_study, 
       terminal_ind, certifying_body_id, subspecialty, license_number, 
       npi, upin, medicaid, abbreviation, created_at, updated_at, city, 
       state, country
  FROM kmdata.degree_certifications;
