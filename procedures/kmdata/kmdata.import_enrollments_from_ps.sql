CREATE OR REPLACE FUNCTION kmdata.import_enrollments_from_ps (
) RETURNS VARCHAR AS $$
DECLARE

   v_UpdateCursor CURSOR FOR
      SELECT DISTINCT e1.id, e1.section_id, e1.user_id, e1.role_id,
         CAST(NULL AS BIGINT) AS career_id,
         e1.career_id AS curr_career_id
      FROM kmdata.enrollments e1
      INNER JOIN kmdata.sections a ON e1.section_id = a.id
      INNER JOIN kmdata.offerings b ON a.offering_id = b.id
      INNER JOIN kmdata.term_sessions ts ON b.term_session_id = ts.id
      INNER JOIN kmdata.terms t ON ts.term_id = t.id
      INNER JOIN kmdata.acad_departments ad ON b.acad_department_id = ad.id
      INNER JOIN kmdata.colleges c ON ad.college_id = c.id
      INNER JOIN kmdata.campuses ca ON c.campus_id = ca.id
      INNER JOIN kmdata.courses co ON b.course_id = co.id
      INNER JOIN kmdata.subjects s ON co.subject_id = s.id
      INNER JOIN kmdata.user_identifiers ui1 ON e1.user_id = ui1.user_id
      INNER JOIN kmdata.enrollment_roles er ON e1.role_id = er.id
      INNER JOIN sid.osu_unit_enrollment sidenrl ON sidenrl.yearQuarterCode = t.term_code 
         AND sidenrl.campusId = ca.ps_location_name 
         AND sidenrl.departmentNumber = s.subject_abbrev 
         AND sidenrl.courseNumber = co.course_number 
         AND sidenrl.session_code = ts.session_code 
         AND sidenrl.acad_group = c.acad_group 
         AND sidenrl.acad_org = ad.dept_code
         AND sidenrl.callNumber = a.class_number 
         AND sidenrl.emplid = ui1.emplid
         AND sidenrl.instr_role = er.role_code;

   v_InsertCursor CURSOR FOR
      SELECT DISTINCT sct.id AS section_id, ui2.user_id, er2.id AS role_id, CAST(NULL AS BIGINT) AS career_id
      FROM
      (
         SELECT yearQuarterCode AS term_code, campusId AS ps_location_name, departmentNumber AS subject_abbrev, 
            courseNumber AS course_number, session_code, acad_group, acad_org, callNumber AS class_number, 
            emplid, instr_role
           FROM sid.osu_unit_enrollment ai
         EXCEPT
         SELECT ti.term_code, cai.ps_location_name, si.subject_abbrev, 
            coi.course_number, tsi.session_code, ci.acad_group, adi.dept_code AS acad_org, xi.class_number,
            ui.emplid, er.role_code AS instr_role
           FROM kmdata.enrollments x
           INNER JOIN kmdata.sections xi ON x.section_id = xi.id
           INNER JOIN kmdata.offerings bi ON xi.offering_id = bi.id
           INNER JOIN kmdata.term_sessions tsi ON bi.term_session_id = tsi.id
           INNER JOIN kmdata.terms ti ON tsi.term_id = ti.id
           INNER JOIN kmdata.acad_departments adi ON bi.acad_department_id = adi.id
           INNER JOIN kmdata.colleges ci ON adi.college_id = ci.id
           INNER JOIN kmdata.campuses cai ON ci.campus_id = cai.id
           INNER JOIN kmdata.courses coi ON bi.course_id = coi.id
           INNER JOIN kmdata.subjects si ON coi.subject_id = si.id
           INNER JOIN kmdata.user_identifiers ui ON x.user_id = ui.user_id
           INNER JOIN kmdata.enrollment_roles er ON x.role_id = er.id
      ) chgenrl
      INNER JOIN sid.osu_unit_enrollment sidenrl ON chgenrl.term_code = sidenrl.yearQuarterCode 
         AND chgenrl.ps_location_name = sidenrl.campusId 
         AND chgenrl.subject_abbrev = sidenrl.departmentNumber 
         AND chgenrl.course_number = sidenrl.courseNumber 
         AND chgenrl.session_code = sidenrl.session_code 
         AND chgenrl.acad_group = sidenrl.acad_group 
         AND chgenrl.acad_org = sidenrl.acad_org
         AND chgenrl.class_number = sidenrl.callNumber
         AND chgenrl.emplid = sidenrl.emplid
         AND chgenrl.instr_role = sidenrl.instr_role
      INNER JOIN kmdata.subjects s ON sidenrl.departmentNumber = s.subject_abbrev
      INNER JOIN kmdata.courses c ON s.id = c.subject_id AND sidenrl.courseNumber = c.course_number
      INNER JOIN kmdata.term_sessions ts ON sidenrl.session_code = ts.session_code
      INNER JOIN kmdata.terms t ON ts.term_id = t.id AND sidenrl.yearQuarterCode = t.term_code
      INNER JOIN kmdata.campuses cam ON sidenrl.campusId = cam.ps_location_name
      INNER JOIN kmdata.colleges col ON cam.id = col.campus_id AND sidenrl.acad_group = col.acad_group
      INNER JOIN kmdata.acad_departments ad ON col.id = ad.college_id AND sidenrl.acad_org = ad.dept_code AND s.acad_org = ad.dept_code AND s.subject_abbrev = ad.abbreviation
      INNER JOIN kmdata.offerings o ON c.id = o.course_id AND ts.id = o.term_session_id AND ad.id = o.acad_department_id
      INNER JOIN kmdata.sections sct ON o.id = sct.offering_id AND sidenrl.callNumber = sct.class_number
      INNER JOIN kmdata.user_identifiers ui2 ON sidenrl.emplid = ui2.emplid
      INNER JOIN kmdata.enrollment_roles er2 ON sidenrl.instr_role = er2.role_code;
      
   v_EnrollmentsUpdated INTEGER;
   v_EnrollmentsInserted INTEGER;
   v_ReturnString VARCHAR(4000);
   
BEGIN

   v_EnrollmentsUpdated := 0;
   v_EnrollmentsInserted := 0;
   v_ReturnString := '';
   
   -- Step 1: delete current phones that are no longer here
   --DELETE FROM 
   --WHERE NOT EXISTS (
   --   SELECT 
   --   FROM sid.osu_unit_enrollment a
   --   INNER JOIN kmdata.user_identifiers b ON a.emplid = b.emplid
   --   WHERE 
   --   AND 
   --)
   --AND 

   -- Step 2: update
   FOR v_updEnrollment IN v_UpdateCursor LOOP

      -- if this has changed then update
      IF COALESCE(CAST(v_updEnrollment.career_id AS VARCHAR),'') != COALESCE(CAST(v_updEnrollment.curr_career_id AS VARCHAR),'')
      THEN
      
         -- update the record
         UPDATE kmdata.enrollments
            SET career_id = v_updEnrollment.career_id,
	        updated_at = current_timestamp
          WHERE id = v_updEnrollment.id;

         v_EnrollmentsUpdated := v_EnrollmentsUpdated + 1;
         
      END IF;
            
   END LOOP;

   -- Step 3: insert
   FOR v_insEnrollment IN v_InsertCursor LOOP
      
      -- insert if not already there
      INSERT INTO kmdata.enrollments (
	 section_id, user_id, role_id, career_id, 
         created_at, updated_at, resource_id)
      VALUES (
         v_insEnrollment.section_id, v_insEnrollment.user_id, v_insEnrollment.role_id, v_insEnrollment.career_id, 
         current_timestamp, current_timestamp, kmdata.add_new_resource('peoplesoft', 'enrollments'));

      v_EnrollmentsInserted := v_EnrollmentsInserted + 1;
      
   END LOOP;


   v_ReturnString := 'Enrollments import completed. ' || CAST(v_EnrollmentsUpdated AS VARCHAR) || ' enrollments updated and ' || CAST(v_EnrollmentsInserted AS VARCHAR) || ' enrollments inserted.';

   RETURN v_ReturnString;
END;
$$ LANGUAGE plpgsql;
