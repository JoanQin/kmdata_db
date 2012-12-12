CREATE OR REPLACE VIEW ror.vw_Languages AS
SELECT id, name
  FROM languages;

GRANT SELECT ON ror.vw_languages TO kmd_ror_app_user;

