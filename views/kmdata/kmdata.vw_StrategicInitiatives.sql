CREATE OR REPLACE VIEW kmdata.vw_StrategicInitiatives AS
SELECT id, user_id, institution_id, role_name, activity_id, summary, 
       start_year, end_year, active_ind, output_text, resource_id, created_at, 
       updated_at
  FROM kmdata.strategic_initiatives;
