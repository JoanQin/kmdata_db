CREATE OR REPLACE FUNCTION kmdata.import_users_from_ps (
) RETURNS VARCHAR AS $$
DECLARE
   v_intResourceID BIGINT;
   v_intSourceID BIGINT;
   v_intKMDataTableID BIGINT;
   v_intUserID BIGINT;
   v_intUserIdentifierID BIGINT;
   --v_strEmplid VARCHAR(11);
   --v_strNameDotNumber VARCHAR(50);

   v_intUserCount BIGINT;
   v_intUserIndentCount BIGINT;

   v_UsersUpdated INTEGER;
   v_UsersInserted INTEGER;
   v_ReturnString VARCHAR(4000);

   v_UpdateCursor CURSOR FOR
      SELECT ui.user_id, u.last_name AS curr_last_name, u.first_name AS curr_first_name, u.middle_name AS curr_middle_name,
        ui.emplid AS curr_emplid, ui.inst_username AS curr_inst_username, u.name_prefix AS curr_name_prefix, u.name_suffix AS curr_name_suffix,
        u.display_name AS curr_name_display, u.deceased_ind AS curr_deceased_ind,
        pn.last_name, pn.first_name, pn.middle_name, pn.emplid, lower(pn.campus_id) AS inst_username,
        pn.name_prefix, pn.name_suffix, pn.name_display, pn.deceased_ind
        FROM peoplesoft.ps_names pn
        INNER JOIN kmdata.user_identifiers ui ON pn.emplid = ui.emplid
        INNER JOIN kmdata.users u ON ui.user_id = u.id
        WHERE pn.name_type = 'PRI';
        
   v_InsertCursor CURSOR FOR
      SELECT pn.last_name, pn.first_name, pn.middle_name, pn.emplid, lower(pn.campus_id) AS inst_username,
        pn.name_prefix, pn.name_suffix, pn.name_display, pn.deceased_ind
      FROM (
         SELECT pn1.emplid
           FROM peoplesoft.ps_names pn1
           WHERE pn1.name_type = 'PRI'
         EXCEPT
         SELECT ui2.emplid
           FROM kmdata.users u2
           INNER JOIN kmdata.user_identifiers ui2 ON u2.id = ui2.user_id
      ) newu
      INNER JOIN peoplesoft.ps_names pn ON newu.emplid = pn.emplid
      WHERE pn.name_type = 'PRI';

   /*
   v_InactivateCursor CURSOR FOR
      SELECT ui.emplid, ui.inst_username
        FROM kmdata.users u
        INNER JOIN kmdata.user_identifiers ui ON u.id = ui.user_id
      EXCEPT
      SELECT pn.emplid, lower(pn.campus_id) AS inst_username
        FROM peoplesoft.ps_names pn
        WHERE pn.name_type = 'PRI';
   */
BEGIN

   -- get the peoplesoft source id
   SELECT id INTO v_intSourceID FROM kmdata.sources WHERE source_name = 'peoplesoft';
   SELECT id INTO v_intKMDataTableID FROM kmdata.kmdata_tables WHERE table_name = 'users';

   v_UsersUpdated := 0;
   v_UsersInserted := 0;
   v_ReturnString := '';

   FOR v_updUser IN v_UpdateCursor LOOP
   
      -- update the users and user_identifiers table ONLY if something has changed
      -- deltas are driven from the updated_at column
      IF v_updUser.last_name != v_updUser.curr_last_name
         OR v_updUser.first_name != v_updUser.curr_first_name
         OR v_updUser.middle_name != v_updUser.curr_middle_name
         OR v_updUser.name_prefix != v_updUser.curr_name_prefix
         OR v_updUser.name_suffix != v_updUser.curr_name_suffix
         OR v_updUser.name_display != v_updUser.curr_name_display
         OR v_updUser.deceased_ind != v_updUser.curr_deceased_ind
         OR v_updUser.inst_username != v_updUser.curr_inst_username
      THEN
      
         UPDATE kmdata.users
         SET last_name = v_updUser.last_name,
             first_name = v_updUser.first_name,
             middle_name = v_updUser.middle_name,
             updated_at = current_timestamp,
             name_prefix = v_updUser.name_prefix,
             name_suffix = v_updUser.name_suffix,
             display_name = v_updUser.name_display,
             deceased_ind = v_updUser.deceased_ind
         WHERE id = v_updUser.user_id;

         UPDATE kmdata.user_identifiers
         SET inst_username = v_updUser.inst_username,
             updated_at = current_timestamp
         WHERE user_id = v_updUser.user_id;

         v_UsersUpdated := v_UsersUpdated + 1;
         
      END IF;
      
   END LOOP;


   FOR v_insUser IN v_InsertCursor LOOP
   
      -- insert resource and get resource id
      v_intResourceID := nextval('kmdata.resources_id_seq');

      INSERT INTO kmdata.resources (id, source_id, kmdata_table_id) VALUES (v_intResourceID, v_intSourceID, v_intKMDataTableID);

      -- insert user and get user id
      v_intUserID := nextval('kmdata.users_id_seq');

      INSERT INTO kmdata.users
         (id, last_name, first_name, middle_name, created_at, updated_at, resource_id,
          name_prefix, name_suffix, display_name, deceased_ind)
      VALUES
         (v_intUserID, v_insUser.last_name, v_insUser.first_name, v_insUser.middle_name,
          current_timestamp, current_timestamp, v_intResourceID,
          v_insUser.name_prefix, v_insUser.name_suffix, v_insUser.name_display, v_insUser.deceased_ind);

      -- insert user identifier
      v_intUserIdentifierID := nextval('kmdata.user_identifiers_id_seq');
   
      INSERT INTO kmdata.user_identifiers
         (id, user_id, emplid, inst_username, created_at, updated_at)
      VALUES
         (v_intUserIdentifierID, v_intUserID, v_insUser.emplid, v_insUser.inst_username,
          current_timestamp, current_timestamp);

      v_UsersInserted := v_UsersInserted + 1;
      
   END LOOP;



   v_ReturnString := 'User import completed. ' || CAST(v_UsersUpdated AS VARCHAR) || ' users updated and ' || CAST(v_UsersInserted AS VARCHAR) || ' users inserted.';

   RETURN v_ReturnString;
END;
$$ LANGUAGE plpgsql;
