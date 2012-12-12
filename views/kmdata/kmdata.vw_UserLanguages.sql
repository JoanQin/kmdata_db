CREATE OR REPLACE VIEW kmdata.vw_UserLanguages AS
SELECT id, language_id, dialect_id, user_id, reading_proficiency, speaking_proficiency, 
       writing_proficiency, resource_id, created_at, updated_at
  FROM kmdata.user_languages;
