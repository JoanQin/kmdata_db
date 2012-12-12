CREATE OR REPLACE FUNCTION sid.import_users_from_sid (
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

   -- Cursor of all Peoplesoft info
   v_UserCursor CURSOR FOR
      SELECT su.lastName, su.firstName, su.middleName, su.iid, su.emplid, lower(su.username) AS inst_username,
         su.namePrefix, su.nameSuffix, su.displayName --, su.deceased_ind
      FROM sid.sid_users su;
      --WHERE pn.name_type = 'PRI';
BEGIN

   -- get the peoplesoft source id
   SELECT id INTO v_intSourceID FROM kmdata.sources WHERE source_name = 'sid';
   SELECT id INTO v_intKMDataTableID FROM kmdata.kmdata_tables WHERE table_name = 'users';

   v_UsersUpdated := 0;
   v_UsersInserted := 0;
   v_ReturnString := '';
   
   -- loop over the peoplesoft records
   FOR v_currUser IN v_UserCursor LOOP

      SELECT COUNT(*) INTO v_intUserIndentCount 
      FROM kmdata.user_identifiers
      WHERE emplid = v_currUser.emplid;

      IF v_intUserIndentCount = 0 THEN

         -- insert resource and get resource id
         v_intResourceID := nextval('kmdata.resources_id_seq');

         INSERT INTO kmdata.resources (id, source_id, kmdata_table_id) VALUES (v_intResourceID, v_intSourceID, v_intKMDataTableID);

         -- insert user and get user id
         v_intUserID := nextval('kmdata.users_id_seq');

         INSERT INTO kmdata.users
            (id, last_name, first_name, middle_name, created_at, updated_at, resource_id,
             name_prefix, name_suffix, display_name) --, deceased_ind)
         VALUES
            (v_intUserID, v_currUser.lastName, v_currUser.firstName, v_currUser.middleName,
             current_timestamp, current_timestamp, v_intResourceID,
             v_currUser.namePrefix, v_currUser.nameSuffix, v_currUser.displayName); --, v_currUser.deceased_ind);

         -- insert user identifier
         v_intUserIdentifierID := nextval('kmdata.user_identifiers_id_seq');
   
         INSERT INTO kmdata.user_identifiers
            (id, user_id, emplid, inst_username, idm_id, created_at, updated_at)
         VALUES
            (v_intUserIdentifierID, v_intUserID, v_currUser.emplid, v_currUser.inst_username, v_currUser.iid,
             current_timestamp, current_timestamp);

         v_UsersInserted := v_UsersInserted + 1;

      ELSE

         -- get the user id
         SELECT user_id INTO v_intUserID 
         FROM kmdata.user_identifiers
         WHERE emplid = v_currUser.emplid;
         
         -- update the users and user_identifiers table
         UPDATE kmdata.users
         SET last_name = v_currUser.lastName,
             first_name = v_currUser.firstName,
             middle_name = v_currUser.middleName,
             updated_at = current_timestamp,
             name_prefix = v_currUser.namePrefix,
             name_suffix = v_currUser.nameSuffix,
             display_name = v_currUser.displayName --,
             --deceased_ind = v_currUser.deceased_ind
         WHERE id = v_intUserID;

         UPDATE kmdata.user_identifiers
         SET inst_username = v_currUser.inst_username,
             idm_id = v_currUser.iid,
             updated_at = current_timestamp
         WHERE user_id = v_intUserID;

         v_UsersUpdated := v_UsersUpdated + 1;
         
      END IF;

   END LOOP;

   v_ReturnString := 'User import completed. ' || CAST(v_UsersUpdated AS VARCHAR) || ' users updated and ' || CAST(v_UsersInserted AS VARCHAR) || ' users inserted.';

   RETURN v_ReturnString;
END;
$$ LANGUAGE plpgsql;
