CREATE OR REPLACE FUNCTION kmdata.import_sections_from_sid (
) RETURNS VARCHAR AS $$
DECLARE
   --v_CampusID BIGINT;

   v_UpdateCursor CURSOR FOR
      SELECT a.id, m.id AS section_weekly_mtg_id,
         CAST(NULL AS VARCHAR) AS section_name, CAST(NULL AS VARCHAR) AS section_type, CAST(NULL AS BIGINT) AS parent_section_id, bd.id AS building_id, sids.room AS room_no, 
         to_char(sids.meeting_time_start, 'HH12:MI AM') AS start_time, to_char(sids.meeting_time_end, 'HH12:MI AM') AS end_time,
         CASE sids.mon WHEN 'Y' THEN '1' ELSE '0' END ||
         CASE sids.tues WHEN 'Y' THEN '1' ELSE '0' END ||
         CASE sids.wed WHEN 'Y' THEN '1' ELSE '0' END ||
         CASE sids.thurs WHEN 'Y' THEN '1' ELSE '0' END ||
         CASE sids.fri WHEN 'Y' THEN '1' ELSE '0' END ||
         CASE sids.sat WHEN 'Y' THEN '1' ELSE '0' END ||
         CASE sids.sun WHEN 'Y' THEN '1' ELSE '0' END AS days_of_week, 
         sids.start_dt AS start_date, sids.end_dt AS end_date,
         sids.enrl_tot AS enrollment_total, 
         a.section_name AS curr_section_name, a.section_type AS curr_section_type, a.parent_section_id AS curr_parent_section_id, m.building_id AS curr_building_id, m.room_no AS curr_room_no, 
         m.start_time AS curr_start_time, m.end_time AS curr_end_time,
         m.days_of_week AS curr_days_of_week,
         m.start_date AS curr_start_date, m.end_date AS curr_end_date,
         a.enrollment_total AS curr_enrollment_total,
         sids.mtg_pat_crse_id
      FROM kmdata.sections a
      INNER JOIN kmdata.offerings b ON a.offering_id = b.id
      INNER JOIN kmdata.term_sessions ts ON b.term_session_id = ts.id
      INNER JOIN kmdata.terms t ON ts.term_id = t.id
      INNER JOIN kmdata.acad_departments ad ON b.acad_department_id = ad.id
      INNER JOIN kmdata.colleges c ON ad.college_id = c.id
      INNER JOIN kmdata.campuses ca ON c.campus_id = ca.id
      INNER JOIN kmdata.courses co ON b.course_id = co.id
      INNER JOIN kmdata.subjects s ON co.subject_id = s.id
      LEFT JOIN kmdata.section_weekly_mtgs m ON a.id = m.section_id
      INNER JOIN sid.osu_section sids ON sids.yearQuarterCode = t.term_code 
         AND sids.campusId = ca.ps_location_name 
         AND sids.departmentNumber = s.subject_abbrev 
         AND sids.courseNumber = co.course_number 
         AND sids.session_code = ts.session_code 
         AND sids.acad_group = c.acad_group 
         AND sids.acad_org = ad.dept_code
         AND sids.callNumber = a.class_number 
      LEFT JOIN kmdata.buildings bd ON sids.building = bd.building_code;

   v_InsertCursor CURSOR FOR
      SELECT DISTINCT CAST(NULL AS VARCHAR) AS section_name, o.id AS offering_id, chgsect.class_number, 
         CAST(NULL AS VARCHAR) AS section_type, CAST(NULL AS BIGINT) AS parent_section_id, 
         sids.mtg_pat_crse_id,
         bds.id AS building_id, sids.room AS room_no, to_char(sids.meeting_time_start, 'HH12:MI AM') AS start_time, to_char(sids.meeting_time_end, 'HH12:MI AM') AS end_time,
         CASE sids.mon WHEN 'Y' THEN '1' ELSE '0' END ||
         CASE sids.tues WHEN 'Y' THEN '1' ELSE '0' END ||
         CASE sids.wed WHEN 'Y' THEN '1' ELSE '0' END ||
         CASE sids.thurs WHEN 'Y' THEN '1' ELSE '0' END ||
         CASE sids.fri WHEN 'Y' THEN '1' ELSE '0' END ||
         CASE sids.sat WHEN 'Y' THEN '1' ELSE '0' END ||
         CASE sids.sun WHEN 'Y' THEN '1' ELSE '0' END AS days_of_week, 
         sids.start_dt AS start_date, sids.end_dt AS end_date,
         sids.enrl_tot AS enrollment_total
      FROM
      (
         SELECT yearQuarterCode AS term_code, campusId AS ps_location_name, departmentNumber AS subject_abbrev, 
            courseNumber AS course_number, session_code, acad_group, acad_org, callNumber AS class_number
           FROM sid.osu_section ai
         EXCEPT
         SELECT ti.term_code, cai.ps_location_name, si.subject_abbrev, coi.course_number, tsi.session_code, ci.acad_group, adi.dept_code AS acad_org, xi.class_number
           FROM kmdata.sections xi
           INNER JOIN kmdata.offerings bi ON xi.offering_id = bi.id
           INNER JOIN kmdata.term_sessions tsi ON bi.term_session_id = tsi.id
           INNER JOIN kmdata.terms ti ON tsi.term_id = ti.id
           INNER JOIN kmdata.acad_departments adi ON bi.acad_department_id = adi.id
           INNER JOIN kmdata.colleges ci ON adi.college_id = ci.id
           INNER JOIN kmdata.campuses cai ON ci.campus_id = cai.id
           INNER JOIN kmdata.courses coi ON bi.course_id = coi.id
           INNER JOIN kmdata.subjects si ON coi.subject_id = si.id
      ) chgsect
      INNER JOIN sid.osu_section sids ON chgsect.term_code = sids.yearQuarterCode 
         AND chgsect.ps_location_name = sids.campusId 
         AND chgsect.subject_abbrev = sids.departmentNumber 
         AND chgsect.course_number = sids.courseNumber 
         AND chgsect.session_code = sids.session_code 
         AND chgsect.acad_group = sids.acad_group 
         AND chgsect.acad_org = sids.acad_org
         AND chgsect.class_number = sids.callNumber
      INNER JOIN kmdata.subjects s ON sids.departmentNumber = s.subject_abbrev
      INNER JOIN kmdata.courses c ON s.id = c.subject_id AND sids.courseNumber = c.course_number
      INNER JOIN kmdata.term_sessions ts ON sids.session_code = ts.session_code
      INNER JOIN kmdata.terms t ON ts.term_id = t.id AND sids.yearQuarterCode = t.term_code
      INNER JOIN kmdata.campuses cam ON sids.campusId = cam.ps_location_name
      INNER JOIN kmdata.colleges col ON cam.id = col.campus_id AND sids.acad_group = col.acad_group
      INNER JOIN kmdata.acad_departments ad ON col.id = ad.college_id AND sids.acad_org = ad.dept_code AND s.acad_org = ad.dept_code AND s.subject_abbrev = ad.abbreviation
      INNER JOIN kmdata.offerings o ON c.id = o.course_id AND ts.id = o.term_session_id AND ad.id = o.acad_department_id
      LEFT JOIN kmdata.buildings bds ON sids.building = bds.building_code;

   v_SectionsUpdated INTEGER;
   v_SectionsInserted INTEGER;
   v_ReturnString VARCHAR(4000);
   v_SectionID BIGINT;
   
   v_MPSkipped BIGINT;
   v_MPDeleted BIGINT;
   v_MPUpdated BIGINT;
   v_MP1Inserted BIGINT; -- meeting patterns inserted for updated sections
   v_MP2Inserted BIGINT; -- meeting patterns inserted for brand new sections
   
BEGIN
   --SELECT id
   --INTO v_CampusID
   --FROM kmdata.campuses
   --WHERE campus_name = 'Columbus';

   v_SectionsUpdated := 0;
   v_SectionsInserted := 0;
   v_ReturnString := '';
   
   v_MPSkipped := 0;
   v_MPDeleted := 0;
   v_MPUpdated := 0;
   v_MP1Inserted := 0;
   v_MP2Inserted := 0;
   
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
      IF COALESCE(v_updSection.section_name,'') != COALESCE(v_updSection.curr_section_name,'')
         OR COALESCE(v_updSection.section_type,'') != COALESCE(v_updSection.curr_section_type,'')
         OR COALESCE(CAST(v_updSection.parent_section_id AS VARCHAR),'') != COALESCE(CAST(v_updSection.curr_parent_section_id AS VARCHAR),'')
         OR COALESCE(CAST(v_updSection.building_id AS VARCHAR),'') != COALESCE(CAST(v_updSection.curr_building_id AS VARCHAR),'')
         OR COALESCE(v_updSection.room_no,'') != COALESCE(v_updSection.curr_room_no,'')
         OR COALESCE(v_updSection.start_time,'') != COALESCE(v_updSection.curr_start_time,'')
         OR COALESCE(v_updSection.end_time,'') != COALESCE(v_updSection.curr_end_time,'')
         OR COALESCE(v_updSection.days_of_week,'') != COALESCE(v_updSection.curr_days_of_week,'')
         OR COALESCE(CAST(v_updSection.start_date AS VARCHAR),'') != COALESCE(CAST(v_updSection.curr_start_date AS VARCHAR),'')
         OR COALESCE(CAST(v_updSection.end_date AS VARCHAR),'') != COALESCE(CAST(v_updSection.curr_end_date AS VARCHAR),'')
         OR COALESCE(CAST(v_updSection.enrollment_total AS VARCHAR),'') != COALESCE(CAST(v_updSection.curr_enrollment_total AS VARCHAR),'')
      THEN
      
         -- update the record
         UPDATE kmdata.sections
            SET section_name = v_updSection.section_name,
                section_type = v_updSection.section_type,
                parent_section_id = v_updSection.parent_section_id,
                enrollment_total = v_updSection.enrollment_total
          WHERE id = v_updSection.id;

         -- update the meeting where applicable
         IF v_updSection.section_weekly_mtg_id IS NULL THEN
            IF v_updSection.mtg_pat_crse_id IS NULL THEN
               -- no need to update anything
               v_MPSkipped := v_MPSkipped + 1;
            ELSE
               -- insert a new meeting
               INSERT INTO kmdata.section_weekly_mtgs (
                  section_id, start_time, end_time, building_id, room_no, days_of_week, start_date, end_date)
               VALUES (
                  v_updSection.id, v_updSection.start_time, v_updSection.end_time, v_updSection.building_id, v_updSection.room_no, v_updSection.days_of_week, v_updSection.start_date, v_updSection.end_date);
                  
               v_MP1Inserted := v_MP1Inserted + 1;
            END IF;
         ELSE
            IF v_updSection.mtg_pat_crse_id IS NULL THEN
               -- delete the meeting
               DELETE FROM kmdata.section_weekly_mtgs WHERE id = v_updSection.section_weekly_mtg_id;
               
               v_MPDeleted := v_MPDeleted + 1;
            ELSE
               -- udpate the meeting
               UPDATE kmdata.section_weekly_mtgs
                  SET building_id = v_updSection.building_id,
                      room_no = v_updSection.room_no,
                      start_time = v_updSection.start_time,
                      end_time = v_updSection.end_time,
                      days_of_week = v_updSection.days_of_week, 
                      start_date = v_updSection.start_date, 
                      end_date = v_updSection.end_date
                WHERE id = v_updSection.section_weekly_mtg_id;

               v_MPUpdated := v_MPUpdated + 1;
            END IF;
         END IF;
         
         v_SectionsUpdated := v_SectionsUpdated + 1;
         
      END IF;
            
   END LOOP;

   -- Step 3: insert
   FOR v_insSection IN v_InsertCursor LOOP

      -- get the next value of the sequence
      v_SectionID := nextval('kmdata.sections_id_seq');
      
      -- insert if not already there
      INSERT INTO kmdata.sections (
	 id, section_name, offering_id, class_number, section_type, parent_section_id, enrollment_total, resource_id)
      VALUES (
         v_SectionID, v_insSection.section_name, v_insSection.offering_id, v_insSection.class_number, v_insSection.section_type, v_insSection.parent_section_id, 
         v_insSection.enrollment_total, kmdata.add_new_resource('sid', 'sections'));

      -- insert the meeting
      IF v_insSection.mtg_pat_crse_id IS NOT NULL THEN
         INSERT INTO kmdata.section_weekly_mtgs (
            section_id, start_time, end_time, building_id, room_no, days_of_week, start_date, end_date)
         VALUES (
            v_SectionID, v_insSection.start_time, v_insSection.end_time, v_insSection.building_id, v_insSection.room_no, v_insSection.days_of_week, v_insSection.start_date, v_insSection.end_date);

         v_MP2Inserted := v_MP2Inserted + 1;
      END IF;
      
      v_SectionsInserted := v_SectionsInserted + 1;

   END LOOP;


   v_ReturnString := 'Sections import completed. ' || CAST(v_SectionsUpdated AS VARCHAR) || ' sections updated and ' || CAST(v_SectionsInserted AS VARCHAR) || 
      ' sections inserted. Updated section MP (UPD=' || CAST(v_MPUpdated AS VARCHAR) || 
      '; INS=' || CAST(v_MP1Inserted AS VARCHAR) || 
      '; DEL=' || CAST(v_MPDeleted AS VARCHAR) ||
      '; SKIP=' || CAST(v_MPSkipped AS VARCHAR) || 
      '). New section MP (INS=' || CAST(v_MP2Inserted AS VARCHAR) || ').';

   RETURN v_ReturnString;
END;
$$ LANGUAGE plpgsql;
