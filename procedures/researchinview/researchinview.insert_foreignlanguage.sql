CREATE OR REPLACE FUNCTION researchinview.insert_foreignlanguage (
   p_IntegrationActivityId VARCHAR(2000),
   p_IntegrationUserId VARCHAR(2000),
   p_IsPublic INTEGER,
   p_ExtendedAttribute1 VARCHAR(4000),
   p_ExtendedAttribute2 VARCHAR(4000),
   p_ExtendedAttribute3 VARCHAR(4000),
   p_ExtendedAttribute4 VARCHAR(4000),
   p_ExtendedAttribute5 VARCHAR(4000),
   p_Dialect VARCHAR(2000),
   p_Language VARCHAR(2000),
   p_ReadingProficiency VARCHAR(2000),
   p_SpeakingProficiency VARCHAR(2000),
   p_WritingProficiency VARCHAR(2000)
) RETURNS BIGINT AS $$
DECLARE
   v_ActivityID BIGINT;
   v_ResourceID BIGINT;
   v_UserLanguageID BIGINT;
   v_LanguagesMatchCount BIGINT;
   v_UserID BIGINT;
   v_LanguageID BIGINT;
   v_DialectID BIGINT;
   v_Reading BIGINT;
   v_Speaking BIGINT;
   v_Writing BIGINT;
BEGIN
   -- select the user ID
   --v_UserID := p_IntegrationUserId;
   SELECT user_id INTO v_UserID
     FROM kmdata.user_identifiers
    WHERE emplid = p_IntegrationUserId;
   
   IF v_UserID IS NULL THEN
      RETURN 0;
   END IF;
   
   -- insert activity information
   v_ActivityID := researchinview.insert_activity('ForeignLanguage', p_IntegrationActivityId, p_IntegrationUserId, p_IsPublic, p_ExtendedAttribute1,
	p_ExtendedAttribute2, p_ExtendedAttribute3, p_ExtendedAttribute4, p_ExtendedAttribute5);

   -- get resource ID
   SELECT resource_id INTO v_ResourceID
     FROM researchinview.activity_import_log
    WHERE id = v_ActivityID;

   IF v_ResourceID IS NULL THEN
      v_ResourceID := add_new_resource('researchinview', 'user_languages');
   END IF;

   -- update activity table in the researchinview schema
   UPDATE researchinview.activity_import_log
      SET resource_id = v_ResourceID
    WHERE id = v_ActivityID;

   -- ****************************************
   -- additional field mappings and processing
   -- ****************************************

   v_LanguageID := CAST(p_Language AS BIGINT);
   v_DialectID := CAST(p_Dialect AS BIGINT);
   v_Reading := CAST(p_ReadingProficiency AS BIGINT);
   v_Speaking := CAST(p_SpeakingProficiency AS BIGINT);
   v_Writing := CAST(p_WritingProficiency AS BIGINT);

   -- check to see if there is a record in user_languages with this resource id
   SELECT COUNT(*) INTO v_LanguagesMatchCount
     FROM kmdata.user_languages
    WHERE resource_id = v_ResourceID;

   IF v_LanguagesMatchCount = 0 AND v_LanguageID > 0 THEN
   
      -- insert activity information
      v_UserLanguageID := nextval('kmdata.user_languages_id_seq');
   
      INSERT INTO kmdata.user_languages
         (id, resource_id, user_id, language_id, dialect_id, reading_proficiency, speaking_proficiency,
          writing_proficiency, created_at, updated_at)
      VALUES
         (v_UserLanguageID, v_ResourceID, v_UserID, v_LanguageID, v_DialectID, v_Reading, v_Speaking,
          v_Writing, current_timestamp, current_timestamp);

   ELSE
   
      -- get the user language id
      SELECT id INTO v_UserLanguageID
        FROM kmdata.user_languages
       WHERE resource_id = v_ResourceID;

      -- update the user_languages table
      UPDATE kmdata.user_languages
         SET user_id = v_UserID,
             language_id = v_LanguageID, 
             dialect_id = v_DialectID, 
             reading_proficiency = v_Reading, 
             speaking_proficiency = v_Speaking,
             writing_proficiency = v_Writing, 
             updated_at = current_timestamp
       WHERE id = v_UserLanguageID;

   END IF;
   
   RETURN v_UserLanguageID;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
