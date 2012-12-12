CREATE OR REPLACE FUNCTION kmdata.import_user_phones_from_ps (
) RETURNS VARCHAR AS $$
DECLARE
   v_CampusPhoneTypeID BIGINT;
   /*
   PS_phones_cursor CURSOR FOR
      SELECT ui.user_id, v_CampusPhoneTypeID AS address_type_id
      FROM peoplesoft.ps_phones psp
      INNER JOIN kmdata.user_identifiers ui ON psp.emplid = ui.emplid;
   */

   v_UpdateCursor CURSOR FOR
      SELECT b.user_id, d.phone_type_id,
         a.country_code, a.phone, a.extension, a.pref_phone_flag, 
         d.country_code AS curr_country_code, d.phone AS curr_phone, d.extension AS curr_extension, d.pref_phone_flag AS curr_pref_phone_flag
      FROM peoplesoft.ps_personal_phone a
      INNER JOIN kmdata.user_identifiers b ON a.emplid = b.emplid
      INNER JOIN kmdata.users c ON b.user_id = c.id
      INNER JOIN kmdata.user_phones d ON b.user_id = d.user_id AND d.phone_type_id = v_CampusPhoneTypeID;

   v_InsertCursor CURSOR FOR
      SELECT b.user_id, chgphone.phone_type_id,
         a.country_code, a.phone, a.extension, a.pref_phone_flag
      FROM
      (
         SELECT bi.user_id, v_CampusPhoneTypeID AS phone_type_id
           FROM peoplesoft.ps_personal_phone ai
           INNER JOIN kmdata.user_identifiers bi ON ai.emplid = bi.emplid
         EXCEPT
         SELECT y.user_id, x.phone_type_id
           FROM kmdata.user_phones x
           INNER JOIN kmdata.user_identifiers y ON x.user_id = y.user_id
           WHERE x.phone_type_id = v_CampusPhoneTypeID
      ) chgphone
      INNER JOIN kmdata.user_identifiers b ON chgphone.user_id = b.user_id
      INNER JOIN kmdata.users c ON b.user_id = c.id
      INNER JOIN peoplesoft.ps_personal_phone a ON b.emplid = a.emplid;
      
   v_UserPhonesUpdated INTEGER;
   v_UserPhonesInserted INTEGER;
   v_ReturnString VARCHAR(4000);
   
BEGIN
   -- cache the campus address type
   v_CampusPhoneTypeID := kmdata.get_or_add_phone_type_id('campus');

   v_UserPhonesUpdated := 0;
   v_UserPhonesInserted := 0;
   v_ReturnString := '';
   
   -- Step 1: delete current phones that are no longer here
   DELETE FROM kmdata.user_phones ua
   WHERE NOT EXISTS (
      SELECT b.user_id, ua.phone_type_id
      FROM peoplesoft.ps_personal_phone a
      INNER JOIN kmdata.user_identifiers b ON a.emplid = b.emplid
      WHERE b.user_id = ua.user_id
      AND ua.phone_type_id = v_CampusPhoneTypeID
   )
   AND ua.phone_type_id = v_CampusPhoneTypeID;

   -- Step 2: update
   FOR v_updPhone IN v_UpdateCursor LOOP

      -- if this has changed then update
      IF v_updPhone.country_code != v_updPhone.curr_country_code
         OR v_updPhone.phone != v_updPhone.curr_phone
         OR v_updPhone.extension != v_updPhone.curr_extension
         OR v_updPhone.pref_phone_flag != v_updPhone.curr_pref_phone_flag
      THEN
      
         -- update the record
         UPDATE kmdata.user_phones
            SET country_code = v_updPhone.curr_country_code, 
                phone = v_updPhone.curr_phone, 
                "extension" = v_updPhone.curr_extension, 
                pref_phone_flag = v_updPhone.curr_pref_phone_flag, 
	        updated_at = current_timestamp
          WHERE user_id = v_updPhone.user_id
            AND phone_type_id = v_updPhone.phone_type_id;

         v_UserPhonesUpdated := v_UserPhonesUpdated + 1;
         
      END IF;
            
   END LOOP;

   -- Step 3: insert
   FOR v_insPhone IN v_InsertCursor LOOP
      
      -- insert if not already there
      INSERT INTO kmdata.user_phones (
	 user_id, phone_type_id, country_code, phone, "extension", pref_phone_flag, 
         created_at, updated_at, 
         resource_id)
      VALUES (
         v_insPhone.user_id, v_insPhone.phone_type_id, v_insPhone.country_code, v_insPhone.phone, v_insPhone.extension, v_insPhone.pref_phone_flag,
         current_timestamp, current_timestamp, 
         kmdata.add_new_resource('peoplesoft', 'user_phones'));

      v_UserPhonesInserted := v_UserPhonesInserted + 1;
      
   END LOOP;


   v_ReturnString := 'User phones import completed. ' || CAST(v_UserPhonesUpdated AS VARCHAR) || ' user phones updated and ' || CAST(v_UserPhonesInserted AS VARCHAR) || ' user phones inserted.';

   RETURN v_ReturnString;
END;
$$ LANGUAGE plpgsql;
