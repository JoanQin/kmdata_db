CREATE OR REPLACE FUNCTION kmdata.import_user_addresses_from_ps (
) RETURNS VARCHAR AS $$
DECLARE
   v_CampusAddressTypeID BIGINT;
   /*
   PS_addresses_cursor CURSOR FOR
      SELECT ui.user_id, v_CampusAddressTypeID AS address_type_id, address1_other, address2_other, address3_other, address4_other, 
         city_other, state_other, postal_other, country_other
      FROM peoplesoft.personal_data_addressinfo pda
      INNER JOIN kmdata.user_identifiers ui ON pda.emplid = ui.emplid;
   */

   v_UpdateCursor CURSOR FOR
      SELECT b.user_id, d.address_type_id,
         a.address1, a.address2, a.address3, a.address4, 
         a.city, a.state, a.postal, a.country,
         d.address1 AS curr_address1, d.address2 AS curr_address2, d.address3 AS curr_address3, d.address4 AS curr_address4,
         d.city AS curr_city, d.state AS curr_state, d.zip AS curr_postal, d.country AS curr_country
      FROM peoplesoft.ps_addresses a
      INNER JOIN kmdata.user_identifiers b ON a.emplid = b.emplid
      INNER JOIN kmdata.users c ON b.user_id = c.id
      INNER JOIN kmdata.user_addresses d ON b.user_id = d.user_id AND d.address_type_id = v_CampusAddressTypeID;

   v_InsertCursor CURSOR FOR
      SELECT b.user_id, chgaddress.address_type_id,
         a.address1, a.address2, a.address3, a.address4, 
         a.city, a.state, a.postal, a.country
      FROM
      (
         SELECT bi.user_id, v_CampusAddressTypeID AS address_type_id
           FROM peoplesoft.ps_addresses ai
           INNER JOIN kmdata.user_identifiers bi ON ai.emplid = bi.emplid
         EXCEPT
         SELECT y.user_id, x.address_type_id
           FROM kmdata.user_addresses x
           INNER JOIN kmdata.user_identifiers y ON x.user_id = y.user_id
           WHERE x.address_type_id = v_CampusAddressTypeID
      ) chgaddress
      INNER JOIN kmdata.user_identifiers b ON chgaddress.user_id = b.user_id
      INNER JOIN kmdata.users c ON b.user_id = c.id
      INNER JOIN peoplesoft.ps_addresses a ON b.emplid = a.emplid;

   v_UserAddressesUpdated INTEGER;
   v_UserAddressesInserted INTEGER;
   v_ReturnString VARCHAR(4000);
   
BEGIN
   -- cache the campus address type
   v_CampusAddressTypeID := kmdata.get_or_add_address_type_id('campus');

   v_UserAddressesUpdated := 0;
   v_UserAddressesInserted := 0;
   v_ReturnString := '';
   
   -- Step 1: delete current addresses that are no longer here
   DELETE FROM kmdata.user_addresses ua
   WHERE NOT EXISTS (
      SELECT b.user_id, ua.address_type_id
      FROM peoplesoft.ps_addresses a
      INNER JOIN kmdata.user_identifiers b ON a.emplid = b.emplid
      WHERE b.user_id = ua.user_id
      AND ua.address_type_id = v_CampusAddressTypeID
   )
   AND ua.address_type_id = v_CampusAddressTypeID;

   -- Step 2: update
   FOR v_updAddress IN v_UpdateCursor LOOP

      -- if this has changed then update
      IF v_updAddress.address1 != v_updAddress.curr_address1
         OR v_updAddress.address2 != v_updAddress.curr_address2
         OR v_updAddress.address3 != v_updAddress.curr_address3
         OR v_updAddress.address4 != v_updAddress.curr_address4
         OR v_updAddress.city != v_updAddress.curr_city
         OR v_updAddress.state != v_updAddress.curr_state
         OR v_updAddress.postal != v_updAddress.curr_postal
         OR v_updAddress.country != v_updAddress.curr_country
      THEN
      
         -- update the record
         UPDATE kmdata.user_addresses
            SET address1 = v_updAddress.address1, 
                address2 = v_updAddress.address2, 
                address3 = v_updAddress.address3, 
                address4 = v_updAddress.address4, 
                city = v_updAddress.city, 
                state = v_updAddress.state, 
                zip = v_updAddress.postal, 
                country = v_updAddress.country,
	        updated_at = current_timestamp
          WHERE user_id = v_updAddress.user_id
            AND address_type_id = v_updAddress.address_type_id;

         v_UserAddressesUpdated := v_UserAddressesUpdated + 1;
         
      END IF;
            
   END LOOP;

   -- Step 3: insert
   FOR v_insAddress IN v_InsertCursor LOOP
      
      -- insert if not already there
      INSERT INTO kmdata.user_addresses (
	 user_id, address_type_id, address1, address2, address3, address4, 
         city, state, zip, created_at, updated_at, 
         resource_id, country)
      VALUES (
         v_insAddress.user_id, v_insAddress.address_type_id, v_insAddress.address1, v_insAddress.address2, v_insAddress.address3, v_insAddress.address4,
         v_insAddress.city, v_insAddress.state, v_insAddress.postal, current_timestamp, current_timestamp, 
         kmdata.add_new_resource('peoplesoft', 'user_addresses'), v_insAddress.country);

      v_UserAddressesInserted := v_UserAddressesInserted + 1;
      
   END LOOP;


   v_ReturnString := 'User addresses import completed. ' || CAST(v_UserAddressesUpdated AS VARCHAR) || ' user addresses updated and ' || CAST(v_UserAddressesInserted AS VARCHAR) || ' user addresses inserted.';

   RETURN v_ReturnString;
END;
$$ LANGUAGE plpgsql;
