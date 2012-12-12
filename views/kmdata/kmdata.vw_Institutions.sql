CREATE OR REPLACE VIEW kmdata.vw_Institutions AS
SELECT id, pro_id, college_university_code, name, comment, state_code, 
       location_id, college_sequence_number, city_code, edited_ind, 
       url, resource_id
  FROM kmdata.institutions;
