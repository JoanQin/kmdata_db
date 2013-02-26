CREATE OR REPLACE FUNCTION peoplesoft.update_colleges (
) RETURNS VARCHAR AS $$
DECLARE
   --v_ReturnValue BIGINT;
   v_MatchCount BIGINT;
   v_ResourceID BIGINT;

   v_CollegesUpdated INTEGER;
   v_CollegesInserted INTEGER;
   v_ReturnString VARCHAR(4000);
   
   CUR_Colleges CURSOR FOR
      SELECT institution, acad_group, effdt, eff_status, descr, descrshort, stdnt_spec_perm, auto_enrl_waitlist
        FROM peoplesoft.ps_acad_group_tbl;

   /*
   v_UpdateCursor CURSOR FOR
      SELECT a.institution, a.acad_group, a.effdt,
         a.eff_status, a.descr, a.descrshort, a.stdnt_spec_perm, a.autho_enrl_waitlist,
         b.eff_status AS curr_eff_status, b.descr AS curr_descr, b.descrshort AS curr_descrshort, 
         b.stdnt_spec_perm AS curr_stdnt_spec_perm, b.auto_enrl_waitlist AS curr_auto_enrl_waitlist
      FROM peoplesoft.ps_acad_group_tbl a
      INNER JOIN kmdata.colleges b ON a.fiscalnumber = b.dept_code;
   
   v_InsertCursor CURSOR FOR
      SELECT chgdept.dept_code, a.abbreviation, a.odsdepartmentnumber AS ods_department_number, a.abbreviation AS department_name
      FROM
      (
         SELECT ai.fiscalnumber AS dept_code
           FROM sid.osu_department ai
         EXCEPT
         SELECT x.dept_code
           FROM kmdata.acad_departments x
      ) chgdept
      INNER JOIN sid.osu_department a ON chgdept.dept_code = a.fiscalnumber;
      */
BEGIN
   --v_ReturnValue := 0;
   v_MatchCount := 0;
   v_CollegesUpdated := 0;
   v_CollegesInserted := 0;
   v_ReturnString := '';

   -- loop over the departments and insert and update as appropriate
   FOR currCollege IN CUR_Colleges LOOP

      -- get the count of the current item
      SELECT COUNT(*) INTO v_MatchCount
        FROM kmdata.colleges a
       WHERE a.college_name = currCollege.descr;

      IF v_MatchCount = 0 THEN
      
         -- insert a new college
         INSERT INTO kmdata.colleges
            (id, acad_group, college_name, abbreviation, resource_id)
         VALUES
            (nextval('kmdata.colleges_id_seq'), currCollege.acad_group, currCollege.descr,  
            currCollege.descrshort, kmdata.add_new_resource('peoplesoft', 'colleges'));

         v_CollegesInserted := v_CollegesInserted + 1;
         
      ELSE
      
         -- update the college
         UPDATE kmdata.colleges
            SET abbreviation = currCollege.descrshort
          WHERE college_name = currCollege.descr;

         v_CollegesUpdated := v_CollegesUpdated + 1;
         
      END IF;
      
   END LOOP;

   v_ReturnString := 'Colleges import completed. ' || CAST(v_CollegesUpdated AS VARCHAR) || ' colleges updated and ' || CAST(v_CollegesInserted AS VARCHAR) || ' colleges inserted.';
   
   RETURN v_ReturnString;
END;
$$ LANGUAGE plpgsql;
