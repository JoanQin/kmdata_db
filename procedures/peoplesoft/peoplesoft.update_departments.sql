CREATE OR REPLACE FUNCTION peoplesoft.update_departments (
) RETURNS VARCHAR AS $$
DECLARE
   --v_ReturnValue BIGINT;
   v_ResourceID BIGINT;

   v_DepartmentsUpdated INTEGER;
   v_DepartmentsInserted INTEGER;
   v_ReturnString VARCHAR(4000);
   
   /*
   deptsCursor CURSOR FOR
      SELECT deptid, dept_name, manager_id, budget_deptid, "location"
        FROM peoplesoft.kmdata_dept_vw;
   */

   v_UpdateCursor CURSOR FOR
      SELECT a.deptid, a.dept_name, a.manager_id, a.budget_deptid, a."location",
         b.dept_name AS curr_dept_name, b.manager_emplid AS curr_manager_id, b.budget_deptid AS curr_budget_deptid, b."location" AS curr_location
      FROM peoplesoft.kmdata_dept_vw a
      INNER JOIN kmdata.departments b ON a.deptid = b.deptid;
   
   v_InsertCursor CURSOR FOR
      SELECT a.deptid, a.dept_name, a.manager_id, a.budget_deptid, a."location"
      FROM (
         SELECT deptid
           FROM peoplesoft.kmdata_dept_vw
         EXCEPT
         SELECT deptid
           FROM kmdata.departments
      ) newdept
      INNER JOIN peoplesoft.kmdata_dept_vw a ON newdept.deptid = a.deptid;

BEGIN
   --v_ReturnValue := 0;
   v_DepartmentsUpdated := 0;
   v_DepartmentsInserted := 0;
   v_ReturnString := '';

   -- update existing departments
   FOR v_updDept IN v_UpdateCursor LOOP

      IF v_updDept.dept_name != v_updDept.curr_dept_name
         OR v_updDept.manager_id != v_updDept.curr_manager_id
         OR v_updDept.budget_deptid != v_updDept.curr_budget_deptid
         OR v_updDept.location != v_updDept.curr_location
      THEN

         -- update the department
         UPDATE kmdata.departments
            SET dept_name = v_updDept.dept_name,
                manager_emplid = v_updDept.manager_id, 
                budget_deptid = v_updDept.budget_deptid, 
                "location" = v_updDept.location, 
                updated_at = current_timestamp
          WHERE deptid = v_updDept.deptid;

          v_DepartmentsUpdated := v_DepartmentsUpdated + 1;
          
      END IF;
      
   END LOOP;


   -- insert new departments
   FOR v_insDept IN v_InsertCursor LOOP

      -- insert a new department
      INSERT INTO kmdata.departments
         (id, deptid, dept_name, manager_emplid, budget_deptid, 
          "location", created_at, updated_at, resource_id)
      VALUES
         (nextval('kmdata.departments_id_seq'), v_insDept.deptid, v_insDept.dept_name, v_insDept.manager_id, v_insDept.budget_deptid,
          v_insDept.location, current_timestamp, current_timestamp, kmdata.add_new_resource('peoplesoft', 'departments'));

      v_DepartmentsInserted := v_DepartmentsInserted + 1;
      
   END LOOP;
   
   v_ReturnString := 'Departments import completed. ' || CAST(v_DepartmentsUpdated AS VARCHAR) || ' departments updated and ' || CAST(v_DepartmentsInserted AS VARCHAR) || ' departments inserted.';
   
   RETURN v_ReturnString;
END;
$$ LANGUAGE plpgsql;
