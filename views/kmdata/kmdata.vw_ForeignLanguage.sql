 CREATE OR REPLACE VIEW kmdata.vw_foreignlanguages AS
 SELECT a.id, a.resource_id, a.user_id, a.language_id, b.name as language_val,
	a.dialect_id, f.name as dialect_val, a.reading_proficiency, c.name as language_prof_val, a.speaking_proficiency,
        d.name as speak_prof_val,  a.writing_proficiency, e.name as writing_prof_val,
         a.created_at, a.updated_at, al.is_public, al.is_active
   FROM kmdata.user_languages a
   LEFT JOIN researchinview.activity_import_log al ON a.resource_id = al.resource_id
   left join researchinview.riv_language b on b.value = a.language_id
   left join researchinview.riv_language_proficiency c on c.id = reading_proficiency
   left join researchinview.riv_language_proficiency d on d.id = speaking_proficiency
   left join researchinview.riv_language_proficiency e on e.id = writing_proficiency
   left join researchinview.riv_dialects f on f.id = a.dialect_id;