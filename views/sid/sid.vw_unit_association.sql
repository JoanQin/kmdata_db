CREATE OR REPLACE VIEW sid.vw_unit_association AS
SELECT a.id AS unit_association_type_id, a.description AS unit_association_type_name, c.name AS parent_type_name, b.parentUnitId, d.name AS child_type_name, b.childunitid
FROM sid.osu_unit_association_type a
INNER JOIN sid.osu_unit_association b ON a.parentunittypeid = b.parentunittypeid AND a.childunittypeid = b.childunittypeid AND a.id = b.associationtypeid
INNER JOIN sid.osu_unit_type c ON b.parentunittypeid = c.id
INNER JOIN sid.osu_unit_type d ON b.childunittypeid = d.id;
--WHERE a.description = 'College Departments';

--GRANT SELECT ON TABLE sid.vw_unit_association TO kmd_ror_app_user;
--GRANT SELECT ON TABLE sid.vw_unit_association TO kmd_dev_riv_user;
