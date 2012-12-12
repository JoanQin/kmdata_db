CREATE OR REPLACE FUNCTION kmdata.import_user_emails_from_ps (
) RETURNS VARCHAR AS $$
DECLARE
   v_CampusEmailTypeID BIGINT;

   /*
   PS_emails_cursor CURSOR FOR
      SELECT ui.user_id, v_CampusEmailTypeID AS email_type_id, pea.email_addr
      FROM peoplesoft.ps_email_addresses pea
      INNER JOIN kmdata.user_identifiers ui ON pea.emplid = ui.emplid
      WHERE pea.e_addr_type = 'CAMP';
   */

   v_UpdateCursor CURSOR FOR
      SELECT b.user_id, d.email_type_id,
         a.email_addr,
         d.email AS curr_email_addr
      FROM peoplesoft.ps_email_addresses a
      INNER JOIN kmdata.user_identifiers b ON a.emplid = b.emplid
      INNER JOIN kmdata.users c ON b.user_id = c.id
      INNER JOIN kmdata.user_emails d ON b.user_id = d.user_id AND d.email_type_id = v_CampusEmailTypeID
      WHERE a.e_addr_type = 'CAMP';
   
   v_InsertCursor CURSOR FOR
      SELECT b.user_id, chgemail.email_type_id,
         a.email_addr
      FROM
      (
         SELECT bi.user_id, v_CampusEmailTypeID AS email_type_id
           FROM peoplesoft.ps_email_addresses ai
           INNER JOIN kmdata.user_identifiers bi ON ai.emplid = bi.emplid
           WHERE ai.e_addr_type = 'CAMP'
         EXCEPT
         SELECT y.user_id, x.email_type_id
           FROM kmdata.user_emails x
           INNER JOIN kmdata.user_identifiers y ON x.user_id = y.user_id
           WHERE x.email_type_id = v_CampusEmailTypeID
      ) chgemail
      INNER JOIN kmdata.user_identifiers b ON chgemail.user_id = b.user_id
      INNER JOIN kmdata.users c ON b.user_id = c.id
      INNER JOIN peoplesoft.ps_email_addresses a ON b.emplid = a.emplid AND a.e_addr_type = 'CAMP';
      
   v_UserEmailsUpdated INTEGER;
   v_UserEmailsInserted INTEGER;
   v_ReturnString VARCHAR(4000);
   
BEGIN
   -- cache the campus email type
   v_CampusEmailTypeID := kmdata.get_or_add_email_type_id('campus');

   v_UserEmailsUpdated := 0;
   v_UserEmailsInserted := 0;
   v_ReturnString := '';
   
   -- Step 1: delete current emails that are no longer here
   DELETE FROM kmdata.user_emails ue
   WHERE NOT EXISTS (
      SELECT b.user_id, a.e_addr_type
      FROM peoplesoft.ps_email_addresses a
      INNER JOIN kmdata.user_identifiers b ON a.emplid = b.emplid
      WHERE b.user_id = ue.user_id
      AND a.e_addr_type = 'CAMP'
      AND ue.email_type_id = v_CampusEmailTypeID
   )
   AND ue.email_type_id = v_CampusEmailTypeID;

   -- Step 2: update
   FOR v_updEmail IN v_UpdateCursor LOOP

      -- if this has changed then update
      IF v_updEmail.email_addr != v_updEmail.curr_email_addr
      THEN
      
         -- update the record
         UPDATE kmdata.user_emails
            SET email = v_updEmail.email_addr, 
	        updated_at = current_timestamp
          WHERE user_id = v_updEmail.user_id
            AND email_type_id = v_updEmail.email_type_id;

         v_UserEmailsUpdated := v_UserEmailsUpdated + 1;
         
      END IF;
            
   END LOOP;

   -- Step 3: insert
   FOR v_insEmail IN v_InsertCursor LOOP
      
      -- insert if not already there
      INSERT INTO kmdata.user_emails (
	 user_id, email_type_id, email, 
	 created_at, updated_at, 
	 resource_id)
      VALUES (
         v_insEmail.user_id, v_insEmail.email_type_id, v_insEmail.email_addr,
         current_timestamp, current_timestamp, 
         kmdata.add_new_resource('peoplesoft', 'user_emails'));

      v_UserEmailsInserted := v_UserEmailsInserted + 1;

   END LOOP;


   v_ReturnString := 'User emails import completed. ' || CAST(v_UserEmailsUpdated AS VARCHAR) || ' user emails updated and ' || CAST(v_UserEmailsInserted AS VARCHAR) || ' user emails inserted.';

   RETURN v_ReturnString;
END;
$$ LANGUAGE plpgsql;
