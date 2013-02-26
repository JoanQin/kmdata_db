CREATE OR REPLACE FUNCTION kmdata.import_courses_from_sid (
) RETURNS VARCHAR AS $$
DECLARE

   v_UpdateCursor CURSOR FOR
      SELECT c.id,
         t.course_title_long AS course_name, t.descr AS course_name_abbrev, 1 AS active, t.descrlong AS description,
         t.crse_repeatable AS repeatable, t.grading_basis, t.units_acad_prog,
         c.course_name AS curr_course_name, c.course_name_abbrev AS curr_course_name_abbrev, c.active AS curr_active, c.description AS curr_description,
         c.repeatable AS curr_repeatable, c.grading_basis AS curr_grading_basis, c.units_acad_prog AS curr_units_acad_prog
      FROM kmdata.courses c
      INNER JOIN sid.ps_crse_catalog t ON c.ps_course_id = t.crse_id;
   
   v_InsertCursor CURSOR FOR
      SELECT chgcrse.crse_id AS ps_course_id, a.course_title_long AS course_name, a.descr AS course_name_abbrev, 1 AS active, 
         a.descrlong AS description, a.crse_repeatable AS repeatable, a.grading_basis, a.units_acad_prog
      FROM
      (
         SELECT t.crse_id
         FROM sid.ps_crse_catalog t
         EXCEPT
         SELECT x.ps_course_id AS crse_id
         FROM kmdata.courses x
      ) chgcrse
      INNER JOIN sid.ps_crse_catalog a ON chgcrse.crse_id = a.crse_id;
      
   v_CoursesUpdated INTEGER;
   v_CoursesInserted INTEGER;
   v_ReturnString VARCHAR(4000);
   
BEGIN

   v_CoursesUpdated := 0;
   v_CoursesInserted := 0;
   v_ReturnString := '';
   
   -- Step 1: set inactive current courses that are no longer here
   UPDATE kmdata.courses co
   SET active = 0
   WHERE NOT EXISTS (
      SELECT pcci.crse_id
      FROM sid.ps_crse_catalog pcci
      WHERE pcci.crse_id = co.ps_course_id
   );

   -- Step 2: update
   FOR v_updCourse IN v_UpdateCursor LOOP

      -- if this has changed then update
      IF COALESCE(CAST(v_updCourse.active AS VARCHAR),'') != COALESCE(CAST(v_updCourse.curr_active AS VARCHAR),'')
         OR COALESCE(v_updCourse.course_name,'') != COALESCE(v_updCourse.curr_course_name,'')
         OR COALESCE(v_updCourse.course_name_abbrev,'') != COALESCE(v_updCourse.curr_course_name_abbrev,'')
         OR COALESCE(v_updCourse.description,'') != COALESCE(v_updCourse.curr_description,'')
         OR COALESCE(v_updCourse.repeatable,'') != COALESCE(v_updCourse.curr_repeatable,'')
         OR COALESCE(v_updCourse.grading_basis,'') != COALESCE(v_updCourse.curr_grading_basis,'')
         OR COALESCE(CAST(v_updCourse.units_acad_prog AS VARCHAR),'') != COALESCE(CAST(v_updCourse.curr_units_acad_prog AS VARCHAR),'')
      THEN
      
         -- update the record
         UPDATE kmdata.courses
            SET active = v_updCourse.active,
                course_name = v_updCourse.course_name,
                course_name_abbrev = v_updCourse.course_name_abbrev,
                description = v_updCourse.description,
                repeatable = v_updCourse.repeatable,
                grading_basis = v_updCourse.grading_basis,
                units_acad_prog = v_updCourse.units_acad_prog
          WHERE id = v_updCourse.id;

         v_CoursesUpdated := v_CoursesUpdated + 1;
         
      END IF;
            
   END LOOP;

   -- Step 3: insert
   FOR v_insCourse IN v_InsertCursor LOOP
      
      -- insert if not already there
      INSERT INTO kmdata.courses (
         ps_course_id, course_name, course_name_abbrev, active, description, 
         repeatable, grading_basis, units_acad_prog, resource_id)
      VALUES (
         v_insCourse.ps_course_id, v_insCourse.course_name, v_insCourse.course_name_abbrev, v_insCourse.active, v_insCourse.description, 
         v_insCourse.repeatable, v_insCourse.grading_basis, v_insCourse.units_acad_prog, kmdata.add_new_resource('sid', 'courses'));

      v_CoursesInserted := v_CoursesInserted + 1;

   END LOOP;


   v_ReturnString := 'Courses import completed. ' || CAST(v_CoursesUpdated AS VARCHAR) || ' courses updated and ' || CAST(v_CoursesInserted AS VARCHAR) || ' courses inserted.';

   RETURN v_ReturnString;
END;
$$ LANGUAGE plpgsql;
