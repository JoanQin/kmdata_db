      SELECT ui.user_id, v_CampusEmailTypeID AS email_type_id, pea.email_addr
      FROM peoplesoft.ps_email_addresses pea
      INNER JOIN kmdata.user_identifiers ui ON pea.emplid = ui.emplid
      WHERE pea.e_addr_type = 'CAMP';


      SELECT b.user_id, a.e_addr_type
      FROM peoplesoft.ps_email_addresses a
      INNER JOIN kmdata.user_identifiers b ON a.emplid = b.emplid
      WHERE b.user_id = ue.user_id
      AND a.e_addr_type = 'CAMP'
      AND ue.email_type_id = v_CampusEmailTypeID


      SELECT COUNT(*) INTO v_MatchCount
        FROM kmdata.user_emails
       WHERE user_id = lc_Curr.user_id
         AND email_type_id = lc_Curr.email_type_id;


-- Insert
SELECT psea.emplid, psea.e_addr_type
  FROM peoplesoft.ps_email_addresses psea
EXCEPT
SELECT ui.emplid, 'CAMP' AS e_addr_type
  FROM kmdata.user_emails ue
  INNER JOIN kmdata.user_identifiers ui ON ue.user_id = ui.user_id;

-- Delete
SELECT ui.emplid, 'CAMP' AS e_addr_type
  FROM kmdata.user_emails ue
  INNER JOIN kmdata.user_identifiers ui ON ue.user_id = ui.user_id
EXCEPT
SELECT psea.emplid, psea.e_addr_type
  FROM peoplesoft.ps_email_addresses psea;


-- Update
SELECT psea.emplid, psea.e_addr_type
  FROM peoplesoft.ps_email_addresses psea
  INNER JOIN kmdata.user_identifiers ui ON psea.emplid = ui.emplid
  INNER JOIN kmdata.user_emails ue ON ui.user_id = ue.user_id;


