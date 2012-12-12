CREATE OR REPLACE VIEW ror.vw_PersonPreferredKeywords AS
SELECT id, user_id AS person_id, expertise_keyterm_id, partners_keyterm_id, contact_ind, 
       create_date
  FROM kmdata.user_preferred_keywords;
