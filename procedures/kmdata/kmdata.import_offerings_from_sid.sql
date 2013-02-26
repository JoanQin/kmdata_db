CREATE OR REPLACE FUNCTION kmdata.import_offerings_from_sid (
) RETURNS VARCHAR AS $$
DECLARE
   --v_CampusID BIGINT;

   v_UpdateCursor CURSOR FOR
      SELECT DISTINCT a.id,
         NULL AS offering_name, sido.acad_career, cl.id AS college_id, d.id AS department_id, 
         ca.id AS campus_id, s.id AS subject_id, sido.catalog_nbr AS course_number,
         sido.schedule_print, sido.catalog_print, sido.sched_print_instr, 1 AS active,
         a.offering_name AS curr_offering_name, a.acad_career AS curr_acad_career, a.college_id AS curr_college_id, a.department_id AS curr_department_id, 
         a.campus_id AS curr_campus_id, a.subject_id AS curr_subject_id, a.course_number AS curr_course_number,
         a.schedule_print AS curr_schedule_print, a.catalog_print AS curr_catalog_print, a.sched_print_instr AS curr_sched_print_instr, a.active AS curr_active
      FROM kmdata.offerings a
      INNER JOIN kmdata.courses c ON a.course_id = c.id
      INNER JOIN sid.ps_crse_offer sido ON c.ps_course_id = sido.crse_id
         AND a.ps_course_offer_number = sido.crse_offer_nbr
      --INNER JOIN kmdata.acad_departments ad ON sido.acad_org = ad.dept_code
      INNER JOIN kmdata.campuses ca ON sido.campus = ca.campus_code
      INNER JOIN kmdata.colleges cl ON sido.acad_group = cl.acad_group
      INNER JOIN kmdata.departments d ON kmdata.get_converted_acad_dept_id(sido.acad_org) = d.deptid
      INNER JOIN kmdata.subjects s ON sido.subject = s.subject_abbrev;
   
   v_InsertCursor CURSOR FOR
      SELECT DISTINCT c.id AS course_id, chgoffer.crse_offer_nbr AS ps_course_offer_number, NULL AS offering_name,
         cl.id AS college_id, s.id AS subject_id, sido.catalog_nbr AS course_number, ca.id AS campus_id,
         d.id AS department_id, sido.acad_career, sido.schedule_print, sido.catalog_print, sido.sched_print_instr,
         1 AS active
      FROM
      (
         SELECT pcoi.crse_id, pcoi.crse_offer_nbr
         FROM sid.ps_crse_offer pcoi
         EXCEPT
         SELECT ci.ps_course_id AS crse_id, oi.ps_course_offer_number AS crse_offer_nbr
         FROM kmdata.offerings oi
         INNER JOIN kmdata.courses ci ON oi.course_id = ci.id
      ) chgoffer
      INNER JOIN sid.ps_crse_offer sido ON chgoffer.crse_id = sido.crse_id AND chgoffer.crse_offer_nbr = sido.crse_offer_nbr
      INNER JOIN kmdata.courses c ON sido.crse_id = c.ps_course_id
      --INNER JOIN kmdata.acad_departments ad ON sido.acad_org = ad.dept_code
      INNER JOIN kmdata.campuses ca ON sido.campus = ca.campus_code
      INNER JOIN kmdata.colleges cl ON sido.acad_group = cl.acad_group
      INNER JOIN kmdata.departments d ON kmdata.get_converted_acad_dept_id(sido.acad_org) = d.deptid
      INNER JOIN kmdata.subjects s ON sido.subject = s.subject_abbrev;
      
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

   -- set offerings to inactive when they no longer appear
   UPDATE kmdata.offerings oo
   SET active = 0
   WHERE NOT EXISTS (
      SELECT pcoi.crse_id, oo.ps_course_offer_number
      FROM sid.ps_crse_offer pcoi
      INNER JOIN kmdata.courses ci ON pcoi.crse_id = ci.ps_course_id
      WHERE pcoi.crse_offer_nbr = oo.ps_course_offer_number
   );

   -- Step 2: update
   FOR v_updOffering IN v_UpdateCursor LOOP

      -- if this has changed then update
      
      IF COALESCE(v_updOffering.offering_name,'') != COALESCE(v_updOffering.curr_offering_name,'')
         OR COALESCE(v_updOffering.college_id,0) != COALESCE(v_updOffering.curr_college_id,0)
         OR COALESCE(v_updOffering.department_id,0) != COALESCE(v_updOffering.curr_department_id,0)
         OR COALESCE(v_updOffering.acad_career,'') != COALESCE(v_updOffering.curr_acad_career,'')
         OR COALESCE(v_updOffering.campus_id,0) != COALESCE(v_updOffering.curr_campus_id,0)
         OR COALESCE(v_updOffering.subject_id,0) != COALESCE(v_updOffering.curr_subject_id,0)
         OR COALESCE(v_updOffering.course_number,'') != COALESCE(v_updOffering.curr_course_number,'')
         OR COALESCE(v_updOffering.schedule_print,'') != COALESCE(v_updOffering.curr_schedule_print,'')
         OR COALESCE(v_updOffering.catalog_print,'') != COALESCE(v_updOffering.curr_catalog_print,'')
         OR COALESCE(v_updOffering.sched_print_instr,'') != COALESCE(v_updOffering.curr_sched_print_instr,'')
         OR COALESCE(CAST(v_updOffering.active AS VARCHAR),'') != COALESCE(CAST(v_updOffering.curr_active AS VARCHAR),'')
      THEN
      
         -- update the record
         UPDATE kmdata.offerings
            SET offering_name = v_updOffering.offering_name,
                college_id = v_updOffering.college_id,
                department_id = v_updOffering.department_id,
                acad_career = v_updOffering.acad_career,
                campus_id = v_updOffering.campus_id,
                subject_id = v_updOffering.subject_id,
                course_number = v_updOffering.course_number,
                schedule_print = v_updOffering.schedule_print,
                catalog_print = v_updOffering.catalog_print,
                sched_print_instr = v_updOffering.sched_print_instr,
                active = v_updOffering.active
          WHERE id = v_updOffering.id;

         v_OfferingsUpdated := v_OfferingsUpdated + 1;
         
      END IF;
            
   END LOOP;

   -- Step 3: insert
   FOR v_insOffering IN v_InsertCursor LOOP
      
      -- insert if not already there
      INSERT INTO kmdata.offerings (
         course_id, ps_course_offer_number, offering_name, college_id, 
         subject_id, course_number, campus_id, department_id, acad_career, 
         schedule_print, catalog_print, sched_print_instr, active,
         resource_id)
      VALUES (
         v_insOffering.course_id, v_insOffering.ps_course_offer_number, NULL, v_insOffering.college_id, 
         v_insOffering.subject_id, v_insOffering.course_number, v_insOffering.campus_id, v_insOffering.department_id, v_insOffering.acad_career, 
         v_insOffering.schedule_print, v_insOffering.catalog_print, v_insOffering.sched_print_instr, v_insOffering.active,
         kmdata.add_new_resource('sid', 'offerings'));

      v_OfferingsInserted := v_OfferingsInserted + 1;

   END LOOP;


   v_ReturnString := 'Offerings import completed. ' || CAST(v_OfferingsUpdated AS VARCHAR) || ' offerings updated and ' || CAST(v_OfferingsInserted AS VARCHAR) || ' offerings inserted.';

   RETURN v_ReturnString;
END;
$$ LANGUAGE plpgsql;
