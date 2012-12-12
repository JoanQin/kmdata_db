CREATE OR REPLACE VIEW kmdata.vw_UserAppointments AS
SELECT id, user_id, department_id, title_abbrv, title, working_title, 
       title_grp_id_code, jobcode, business_unit, organization, fund, 
       account, function, project, program, user_defined, budget_year, 
       prim_appt_code, appt_percent, appt_seq_code, summer1_service, 
       winter_service, autumn_service, spring_service, summer2_service, 
       osu_leave_start_date, appt_end_date, appt_end_length, dw_change_date, 
       dw_change_code, resource_id, created_at, updated_at, rcd_num, 
       sal_admin_plan
  FROM kmdata.user_appointments;
