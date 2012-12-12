CREATE OR REPLACE VIEW kmdata.vw_UserPreferredKeywords AS
SELECT id, user_id, expertise_keyterm_id, partners_keyterm_id, contact_ind, 
       create_date
  FROM kmdata.user_preferred_keywords;
