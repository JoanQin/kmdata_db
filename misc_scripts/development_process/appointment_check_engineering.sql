select * from kmdata.user_identifiers where inst_username like 'morrow-jones.%';
select * from kmdata.users where id in (916136,384022);

-- "rojas-teran.1"
select * from ror.vw_TechnicalReport where person_id = 496188 order by title, author_list;

-- "morrow-jones.1"
select * from ror.vw_TechnicalReport where person_id = 384022 order by title, author_list;

select * from kmdata.user_identifiers where inst_username = 'gustafson.4';

select * from kmdata.user_identifiers where inst_username = 'smith.131';

-- gustafson.4
select b.deptid, b.dept_name, a.title, a.working_title, a.rcd_num, a.sal_admin_plan, a.*
from ror.vw_PersonAppointments a
inner join ror.vw_Departments b on a.department_id = b.deptid
where a.person_id = 877004
order by a.rcd_num;

SELECT b.deptid, b.dept_name, a.title, a.working_title, a.rcd_num, a.sal_admin_plan, a.*
FROM kmdata.user_appointments a
INNER JOIN kmdata.departments b ON a.department_id = b.deptid
WHERE a.user_id = 916133
ORDER BY a.rcd_num;
