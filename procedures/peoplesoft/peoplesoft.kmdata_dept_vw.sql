CREATE OR REPLACE VIEW peoplesoft.kmdata_dept_vw AS
   SELECT d.deptid, d.descr AS dept_name, d.manager_id, d.budget_deptid, d.location
   FROM peoplesoft.ps_dept_tbl d,
   (
      SELECT deptid, MAX(effdt) AS effdt
      FROM peoplesoft.ps_dept_tbl
      GROUP BY deptid
   ) d2
   WHERE d.deptid = d2.deptid
   AND d.effdt = d2.effdt
   AND d.eff_status = 'A'
   AND d.setid = 'OSUSI';