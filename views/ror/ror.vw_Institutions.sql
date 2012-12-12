CREATE OR REPLACE VIEW ror.vw_Institutions AS
SELECT id, pro_id, college_university_code, name, comment, CAST(NULL AS VARCHAR(255)) AS state_code, 
       location_id, college_sequence_number, CAST(NULL AS VARCHAR(250)) AS city_code, edited_ind, 
       url
  FROM kmdata.institutions;
-- resource_id

/*
CREATE OR REPLACE VIEW ror.vw_Institutions AS
SELECT id, pro_id, college_university_code, name, comment, state_code, 
       location_id, college_sequence_number, city_code, edited_ind, 
       url
  FROM kmdata.institutions;
-- resource_id
*/