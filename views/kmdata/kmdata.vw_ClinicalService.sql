CREATE OR REPLACE VIEW kmdata.vw_ClinicalService AS
SELECT id, user_id, clinical_service_type_id, start_date, end_date, 
       title, duration, location, department, description, output_text, 
       resource_id, created_at, updated_at, url
  FROM clinical_service;
