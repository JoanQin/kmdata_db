CREATE OR REPLACE FUNCTION kmdata.import_subjects_from_sid (
) RETURNS VARCHAR AS $$
DECLARE
   --v_CampusID BIGINT;

   v_UpdateCursor CURSOR FOR
      SELECT DISTINCT a.id, a.subject_abbrev, --keys
         b.descr AS subject_name, b.acad_org, b.cip_code, b.descrformal AS formal_descr,  -- from sid
         a.subject_name AS curr_subject_name, a.acad_org AS curr_acad_org, a.cip_code AS curr_cip_code, a.formal_descr AS curr_formal_descr -- from kmdata (current)
      FROM kmdata.subjects a
      INNER JOIN sid.ps_subject_tbl b ON a.subject_abbrev = b.subject AND b.institution = 'OSUSI' AND b.eff_status = 'A';
   
   v_InsertCursor CURSOR FOR
      SELECT DISTINCT chgsub.subject_abbrev, a.descr AS subject_name, a.acad_org, a.cip_code, a.descrformal AS formal_descr
      FROM
      (
         SELECT ai.subject AS subject_abbrev
           FROM sid.ps_subject_tbl ai
          WHERE ai.institution = 'OSUSI' AND ai.eff_status = 'A'
         EXCEPT
         SELECT x.subject_abbrev
           FROM kmdata.subjects x
      ) chgsub
      INNER JOIN sid.ps_subject_tbl a ON chgsub.subject_abbrev = a.subject
      WHERE a.institution = 'OSUSI' AND a.eff_status = 'A';
      
   v_SubjectsUpdated INTEGER;
   v_SubjectsInserted INTEGER;
   v_ReturnString VARCHAR(4000);
   
BEGIN
   --SELECT id
   --INTO v_CampusID
   --FROM kmdata.campuses
   --WHERE campus_name = 'Columbus';

   v_SubjectsUpdated := 0;
   v_SubjectsInserted := 0;
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
   FOR v_updSubject IN v_UpdateCursor LOOP

      -- if this has changed then update
      IF v_updSubject.subject_name != v_updSubject.curr_subject_name
         OR v_updSubject.acad_org != v_updSubject.curr_acad_org
         OR v_updSubject.cip_code != v_updSubject.curr_cip_code
         OR v_updSubject.formal_descr != v_updSubject.curr_formal_descr
      THEN
      
         -- update the record
         UPDATE kmdata.subjects
            SET subject_name = v_updSubject.subject_name,
                acad_org = v_updSubject.acad_org,
                cip_code = v_updSubject.cip_code,
                formal_descr = v_updSubject.formal_descr
          WHERE id = v_updSubject.id;

         v_SubjectsUpdated := v_SubjectsUpdated + 1;
         
      END IF;
            
   END LOOP;

   -- Step 3: insert
   FOR v_insSubject IN v_InsertCursor LOOP
      
      -- insert if not already there
      INSERT INTO kmdata.subjects (
	 subject_abbrev, subject_name, acad_org, cip_code, formal_descr, resource_id)
      VALUES (
         v_insSubject.subject_abbrev, v_insSubject.subject_name, v_insSubject.acad_org, v_insSubject.cip_code, v_insSubject.formal_descr, kmdata.add_new_resource('sid', 'subjects'));

      v_SubjectsInserted := v_SubjectsInserted + 1;

   END LOOP;


   v_ReturnString := 'Subjects import completed. ' || CAST(v_SubjectsUpdated AS VARCHAR) || ' subjects updated and ' || CAST(v_SubjectsInserted AS VARCHAR) || ' subjects inserted.';

   RETURN v_ReturnString;
END;
$$ LANGUAGE plpgsql;
