CREATE OR REPLACE FUNCTION kmdata.import_enrollments_from_ps (
) RETURNS VARCHAR AS $$
DECLARE

   v_UpdateCursor CURSOR FOR
      SELECT DISTINCT e1.id, 
         ui2.user_id, er2.id AS role_id, sidenrl.sched_print_instr,
         e1.user_id AS curr_user_id, e1.role_id AS curr_role_id, e1.sched_print_instr AS curr_sched_print_instr
      FROM kmdata.enrollments e1
      INNER JOIN kmdata.section_weekly_mtgs m ON e1.section_weekly_mtg_id = m.id
      INNER JOIN kmdata.sections a ON m.section_id = a.id
      INNER JOIN kmdata.offerings b ON a.offering_id = b.id
      INNER JOIN kmdata.term_sessions ts ON a.term_session_id = ts.id
      INNER JOIN kmdata.terms t ON ts.term_id = t.id
      INNER JOIN kmdata.courses co ON b.course_id = co.id
      INNER JOIN kmdata.user_identifiers ui1 ON e1.user_id = ui1.user_id
      INNER JOIN kmdata.enrollment_roles er ON e1.role_id = er.id
      INNER JOIN sid.ps_class_instr sidenrl ON co.ps_course_id = sidenrl.crse_id
         AND b.ps_course_offer_number = sidenrl.crse_offer_nbr
         AND t.term_code = sidenrl.strm
         AND ts.session_code = sidenrl.session_code
         AND a.ps_class_section = sidenrl.class_section
         AND m.ps_class_mtg_number = sidenrl.class_mtg_nbr
         AND e1.ps_instr_assign_seq = sidenrl.instr_assign_seq
      INNER JOIN kmdata.user_identifiers ui2 ON sidenrl.emplid = ui2.emplid
      INNER JOIN kmdata.enrollment_roles er2 ON sidenrl.instr_role = er2.role_code;

   v_InsertCursor CURSOR FOR
      SELECT DISTINCT swm.id AS section_weekly_mtg_id, sidenrl.instr_assign_seq AS ps_instr_assign_seq,
         ui.user_id, er.id AS role_id, NULL AS career_id, sidenrl.sched_print_instr
      FROM
      (
         SELECT ai.crse_id, ai.crse_offer_nbr, tsi.id AS term_session_id, ai.class_section, ai.class_mtg_nbr, ai.instr_assign_seq, ai.strm, ai.session_code
         FROM sid.ps_class_instr ai
         INNER JOIN kmdata.terms ti ON ai.strm = ti.term_code
         INNER JOIN kmdata.term_sessions tsi ON ti.id = tsi.term_id AND ai.session_code = tsi.session_code
         EXCEPT 
         SELECT coi.ps_course_id AS crse_id, bi.ps_course_offer_number AS crse_offer_nbr, xi.term_session_id, xi.ps_class_section AS class_section, mi.ps_class_mtg_number AS class_mtg_nbr,
            ei.ps_instr_assign_seq AS instr_assign_seq, ti.term_code AS strm, tsi.session_code AS session_code
         FROM kmdata.enrollments ei
         INNER JOIN kmdata.section_weekly_mtgs mi ON ei.section_weekly_mtg_id = mi.id
         INNER JOIN kmdata.sections xi ON mi.section_id = xi.id
         INNER JOIN kmdata.offerings bi ON xi.offering_id = bi.id
         INNER JOIN kmdata.term_sessions tsi ON xi.term_session_id = tsi.id
         INNER JOIN kmdata.terms ti ON tsi.term_id = ti.id
         INNER JOIN kmdata.courses coi ON bi.course_id = coi.id
      ) chgenrl
      INNER JOIN sid.ps_class_instr sidenrl ON chgenrl.crse_id = sidenrl.crse_id
         AND chgenrl.crse_offer_nbr = sidenrl.crse_offer_nbr
         AND chgenrl.strm = sidenrl.strm
         AND chgenrl.session_code = sidenrl.session_code
         AND chgenrl.class_section = sidenrl.class_section
         AND chgenrl.class_mtg_nbr = sidenrl.class_mtg_nbr
         AND chgenrl.instr_assign_seq = sidenrl.instr_assign_seq
      INNER JOIN kmdata.courses c ON sidenrl.crse_id = c.ps_course_id
      INNER JOIN kmdata.offerings o ON c.id = o.course_id AND sidenrl.crse_offer_nbr = o.ps_course_offer_number
      INNER JOIN kmdata.sections sct ON o.id = sct.offering_id AND sidenrl.class_section = sct.ps_class_section
      INNER JOIN kmdata.section_weekly_mtgs swm ON sct.id = swm.section_id AND sidenrl.class_mtg_nbr = swm.ps_class_mtg_number
      INNER JOIN kmdata.user_identifiers ui ON sidenrl.emplid = ui.emplid
      INNER JOIN kmdata.enrollment_roles er ON sidenrl.instr_role = er.role_code;
      
   v_EnrollmentsUpdated INTEGER;
   v_EnrollmentsInserted INTEGER;
   v_ReturnString VARCHAR(4000);
   
BEGIN

   v_EnrollmentsUpdated := 0;
   v_EnrollmentsInserted := 0;
   v_ReturnString := '';
   
   -- Step 1: delete enrollments that are no longer here
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
      IF COALESCE(CAST(v_updEnrollment.user_id AS VARCHAR),'') != COALESCE(CAST(v_updEnrollment.curr_user_id AS VARCHAR),'')
         OR COALESCE(CAST(v_updEnrollment.role_id AS VARCHAR),'') != COALESCE(CAST(v_updEnrollment.curr_role_id AS VARCHAR),'')
         OR COALESCE(v_updEnrollment.sched_print_instr,'') != COALESCE(v_updEnrollment.curr_sched_print_instr,'')
      THEN
      
         -- update the record
         UPDATE kmdata.enrollments
            SET user_id = v_updEnrollment.user_id,
                role_id = v_updEnrollment.role_id,
                sched_print_instr = v_updEnrollment.sched_print_instr,
                updated_at = current_timestamp
          WHERE id = v_updEnrollment.id;

         v_EnrollmentsUpdated := v_EnrollmentsUpdated + 1;
         
      END IF;
            
   END LOOP;

   -- Step 3: insert
   FOR v_insEnrollment IN v_InsertCursor LOOP
      
      -- insert if not already there
      INSERT INTO kmdata.enrollments (
         section_weekly_mtg_id, ps_instr_assign_seq, user_id, role_id, 
         career_id, sched_print_instr, created_at, updated_at, resource_id)
      VALUES (
         v_insEnrollment.section_weekly_mtg_id, v_insEnrollment.ps_instr_assign_seq, v_insEnrollment.user_id, v_insEnrollment.role_id, 
         NULL, v_insEnrollment.sched_print_instr, current_timestamp, current_timestamp, kmdata.add_new_resource('sid', 'enrollments'));

      v_EnrollmentsInserted := v_EnrollmentsInserted + 1;
      
   END LOOP;


   v_ReturnString := 'Enrollments import completed. ' || CAST(v_EnrollmentsUpdated AS VARCHAR) || ' enrollments updated and ' || CAST(v_EnrollmentsInserted AS VARCHAR) || ' enrollments inserted.';

   RETURN v_ReturnString;
END;
$$ LANGUAGE plpgsql;
