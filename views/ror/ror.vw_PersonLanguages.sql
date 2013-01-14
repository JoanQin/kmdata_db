CREATE OR REPLACE VIEW ror.vw_PersonLanguages AS
SELECT lang.id, lang.language_id, lang.dialect_id, lang.user_id AS person_id, lang.reading_proficiency, lang.speaking_proficiency, 
       lang.writing_proficiency, lang.created_at, lang.updated_at, ld.name AS language_name,
       lddl.name AS dialect_name, pread.name AS reading_proficiency_descr, pspeak.name AS speaking_proficiency_descr,
       pwrite.name AS writing_proficiency_descr, 
       CASE ail.is_public WHEN 1 THEN TRUE ELSE FALSE END AS is_public
  FROM kmdata.user_languages lang
  INNER JOIN kmdata.languages ld ON lang.language_id = ld.id
  LEFT JOIN kmdata.language_dialects lddl ON lang.dialect_id = lddl.id
  INNER JOIN kmdata.language_proficiencies pread ON lang.reading_proficiency = pread.id
  INNER JOIN kmdata.language_proficiencies pspeak ON lang.speaking_proficiency = pspeak.id
  INNER JOIN kmdata.language_proficiencies pwrite ON lang.writing_proficiency = pwrite.id
  INNER JOIN kmdata.resources res ON lang.resource_id = res.id
  INNER JOIN kmdata.sources src ON res.source_id = src.id
  INNER JOIN researchinview.activity_import_log ail ON lang.resource_id = ail.resource_id
 WHERE src.source_name != 'osupro'
   AND ail.is_active = 1;
-- lang.resource_id, 

GRANT SELECT ON ror.vw_personlanguages TO kmd_ror_app_user;

/*
CREATE OR REPLACE VIEW ror.vw_PersonLanguages AS
SELECT id, language_id, dialect_id, user_id AS person_id, reading_proficiency, speaking_proficiency, 
       writing_proficiency, resource_id, created_at, updated_at
  FROM kmdata.user_languages;
*/

ALTER TABLE ror.vw_PersonLanguages
  OWNER TO kmdata;
GRANT ALL ON TABLE ror.vw_PersonLanguages TO kmdata;
GRANT SELECT ON TABLE ror.vw_PersonLanguages TO kmd_ror_app_user;
GRANT SELECT ON TABLE ror.vw_PersonLanguages TO kmd_dev_riv_user;
--GRANT SELECT ON TABLE ror.vw_PersonLanguages TO kmd_report_user;
