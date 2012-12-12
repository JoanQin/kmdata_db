CREATE OR REPLACE FUNCTION kmdata.import_appointments_from_ps (
) RETURNS VARCHAR AS $$
DECLARE

   /*
   PS_appts_cursor CURSOR FOR
      SELECT b.user_id, a.empl_rcd, a.department_id, a.title_abbrv, a.title, a.working_title, a.title_grp_id_code, 
          a.jobcode, a.business_unit, a.organization, a.fund, a.account, a."function", 
          a.project, a.program, a.user_defined, a.budget_year, a.prim_appt_code, 
          a.appt_percent, a.appt_seq_code, a.summer1_service, a.winter_service, 
          a.autumn_service, a.spring_service, a.summer2_service, a.osu_leave_start_date, 
          a.appt_start_date, a.appt_end_date, a.appt_end_length, a.dw_change_date, a.dw_change_code,
          a.sal_admin_plan
     FROM peoplesoft.ps_user_appointments a
     INNER JOIN kmdata.user_identifiers b ON a.emplid = b.emplid;
   */

   v_ApptsUpdated INTEGER;
   v_ApptsInserted INTEGER;
   v_ReturnString VARCHAR(4000);
   
   v_UpdateCursor CURSOR FOR
      SELECT b.user_id, a.empl_rcd, a.department_id, a.title_abbrv, a.title, a.working_title, a.title_grp_id_code, 
          a.jobcode, a.business_unit, a.organization, a.fund, a.account, a."function", 
          a.project, a.program, a.user_defined, a.budget_year, a.prim_appt_code, 
          a.appt_percent, a.appt_seq_code, a.summer1_service, a.winter_service, 
          a.autumn_service, a.spring_service, a.summer2_service, a.osu_leave_start_date, 
          a.appt_start_date, a.appt_end_date, a.appt_end_length, a.dw_change_date, a.dw_change_code,
          a.sal_admin_plan, a.building_code,
          d.department_id AS curr_department_id, d.title_abbrv AS curr_title_abbrv, d.title AS curr_title, d.working_title AS curr_working_title,
          d.title_grp_id_code AS curr_title_grp_id_code, d.jobcode AS curr_jobcode, d.business_unit AS curr_business_unit,
          d.organization AS curr_organization, d.fund AS curr_fund, d.account AS curr_account, d."function" AS curr_function,
          d.project AS curr_project, d.program AS curr_program, d.user_defined AS curr_user_defined, d.budget_year AS curr_budget_year,
          d.prim_appt_code AS curr_prim_appt_code, d.appt_percent AS curr_appt_percent, d.appt_seq_code AS curr_appt_seq_code,
          d.summer1_service AS curr_summer1_service, d.winter_service AS curr_winter_service, d.autumn_service AS curr_autumn_service,
          d.spring_service AS curr_spring_service, d.summer2_service AS curr_summer2_service, d.osu_leave_start_date AS curr_osu_leave_start_date,
          d.appt_start_date AS curr_appt_start_date, d.appt_end_date AS curr_appt_end_date, d.appt_end_length AS curr_appt_end_length,
          d.dw_change_date AS curr_dw_change_date, d.dw_change_code AS curr_dw_change_code, d.sal_admin_plan AS curr_sal_admin_plan,
          d.building_code AS curr_building_code
      FROM peoplesoft.ps_user_appointments a
      INNER JOIN kmdata.user_identifiers b ON a.emplid = b.emplid
      INNER JOIN kmdata.users c ON b.user_id = c.id
      INNER JOIN kmdata.user_appointments d ON b.user_id = d.user_id AND a.empl_rcd = d.rcd_num;

   v_InsertCursor CURSOR FOR
      SELECT b.user_id, a.empl_rcd, a.department_id, a.title_abbrv, a.title, a.working_title, a.title_grp_id_code, 
          a.jobcode, a.business_unit, a.organization, a.fund, a.account, a."function", 
          a.project, a.program, a.user_defined, a.budget_year, a.prim_appt_code, 
          a.appt_percent, a.appt_seq_code, a.summer1_service, a.winter_service, 
          a.autumn_service, a.spring_service, a.summer2_service, a.osu_leave_start_date, 
          a.appt_start_date, a.appt_end_date, a.appt_end_length, a.dw_change_date, a.dw_change_code,
          a.sal_admin_plan, a.building_code
      FROM
      (
         SELECT bi.user_id, ai.empl_rcd
           FROM peoplesoft.ps_user_appointments ai
           INNER JOIN kmdata.user_identifiers bi ON ai.emplid = bi.emplid
         EXCEPT
         SELECT y.user_id, x.rcd_num AS empl_rcd
           FROM kmdata.user_appointments x
           INNER JOIN kmdata.user_identifiers y ON x.user_id = y.user_id
      ) chgappt
      INNER JOIN kmdata.user_identifiers b ON chgappt.user_id = b.user_id
      INNER JOIN kmdata.users c ON b.user_id = c.id
      INNER JOIN peoplesoft.ps_user_appointments a ON b.emplid = a.emplid AND chgappt.empl_rcd = a.empl_rcd;

BEGIN

   v_ApptsUpdated := 0;
   v_ApptsInserted := 0;
   v_ReturnString := '';
   
   -- Step 1: delete current positions that are no longer here
   DELETE FROM kmdata.user_appointments ua
   WHERE NOT EXISTS (
      SELECT b.user_id, a.empl_rcd
      FROM peoplesoft.ps_user_appointments a
      INNER JOIN kmdata.user_identifiers b ON a.emplid = b.emplid
      WHERE b.user_id = ua.user_id
      AND a.empl_rcd = ua.rcd_num
   );

   -- Step 2: update
   FOR v_updAppt IN v_UpdateCursor LOOP

      -- if this has changed then update
      IF v_updAppt.department_id != v_updAppt.curr_department_id
         OR v_updAppt.title_abbrv != v_updAppt.curr_title_abbrv
         OR v_updAppt.title != v_updAppt.curr_title
         OR v_updAppt.working_title != v_updAppt.curr_working_title
         OR v_updAppt.title_grp_id_code != v_updAppt.curr_title_grp_id_code
         OR v_updAppt.jobcode != v_updAppt.curr_jobcode
         OR v_updAppt.business_unit != v_updAppt.curr_business_unit
         OR v_updAppt.organization != v_updAppt.curr_organization
         OR v_updAppt.fund != v_updAppt.curr_fund
         OR v_updAppt.account != v_updAppt.curr_account
         OR v_updAppt.function != v_updAppt.curr_function
         OR v_updAppt.project != v_updAppt.curr_project
         OR v_updAppt.program != v_updAppt.curr_program
         OR v_updAppt.user_defined != v_updAppt.curr_user_defined
         OR v_updAppt.budget_year != v_updAppt.curr_budget_year
         OR v_updAppt.prim_appt_code != v_updAppt.curr_prim_appt_code
         OR v_updAppt.appt_percent != v_updAppt.curr_appt_percent
         OR v_updAppt.appt_seq_code != v_updAppt.curr_appt_seq_code
         OR v_updAppt.summer1_service != v_updAppt.curr_summer1_service
         OR v_updAppt.winter_service != v_updAppt.curr_winter_service
         OR v_updAppt.autumn_service != v_updAppt.curr_autumn_service
         OR v_updAppt.spring_service != v_updAppt.curr_spring_service
         OR v_updAppt.summer2_service != v_updAppt.curr_summer2_service
         OR v_updAppt.osu_leave_start_date != v_updAppt.curr_osu_leave_start_date
         OR v_updAppt.appt_start_date != v_updAppt.curr_appt_start_date
         OR v_updAppt.appt_end_date != v_updAppt.curr_appt_end_date
         OR v_updAppt.appt_end_length != v_updAppt.curr_appt_end_length
         OR v_updAppt.dw_change_date != v_updAppt.curr_dw_change_date
         OR v_updAppt.dw_change_code != v_updAppt.curr_dw_change_code
         OR v_updAppt.sal_admin_plan != v_updAppt.curr_sal_admin_plan
         OR COALESCE(v_updAppt.building_code,'') != COALESCE(v_updAppt.curr_building_code,'')
      THEN
      
         -- update the record
         UPDATE kmdata.user_appointments
            SET department_id = v_updAppt.department_id, 
                title_abbrv = v_updAppt.title_abbrv, 
                title = v_updAppt.title, 
                working_title = v_updAppt.working_title, 
                title_grp_id_code = v_updAppt.title_grp_id_code, 
	        jobcode = v_updAppt.jobcode, 
	        business_unit = v_updAppt.business_unit, 
	        organization = v_updAppt.organization, 
	        fund = v_updAppt.fund, 
	        account = v_updAppt.account, 
	        "function" = v_updAppt.function, 
   	        project = v_updAppt.project, 
   	        program = v_updAppt.program, 
   	        user_defined = v_updAppt.user_defined, 
   	        budget_year = v_updAppt.budget_year, 
   	        prim_appt_code = v_updAppt.prim_appt_code, 
	        appt_percent = v_updAppt.appt_percent, 
	        appt_seq_code = v_updAppt.appt_seq_code, 
	        summer1_service = v_updAppt.summer1_service, 
	        winter_service = v_updAppt.winter_service, 
	        autumn_service = v_updAppt.autumn_service, 
	        spring_service = v_updAppt.spring_service, 
	        summer2_service = v_updAppt.summer2_service, 
	        osu_leave_start_date = v_updAppt.osu_leave_start_date, 
	        appt_start_date = v_updAppt.appt_start_date,
	        appt_end_date = v_updAppt.appt_end_date, 
	        appt_end_length = v_updAppt.appt_end_length, 
	        dw_change_date = v_updAppt.dw_change_date, 
	        dw_change_code = v_updAppt.dw_change_code, 
	        sal_admin_plan = v_updAppt.sal_admin_plan,
	        building_code = v_updAppt.building_code,
	        updated_at = current_timestamp
          WHERE user_id = v_updAppt.user_id
            AND rcd_num = v_updAppt.empl_rcd;

         v_ApptsUpdated := v_ApptsUpdated + 1;
         
      END IF;
            
   END LOOP;

   -- Step 3: insert
   FOR v_insAppt IN v_InsertCursor LOOP
      
      -- insert if not already there
      INSERT INTO kmdata.user_appointments (
	       user_id, rcd_num, department_id, title_abbrv, title, working_title, title_grp_id_code, 
	       jobcode, business_unit, organization, fund, account, "function", 
   	       project, program, user_defined, budget_year, prim_appt_code, 
	       appt_percent, appt_seq_code, summer1_service, winter_service, 
	       autumn_service, spring_service, summer2_service, osu_leave_start_date, 
	       appt_start_date, appt_end_date, appt_end_length, dw_change_date, dw_change_code, 
	       sal_admin_plan, building_code,
	       resource_id, created_at, updated_at)
      VALUES (
         v_insAppt.user_id, v_insAppt.empl_rcd, v_insAppt.department_id, v_insAppt.title_abbrv, v_insAppt.title, v_insAppt.working_title, v_insAppt.title_grp_id_code,
         v_insAppt.jobcode, v_insAppt.business_unit, v_insAppt.organization, v_insAppt.fund, v_insAppt.account, v_insAppt.function,
         v_insAppt.project, v_insAppt.program, v_insAppt.user_defined, v_insAppt.budget_year, v_insAppt.prim_appt_code,
         v_insAppt.appt_percent, v_insAppt.appt_seq_code, v_insAppt.summer1_service, v_insAppt.winter_service,
         v_insAppt.autumn_service, v_insAppt.spring_service, v_insAppt.summer2_service, v_insAppt.osu_leave_start_date,
         v_insAppt.appt_start_date, v_insAppt.appt_end_date, v_insAppt.appt_end_length, v_insAppt.dw_change_date, v_insAppt.dw_change_code,
         v_insAppt.sal_admin_plan, v_insAppt.building_code,
         kmdata.add_new_resource('peoplesoft', 'user_appointments'), current_timestamp, current_timestamp);
            
      v_ApptsInserted := v_ApptsInserted + 1;
      
   END LOOP;

   v_ReturnString := 'Appointments import completed. ' || CAST(v_ApptsUpdated AS VARCHAR) || ' appointments updated and ' || CAST(v_ApptsInserted AS VARCHAR) || ' appointments inserted.';


   RETURN v_ReturnString;
END;
$$ LANGUAGE plpgsql;
