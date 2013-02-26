CREATE OR REPLACE FUNCTION kmdata.import_sections_from_sid (
) RETURNS VARCHAR AS $$
DECLARE
   -- In this new version we will not include weekly meetings. It has been separated to be processed separately.
   --v_CampusID BIGINT;

   v_UpdateCursor CURSOR FOR
      SELECT DISTINCT a.id,
         NULL AS section_name, sidc.class_nbr AS class_number, CAST(NULL AS VARCHAR) AS section_type, 
         CAST(NULL AS BIGINT) AS parent_section_id, sidc.enrl_tot AS enrollment_total,
         sidc.enrl_cap AS enrollment_capacity, sidc.wait_tot AS waitlist_total, sidc.ssr_component,
         sidc.schedule_print, sidc.print_topic, sidc.instruction_mode,
         a.section_name AS curr_section_name, a.class_number AS curr_class_number, a.section_type AS curr_section_type, 
         a.parent_section_id AS curr_parent_section_id, a.enrollment_total AS curr_enrollment_total,
         a.enrollment_capacity AS curr_enrollment_capacity, a.waitlist_total AS curr_waitlist_total, a.ssr_component AS curr_ssr_component,
         a.schedule_print AS curr_schedule_print, a.print_topic AS curr_print_topic, a.instruction_mode AS curr_instruction_mode
      FROM kmdata.sections a
      INNER JOIN kmdata.offerings b ON a.offering_id = b.id
      INNER JOIN kmdata.courses co ON b.course_id = co.id
      INNER JOIN kmdata.term_sessions ts ON a.term_session_id = ts.id
      INNER JOIN kmdata.terms t ON ts.term_id = t.id
      INNER JOIN sid.ps_class_tbl sidc ON co.ps_course_id = sidc.crse_id
         AND b.ps_course_offer_number = sidc.crse_offer_nbr
         AND t.term_code = sidc.strm
         AND ts.session_code = sidc.session_code
         AND a.ps_class_section = sidc.class_section;
	  
   v_InsertCursor CURSOR FOR
      SELECT DISTINCT CAST(NULL AS VARCHAR) AS section_name, o.id AS offering_id, chgsect.term_session_id, sids.class_section AS ps_class_section, 
         sids.class_nbr AS class_number, CAST(NULL AS VARCHAR) AS section_type, CAST(NULL AS BIGINT) AS parent_section_id, 
         sids.enrl_tot AS enrollment_total,
         sids.enrl_cap AS enrollment_capacity, sids.wait_tot AS waitlist_total, sids.ssr_component,
         sids.schedule_print, sids.print_topic, sids.instruction_mode
      FROM
      (
         SELECT pci.crse_id, pci.crse_offer_nbr, tsi.id AS term_session_id, pci.class_section, pci.strm, pci.session_code
         FROM sid.ps_class_tbl pci
         INNER JOIN kmdata.terms ti ON pci.strm = ti.term_code
         INNER JOIN kmdata.term_sessions tsi ON ti.id = tsi.term_id AND pci.session_code = tsi.session_code
         EXCEPT
         SELECT ci.ps_course_id AS crse_id, bi.ps_course_offer_number AS crse_offer_nbr, ai.term_session_id, ai.ps_class_section AS class_section, ti.term_code AS strm, tsi.session_code AS session_code
         FROM kmdata.sections ai
         INNER JOIN kmdata.offerings bi ON ai.offering_id = bi.id
         INNER JOIN kmdata.courses ci ON bi.course_id = ci.id
         INNER JOIN kmdata.term_sessions tsi ON ai.term_session_id = tsi.id
         INNER JOIN kmdata.terms ti ON tsi.term_id = ti.id
      ) chgsect
      INNER JOIN sid.ps_class_tbl sids ON chgsect.crse_id = sids.crse_id
         AND chgsect.crse_offer_nbr = sids.crse_offer_nbr
         AND chgsect.strm = sids.strm
         AND chgsect.session_code = sids.session_code
         AND chgsect.class_section = sids.class_section
      INNER JOIN kmdata.courses c ON sids.crse_id = c.ps_course_id
      INNER JOIN kmdata.offerings o ON c.id = o.course_id AND sids.crse_offer_nbr = o.ps_course_offer_number;
	  
	  

   v_SectionsUpdated INTEGER;
   v_SectionsInserted INTEGER;
   v_ReturnString VARCHAR(4000);
   v_SectionID BIGINT;
   
BEGIN
   --SELECT id
   --INTO v_CampusID
   --FROM kmdata.campuses
   --WHERE campus_name = 'Columbus';

   v_SectionsUpdated := 0;
   v_SectionsInserted := 0;
   v_ReturnString := '';
   
   -- Step 1: delete current emails that are no longer here
   --DELETE FROM kmdata.sections bd
   --WHERE NOT EXISTS (
   --   SELECT 
   --   FROM sid.osu_section a
   --   INNER JOIN kmdata.acad_departments b ON a.departmentNumber = b.abbreviation
   --   WHERE 
   --   AND 
   --   AND 
   --);

   -- Step 2: update
   FOR v_updSection IN v_UpdateCursor LOOP

      -- if this has changed then update
      --COALESCE(v_updSection.section_name,'') != COALESCE(v_updSection.curr_section_name,'')
      --   OR COALESCE(v_updSection.section_type,'') != COALESCE(v_updSection.curr_section_type,'')
      --   OR COALESCE(CAST(v_updSection.parent_section_id AS VARCHAR),'') != COALESCE(CAST(v_updSection.curr_parent_section_id AS VARCHAR),'')
      IF COALESCE(CAST(v_updSection.enrollment_total AS VARCHAR),'') != COALESCE(CAST(v_updSection.curr_enrollment_total AS VARCHAR),'')
         OR COALESCE(CAST(v_updSection.enrollment_capacity AS VARCHAR),'') != COALESCE(CAST(v_updSection.curr_enrollment_capacity AS VARCHAR),'')
         OR COALESCE(CAST(v_updSection.waitlist_total AS VARCHAR),'') != COALESCE(CAST(v_updSection.curr_waitlist_total AS VARCHAR),'')
         OR COALESCE(v_updSection.ssr_component,'') != COALESCE(v_updSection.curr_ssr_component,'')
         OR COALESCE(v_updSection.schedule_print,'') != COALESCE(v_updSection.curr_schedule_print,'')
         OR COALESCE(v_updSection.print_topic,'') != COALESCE(v_updSection.curr_print_topic,'')
         OR COALESCE(v_updSection.instruction_mode,'') != COALESCE(v_updSection.curr_instruction_mode,'')
      THEN
      
         -- update the record
         UPDATE kmdata.sections
            SET section_name = NULL, --v_updSection.section_name,
                section_type = NULL, --v_updSection.section_type,
                parent_section_id = NULL, --v_updSection.parent_section_id,
                enrollment_total = v_updSection.enrollment_total,
                enrollment_capacity = v_updSection.enrollment_capacity,
                waitlist_total = v_updSection.waitlist_total,
                ssr_component = v_updSection.ssr_component,
                schedule_print = v_updSection.schedule_print,
                print_topic = v_updSection.print_topic,
                instruction_mode = v_updSection.instruction_mode
          WHERE id = v_updSection.id;

         v_SectionsUpdated := v_SectionsUpdated + 1;
         
      END IF;
            
   END LOOP;

   -- Step 3: insert
   FOR v_insSection IN v_InsertCursor LOOP

      -- get the next value of the sequence
      v_SectionID := nextval('kmdata.sections_id_seq');
      
      -- insert if not already there
      INSERT INTO kmdata.sections (
         id, section_name, offering_id, term_session_id, ps_class_section, 
         class_number, section_type, parent_section_id, enrollment_total, 
         enrollment_capacity, waitlist_total, ssr_component,
         schedule_print, print_topic, instruction_mode,
         resource_id)
      VALUES (
         v_SectionID, NULL, v_insSection.offering_id, v_insSection.term_session_id, v_insSection.ps_class_section, 
         v_insSection.class_number, NULL, NULL,  v_insSection.enrollment_total, 
         v_insSection.enrollment_capacity, v_insSection.waitlist_total, v_insSection.ssr_component,
         v_insSection.schedule_print, v_insSection.print_topic, v_insSection.instruction_mode,
         kmdata.add_new_resource('sid', 'sections'));

      v_SectionsInserted := v_SectionsInserted + 1;

   END LOOP;


   v_ReturnString := 'Sections import completed. ' || CAST(v_SectionsUpdated AS VARCHAR) || ' sections updated and ' || CAST(v_SectionsInserted AS VARCHAR) || ' sections inserted.';

   RETURN v_ReturnString;
END;
$$ LANGUAGE plpgsql;
