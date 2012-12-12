      SELECT ui.user_id, v_CampusAddressTypeID AS address_type_id, address1_other, address2_other, address3_other, address4_other, 
         city_other, state_other, postal_other, country_other
      FROM peoplesoft.personal_data_addressinfo pda
      INNER JOIN kmdata.user_identifiers ui ON pda.emplid = ui.emplid;



      SELECT b.user_id, ua.address_type_id
      FROM peoplesoft.personal_data_addressinfo a
      INNER JOIN kmdata.user_identifiers b ON a.emplid = b.emplid
      WHERE b.user_id = ua.user_id
      AND ua.address_type_id = v_CampusAddressTypeID


      SELECT COUNT(*) INTO v_MatchCount
        FROM kmdata.user_addresses
       WHERE user_id = lc_Curr.user_id
         AND address_type_id = lc_Curr.address_type_id;


-- delete
SELECT ui.emplid
  FROM kmdata.user_addresses ua
  INNER JOIN kmdata.user_identifiers ui ON ua.user_id = ui.user_id
EXCEPT
SELECT pda.emplid
  FROM peoplesoft.personal_data_addressinfo pda;

-- insert -- 2249
SELECT pda.emplid
  FROM peoplesoft.personal_data_addressinfo pda
EXCEPT
SELECT ui.emplid
  FROM kmdata.user_addresses ua
  INNER JOIN kmdata.user_identifiers ui ON ua.user_id = ui.user_id;

-- update (join) -- 1285248
SELECT pda.emplid
  FROM peoplesoft.personal_data_addressinfo pda
  INNER JOIN kmdata.user_identifiers ui ON pda.emplid = ui.emplid
  INNER JOIN kmdata.user_addresses ua ON ui.user_id = ua.user_id;


