SELECT psjo.EMPLID, psjo.EMPL_RCD, psjo.EFFSEQ, psjo.DEPTID, psjc.DESCRSHORT AS TITLE_ABBRV, psjc.DESCR AS TITLE, psjo.JOBCODE, psjo.POSITION_NBR,  psdo.DESCR AS WORKING_TITLE, psdo.POSN_STATUS, psdo.STATUS_DT, psdo.DESCRLONG
FROM PS_JOB psjo, PS_JOBCODE_TBL psjc, PS_POSITION_DATA psdo
WHERE psjo.JOBCODE = psjc.JOBCODE
AND psjo.POSITION_NBR = psdo.POSITION_NBR
AND psjo.EMPLID = '06169467'
AND psjo.EFFDT = (SELECT MAX(psji.EFFDT) FROM PS_JOB psji WHERE psji.EMPLID = psjo.EMPLID)
AND psjc.EFFDT = (SELECT MAX(psjci.EFFDT) FROM PS_JOBCODE_TBL psjci WHERE psjci.JOBCODE = psjc.JOBCODE)
AND psdo.EFFDT = (SELECT MAX(psdi.EFFDT) FROM PS_POSITION_DATA psdi WHERE psdi.POSITION_NBR = psdo.POSITION_NBR)



SELECT 
   psjo.EMPLID, psjo.EMPL_RCD, psjo.EFFSEQ, psjo.DEPTID, 
   psjc.DESCRSHORT AS TITLE_ABBRV, psjc.DESCR AS TITLE, 
   psjo.JOBCODE, psjo.POSITION_NBR, 
   psdo.DESCR AS WORKING_TITLE, psdo.POSN_STATUS, psdo.STATUS_DT, psdo.DESCRLONG
FROM PS_JOB psjo, PS_JOBCODE_TBL psjc, PS_POSITION_DATA psdo
WHERE psjo.JOBCODE = psjc.JOBCODE
AND psjo.POSITION_NBR = psdo.POSITION_NBR
AND psjo.EMPLID = '06169467'
AND psjo.EFFDT = (SELECT MAX(psji.EFFDT) FROM PS_JOB psji WHERE psji.EMPLID = psjo.EMPLID)
AND psjc.EFFDT = (SELECT MAX(psjci.EFFDT) FROM PS_JOBCODE_TBL psjci WHERE psjci.JOBCODE = psjc.JOBCODE)
AND psdo.EFFDT = (SELECT MAX(psdi.EFFDT) FROM PS_POSITION_DATA psdi WHERE psdi.POSITION_NBR = psdo.POSITION_NBR)
--AND psjo.EMPL_RCD = (SELECT MAX(psji2.EMPL_RCD) FROM PS_JOB psji2 WHERE psji2.EMPLID = psjo.EMPLID AND psji2.EFFDT = psjo.EMPLID)
--AND psjo.EFFSEQ = (SELECT MAX(psji3.EFFSEQ) FROM PS_JOB psji3 WHERE psji3.EMPLID = psjo.EMPLID AND psji3.EFFDT = psjo.EMPLID AND psji3.EMPL_RCD = psjo.EMPL_RCD);

SELECT psdo.* 
FROM PS_POSITION_DATA psdo
WHERE psdo.POSITION_NBR = 00062274 -- 00062250
AND psdo.EFFDT = (SELECT MAX(psdi.EFFDT) FROM PS_POSITION_DATA psdi WHERE psdi.POSITION_NBR = psdo.POSITION_NBR);

SELECT * FROM PS_PERSONAL_DATA WHERE EMPLID = '06169467'

SELECT * FROM PS_DEPT_TBL WHERE DEPTID = '46101'

select psp.*, psj.* 
from PS_JOB psj, PS_POSITION_DATA psp
WHERE psj.position_nbr = psp.position_nbr
AND psj.EMPLID = '06169467' -- '96069775'
AND psj.
-- 71060493 (whitacre.3)

SELECT EMPLID, COUNTRY, ADDRESS1, ADDRESS2, ADDRESS3, ADDRESS4, CITY, NUM1, NUM2, HOUSE_TYPE, ADDR_FIELD1, ADDR_FIELD2, ADDR_FIELD3, COUNTY, STATE, POSTAL, GEO_CODE, 
   IN_CITY_LIMIT, COUNTRY_OTHER, ADDRESS1_OTHER, ADDRESS2_OTHER, ADDRESS3_OTHER, ADDRESS4_OTHER, CITY_OTHER, COUNTY_OTHER, STATE_OTHER, POSTAL_OTHER, NUM1_OTHER, 
   NUM2_OTHER, HOUSE_TYPE_OTHER, ADDR_FIELD1_OTHER, ADDR_FIELD2_OTHER, ADDR_FIELD3_OTHER, IN_CITY_LMT_OTHER, GEO_CODE_OTHER, COUNTRY_CODE, PHONE, EXTENSION
FROM PS_PERSONAL_DATA
WHERE EMPLID = '06169467' -- '200222110'
AND ROWNUM <= 100


SELECT psjv.EMPLID, psjv.EMPL_RCD, psj2.DEPTID, psjc2.DESCRSHORT AS TITLE_ABBRV, psjc2.DESCR AS TITLE, psp2.DESCR AS WORKING_TITLE,
   psj2.CLASS_INDC AS TITLE_GRP_ID_CODE, psj2.JOBCODE, NULL AS BUSINESS_UNIT, NULL AS "ORGANIZATION", NULL AS FUND, NULL AS "ACCOUNT",
   psjc2.JOB_FUNCTION AS "FUNCTION", NULL AS "PROJECT", NULL AS "PROGRAM", NULL AS "USER_DEFINED", NULL AS BUDGET_YEAR, NULL AS PRIM_APPT_CODE,
   TO_NUMBER(NULL) AS APPT_PERCENT, NULL AS APPT_SEQ_CODE, NULL AS SUMMER1_SERVICE, NULL AS WINTER_SERVICE, NULL AS AUTUMN_SERVICE,
   NULL AS SPRING_SERVICE, NULL AS SUMMER2_SERVICE, TO_DATE(NULL) AS OSU_LEAVE_START_DATE, TO_DATE(NULL) AS APPT_END_DATE, psp2.OS_APPT_LENGTH AS APPT_END_LENGTH,
   TO_DATE(NULL) AS DW_CHANGE_DATE, NULL AS DW_CHANGE_CODE, psjc2.SAL_ADMIN_PLAN
FROM (
   SELECT psji.EFFDT, psji.EMPLID, psji.EMPL_RCD, MAX(pst.EFFSEQ) AS EFFSEQ
   FROM (SELECT MAX(EFFDT) AS EFFDT, EMPLID, EMPL_RCD 
         FROM PS_JOB
         GROUP BY EMPLID, EMPL_RCD) psji
   INNER JOIN PS_JOB pst ON psji.EFFDT = pst.EFFDT AND psji.EMPLID = pst.EMPLID AND psji.EMPL_RCD = pst.EMPL_RCD
   GROUP BY psji.EFFDT, psji.EMPLID, psji.EMPL_RCD
) psjv
INNER JOIN PS_JOB psj2 ON psjv.EFFDT = psj2.EFFDT AND psjv.EMPLID = psj2.EMPLID AND psjv.EMPL_RCD = psj2.EMPL_RCD AND psjv.EFFSEQ = psj2.EFFSEQ
INNER JOIN (
   SELECT MAX(psjci.EFFDT) AS EFFDT, psjci.SETID, psjci.JOBCODE
   FROM PS_JOBCODE_TBL psjci
   GROUP BY psjci.SETID, psjci.JOBCODE
) psjcv ON psj2.JOBCODE = psjcv.JOBCODE
INNER JOIN PS_JOBCODE_TBL psjc2 ON psjcv.JOBCODE = psjc2.JOBCODE AND psjcv.EFFDT = psjc2.EFFDT AND psjcv.SETID = psjc2.SETID
INNER JOIN (
   SELECT MAX(pspi.EFFDT) AS EFFDT, pspi.POSITION_NBR
   FROM PS_POSITION_DATA pspi
   GROUP BY pspi.POSITION_NBR
) pspv ON psj2.POSITION_NBR = pspv.POSITION_NBR
INNER JOIN PS_POSITION_DATA psp2 ON pspv.POSITION_NBR = psp2.POSITION_NBR AND pspv.EFFDT = psp2.EFFDT
WHERE psj2.EMPL_STATUS = 'A'
--WHERE psjv.EMPLID = '71060493' -- 71060493
--AND psj2.EMPL_STATUS = 'A'


select EMPL_TYPE, EMPL_CLASS, SAL_ADMIN_PLAN, REG_TEMP, FULL_PART_TIME, PS_JOB.* from PS_JOB WHERE EMPLID = '06169467'; -- '100114638' '03129362';

select * from PS_POSITION_DATA WHERE POSITION_NBR = '00062274';

SELECT psp2.* 
   --psjv.EMPLID, psj2.DEPTID, psjc2.DESCRSHORT AS TITLE_ABBRV, psjc2.DESCR AS TITLE, psp2.DESCR AS WORKING_TITLE,
   --psj2.CLASS_INDC AS TITLE_GRP_ID_CODE, psj2.JOBCODE, NULL AS BUSINESS_UNIT, NULL AS "ORGANIZATION", NULL AS FUND, NULL AS "ACCOUNT",
   --psjc2.JOB_FUNCTION AS "FUNCTION", NULL AS "PROJECT", NULL AS "PROGRAM", NULL AS "USER_DEFINED", NULL AS BUDGET_YEAR, NULL AS PRIM_APPT_CODE,
   --TO_NUMBER(NULL) AS APPT_PERCENT, NULL AS APPT_SEQ_CODE, NULL AS SUMMER1_SERVICE, NULL AS WINTER_SERVICE, NULL AS AUTUMN_SERVICE,
   --NULL AS SPRING_SERVICE, NULL AS SUMMER2_SERVICE, TO_DATE(NULL) AS OSU_LEAVE_START_DATE, TO_DATE(NULL) AS APPT_END_DATE, psp2.OS_APPT_LENGTH AS APPT_END_LENGTH,
   --TO_DATE(NULL) AS DW_CHANGE_DATE, NULL AS DW_CHANGE_CODE
FROM (
   SELECT psji.EFFDT, psji.EMPLID, psji.EMPL_RCD, MAX(pst.EFFSEQ) AS EFFSEQ
   FROM (SELECT MAX(EFFDT) AS EFFDT, EMPLID, EMPL_RCD 
         FROM PS_JOB
         GROUP BY EMPLID, EMPL_RCD) psji
   INNER JOIN PS_JOB pst ON psji.EFFDT = pst.EFFDT AND psji.EMPLID = pst.EMPLID AND psji.EMPL_RCD = pst.EMPL_RCD
   GROUP BY psji.EFFDT, psji.EMPLID, psji.EMPL_RCD
) psjv
INNER JOIN PS_JOB psj2 ON psjv.EFFDT = psj2.EFFDT AND psjv.EMPLID = psj2.EMPLID AND psjv.EMPL_RCD = psj2.EMPL_RCD AND psjv.EFFSEQ = psj2.EFFSEQ
INNER JOIN (
   SELECT MAX(psjci.EFFDT) AS EFFDT, psjci.SETID, psjci.JOBCODE
   FROM PS_JOBCODE_TBL psjci
   --WHERE JOBCODE = '8187'
   GROUP BY psjci.SETID, psjci.JOBCODE
) psjcv ON psj2.JOBCODE = psjcv.JOBCODE
INNER JOIN PS_JOBCODE_TBL psjc2 ON psjcv.JOBCODE = psjc2.JOBCODE AND psjcv.EFFDT = psjc2.EFFDT AND psjcv.SETID = psjc2.SETID
INNER JOIN (
   SELECT MAX(pspi.EFFDT) AS EFFDT, pspi.POSITION_NBR
   FROM PS_POSITION_DATA pspi
   --WHERE POSITION_NBR = '00062274'
   GROUP BY pspi.POSITION_NBR
) pspv ON psj2.POSITION_NBR = pspv.POSITION_NBR
INNER JOIN PS_POSITION_DATA psp2 ON pspv.POSITION_NBR = psp2.POSITION_NBR AND pspv.EFFDT = psp2.EFFDT
WHERE psj2.EMPL_STATUS = 'A'
AND psjv.EMPLID = '06169467';

SELECT * FROM PS_JOB WHERE EFFDT = TO_DATE('01-OCT-11') AND EMPLID = '06169467' AND EMPL_RCD = 0 AND EFFSEQ = 2


-- PROD
SELECT COUNT(*) FROM (
SELECT DISTINCT b.inst_username --c.id AS group_id, b.user_id, b.inst_username, e.descr AS group_name, 0 AS manual_ind --,c.id AS group_id ,c.group_name
FROM peoplesoft.ps_user_appointments a
INNER JOIN kmdata.user_identifiers b ON a.emplid = b.emplid
INNER JOIN kmdata.groups c ON a.department_id = c.department_id
INNER JOIN kmdata.group_categories d ON c.group_category_id = d.id
INNER JOIN peoplesoft.ps_dept_tbl e ON a.department_id = e.deptid
WHERE d.group_category_name = 'HR Departments Faculty and Staff' AND c.id = 260 --AND b.inst_username = 'whitacre.3' --HR Departments Faculty and Staff
ORDER BY b.inst_username
UNION
SELECT DISTINCT d.inst_username --g.id AS group_id, d.user_id, d.inst_username, e.descr AS group_name, a.manual_ind --,a.group_id ,b.name
FROM osupro.user_groups a
INNER JOIN osupro.user_groups_ref b ON a.group_id = b.id
INNER JOIN osupro.user_group_categories_ref c ON b.category_id = c.id
INNER JOIN kmdata.user_identifiers d ON a.profile_emplid = d.emplid
INNER JOIN peoplesoft.ps_dept_tbl e ON b.department_id = e.deptid
INNER JOIN kmdata.group_categories f ON c.name = f.group_category_name
INNER JOIN kmdata.groups g ON b.name = g.group_name AND f.id = g.group_category_id
WHERE c."name" = 'HR Departments Faculty and Staff' AND g.id = 260 --AND d.inst_username = 'whitacre.3'
ORDER BY d.inst_username
) t;


-- DEV
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

SELECT * FROM kmdata.groups WHERE department_id = '42711';



SELECT COUNT(*) FROM (
SELECT b.user_id, c.id AS group_id
FROM peoplesoft.ps_user_appointments a
INNER JOIN kmdata.user_identifiers b ON a.emplid = b.emplid
INNER JOIN kmdata.groups c ON a.department_id = c.department_id
INNER JOIN kmdata.group_categories d ON c.group_category_id = d.id
INNER JOIN peoplesoft.ps_dept_tbl e ON a.department_id = e.deptid
WHERE d.group_category_name = 'HR Departments Faculty and Staff'
EXCEPT
SELECT a.user_id, a.group_id
FROM kmdata.user_groups a
INNER JOIN kmdata.groups b ON a.group_id = b.id
INNER JOIN kmdata.group_categories c ON b.group_category_id = c.id
WHERE c.group_category_name = 'HR Departments Faculty and Staff') t;

SELECT COUNT(*) FROM peoplesoft.ps_user_appointments;
SELECT COUNT(*) FROM kmdata.user_appointments;











WITH RECURSIVE structured_groups(group_id, depth, path, cycle) AS (
   SELECT a.id, 1, ARRAY[a.id], false
   FROM kmdata.groups a
   WHERE a.id = 17132
   UNION ALL
   SELECT a1.id, c1.depth + 1, path || a1.id, a1.id = ANY(path)
   FROM kmdata.groups a1
   INNER JOIN kmdata.user_groups_nestings b1 ON a1.id = b1.group_id
   INNER JOIN structured_groups c1 ON b1.parent_id = c1.group_id
   WHERE NOT cycle
)
SELECT DISTINCT b.user_id
FROM structured_groups a
INNER JOIN kmdata.user_groups b ON a.group_id = b.group_id
WHERE b.user_id NOT IN (
   SELECT b2.user_id 
   FROM structured_groups a2
   INNER JOIN kmdata.group_excluded_users b2 ON a2.group_id = b2.group_id
   WHERE a2.group_id = ANY(path)
);


WITH RECURSIVE structured_groups(group_id, depth, path, cycle) AS (
   SELECT a.id, 1, ARRAY[a.id], false
   FROM kmdata.groups a
   WHERE a.id = 2146
   UNION ALL
   SELECT a1.id, c1.depth + 1, path || a1.id, a1.id = ANY(path)
   FROM kmdata.groups a1
   INNER JOIN kmdata.user_groups_nestings b1 ON a1.id = b1.group_id
   INNER JOIN structured_groups c1 ON b1.parent_id = c1.group_id
   WHERE NOT cycle
)
SELECT *
FROM structured_groups a
INNER JOIN kmdata.groups b ON a.group_id = b.id
ORDER BY depth ASC, path ASC;


-- SQL Server
WITH Structured_Groups(GroupID, Depth, PathString) AS (
   SELECT a.intID, 1, CAST(a.intID AS VARCHAR) AS PathString
   FROM dbo.Ref_User_Groups a
   WHERE a.intID = 8519 -- Arts and Sciences Cluster
   UNION ALL
   SELECT a1.intID, c1.Depth + 1, CAST((c1.PathString + '.' + CAST(a1.intID AS VARCHAR)) AS VARCHAR) AS PathString
   FROM dbo.Ref_User_Groups a1
   INNER JOIN dbo.User_Groups_Nesting b1 ON a1.intID = b1.intGroupID
   INNER JOIN Structured_Groups c1 ON b1.intParentID = c1.GroupID
)
SELECT *
FROM Structured_Groups a
INNER JOIN dbo.Ref_User_Groups b ON a.GroupID = b.intID
ORDER BY PathString ASC;





WITH Structured_Groups(Depth, PathString, GroupName, GroupID, DeptID, ParentGroupName, ParentGroupID, ParentDeptID) AS (
   SELECT 1 AS Depth, CAST(a.intID AS VARCHAR) AS PathString, 
		a.chvName AS GroupName, a.intID AS GroupID, a.chvDepartmentID AS DeptID,
		CAST(NULL AS VARCHAR) AS ParentGroupName, NULL AS ParentGroupID, CAST(NULL AS VARCHAR) AS ParentDeptID
   FROM dbo.Ref_User_Groups a
   WHERE a.intCategoryID IN (7,11,8,4,9,12,3) -- JV's category list
   UNION ALL
   SELECT c1.Depth + 1 AS Depth, CAST((c1.PathString + '.' + CAST(a1.intID AS VARCHAR)) AS VARCHAR) AS PathString, 
		a1.chvName AS GroupName, a1.intID AS GroupID, a1.chvDepartmentID AS DeptID,
		CAST(c1.GroupName AS VARCHAR) AS ParentGroupName, c1.GroupID AS ParentGroupID, CAST(c1.DeptID AS VARCHAR) AS ParentDeptID
   FROM dbo.Ref_User_Groups a1
   INNER JOIN dbo.User_Groups_Nesting b1 ON a1.intID = b1.intGroupID
   INNER JOIN Structured_Groups c1 ON b1.intParentID = c1.GroupID
)
SELECT a.Depth, a.PathString AS GroupIDPathString,
       a.GroupName, a.GroupID, a.DeptID, 
       a.ParentGroupName, a.ParentGroupID, a.ParentDeptID
FROM Structured_Groups a
ORDER BY a.PathString













WITH Structured_Groups(Depth, PathString, GroupName, GroupID, DeptID, ParentGroupName, ParentGroupID, ParentDeptID) AS (
   SELECT 1 AS Depth, CAST(a.intID AS VARCHAR) AS PathString, 
		a.chvName AS GroupName, a.intID AS GroupID, a.chvDepartmentID AS DeptID,
		CAST(NULL AS VARCHAR) AS ParentGroupName, NULL AS ParentGroupID, CAST(NULL AS VARCHAR) AS ParentDeptID
   FROM dbo.Ref_User_Groups a
   WHERE a.intCategoryID IN (7,11,8,4,9,12,3) -- JV's category list
   UNION ALL
   SELECT c1.Depth + 1 AS Depth, CAST((c1.PathString + '.' + CAST(a1.intID AS VARCHAR)) AS VARCHAR) AS PathString, 
		a1.chvName AS GroupName, a1.intID AS GroupID, a1.chvDepartmentID AS DeptID,
		CAST(c1.GroupName AS VARCHAR) AS ParentGroupName, c1.GroupID AS ParentGroupID, CAST(c1.DeptID AS VARCHAR) AS ParentDeptID
   FROM dbo.Ref_User_Groups a1
   INNER JOIN dbo.User_Groups_Nesting b1 ON a1.intID = b1.intGroupID
   INNER JOIN Structured_Groups c1 ON b1.intParentID = c1.GroupID
)
SELECT a.Depth, a.PathString AS GroupIDPathString,
       a.GroupName, a.GroupID, a.DeptID, 
       a.ParentGroupName, a.ParentGroupID, a.ParentDeptID
FROM Structured_Groups a
ORDER BY a.PathString


WITH Structured_Groups(GroupID, Depth, PathString) AS (
   SELECT a.intID, 1, CAST(a.intID AS VARCHAR) AS PathString
   FROM dbo.Ref_User_Groups a
   WHERE a.intCategoryID IN (7,11,8,4,9,12,3) -- JV's category list
   UNION ALL
   SELECT a1.intID, c1.Depth + 1, CAST((c1.PathString + '.' + CAST(a1.intID AS VARCHAR)) AS VARCHAR) AS PathString
   FROM dbo.Ref_User_Groups a1
   INNER JOIN dbo.User_Groups_Nesting b1 ON a1.intID = b1.intGroupID
   INNER JOIN Structured_Groups c1 ON b1.intParentID = c1.GroupID
)
SELECT a.GroupID, a.Depth, a.PathString, b.intCategoryID AS CategoryID, 
       b.chvDepartmentID AS DepartmentID, d.chvDepartmentID AS ParentDepartmentID
FROM Structured_Groups a
INNER JOIN dbo.Ref_User_Groups b ON a.GroupID = b.intID
LEFT JOIN dbo.User_Groups_Nesting c ON b.intID = c.intGroupID
LEFT JOIN dbo.Ref_User_Groups d ON c.intParentID = d.intID




SELECT a.GroupID, a.Depth, a.PathString, b.chvDepartmentID, b.intCategoryID
FROM Structured_Groups a
INNER JOIN dbo.Ref_User_Groups b ON a.GroupID = b.intID
LEFT JOIN dbo.User_Groups_Nesting c ON b.intID = c.intGroupID
LEFT JOIN dbo.Ref_User_Groups d ON c.intParentID = d.intID




WITH Structured_Groups(Depth, PathString, GroupName, GroupID, DeptID, ParentGroupName, ParentGroupID, ParentDeptID) AS (
   SELECT 1 AS Depth, CAST(a.intID AS VARCHAR) AS PathString, 
		a.chvName AS GroupName, a.intID AS GroupID, a.chvDepartmentID AS DeptID,
		CAST(NULL AS VARCHAR) AS ParentGroupName, NULL AS ParentGroupID, CAST(NULL AS VARCHAR) AS ParentDeptID
   FROM dbo.Ref_User_Groups a
   WHERE a.intCategoryID IN (1) -- JV's category list
   UNION ALL
   SELECT c1.Depth + 1 AS Depth, CAST((c1.PathString + '.' + CAST(a1.intID AS VARCHAR)) AS VARCHAR) AS PathString, 
		a1.chvName AS GroupName, a1.intID AS GroupID, a1.chvDepartmentID AS DeptID,
		CAST(c1.GroupName AS VARCHAR) AS ParentGroupName, c1.GroupID AS ParentGroupID, CAST(c1.DeptID AS VARCHAR) AS ParentDeptID
   FROM dbo.Ref_User_Groups a1
   INNER JOIN dbo.User_Groups_Nesting b1 ON a1.intID = b1.intGroupID
   INNER JOIN Structured_Groups c1 ON b1.intParentID = c1.GroupID
)
SELECT --a.Depth, a.PathString AS GroupIDPathString,
       a.GroupID, a.GroupName, a.DeptID --, 
       --a.ParentGroupName, a.ParentGroupID, a.ParentDeptID
FROM Structured_Groups a
ORDER BY a.GroupID --a.PathString


WITH Structured_Groups(Depth, PathString, GroupName, GroupID, DeptID, ParentGroupName, ParentGroupID, ParentDeptID) AS (
   SELECT 1 AS Depth, CAST(a.intID AS VARCHAR) AS PathString, 
		a.chvName AS GroupName, a.intID AS GroupID, a.chvDepartmentID AS DeptID,
		CAST(NULL AS VARCHAR) AS ParentGroupName, NULL AS ParentGroupID, CAST(NULL AS VARCHAR) AS ParentDeptID
   FROM dbo.Ref_User_Groups a
   WHERE a.intCategoryID IN (1) -- JV's category list
   UNION ALL
   SELECT c1.Depth + 1 AS Depth, CAST((c1.PathString + '.' + CAST(a1.intID AS VARCHAR)) AS VARCHAR) AS PathString, 
		a1.chvName AS GroupName, a1.intID AS GroupID, a1.chvDepartmentID AS DeptID,
		CAST(c1.GroupName AS VARCHAR) AS ParentGroupName, c1.GroupID AS ParentGroupID, CAST(c1.DeptID AS VARCHAR) AS ParentDeptID
   FROM dbo.Ref_User_Groups a1
   INNER JOIN dbo.User_Groups_Nesting b1 ON a1.intID = b1.intGroupID
   INNER JOIN Structured_Groups c1 ON b1.intParentID = c1.GroupID
)
SELECT --y.chvDepartmentID AS ParentDeptID, 
x.intParentID AS ParentGroupID, z.chvDepartmentID AS ChildDeptID
FROM dbo.User_Groups_Nesting x
INNER JOIN dbo.Ref_User_Groups y ON x.intParentID = y.intID
INNER JOIN dbo.Ref_User_Groups z ON x.intGroupID = z.intID
WHERE x.intParentID IN (SELECT a.GroupID FROM Structured_Groups a
					UNION SELECT b.ParentGroupID FROM Structured_Groups b)
OR x.intGroupID IN (SELECT a.GroupID FROM Structured_Groups a
				UNION SELECT b.ParentGroupID FROM Structured_Groups b)
ORDER BY x.intParentID









--5/9/2012
SELECT psjv.EMPLID, psjv.EMPL_RCD, psj2.DEPTID, psjc2.DESCRSHORT AS TITLE_ABBRV, psjc2.DESCR AS TITLE, psp2.DESCR AS WORKING_TITLE,
   NULL AS TITLE_GRP_ID_CODE, psj2.JOBCODE, NULL AS BUSINESS_UNIT, NULL AS "ORGANIZATION", NULL AS FUND, NULL AS "ACCOUNT",
   psjc2.JOB_FUNCTION AS "FUNCTION", NULL AS "PROJECT", NULL AS "PROGRAM", NULL AS "USER_DEFINED", NULL AS BUDGET_YEAR, NULL AS PRIM_APPT_CODE,
   CAST(NULL AS INTEGER) AS APPT_PERCENT, NULL AS APPT_SEQ_CODE, NULL AS SUMMER1_SERVICE, NULL AS WINTER_SERVICE, NULL AS AUTUMN_SERVICE,
   NULL AS SPRING_SERVICE, NULL AS SUMMER2_SERVICE, CAST(NULL AS DATETIME) AS OSU_LEAVE_START_DATE, psj2.ASGN_END_DT AS APPT_END_DATE, psp2.OS_APPT_LENGTH AS APPT_END_LENGTH,
   psj2.ASGN_START_DT AS APPT_START_DT,
   CAST(NULL AS DATETIME) AS DW_CHANGE_DATE, NULL AS DW_CHANGE_CODE, NULL AS SAL_ADMIN_PLAN
FROM (
   SELECT psji.EFFDT, psji.EMPLID, psji.EMPL_RCD, MAX(pst.EFFSEQ) AS EFFSEQ
   FROM (SELECT MAX(EFFDT) AS EFFDT, EMPLID, EMPL_RCD 
         FROM ps_new.PS_JOB
         GROUP BY EMPLID, EMPL_RCD) psji
   INNER JOIN ps_new.PS_JOB pst ON psji.EFFDT = pst.EFFDT AND psji.EMPLID = pst.EMPLID AND psji.EMPL_RCD = pst.EMPL_RCD
   GROUP BY psji.EFFDT, psji.EMPLID, psji.EMPL_RCD
) psjv
INNER JOIN ps_new.PS_JOB psj2 ON psjv.EFFDT = psj2.EFFDT AND psjv.EMPLID = psj2.EMPLID AND psjv.EMPL_RCD = psj2.EMPL_RCD AND psjv.EFFSEQ = psj2.EFFSEQ
INNER JOIN (
   SELECT MAX(psjci.EFFDT) AS EFFDT, psjci.SETID, psjci.JOBCODE
   FROM ps_new.PS_JOBCODE_TBL psjci
   GROUP BY psjci.SETID, psjci.JOBCODE
) psjcv ON psj2.JOBCODE = psjcv.JOBCODE
INNER JOIN ps_new.PS_JOBCODE_TBL psjc2 ON psjcv.JOBCODE = psjc2.JOBCODE AND psjcv.EFFDT = psjc2.EFFDT AND psjcv.SETID = psjc2.SETID
INNER JOIN (
   SELECT MAX(pspi.EFFDT) AS EFFDT, pspi.POSITION_NBR
   FROM ps_new.PS_POSITION_DATA pspi
   GROUP BY pspi.POSITION_NBR
) pspv ON psj2.POSITION_NBR = pspv.POSITION_NBR
INNER JOIN ps_new.PS_POSITION_DATA psp2 ON pspv.POSITION_NBR = psp2.POSITION_NBR AND pspv.EFFDT = psp2.EFFDT
WHERE psj2.EMPL_STATUS = 'A'