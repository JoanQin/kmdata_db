CREATE OR REPLACE FUNCTION kmdata.ProcessUserBios (
) RETURNS BIGINT AS $$
DECLARE
   v_intNewItemID BIGINT;
   v_intNarrativeTypeCount BIGINT;
   v_intNarrativeCount BIGINT;
   v_intSourceID BIGINT;
   v_strUserEmplid VARCHAR(11);
   v_intUserCount INTEGER;
   v_intUserID BIGINT;
   v_intUserNarrativeCount INTEGER;
   narrQuery CURSOR FOR 
      SELECT a.item_id, b.profile_emplid, a.narrative, d.id AS narrative_type_id,
      b.create_date, b.modified_date, 0 AS private_ind
      FROM osupro.narrative a
      INNER JOIN osupro.academic_item b ON a.item_id = b.item_id
      INNER JOIN osupro.narrative_type_ref c ON a.narrative_type_id = c.id
      INNER JOIN kmdata.narrative_types d ON c.type = d.narrative_desc
      -- WHERE a.narrative_type_id = 1 -- (1, 15)
      UNION
      SELECT NULL AS item_id, profile_emplid, focus_accomp_plan AS narrative, b2.id AS narrative_type_id, 
      localtimestamp as create_date, localtimestamp as modified_date, 1 AS private_ind
      FROM osupro.research_interest a2
      INNER JOIN kmdata.narrative_types b2 ON b2.narrative_desc = 'Focus of Research';
BEGIN
   -- select and return the existing id
   v_intNewItemID := 0;

   -- get the peoplesoft source id
   SELECT id INTO v_intSourceID FROM kmdata.sources WHERE source_name = 'osupro';

   -- populate the narrative type table if necessary
   SELECT COUNT(*) INTO v_intNarrativeTypeCount FROM kmdata.narrative_types;
   IF v_intNarrativeTypeCount < 1 THEN
      INSERT INTO kmdata.narrative_types
         (narrative_desc)
      SELECT type
         FROM osupro.narrative_type_ref
         ORDER BY id ASC;
   END IF;

   -- loop through biographical narratives
   FOR currNarr IN narrQuery LOOP

      -- get the emplid from the item id
      v_strUserEmplid := currNarr.profile_emplid;
      
      -- check if the count is zero or one
      SELECT COUNT(*) INTO v_intUserCount
      FROM kmdata.user_identifiers
      WHERE emplid = v_strUserEmplid;
      
      IF v_intUserCount = 1 THEN
         
         SELECT user_id INTO v_intUserID
         FROM kmdata.user_identifiers
         WHERE emplid = v_strUserEmplid;
   
         -- check the count
         SELECT COUNT(*) INTO v_intNarrativeCount
         FROM kmdata.narratives a
         INNER JOIN kmdata.user_narratives b ON a.id = b.narrative_id
         WHERE b.user_id = v_intUserID
         AND a.narrative_type_id = currNarr.narrative_type_id;

         IF v_intNarrativeCount < 1 THEN

            -- get a new sequence number
            v_intNewItemID := nextval('kmdata.narratives_id_seq');

            -- insert the record
            INSERT INTO kmdata.narratives
               (id, narrative_type_id, narrative_text, created_at, updated_at, private_ind)
            VALUES
               (v_intNewItemID, currNarr.narrative_type_id, currNarr.narrative, currNarr.create_date, currNarr.modified_date, currNarr.private_ind);

            -- insert the associated user record
            INSERT INTO kmdata.user_narratives
               (user_id, narrative_id)
            VALUES
               (v_intUserID, v_intNewItemID);
            
         ELSE

            -- select the narrative id
            SELECT a.id INTO v_intNewItemID
            FROM kmdata.narratives a
            INNER JOIN kmdata.user_narratives b ON a.id = b.narrative_id
            WHERE b.user_id = v_intUserID
            AND a.narrative_type_id = currNarr.narrative_type_id;
            
            -- update the record
            UPDATE kmdata.narratives
            SET narrative_text = currNarr.narrative,
               created_at = currNarr.create_date,
               updated_at = currNarr.modified_date
            WHERE id = v_intNewItemID;

            SELECT COUNT(*) INTO v_intUserNarrativeCount
            FROM kmdata.user_narratives
            WHERE user_id = v_intUserID
            AND narrative_id = v_intNewItemID;

            IF v_intUserNarrativeCount < 1 THEN
               -- insert the associated user record
               INSERT INTO kmdata.user_narratives
                  (user_id, narrative_id)
               VALUES
                  (v_intUserID, v_intNewItemID);
            END IF;

         END IF;

      ELSE

         -- the count was not a single record
         INSERT INTO kmdata.import_errors (message_varchar) 
         VALUES ('User_Narratives and bios INSERT error (non-single match): ' || 
                 CAST(v_intUserCount AS CHAR) || ' users matched EMPLID ' || v_strUserEmplid || '. Record skipped.'
         );
         
      END IF;
      
   END LOOP;

   RETURN v_intNewItemID;
END;
$$ LANGUAGE plpgsql;
