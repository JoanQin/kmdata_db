CREATE OR REPLACE FUNCTION kmdata.import_acad_departments_from_sid (
) RETURNS VARCHAR AS $$
DECLARE
   --v_CampusID BIGINT;

   v_UpdateCursor CURSOR FOR
      SELECT DISTINCT b.id, a.abbreviation, a.fiscalnumber AS dept_code, b.college_id, a.odsdepartmentnumber AS ods_department_number,
         a.abbreviation AS department_name, 
         b.department_name AS curr_department_name
      FROM sid.osu_department a
      INNER JOIN kmdata.acad_departments b ON a.fiscalnumber = b.dept_code AND a.abbreviation = b.abbreviation AND a.odsDepartmentNumber = b.ods_department_number
      INNER JOIN sid.matvw_unit_association c ON c.unit_association_type_name = 'College Departments' AND a.id = c.childunitid
      INNER JOIN sid.osu_college d ON c.parentunitid = d.id
      INNER JOIN kmdata.colleges e ON d.abbreviation = e.acad_group
      WHERE a.defunct = 0;
   
   v_InsertCursor CURSOR FOR
      SELECT DISTINCT chgdept.dept_code, a.abbreviation, a.odsdepartmentnumber AS ods_department_number, a.abbreviation AS department_name, d.id AS college_id
      FROM
      (
         SELECT ai.fiscalnumber AS dept_code
           FROM sid.osu_department ai
         WHERE ai.defunct = 0
         EXCEPT
         SELECT x.dept_code
           FROM kmdata.acad_departments x
      ) chgdept
      INNER JOIN sid.osu_department a ON chgdept.dept_code = a.fiscalnumber
      INNER JOIN sid.matvw_unit_association b ON b.unit_association_type_name = 'College Departments' AND a.id = b.childunitid
      INNER JOIN sid.osu_college c ON b.parentunitid = c.id
      INNER JOIN kmdata.colleges d ON c.abbreviation = d.acad_group
      WHERE a.defunct = 0;
      
   v_AcadDeptsUpdated INTEGER;
   v_AcadDeptsInserted INTEGER;
   v_ReturnString VARCHAR(4000);
   
BEGIN
   --SELECT id
   --INTO v_CampusID
   --FROM kmdata.campuses
   --WHERE campus_name = 'Columbus';

   v_AcadDeptsUpdated := 0;
   v_AcadDeptsInserted := 0;
   v_ReturnString := '';
   
   -- Step 1: delete current Acad Departments that are no longer here
   -- Note: in KMData we don't want to purge departments, in future flag as inactive
   --DELETE FROM kmdata.acad_departments bd
   --WHERE NOT EXISTS (
   --   SELECT a.fiscalnumber
   --   FROM sid.osu_department a
   --   WHERE a.fiscalnumber = bd.dept_code
   --);

   -- Step 2: update
   FOR v_updAcadDept IN v_UpdateCursor LOOP

      -- if this has changed then update
      IF v_updAcadDept.department_name != v_updAcadDept.curr_department_name
      THEN
      
         -- update the record
         UPDATE kmdata.acad_departments
            SET department_name = v_updAcadDept.department_name
          WHERE id = v_updAcadDept.id;

         v_AcadDeptsUpdated := v_AcadDeptsUpdated + 1;
         
      END IF;
            
   END LOOP;

   -- Step 3: insert
   FOR v_insAcadDept IN v_InsertCursor LOOP
      
      -- insert if not already there
      INSERT INTO kmdata.acad_departments (
	 department_name, college_id, abbreviation, dept_code, ods_department_number, resource_id)
      VALUES (
         v_insAcadDept.department_name, v_insAcadDept.college_id, v_insAcadDept.abbreviation, v_insAcadDept.dept_code, v_insAcadDept.ods_department_number, kmdata.add_new_resource('sid', 'acad_departments'));

      v_AcadDeptsInserted := v_AcadDeptsInserted + 1;

   END LOOP;


   v_ReturnString := 'Acad departments import completed. ' || CAST(v_AcadDeptsUpdated AS VARCHAR) || ' acad departments updated and ' || CAST(v_AcadDeptsInserted AS VARCHAR) || ' acad departments inserted.';

   RETURN v_ReturnString;
END;
$$ LANGUAGE plpgsql;
