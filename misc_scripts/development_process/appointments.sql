      SELECT b.user_id, a.empl_rcd, a.department_id, a.title_abbrv, a.title, a.working_title, a.title_grp_id_code, 
          a.jobcode, a.business_unit, a.organization, a.fund, a.account, a."function", 
          a.project, a.program, a.user_defined, a.budget_year, a.prim_appt_code, 
          a.appt_percent, a.appt_seq_code, a.summer1_service, a.winter_service, 
          a.autumn_service, a.spring_service, a.summer2_service, a.osu_leave_start_date, 
          a.appt_start_date, a.appt_end_date, a.appt_end_length, a.dw_change_date, a.dw_change_code,
          a.sal_admin_plan
     FROM peoplesoft.ps_user_appointments a
     INNER JOIN kmdata.user_identifiers b ON a.emplid = b.emplid;




      SELECT b.user_id, a.empl_rcd
      FROM peoplesoft.ps_user_appointments a
      INNER JOIN kmdata.user_identifiers b ON a.emplid = b.emplid
      WHERE b.user_id = ua.user_id
      AND a.empl_rcd = ua.rcd_num



      SELECT COUNT(*) INTO v_MatchCount
        FROM kmdata.user_appointments
       WHERE user_id = lc_Curr.user_id
         AND rcd_num = lc_Curr.empl_rcd;


-- new appointments (to be inserted)
SELECT psua.emplid, psua.empl_rcd
  FROM peoplesoft.ps_user_appointments psua
EXCEPT
SELECT ui.emplid, ua.rcd_num AS empl_rcd
  FROM kmdata.user_appointments ua
  INNER JOIN kmdata.user_identifiers ui ON ua.user_id = ui.user_id;

-- deleted appointments (not 100% for positions) -- we may already have this working in current procedure
SELECT ui.emplid, ua.rcd_num AS empl_rcd
  FROM kmdata.user_appointments ua
  INNER JOIN kmdata.user_identifiers ui ON ua.user_id = ui.user_id
EXCEPT
SELECT psua.emplid, psua.empl_rcd
  FROM peoplesoft.ps_user_appointments psua;

-- same appointments (to be updated)
SELECT psua.emplid, psua.empl_rcd
  FROM peoplesoft.ps_user_appointments psua
  INNER JOIN kmdata.user_identifiers ui ON psua.emplid = ui.emplid
  INNER JOIN kmdata.user_appointments ua ON ui.user_id = ua.user_id;




