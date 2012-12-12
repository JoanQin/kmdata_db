CREATE OR REPLACE VIEW kmdata.vw_UserTracks AS
SELECT id, user_id, login_dt, logout_dt, login_mode, created_at, updated_at
  FROM kmdata.user_tracks;
