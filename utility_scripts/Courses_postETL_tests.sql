select reg_cal_yr_num, reg_qtr_cd, count(*) from peoplesoft.courses_all group by reg_cal_yr_num, reg_qtr_cd order by 1 desc, 2 desc;

select distinct reg_qtr_cd, reg_cal_yr_num from peoplesoft.courses_all;



select ca.reg_cal_yr_num, ca.reg_qtr_desc, ca.crse_acad_dept_nam, ca.crse_num, psn."name", ca.instr_emplid, ca.total_section_enrollment
from peoplesoft.courses_all ca
inner join peoplesoft.ps_names psn on ca.instr_emplid = psn.emplid
where ca.instr_emplid = '200005181'
order by ca.reg_cal_yr_num desc, ca.reg_qtr_cd desc