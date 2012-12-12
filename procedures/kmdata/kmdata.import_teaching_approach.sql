CREATE OR REPLACE FUNCTION kmdata.import_teaching_approach (
) RETURNS BIGINT AS $$
DECLARE
   v_intNewItemID BIGINT;
   v_intNarrativeTypeCount BIGINT;
   v_intNarrativeCount BIGINT;
   v_intSourceID BIGINT;
   v_strUserEmplid VARCHAR(11);
   v_intUserCount INTEGER;
   v_intUserID BIGINT;
   v_ResourceID BIGINT;
   v_NarrativeID BIGINT;
   narrQuery CURSOR FOR 
      SELECT NULL AS item_id, b.profile_emplid, a.approach_goals_results AS narrative, (SELECT id FROM kmdata.narrative_types WHERE narrative_desc = 'Approach & Goals to Teaching') AS narrative_type_id, 
      localtimestamp as create_date, localtimestamp as modified_date, 1 AS private_ind
      FROM osupro.teaching_approach a
      INNER JOIN osupro.academic_item b ON a.item_id = b.item_id;

   --SELECT item_id, year, approach_goals_results, approach, goals, results, output_text
   --FROM osupro.teaching_approach
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
      --SELECT profile_emplid INTO v_strUserEmplid
      --FROM osupro.academic_item
      --WHERE item_id = currNarr.item_id;
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
         FROM kmdata.narratives
         WHERE user_id = v_intUserID
         AND narrative_type_id = currNarr.narrative_type_id;

         v_NarrativeID := 0;
         
         IF v_intNarrativeCount < 1 THEN

            -- insert the record
            v_ResourceID := kmdata.add_new_resource('osupro', 'narratives');
            v_NarrativeID := nextval('kmdata.narratives_id_seq');
            INSERT INTO kmdata.narratives
               (id, narrative_type_id, narrative_text, user_id, created_at, updated_at, private_ind, resource_id)
            VALUES
               (v_NarrativeID, currNarr.narrative_type_id, currNarr.narrative, v_intUserID, currNarr.create_date, currNarr.modified_date, currNarr.private_ind, v_ResourceID);
            
         ELSE
         
            -- update the record
            UPDATE kmdata.narratives
            SET narrative_text = currNarr.narrative,
               created_at = currNarr.create_date,
               updated_at = currNarr.modified_date
            WHERE user_id = v_intUserID
              AND narrative_type_id = currNarr.narrative_type_id;

            SELECT MIN(narrative_id) INTO v_NarrativeID
            FROM kmdata.narratives
            WHERE user_id = v_intUserID
              AND narrative_type_id = currNarr.narrative_type_id;

         END IF;

         INSERT INTO kmdata.user_narratives
            (user_id, narrative_id)
         VALUES
            (v_intUserID, v_NarrativeID);

      ELSE

         -- the count was not a single record
         INSERT INTO kmdata.import_errors (message_varchar) 
         VALUES ('narratives from teaching_approach INSERT error (non-single match): ' || 
                 CAST(v_intUserCount AS CHAR) || ' users matched EMPLID ' || v_strUserEmplid || '. Record skipped.'
         );
         
      END IF;
      
   END LOOP;

   RETURN v_intNewItemID;
END;
$$ LANGUAGE plpgsql;
