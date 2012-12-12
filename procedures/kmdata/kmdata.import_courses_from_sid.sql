CREATE OR REPLACE FUNCTION kmdata.import_courses_from_sid (
) RETURNS VARCHAR AS $$
DECLARE
   --v_CampusID BIGINT;

   v_UpdateCursor CURSOR FOR
      SELECT DISTINCT c.id, c.subject_id, c.course_number,
         a.course_title_long AS course_name, a.descr AS course_name_abbrev, 1 AS active, NULL AS description,
         c.course_name AS curr_course_name, c.course_name_abbrev AS curr_course_name_abbrev, c.active AS curr_active, c.description AS curr_description
      FROM kmdata.courses c
      INNER JOIN kmdata.subjects s ON c.subject_id = s.id
      INNER JOIN sid.osu_course a ON c.course_number = a.courseNumber AND s.subject_abbrev = a.departmentNumber;
      --INNER JOIN sid.osu_unit d ON a.id = d.id;
   
   v_InsertCursor CURSOR FOR
      SELECT DISTINCT s.id AS subject_id, chgcrse.course_number, a.course_title_long AS course_name, a.descr AS course_name_abbrev, --e.longTitle AS course_name,
         1 AS active, NULL AS description
      FROM
      (
         SELECT ai.departmentNumber AS subject_abbrev, ai.courseNumber AS course_number
           FROM sid.osu_course ai
         EXCEPT
         SELECT y.subject_abbrev, x.course_number
           FROM kmdata.courses x
           INNER JOIN kmdata.subjects y ON x.subject_id = y.id
      ) chgcrse
      INNER JOIN sid.osu_course a ON chgcrse.subject_abbrev = a.departmentNumber AND chgcrse.course_number = a.courseNumber
      --INNER JOIN sid.matvw_unit_association b ON b.unit_association_type_name = 'Department Courses' AND a.id = b.childunitid
      --INNER JOIN sid.osu_department c ON b.parentunitid = c.id
      INNER JOIN kmdata.subjects s ON chgcrse.subject_abbrev = s.subject_abbrev; -- AND c.abbreviation = d.abbreviation AND c.odsDepartmentNumber = d.ods_department_number
      --INNER JOIN sid.osu_unit e ON a.id = e.id;
      
   v_CoursesUpdated INTEGER;
   v_CoursesInserted INTEGER;
   v_ReturnString VARCHAR(4000);
   
BEGIN
   --SELECT id
   --INTO v_CampusID
   --FROM kmdata.campuses
   --WHERE campus_name = 'Columbus';

   v_CoursesUpdated := 0;
   v_CoursesInserted := 0;
   v_ReturnString := '';
   
   -- Step 1: delete current emails that are no longer here
   --DELETE FROM kmdata.courses bd
   --WHERE NOT EXISTS (
   --   SELECT a.departmentNumber, a.courseNumber, a.yearQuarterCode
   --   FROM sid.osu_course a
   --   INNER JOIN kmdata.acad_departments b ON a.departmentNumber = b.abbreviation
   --   WHERE b.id = bd.acad_department_id
   --   AND a.courseNumber = bd.course_number
   --   AND a.yearQuarterCode = bd.year_term_code
   --);

   -- Step 2: update
   FOR v_updCourse IN v_UpdateCursor LOOP

      -- if this has changed then update
      IF v_updCourse.active != v_updCourse.active
         OR COALESCE(v_updCourse.course_name,'') != COALESCE(v_updCourse.curr_course_name,'')
         OR COALESCE(v_updCourse.course_name_abbrev,'') != COALESCE(v_updCourse.curr_course_name_abbrev,'')
         OR COALESCE(v_updCourse.description,'') != COALESCE(v_updCourse.curr_description,'')
      THEN
      
         -- update the record
         UPDATE kmdata.courses
            SET active = v_updCourse.active,
                course_name = v_updCourse.course_name,
                course_name_abbrev = v_updCourse.course_name_abbrev,
                description = v_updCourse.description
          WHERE id = v_updCourse.id;

         v_CoursesUpdated := v_CoursesUpdated + 1;
         
      END IF;
            
   END LOOP;

   -- Step 3: insert
   FOR v_insCourse IN v_InsertCursor LOOP
      
      -- insert if not already there
      INSERT INTO kmdata.courses (
	 subject_id, course_number, course_name, course_name_abbrev, active, description, resource_id)
      VALUES (
         v_insCourse.subject_id, v_insCourse.course_number, v_insCourse.course_name, v_insCourse.course_name_abbrev, v_insCourse.active, v_insCourse.description, kmdata.add_new_resource('sid', 'courses'));

      v_CoursesInserted := v_CoursesInserted + 1;

   END LOOP;


   v_ReturnString := 'Courses import completed. ' || CAST(v_CoursesUpdated AS VARCHAR) || ' courses updated and ' || CAST(v_CoursesInserted AS VARCHAR) || ' courses inserted.';

   RETURN v_ReturnString;
END;
$$ LANGUAGE plpgsql;
