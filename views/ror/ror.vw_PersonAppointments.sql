CREATE OR REPLACE VIEW ror.vw_PersonAppointments AS
SELECT id, user_id AS person_id, department_id, title_abbrv, title, working_title, 
       title_grp_id_code, jobcode, business_unit, organization, fund, 
       account, function, project, program, user_defined AS person_defined, budget_year, 
       prim_appt_code, appt_percent, appt_seq_code, summer1_service, 
       winter_service, autumn_service, spring_service, summer2_service, 
       osu_leave_start_date, appt_end_date, appt_end_length, dw_change_date, 
       dw_change_code, created_at, updated_at, rcd_num, 
       sal_admin_plan, building_code
  FROM kmdata.user_appointments;
-- resource_id, 


ALTER TABLE ror.vw_personappointments
  OWNER TO kmdata;
GRANT ALL ON TABLE ror.vw_personappointments TO kmdata;
GRANT SELECT ON TABLE ror.vw_personappointments TO kmd_ror_app_user;
GRANT SELECT ON TABLE ror.vw_personappointments TO kmd_dev_riv_user;
--GRANT SELECT ON TABLE ror.vw_personappointments TO kmd_report_user;

