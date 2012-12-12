CREATE OR REPLACE FUNCTION kmdata.ProcessCreativeWorks (
) RETURNS BIGINT AS $$
DECLARE
   v_intResourceID BIGINT;
   v_intSourceID BIGINT;
   v_intWorkID BIGINT;
   v_intNewItemID BIGINT;
   v_intMatchCount INTEGER;
   v_intCreativeWorkID BIGINT;
   v_intCreativeWorkDateCollID BIGINT;
   v_strAuthorEmplid VARCHAR(11);
   v_dtmCreateDate TIMESTAMP;
   v_dtmModifiedDate TIMESTAMP;
   v_intUserID BIGINT;
   v_intUserCount INTEGER;
   v_intKMDataCreativeWorkTypeID BIGINT;

   worksQuery CURSOR FOR 
      SELECT a.item_id, a.creative_work_type_id, a.artist, a.composer, a.event_title, a.role_designator, a.title,
         a.title_in, a.format, a.program_length, a.medium, a.dimensions, a.series, a.city, a.state, a.country, a.sponsor, a.venue,
         a.url, a.forthcoming_id, a.percent_authorship, a.description, a.author_date_citation, a.bibliography_citation,
         a.edition, a.volume, a.publisher, a.collector, a.collection, a.artwork_id, a.exhibit_title, a.exhibition_type_id,
         a.juried_ind, a.curator, a.audience, a.juror, a.piece_description, a.inventor, a.name, a.patent_number, a.manufacturer,
         a.format_id, a.director, a.performer, a.network, a.distributor, a.station_call_number, a.author, a.duration, a.media_collection,
         a.publication_location, a.volume_number, a.participant, a.episode_title, a.recital_performance_type_id, a.performance_company,
         a.writer, a.based_on, a.organizer, a.publication_yearborked, a.ad_location, a.beginning_page, a.ending_page, a.event_location,
         a.publication_title, a.other_info, 
         b.presentation_year, b.presentation_month, b.presentation_day, b.presentation_end_year, b.presentation_end_month, b.presentation_end_day,
         b.performance_start_date, b.performance_end_date, b.performance_start_year, b.performance_start_month, b.performance_start_day, b.performance_end_year, 
         b.performance_end_month, b.performance_end_day, b.exhibit_start_year, b.exhibit_start_month, b.exhibit_start_day, b.exhibit_end_year, b.exhibit_end_month,
         b.exhibit_end_day, b.filed_date, b.issued_date, b.filed_year, b.filed_month, b.filed_day, b.year, b.issued_year, b.issued_month, b.issued_day, b.publication_year,
         b.publication_month, b.publication_day, b.presentation_start_year, b.presentation_start_month, b.presentation_start_day, b.last_update_year, b.last_update_month,
         b.last_update_day, b.creation_year, b.creation_month, b.creation_day, b.broadcast_date, b.broadcast_year, b.broadcast_month, b.broadcast_day, b.disclosure_year,
         b.disclosure_month, b.disclosure_day
	FROM osupro.creative_work a
	INNER JOIN osupro.creative_work_date_collection b ON a.item_id = b.item_id
	ORDER BY article_title DESC, journal_title DESC;

BEGIN
   -- select and return the existing id
   v_intNewItemID := 0;

   -- get the peoplesoft source id
   SELECT id INTO v_intSourceID FROM kmdata.sources WHERE source_name = 'osupro';
   
   -- loop over the cursor
   FOR currWork IN worksQuery LOOP

      -- get the user id
      SELECT profile_emplid, create_date, modified_date INTO v_strAuthorEmplid, v_dtmCreateDate, v_dtmModifiedDate
      FROM osupro.academic_item
      WHERE item_id = currWork.item_id;

      -- check if the count is zero or one
      SELECT COUNT(*) INTO v_intUserCount
      FROM kmdata.user_identifiers
      WHERE emplid = v_strAuthorEmplid;

      IF v_intUserCount = 1 THEN
         
         SELECT user_id INTO v_intUserID
         FROM kmdata.user_identifiers
         WHERE emplid = v_strAuthorEmplid;
   
         -- lookup to see if there is another article that matches identification information
         SELECT COUNT(*) INTO v_intMatchCount
         FROM kmdata.creative_works p
         LEFT JOIN kmdata.creative_work_date_collections p2 ON p.id = p2.creative_work_id
         WHERE p.title = currWork.title
         AND (p.title_in = currWork.title_in OR p.title_in IS NULL)
         AND (p.creative_work_type_id = currWork.creative_work_type_id OR p.creative_work_type_id IS NULL)
         AND (p2.creation_year = currWork.creation_year OR p2.creation_year IS NULL)
         AND (p2.creation_month = currWork.creation_month OR p2.creation_month IS NULL)
         AND (p2.creation_day = currWork.creation_day OR p2.creation_day IS NULL)
         AND (p.city = currWork.city OR p.city IS NULL)
         AND (p.state = currWork.state OR p.state IS NULL)
         AND (p.country = currWork.country OR p.country IS NULL);
   
         -- if there is an article, check if the author exists in the users table then insert into work_authors table
         IF v_intMatchCount <= 0 THEN
   
            -- insert resource and get resource id
            v_intResourceID := nextval('kmdata.resources_id_seq');
   
            INSERT INTO kmdata.resources (id, source_id) VALUES (v_intResourceID, v_intSourceID);
   
            -- insert work (kmdata.works)
            v_intWorkID := nextval('kmdata.works_id_seq');
   
            INSERT INTO kmdata.works
               (id, resource_id, title, user_id, created_at, updated_at)
            VALUES
               (v_intWorkID, v_intResourceID, currWork.article_title, v_intUserID, v_dtmCreateDate, v_dtmModifiedDate);

            -- read in the publication type
            SELECT b.id INTO v_intKMDataCreativeWorkTypeID
            FROM osupro.creative_work_type_ref a
            INNER JOIN kmdata.creative_work_type_refs b ON a.creative_work_type_descr = b.creative_work_type_descr
            WHERE a.creative_work_type_id = currWork.creative_work_type_id;
   
            -- read from the sequence
            v_intCreativeWorkID := nextval('kmdata.creative_works_id_seq');
   
            -- insert the article using the creative works id ID
            INSERT INTO kmdata.creative_works
               (id, work_id, creative_work_type_id, artist, composer, event_title, role_designator, title,
                title_in, format, program_length, medium, dimensions, series, city, state, country, sponsor, venue,
                url, forthcoming_id, percent_authorship, description, author_date_citation, bibliography_citation,
                edition, volume, publisher, collector, collection, artwork_id, exhibit_title, exhibition_type_id,
                juried_ind, curator, audience, juror, piece_description, inventor, "name", patent_number, manufacturer,
                format_id, director, performer, network, distributor, station_call_number, author, duration, media_collection,
                publication_location, volume_number, participant, episode_title, recital_performance_type_id, performance_company,
                writer, based_on, organizer, publication_yearborked, ad_location, beginning_page, ending_page, event_location,
                publication_title, other_info)
            VALUES
               (v_intCreativeWorkID, v_intWorkID, v_intKMDataCreativeWorkTypeID, 
                currWork.artist, currWork.composer, currWork.event_title, currWork.role_designator, currWork.title,
                currWork.title_in, currWork.format, currWork.program_length, currWork.medium, currWork.dimensions, currWork.series, currWork.city, currWork.state, currWork.country, currWork.sponsor, currWork.venue,
                currWork.url, currWork.forthcoming_id, currWork.percent_authorship, currWork.description, currWork.author_date_citation, currWork.bibliography_citation,
                currWork.edition, currWork.volume, currWork.publisher, currWork.collector, currWork.collection, currWork.artwork_id, currWork.exhibit_title, currWork.exhibition_type_id,
                currWork.juried_ind, currWork.curator, currWork.audience, currWork.juror, currWork.piece_description, currWork.inventor, currWork.name, currWork.patent_number, currWork.manufacturer,
                currWork.format_id, currWork.director, currWork.performer, currWork.network, currWork.distributor, currWork.station_call_number, currWork.author, currWork.duration, currWork.media_collection,
                currWork.publication_location, currWork.volume_number, currWork.participant, currWork.episode_title, currWork.recital_performance_type_id, currWork.performance_company,
                currWork.writer, currWork.based_on, currWork.organizer, currWork.publication_yearborked, currWork.ad_location, currWork.beginning_page, currWork.ending_page, currWork.event_location,
                currWork.publication_title, currWork.other_info);

            -- read from the date collection sequence
            v_intCreativeWorkDateCollID := nextval('kdmata.creative_work_date_collections_id_seq');
            
            -- insert the date information in creative_work_date_collections
            INSERT INTO kmdata.creative_work_date_collections
               (id, creative_work_id, presentation_year, presentation_month, presentation_day, presentation_end_year, presentation_end_month, presentation_end_day,
                performance_start_date, performance_end_date, performance_start_year, performance_start_month, performance_start_day, performance_end_year, 
                performance_end_month, performance_end_day, exhibit_start_year, exhibit_start_month, exhibit_start_day, exhibit_end_year, exhibit_end_month,
                exhibit_end_day, filed_date, issued_date, filed_year, filed_month, filed_day, year, issued_year, issued_month, issued_day, publication_year,
                publication_month, publication_day, presentation_start_year, presentation_start_month, presentation_start_day, last_update_year, last_update_month,
                last_update_day, creation_year, creation_month, creation_day, broadcast_date, broadcast_year, broadcast_month, broadcast_day, disclosure_year,
                disclosure_month, disclosure_day)
            VALUES
               (v_intCreativeWorkDateCollID, v_intCreativeWorkID,
                currWork.presentation_year, currWork.presentation_month, currWork.presentation_day, currWork.presentation_end_year, currWork.presentation_end_month, currWork.presentation_end_day,
                currWork.performance_start_date, currWork.performance_end_date, currWork.performance_start_year, currWork.performance_start_month, currWork.performance_start_day, currWork.performance_end_year, 
                currWork.performance_end_month, currWork.performance_end_day, currWork.exhibit_start_year, currWork.exhibit_start_month, currWork.exhibit_start_day, currWork.exhibit_end_year, currWork.exhibit_end_month,
                currWork.exhibit_end_day, currWork.filed_date, currWork.issued_date, currWork.filed_year, currWork.filed_month, currWork.filed_day, currWork.year, currWork.issued_year, currWork.issued_month, currWork.issued_day, currWork.publication_year,
                currWork.publication_month, currWork.publication_day, currWork.presentation_start_year, currWork.presentation_start_month, currWork.presentation_start_day, currWork.last_update_year, currWork.last_update_month,
                currWork.last_update_day, currWork.creation_year, currWork.creation_month, currWork.creation_day, currWork.broadcast_date, currWork.broadcast_year, currWork.broadcast_month, currWork.broadcast_day, currWork.disclosure_year,
                currWork.disclosure_month, currWork.disclosure_day);
   
         ELSE
   
            -- get the creative work id
            SELECT p.id INTO v_intCreativeWorkID
            FROM kmdata.creative_works p
            LEFT JOIN kmdata.creative_work_date_collections p2 ON p.id = p2.creative_work_id
            WHERE p.title = currWork.title
            AND (p.title_in = currWork.title_in OR p.title_in IS NULL)
            AND (p.creative_work_type_id = currWork.creative_work_type_id OR p.creative_work_type_id IS NULL)
            AND (p2.creation_year = currWork.creation_year OR p2.creation_year IS NULL)
            AND (p2.creation_month = currWork.creation_month OR p2.creation_month IS NULL)
            AND (p2.creation_day = currWork.creation_day OR p2.creation_day IS NULL)
            AND (p.city = currWork.city OR p.city IS NULL)
            AND (p.state = currWork.state OR p.state IS NULL)
            AND (p.country = currWork.country OR p.country IS NULL)
            ORDER BY p.id ASC
            LIMIT 1;
   
         END IF;
   
         -- insert into the publication_authors table
         DECLARE
         BEGIN
            INSERT INTO kmdata.publication_authors
               (publication_id, user_id)
            VALUES
               (v_intCreativeWorkID, v_intUserID);
         EXCEPTION
            WHEN OTHERS THEN
               INSERT INTO kmdata.import_errors (error_number, message_varchar) 
               VALUES (SQLSTATE, 'INSERT into kmdata.publication_authors failed with work_id == ' || 
                       CAST(v_intCreativeWorkID AS CHAR) || ' and user_id == ' || CAST(v_intUserID AS CHAR) || '. Not inserted.');
         END;
   
      ELSE

         -- the count was not a single record
         INSERT INTO kmdata.import_errors (message_varchar) 
         VALUES ('creative_works INSERT error (non-single match): ' || 
                 CAST(v_intUserCount AS CHAR) || ' users matched EMPLID ' || v_strAuthorEmplid || '. Record skipped.'
         );
         
      END IF;
      
   END LOOP;

   RETURN v_intNewItemID;
END;
$$ LANGUAGE plpgsql;
