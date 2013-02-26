CREATE OR REPLACE FUNCTION kmdata.import_section_weekly_mtgs_from_sid (
) RETURNS VARCHAR AS $$
DECLARE

   v_UpdateCursor CURSOR FOR
      SELECT DISTINCT m.id,
         to_char(sidp.meeting_time_start, 'HH12:MI AM') AS start_time, to_char(sidp.meeting_time_end, 'HH12:MI AM') AS end_time,
         bd.id AS building_id, sidp.facility_room AS room_no, 
         sidp.start_dt AS start_date, sidp.end_dt AS end_date,
         CASE sidp.mon WHEN 'Y' THEN '1' ELSE '0' END ||
         CASE sidp.tues WHEN 'Y' THEN '1' ELSE '0' END ||
         CASE sidp.wed WHEN 'Y' THEN '1' ELSE '0' END ||
         CASE sidp.thurs WHEN 'Y' THEN '1' ELSE '0' END ||
         CASE sidp.fri WHEN 'Y' THEN '1' ELSE '0' END ||
         CASE sidp.sat WHEN 'Y' THEN '1' ELSE '0' END ||
         CASE sidp.sun WHEN 'Y' THEN '1' ELSE '0' END AS days_of_week, 
         m.start_time AS curr_start_time, m.end_time AS curr_end_time,
         m.building_id AS curr_building_id, m.room_no AS curr_room_no, 
         m.start_date AS curr_start_date, m.end_date AS curr_end_date,
         m.days_of_week AS curr_days_of_week
      FROM kmdata.section_weekly_mtgs m
      INNER JOIN kmdata.sections sc ON m.section_id = sc.id
      INNER JOIN kmdata.offerings o ON sc.offering_id = o.id
      INNER JOIN kmdata.courses co ON o.course_id = co.id
      INNER JOIN kmdata.term_sessions ts ON sc.term_session_id = ts.id
      INNER JOIN kmdata.terms t ON ts.term_id = t.id
      INNER JOIN sid.ps_class_mtg_pat sidp ON co.ps_course_id = sidp.crse_id
         AND o.ps_course_offer_number = sidp.crse_offer_nbr
         AND t.term_code = sidp.strm
         AND ts.session_code = sidp.session_code
         AND sc.ps_class_section = sidp.class_section
         AND m.ps_class_mtg_number = sidp.class_mtg_nbr
      LEFT JOIN kmdata.buildings bd ON sidp.facility_bldg_cd = bd.building_code;
	  
   v_InsertCursor CURSOR FOR
      SELECT DISTINCT sct.id AS section_id, sidm.class_mtg_nbr AS ps_class_mtg_number,
         to_char(sidm.meeting_time_start, 'HH12:MI AM') AS start_time, to_char(sidm.meeting_time_end, 'HH12:MI AM') AS end_time,
         bds.id AS building_id, sidm.facility_room AS room_no,
         CASE sidm.mon WHEN 'Y' THEN '1' ELSE '0' END ||
         CASE sidm.tues WHEN 'Y' THEN '1' ELSE '0' END ||
         CASE sidm.wed WHEN 'Y' THEN '1' ELSE '0' END ||
         CASE sidm.thurs WHEN 'Y' THEN '1' ELSE '0' END ||
         CASE sidm.fri WHEN 'Y' THEN '1' ELSE '0' END ||
         CASE sidm.sat WHEN 'Y' THEN '1' ELSE '0' END ||
         CASE sidm.sun WHEN 'Y' THEN '1' ELSE '0' END AS days_of_week, 
         sidm.start_dt AS start_date, sidm.end_dt AS end_date
      FROM
      (
         SELECT ai.crse_id, ai.crse_offer_nbr, tsi.id AS term_session_id, ai.class_section, ai.class_mtg_nbr, ai.strm, ai.session_code
         FROM sid.ps_class_mtg_pat ai
         INNER JOIN kmdata.terms ti ON ai.strm = ti.term_code
         INNER JOIN kmdata.term_sessions tsi ON ti.id = tsi.term_id AND ai.session_code = tsi.session_code
         EXCEPT
         SELECT coi.ps_course_id AS crse_id, bi.ps_course_offer_number AS crse_offer_nbr, xi.term_session_id, xi.ps_class_section AS class_section, mi.ps_class_mtg_number AS class_mtg_nbr, 
            ti.term_code AS strm, tsi.session_code AS session_code
         FROM kmdata.section_weekly_mtgs mi
         INNER JOIN kmdata.sections xi ON mi.section_id = xi.id
         INNER JOIN kmdata.offerings bi ON xi.offering_id = bi.id
         INNER JOIN kmdata.term_sessions tsi ON xi.term_session_id = tsi.id
         INNER JOIN kmdata.terms ti ON tsi.term_id = ti.id
         INNER JOIN kmdata.courses coi ON bi.course_id = coi.id
      ) chgmtg
      INNER JOIN sid.ps_class_mtg_pat sidm ON chgmtg.crse_id = sidm.crse_id
         AND chgmtg.crse_offer_nbr = sidm.crse_offer_nbr
         AND chgmtg.strm = sidm.strm
         AND chgmtg.session_code = sidm.session_code
         AND chgmtg.class_section = sidm.class_section
         AND chgmtg.class_mtg_nbr = sidm.class_mtg_nbr
      INNER JOIN kmdata.courses c ON sidm.crse_id = c.ps_course_id
      INNER JOIN kmdata.offerings o ON c.id = o.course_id AND sidm.crse_offer_nbr = o.ps_course_offer_number
      INNER JOIN kmdata.sections sct ON o.id = sct.offering_id AND sidm.class_section = sct.ps_class_section
      LEFT JOIN kmdata.buildings bds ON sidm.facility_bldg_cd = bds.building_code;
	  
   v_ReturnString VARCHAR(4000);
   v_MeetingID BIGINT;
   
   v_MeetingsUpdated INTEGER;
   v_MeetingsInserted INTEGER;
   v_MeetingsDeleted INTEGER;
   
BEGIN
   v_MeetingsUpdated := 0;
   v_MeetingsInserted := 0;
   v_MeetingsDeleted := 0;
   
   -- Step 1: delete current emails that are no longer here
   
   
   
   -- Step 2: update
   FOR v_updMP IN v_UpdateCursor LOOP

      -- if this has changed then update
      IF COALESCE(CAST(v_updMP.start_time AS VARCHAR),'') != COALESCE(CAST(v_updMP.curr_start_time AS VARCHAR),'')
         OR COALESCE(CAST(v_updMP.end_time AS VARCHAR),'') != COALESCE(CAST(v_updMP.curr_end_time AS VARCHAR),'')
         OR COALESCE(CAST(v_updMP.building_id AS VARCHAR),'') != COALESCE(CAST(v_updMP.curr_building_id AS VARCHAR),'')
         OR COALESCE(v_updMP.room_no,'') != COALESCE(v_updMP.curr_room_no,'')
         OR COALESCE(CAST(v_updMP.start_date AS VARCHAR),'') != COALESCE(CAST(v_updMP.curr_start_date AS VARCHAR),'')
         OR COALESCE(CAST(v_updMP.end_date AS VARCHAR),'') != COALESCE(CAST(v_updMP.curr_end_date AS VARCHAR),'')
         OR COALESCE(v_updMP.days_of_week,'') != COALESCE(v_updMP.curr_days_of_week)
      THEN
      
         -- update the record
         UPDATE kmdata.section_weekly_mtgs
            SET start_time = v_updMP.start_time,
                end_time = v_updMP.end_time,
                building_id = v_updMP.building_id,
                room_no = v_updMP.room_no,
                start_date = v_updMP.start_date,
                end_date = v_updMP.end_date,
                days_of_week = v_updMP.days_of_week
          WHERE id = v_updMP.id;

         v_MeetingsUpdated := v_MeetingsUpdated + 1;
         
      END IF;
            
   END LOOP;
   
   
   -- Step 3: insert
   FOR v_insMP IN v_InsertCursor LOOP

      -- get the next value of the sequence
      v_MeetingID := nextval('kmdata.section_weekly_mtgs_id_seq');
      
      -- insert if not already there
      INSERT INTO kmdata.section_weekly_mtgs (
         id, section_id, ps_class_mtg_number, start_time, end_time, 
         building_id, room_no, days_of_week, start_date, end_date, resource_id)
      VALUES (
         v_MeetingID, v_insMP.section_id, v_insMP.ps_class_mtg_number, v_insMP.start_time, v_insMP.end_time, 
         v_insMP.building_id, v_insMP.room_no, v_insMP.days_of_week, v_insMP.start_date, v_insMP.end_date, kmdata.add_new_resource('sid', 'section_weekly_mtgs'));

      v_MeetingsInserted := v_MeetingsInserted + 1;

   END LOOP;
   
   
   v_ReturnString := 'Section meeting patterns import completed. ' || CAST(v_MeetingsUpdated AS VARCHAR) || ' meetings updated and ' || CAST(v_MeetingsInserted AS VARCHAR) || ' meetings inserted.';

   RETURN v_ReturnString;
END;
$$ LANGUAGE plpgsql;
