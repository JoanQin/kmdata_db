SELECT DISTINCT d.deptid, d.dept_name -- ad.department_name, ad.college_id, ad.abbreviation, ad.dept_code, d.deptid, d.dept_name
FROM kmdata.acad_departments ad
INNER JOIN kmdata.departments d ON kmdata.get_converted_acad_dept_id(ad.dept_code) = d.deptid
ORDER BY d.deptid;