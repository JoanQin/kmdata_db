      SELECT DISTINCT CAST(NULL AS VARCHAR) AS section_name, o.id AS offering_id, chgsect.class_number, 
         CAST(NULL AS VARCHAR) AS section_type, CAST(NULL AS BIGINT) AS parent_section_id, 
         bds.id AS building_id, sids.room AS room_no, sids.startTime AS start_time, sids.endTime AS end_time
      FROM
      (
         SELECT yearQuarterCode AS term_code, campusId AS campus_name, departmentNumber AS subject_abbrev, 
            courseNumber AS course_number, session_code, acad_group, acad_org, callNumber AS class_number
           FROM sid.osu_section ai
         EXCEPT
         SELECT ti.term_code, cai.campus_name, si.subject_abbrev, coi.course_number, tsi.session_code, ci.acad_group, adi.dept_code AS acad_org, xi.class_number
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
         AND chgsect.campus_name = sids.campusId 
         AND chgsect.subject_abbrev = sids.departmentNumber 
         AND chgsect.course_number = sids.courseNumber 
         AND chgsect.session_code = sids.session_code 
         AND chgsect.acad_group = sids.acad_group 
         AND chgsect.acad_org = sids.acad_org
         AND chgsect.class_number = sids.callNumber
      INNER JOIN kmdata.buildings bds ON sids.building = bds.building_code
      INNER JOIN kmdata.subjects s ON sids.departmentNumber = s.subject_abbrev
      INNER JOIN kmdata.courses c ON s.id = c.subject_id AND sids.courseNumber = c.course_number
      INNER JOIN kmdata.term_sessions ts ON sids.session_code = ts.session_code
      INNER JOIN kmdata.terms t ON ts.term_id = t.id AND sids.yearQuarterCode = t.term_code
      INNER JOIN kmdata.campuses cam ON sids.campusId = cam.ps_location_name
      INNER JOIN kmdata.colleges col ON cam.id = col.campus_id AND sids.acad_group = col.acad_group
      INNER JOIN kmdata.acad_departments ad ON col.id = ad.college_id AND sids.acad_org = ad.dept_code
      INNER JOIN kmdata.offerings o ON c.id = o.course_id AND ts.id = o.term_session_id AND ad.id = o.acad_department_id;

