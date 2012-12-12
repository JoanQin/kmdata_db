CREATE OR REPLACE FUNCTION kmdata.fix_duplicate_user_appointments (
) RETURNS BIGINT AS $$
DECLARE

   DupPositionsCursor CURSOR FOR
      SELECT user_id, department_id, title_abbrv, title, working_title, 
          title_grp_id_code, jobcode, business_unit, organization, fund, 
          account, "function", project, program, user_defined, budget_year, 
          prim_appt_code, appt_percent, appt_seq_code, summer1_service, 
          winter_service, autumn_service, spring_service, summer2_service, 
          osu_leave_start_date, appt_end_date, appt_end_length, dw_change_date, 
          dw_change_code
     FROM kmdata.user_appointments
     GROUP BY user_id, department_id, title_abbrv, title, working_title, 
          title_grp_id_code, jobcode, business_unit, organization, fund, 
          account, "function", project, program, user_defined, budget_year, 
          prim_appt_code, appt_percent, appt_seq_code, summer1_service, 
          winter_service, autumn_service, spring_service, summer2_service, 
          osu_leave_start_date, appt_end_date, appt_end_length, dw_change_date, 
          dw_change_code
     HAVING COUNT(*) > 1;

   v_ReturnValue INTEGER := 0;
BEGIN
   -- loop through the cursor
   FOR currPosition IN DupPositionsCursor LOOP

      -- delete the duplicate positions
      DELETE FROM kmdata.user_appointments
         WHERE user_id = currPosition.user_id
         AND department_id = currPosition.department_id
         AND title_abbrv = currPosition.title_abbrv
         AND title = currPosition.title
         AND working_title = currPosition.working_title
         AND title_grp_id_code = currPosition.title_grp_id_code
         AND jobcode = currPosition.jobcode
         AND (business_unit = currPosition.business_unit OR business_unit IS NULL)
         AND (organization = currPosition.organization OR organization IS NULL)
         AND (fund = currPosition.fund OR fund IS NULL)
         AND (account = currPosition.account OR account IS NULL)
         AND ("function" = currPosition."function" OR "function" IS NULL)
         AND (project = currPosition.project OR project IS NULL)
         AND (program = currPosition.program OR program IS NULL)
         AND (user_defined = currPosition.user_defined OR user_defined IS NULL)
         AND (budget_year = currPosition.budget_year OR budget_year IS NULL)
         AND (prim_appt_code = currPosition.prim_appt_code OR prim_appt_code IS NULL)
         AND (appt_percent = currPosition.appt_percent OR appt_percent IS NULL)
         AND (appt_seq_code = currPosition.appt_seq_code OR appt_seq_code IS NULL)
         AND (summer1_service = currPosition.summer1_service OR summer1_service IS NULL)
         AND (winter_service = currPosition.winter_service OR winter_service IS NULL)
         AND (autumn_service = currPosition.autumn_service OR autumn_service IS NULL)
         AND (spring_service = currPosition.spring_service OR spring_service IS NULL)
         AND (summer2_service = currPosition.summer2_service OR summer2_service IS NULL)
         AND (osu_leave_start_date = currPosition.osu_leave_start_date OR osu_leave_start_date IS NULL)
         AND (appt_end_date = currPosition.appt_end_date OR appt_end_date IS NULL)
         AND (appt_end_length = currPosition.appt_end_length OR appt_end_length IS NULL)
         AND (dw_change_date = currPosition.dw_change_date OR dw_change_date IS NULL)
         AND (dw_change_code = currPosition.dw_change_code OR dw_change_code IS NULL)
         AND id != (SELECT MIN(id) 
                    FROM kmdata.user_appointments 
                    WHERE user_id = currPosition.user_id
                    AND department_id = currPosition.department_id
                    AND title_abbrv = currPosition.title_abbrv
                    AND title = currPosition.title
                    AND working_title = currPosition.working_title
                    AND title_grp_id_code = currPosition.title_grp_id_code
                    AND jobcode = currPosition.jobcode
                    AND (business_unit = currPosition.business_unit OR business_unit IS NULL)
                    AND (organization = currPosition.organization OR organization IS NULL)
                    AND (fund = currPosition.fund OR fund IS NULL)
                    AND (account = currPosition.account OR account IS NULL)
                    AND ("function" = currPosition."function" OR "function" IS NULL)
                    AND (project = currPosition.project OR project IS NULL)
                    AND (program = currPosition.program OR program IS NULL)
                    AND (user_defined = currPosition.user_defined OR user_defined IS NULL)
                    AND (budget_year = currPosition.budget_year OR budget_year IS NULL)
                    AND (prim_appt_code = currPosition.prim_appt_code OR prim_appt_code IS NULL)
                    AND (appt_percent = currPosition.appt_percent OR appt_percent IS NULL)
                    AND (appt_seq_code = currPosition.appt_seq_code OR appt_seq_code IS NULL)
                    AND (summer1_service = currPosition.summer1_service OR summer1_service IS NULL)
                    AND (winter_service = currPosition.winter_service OR winter_service IS NULL)
                    AND (autumn_service = currPosition.autumn_service OR autumn_service IS NULL)
                    AND (spring_service = currPosition.spring_service OR spring_service IS NULL)
                    AND (summer2_service = currPosition.summer2_service OR summer2_service IS NULL)
                    AND (osu_leave_start_date = currPosition.osu_leave_start_date OR osu_leave_start_date IS NULL)
                    AND (appt_end_date = currPosition.appt_end_date OR appt_end_date IS NULL)
                    AND (appt_end_length = currPosition.appt_end_length OR appt_end_length IS NULL)
                    AND (dw_change_date = currPosition.dw_change_date OR dw_change_date IS NULL)
                    AND (dw_change_code = currPosition.dw_change_code OR dw_change_code IS NULL)
         );
      
   END LOOP;
   
   -- return value
   RETURN v_ReturnValue;
END;
$$ LANGUAGE plpgsql;
