CREATE OR REPLACE VIEW kmdata.vw_UserEmails AS
SELECT id, email, created_at, updated_at, user_id
  FROM kmdata.user_emails;
