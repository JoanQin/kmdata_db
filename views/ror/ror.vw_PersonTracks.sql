CREATE OR REPLACE VIEW ror.vw_PersonTracks AS
SELECT id, user_id AS person_id, login_dt, logout_dt, login_mode, created_at, updated_at
  FROM kmdata.user_tracks;
