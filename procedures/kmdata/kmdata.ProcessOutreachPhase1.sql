CREATE OR REPLACE FUNCTION kmdata.ProcessOutreachPhase1 (
) RETURNS BIGINT AS $$
DECLARE
   v_intReturn BIGINT := 0;
   v_OutreachWorkMatchCount BIGINT;
   v_ResourceID BIGINT;
   v_WorkTypeID BIGINT;
   v_UserID BIGINT;
   v_WorkID BIGINT;
   v_OutreachDescriptionID BIGINT;
   v_SuccessID BIGINT;
   v_OutcomeID BIGINT;
   v_OutputTextID BIGINT;
   v_OutreachDMYDateRangeID BIGINT;
   v_CurrentLocationID BIGINT := 0;
   v_CurrentItemID BIGINT := 0;

   v_CurrentCounty VARCHAR(50);
   v_CurrentCountryName VARCHAR(80);
   v_CurrentCountryISO CHAR(2);
   v_CurrentSchool VARCHAR(255);
   v_CurrentSchoolDistrict VARCHAR(50);
   v_CurrentState VARCHAR(50);
   v_CurrentStateAbbr VARCHAR(50);

   OutreachItemsCursor CURSOR FOR
      SELECT o.item_id, o.title, o.url, o.description, o.success, o.outcome, o.people_served,
         o.hours, o.direct_cost, o.other_audience, o.other_result, o.other_subject, o.output_text,
         o.outreach_start_year, o.outreach_start_month, o.outreach_start_day,
         o.outreach_end_year, o.outreach_end_month, o.outreach_end_day, ai.profile_emplid
      FROM osupro.outreach o
      INNER JOIN osupro.academic_item ai ON o.item_id = ai.item_id;
BEGIN

   -- get the work type id
   v_WorkTypeID := kmdata.get_or_add_work_type_id('Outreach');

   -- loop over all of outreach
   FOR currOItem IN OutreachItemsCursor LOOP

      -- assign v_CurrentItemID
      v_CurrentItemID := currOItem.item_id;

      -- try to find a matching work for outreach
      /*SELECT COUNT(*) INTO v_OutreachWorkMatchCount
      FROM kmdata.works
      WHERE work_type_id = v_WorkTypeID
      AND title = currOItem.title
      AND url = currOItem.url OR url IS NULL
      AND people_served = currOItem.people_served OR people_served IS NULL
      AND hours = currOItem.hours OR hours IS NULL
      AND direct_cost = currOItem.direct_cost OR direct_cost IS NULL
      AND other_audience = currOItem.other_audience OR other_audience IS NULL
      AND other_result = currOItem.other_result OR other_result IS NULL
      AND other_subject = currOItem.other_subject OR other_subject IS NULL;*/
      v_OutreachWorkMatchCount := 0;

      -- if there is no match then process it
      IF v_OutreachWorkMatchCount < 1 THEN

         -- get the user id
         SELECT user_id INTO v_UserID
         FROM kmdata.user_identifiers
         WHERE emplid = currOItem.profile_emplid;

         IF v_UserID IS NOT NULL THEN

         -- get the resource id
         v_ResourceID := kmdata.add_new_resource('osupro', 'works');

         -- get the works sequence id
         v_WorkID := nextval('kmdata.works_id_seq');

         -- narrative long text types
         v_OutreachDescriptionID := -1;
         v_SuccessID := -1;
         v_OutcomeID := -1;
         v_OutputTextID := -1;
         -- insert the text fields into narrative
         IF currOItem.description IS NOT NULL AND TRIM(currOItem.description) != '' THEN
            v_OutreachDescriptionID := kmdata.add_new_narrative('osupro', 'Outreach Description', CAST(currOItem.description AS TEXT), 0, v_UserID);
         END IF;
         IF currOItem.success IS NOT NULL AND TRIM(currOItem.success) != '' THEN
            v_SuccessID := kmdata.add_new_narrative('osupro', 'Outreach Success', CAST(currOItem.success AS TEXT), 0, v_UserID);
         END IF;
         IF currOItem.outcome IS NOT NULL AND TRIM(currOItem.outcome) != '' THEN
            v_OutcomeID := kmdata.add_new_narrative('osupro', 'Outreach Outcome', CAST(currOItem.outcome AS TEXT), 0, v_UserID);
         END IF;
         IF currOItem.output_text IS NOT NULL AND TRIM(currOItem.output_text) != '' THEN
            v_OutputTextID := kmdata.add_new_narrative('osupro', 'Output Text', CAST(currOItem.output_text AS TEXT), 0, v_UserID);
         END IF;

         -- insert and get the date range
         v_OutreachDMYDateRangeID := kmdata.add_dmy_range_date(currOItem.outreach_start_day, currOItem.outreach_start_month, currOItem.outreach_start_year,
            currOItem.outreach_end_day, currOItem.outreach_end_month, currOItem.outreach_end_year);

         -- insert the works record (for outreach)
         INSERT INTO kmdata.works
            (id, resource_id, work_type_id, title, user_id,
             url, people_served, hours, direct_cost, other_audience,
             other_result, other_subject, outreach_dmy_range_date_id,
             created_at, updated_at)
         VALUES
            (v_WorkID, v_ResourceID, v_WorkTypeID, currOItem.title, v_UserID,
             currOItem.url, currOItem.people_served, currOItem.hours, currOItem.direct_cost, currOItem.other_audience,
             currOItem.other_result, currOItem.other_subject, v_OutreachDMYDateRangeID,
             current_timestamp, current_timestamp);

         -- create the work_authors record

         -- create the work_narratives records (4)
         IF v_OutreachDescriptionID != -1 THEN
            INSERT INTO kmdata.work_narratives (work_id, narrative_id) VALUES (v_WorkID, v_OutreachDescriptionID);
         END IF;
         IF v_SuccessID != -1 THEN
            INSERT INTO kmdata.work_narratives (work_id, narrative_id) VALUES (v_WorkID, v_SuccessID);
         END IF;
         IF v_OutcomeID != -1 THEN
            INSERT INTO kmdata.work_narratives (work_id, narrative_id) VALUES (v_WorkID, v_OutcomeID);
         END IF;
         IF v_OutputTextID != -1 THEN
            INSERT INTO kmdata.work_narratives (work_id, narrative_id) VALUES (v_WorkID, v_OutputTextID);
         END IF;
         
         -- now loop over the 5 location types
         v_CurrentLocationID := 0;

         -- county
         FOR v_CurrentCounty IN SELECT b.county FROM osupro.outreach_county a INNER JOIN osupro.location_county_ref b ON a.county_id = b.id
                           WHERE a.item_id = v_CurrentItemID
         LOOP
            -- get/add the location id for this item
            v_CurrentLocationID := kmdata.get_or_add_location_id('County', NULL, v_CurrentCounty, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

            -- attach to the work
            IF v_CurrentLocationID IS NOT NULL THEN
               INSERT INTO kmdata.work_locations
                  (work_id, location_id)
               VALUES
                  (v_WorkID, v_CurrentLocationID);
            END IF;
         END LOOP;

         v_CurrentLocationID := 0;

         -- country
         FOR v_CurrentCountryName, v_CurrentCountryISO IN SELECT b.name, b.iso FROM osupro.outreach_country a INNER JOIN osupro.location_country_ref b ON a.country_id = b.id
                                                          WHERE a.item_id = v_CurrentItemID
         LOOP
            -- get/add the location id for this item
            v_CurrentLocationID := kmdata.get_or_add_location_id('Country', NULL, v_CurrentCountryName, v_CurrentCountryISO, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

            -- attach to the work
            IF v_CurrentLocationID IS NOT NULL THEN
               INSERT INTO kmdata.work_locations
                  (work_id, location_id)
               VALUES
                  (v_WorkID, v_CurrentLocationID);
            END IF;
         END LOOP;

         v_CurrentLocationID := 0;

         -- school
         FOR v_CurrentSchool IN SELECT b.school FROM osupro.outreach_school a INNER JOIN osupro.school_ref b ON a.school_id = b.id
                                WHERE a.item_id = v_CurrentItemID
         LOOP
            -- get/add the location id for this item
            v_CurrentLocationID := kmdata.get_or_add_location_id('School', NULL, v_CurrentSchool, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

            -- attach to the work
            IF v_CurrentLocationID IS NOT NULL THEN
               INSERT INTO kmdata.work_locations
                  (work_id, location_id)
               VALUES
                  (v_WorkID, v_CurrentLocationID);
            END IF;
         END LOOP;

         v_CurrentLocationID := 0;

         -- school district
         FOR v_CurrentSchoolDistrict IN SELECT b.district FROM osupro.outreach_school_district a INNER JOIN osupro.school_district_ref b ON a.district_id = b.id
                                        WHERE a.item_id = v_CurrentItemID
         LOOP
            -- get/add the location id for this item
            v_CurrentLocationID := kmdata.get_or_add_location_id('School District', NULL, v_CurrentSchoolDistrict, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

            -- attach to the work
            IF v_CurrentLocationID IS NOT NULL THEN
               INSERT INTO kmdata.work_locations
                  (work_id, location_id)
               VALUES
                  (v_WorkID, v_CurrentLocationID);
            END IF;
         END LOOP;

         v_CurrentLocationID := 0;

         -- state
         FOR v_CurrentState, v_CurrentStateAbbr IN SELECT b.state, b.abbreviation FROM osupro.outreach_state a INNER JOIN osupro.location_state_ref b ON a.state_id = b.id
                                                   WHERE a.item_id = v_CurrentItemID
         LOOP
            -- get/add the location id for this item
            v_CurrentLocationID := kmdata.get_or_add_location_id('State', NULL, v_CurrentState, v_CurrentStateAbbr, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

            -- attach to the work
            IF v_CurrentLocationID IS NOT NULL THEN
               INSERT INTO kmdata.work_locations
                  (work_id, location_id)
               VALUES
                  (v_WorkID, v_CurrentLocationID);
            END IF;
         END LOOP;

         END IF; -- end NOT NULL check on user_id
         
      END IF;
      
   END LOOP;

   RETURN v_intReturn;
END;
$$ LANGUAGE plpgsql;
