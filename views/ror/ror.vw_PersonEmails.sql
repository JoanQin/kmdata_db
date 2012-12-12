CREATE OR REPLACE VIEW ror.vw_PersonEmails AS
SELECT id, email, created_at, updated_at, user_id AS person_id
  FROM kmdata.user_emails;
