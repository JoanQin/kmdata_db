-- USERS AND USER_IDENTIFIERS

      SELECT pn.last_name, pn.first_name, pn.middle_name, pn.emplid, lower(pn.campus_id) AS inst_username,
         pn.name_prefix, pn.name_suffix, pn.name_display, pn.deceased_ind
      FROM peoplesoft.ps_names pn
      WHERE pn.name_type = 'PRI';


      SELECT COUNT(*) INTO v_intUserIndentCount 
      FROM kmdata.user_identifiers
      WHERE emplid = v_currUser.emplid;


-- Insert users
SELECT pn.emplid, lower(pn.campus_id) AS inst_username
  FROM peoplesoft.ps_names pn
  WHERE pn.name_type = 'PRI'
EXCEPT
SELECT ui.emplid, ui.inst_username
  FROM kmdata.users u
  INNER JOIN kmdata.user_identifiers ui ON u.id = ui.user_id;


-- Delete users
SELECT ui.emplid, ui.inst_username
  FROM kmdata.users u
  INNER JOIN kmdata.user_identifiers ui ON u.id = ui.user_id
EXCEPT
SELECT pn.emplid, lower(pn.campus_id) AS inst_username
  FROM peoplesoft.ps_names pn
  WHERE pn.name_type = 'PRI';


SELECT ui.emplid, ui.inst_username
  FROM kmdata.users u
  INNER JOIN kmdata.user_identifiers ui ON u.id = ui.user_id
  WHERE ui.inst_username = 'charney.13';
SELECT pn.emplid, lower(pn.campus_id) AS inst_username
  FROM peoplesoft.ps_names pn
  WHERE pn.name_type = 'PRI' and lower(pn.campus_id) = 'charney.13';


-- Update users (join)
SELECT COUNT(*) --pn.emplid, lower(pn.campus_id) AS inst_username
  FROM peoplesoft.ps_names pn
  INNER JOIN kmdata.user_identifiers ui ON pn.emplid = ui.emplid
  INNER JOIN kmdata.users u ON ui.user_id = u.id
  WHERE pn.name_type = 'PRI';

