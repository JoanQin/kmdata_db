CREATE OR REPLACE VIEW ror.vw_Buildings AS
SELECT id, name, building_code, name_abbrev, campus_id, location_id --, resource_id
  FROM kmdata.buildings;

ALTER TABLE ror.vw_Buildings
  OWNER TO kmdata;
GRANT ALL ON TABLE ror.vw_Buildings TO kmdata;
GRANT SELECT ON TABLE ror.vw_Buildings TO kmd_ror_app_user;
GRANT SELECT ON TABLE ror.vw_Buildings TO kmd_dev_riv_user;
GRANT SELECT ON TABLE ror.vw_Buildings TO kmd_report_user;
