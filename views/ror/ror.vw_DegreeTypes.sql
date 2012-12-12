CREATE OR REPLACE VIEW ror.vw_DegreeTypes AS
SELECT id, description_abbreviation, transcript_abbreviation, degree_description, 
       degree_class_id
  FROM kmdata.degree_types;
