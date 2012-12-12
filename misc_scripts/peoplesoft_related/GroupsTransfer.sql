SELECT COUNT(*) FROM (
SELECT DISTINCT c.id AS group_id, b.user_id, b.inst_username, e.descr AS group_name, 0 AS manual_ind --,c.id AS group_id ,c.group_name
FROM peoplesoft.ps_user_appointments a
INNER JOIN kmdata.user_identifiers b ON a.emplid = b.emplid
INNER JOIN kmdata.groups c ON a.department_id = c.department_id
INNER JOIN kmdata.group_categories d ON c.group_category_id = d.id
INNER JOIN peoplesoft.ps_dept_tbl e ON a.department_id = e.deptid
WHERE d.group_category_name = 'HR Departments Faculty and Staff' AND c.id = 484 --AND b.inst_username = 'whitacre.3' --HR Departments Faculty and Staff
UNION
SELECT DISTINCT g.id AS group_id, d.user_id, d.inst_username, e.descr AS group_name, a.manual_ind --,a.group_id ,b.name
FROM osupro.user_groups a
INNER JOIN osupro.user_groups_ref b ON a.group_id = b.id
INNER JOIN osupro.user_group_categories_ref c ON b.category_id = c.id
INNER JOIN kmdata.user_identifiers d ON a.profile_emplid = d.emplid
INNER JOIN peoplesoft.ps_dept_tbl e ON b.department_id = e.deptid
INNER JOIN kmdata.group_categories f ON c.name = f.group_category_name
INNER JOIN kmdata.groups g ON b.name = g.group_name AND f.id = g.group_category_id
WHERE c."name" = 'HR Departments Faculty and Staff' AND g.id = 484 --AND d.inst_username = 'whitacre.3'
) t;

-- INTERSECT: 19230
-- EXCEPT: 42830
-- UNION: 616801

SELECT COUNT(*) FROM kmdata.user_groups WHERE manual_ind = 0 AND (user_id, group_id) NOT IN (
SELECT DISTINCT b.user_id, c.id AS group_id
FROM peoplesoft.ps_user_appointments a
INNER JOIN kmdata.user_identifiers b ON a.emplid = b.emplid
INNER JOIN kmdata.groups c ON a.department_id = c.department_id
INNER JOIN kmdata.group_categories d ON c.group_category_id = d.id
INNER JOIN peoplesoft.ps_dept_tbl e ON a.department_id = e.deptid
WHERE d.group_category_name = 'HR Departments Faculty and Staff'
);