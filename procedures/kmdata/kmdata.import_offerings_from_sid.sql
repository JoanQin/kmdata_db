CREATE OR REPLACE FUNCTION kmdata.import_offerings_from_sid (
) RETURNS VARCHAR AS $$
DECLARE
   --v_CampusID BIGINT;

   v_UpdateCursor CURSOR FOR
      SELECT a.id,
         CAST(NULL AS VARCHAR) AS offering_name,
         a.offering_name AS curr_offering_name
      FROM kmdata.offerings a
      INNER JOIN kmdata.term_sessions ts ON a.term_session_id = ts.id
      INNER JOIN kmdata.terms t ON ts.term_id = t.id
      INNER JOIN kmdata.acad_departments ad ON a.acad_department_id = ad.id
      INNER JOIN kmdata.colleges c ON ad.college_id = c.id
      INNER JOIN kmdata.campuses ca ON c.campus_id = ca.id
      INNER JOIN kmdata.courses co ON a.course_id = co.id
      INNER JOIN kmdata.subjects s ON co.subject_id = s.id
      INNER JOIN sid.osu_offering sido ON sido.yearQuarterCode = t.term_code 
         AND sido.campusId = ca.ps_location_name 
         AND sido.departmentNumber = s.subject_abbrev 
         AND sido.courseNumber = co.course_number 
         AND sido.session_code = ts.session_code 
         AND sido.acad_group = c.acad_group
         AND sido.acad_org = ad.dept_code;
   
   v_InsertCursor CURSOR FOR
      SELECT DISTINCT CAST(NULL AS VARCHAR) AS offering_name, c.id AS course_id, ts.id AS term_session_id, ad.id AS acad_department_id
      FROM
      (
         SELECT yearQuarterCode AS term_code, campusId AS ps_location_name, departmentNumber AS subject_abbrev, 
            courseNumber AS course_number, session_code, acad_group, acad_org
           FROM sid.osu_offering ai
         EXCEPT
         SELECT ti.term_code, cai.ps_location_name, si.subject_abbrev, coi.course_number, tsi.session_code, ci.acad_group, adi.dept_code AS acad_org
           FROM kmdata.offerings bi
           INNER JOIN kmdata.term_sessions tsi ON bi.term_session_id = tsi.id
           INNER JOIN kmdata.terms ti ON tsi.term_id = ti.id
           INNER JOIN kmdata.acad_departments adi ON bi.acad_department_id = adi.id
           INNER JOIN kmdata.colleges ci ON adi.college_id = ci.id
           INNER JOIN kmdata.campuses cai ON ci.campus_id = cai.id
           INNER JOIN kmdata.courses coi ON bi.course_id = coi.id
           INNER JOIN kmdata.subjects si ON coi.subject_id = si.id
      ) chgoffer
      INNER JOIN kmdata.courses c ON chgoffer.course_number = c.course_number
      INNER JOIN kmdata.subjects s ON c.subject_id = s.id AND chgoffer.subject_abbrev = s.subject_abbrev
      INNER JOIN kmdata.terms t ON chgoffer.term_code = t.term_code
      INNER JOIN kmdata.term_sessions ts ON chgoffer.session_code = ts.session_code AND t.id = ts.term_id
      INNER JOIN kmdata.colleges col ON chgoffer.acad_group = col.acad_group
      INNER JOIN kmdata.acad_departments ad ON col.id = ad.college_id AND chgoffer.acad_org = ad.dept_code AND s.acad_org = ad.dept_code AND s.subject_abbrev = ad.abbreviation
      INNER JOIN kmdata.campuses cam ON chgoffer.ps_location_name = cam.ps_location_name AND col.campus_id = cam.id;
      
   v_OfferingsUpdated INTEGER;
   v_OfferingsInserted INTEGER;
   v_ReturnString VARCHAR(4000);
   
BEGIN
   --SELECT id
   --INTO v_CampusID
   --FROM kmdata.campuses
   --WHERE campus_name = 'Columbus';

   v_OfferingsUpdated := 0;
   v_OfferingsInserted := 0;
   v_ReturnString := '';
   
   -- Step 1: delete current emails that are no longer here
   --DELETE FROM kmdata.offerings bd
   --WHERE NOT EXISTS (
   --   SELECT a.departmentNumber, a.courseNumber, a.yearQuarterCode
   --   FROM sid.osu_offering a
   --   INNER JOIN kmdata.acad_departments b ON a.departmentNumber = b.abbreviation
   --   WHERE 
   --   AND 
   --   AND 
   --);

   -- Step 2: update
   FOR v_updOffering IN v_UpdateCursor LOOP

      -- if this has changed then update
      IF COALESCE(v_updOffering.offering_name,'') != COALESCE(v_updOffering.curr_offering_name,'')
      THEN
      
         -- update the record
         UPDATE kmdata.offerings
            SET offering_name = v_updOffering.offering_name
          WHERE id = v_updOffering.id;

         v_OfferingsUpdated := v_OfferingsUpdated + 1;
         
      END IF;
            
   END LOOP;

   -- Step 3: insert
   FOR v_insOffering IN v_InsertCursor LOOP
      
      -- insert if not already there
      INSERT INTO kmdata.offerings (
	 offering_name, course_id, term_session_id, acad_department_id, resource_id)
      VALUES (
         v_insOffering.offering_name, v_insOffering.course_id, v_insOffering.term_session_id, v_insOffering.acad_department_id, kmdata.add_new_resource('sid', 'offerings'));

      v_OfferingsInserted := v_OfferingsInserted + 1;

   END LOOP;


   v_ReturnString := 'Offerings import completed. ' || CAST(v_OfferingsUpdated AS VARCHAR) || ' offerings updated and ' || CAST(v_OfferingsInserted AS VARCHAR) || ' offerings inserted.';

   RETURN v_ReturnString;
END;
$$ LANGUAGE plpgsql;
