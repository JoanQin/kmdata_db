CREATE OR REPLACE FUNCTION kmdata.import_offerings_from_sid (
) RETURNS VARCHAR AS $$
DECLARE
   --v_CampusID BIGINT;

   v_UpdateCursor CURSOR FOR
      SELECT DISTINCT o.id, o.course_id, a.yearQuarterCode AS year_term_code, a.callNumber AS call_number,
         ou.longTitle AS offering_name,
         o.offering_name AS curr_offering_name
      FROM sid.osu_offering a
      INNER JOIN kmdata.acad_departments ad ON a.departmentNumber = ad.abbreviation
      INNER JOIN kmdata.courses c ON ad.id = c.acad_department_id AND a.courseNumber = c.course_number
      INNER JOIN kmdata.offerings o ON c.id = o.course_id AND c.year_term_code = o.year_term_code AND a.callNumber = o.call_number
      INNER JOIN sid.osu_unit ou ON a.id = ou.id;
   
   v_InsertCursor CURSOR FOR
      SELECT DISTINCT e.id AS course_id, chgoffer.year_term_code, chgoffer.call_number, f.longTitle AS offering_name
      FROM
      (
         SELECT ai.departmentNumber AS department_number, ai.courseNumber AS course_number, ai.yearQuarterCode AS year_term_code, callNumber AS call_number
           FROM sid.osu_offering ai
         EXCEPT
         SELECT z.abbreviation AS department_number, y.course_number, x.year_term_code, x.call_number
           FROM kmdata.offerings x
           INNER JOIN kmdata.courses y ON x.course_id = y.id
           INNER JOIN kmdata.acad_departments z ON y.acad_department_id = z.id
      ) chgoffer
      INNER JOIN sid.osu_offering a ON chgoffer.department_number = a.departmentNumber AND chgoffer.course_number = a.courseNumber AND chgoffer.year_term_code = a.yearQuarterCode AND chgoffer.call_number = a.callNumber
      INNER JOIN sid.matvw_unit_association b ON b.unit_association_type_name = 'Course Offerings' AND a.id = b.childunitid
      INNER JOIN sid.osu_course c ON b.parentunitid = c.id
      INNER JOIN kmdata.acad_departments d ON a.departmentNumber = d.abbreviation
      INNER JOIN kmdata.courses e ON d.id = e.acad_department_id AND chgoffer.course_number = e.course_number
      INNER JOIN sid.osu_unit f ON a.id = f.id;
      
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
      IF v_updOffering.offering_name != v_updOffering.curr_offering_name
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
	 offering_name, course_id, year_term_code, call_number, resource_id)
      VALUES (
         v_insOffering.offering_name, v_insOffering.course_id, v_insOffering.year_term_code, v_insOffering.call_number, kmdata.add_new_resource('sid', 'offerings'));

      v_OfferingsInserted := v_OfferingsInserted + 1;

   END LOOP;


   v_ReturnString := 'Offerings import completed. ' || CAST(v_OfferingsUpdated AS VARCHAR) || ' offerings updated and ' || CAST(v_OfferingsInserted AS VARCHAR) || ' offerings inserted.';

   RETURN v_ReturnString;
END;
$$ LANGUAGE plpgsql;
