CREATE OR REPLACE VIEW ror.vw_Departments AS
SELECT id, deptid, dept_name, manager_emplid, budget_deptid, location, 
       created_at, updated_at
  FROM kmdata.departments;
-- , resource_id

GRANT ALL ON TABLE ror.vw_Departments TO kmdata;
GRANT SELECT ON TABLE ror.vw_Departments TO kmd_dev_riv_user;
GRANT SELECT ON TABLE ror.vw_Departments TO kmd_ror_app_user;
