CREATE OR REPLACE FUNCTION kmdata.ProcessArticles (
) RETURNS BIGINT AS $$
DECLARE
   v_intResourceID BIGINT;
   v_intSourceID BIGINT;
   v_intWorkID BIGINT;
   v_intNewItemID BIGINT;
   v_intMatchCount INTEGER;
   v_intPublicationID BIGINT;
   v_strAuthorEmplid VARCHAR(11);
   v_dtmCreateDate TIMESTAMP;
   v_dtmModifiedDate TIMESTAMP;
   v_intUserID BIGINT;
   v_intUserCount INTEGER;
   v_intKMDataPublicationTypeID BIGINT;

   worksQuery CURSOR FOR SELECT "item_id", "publication_type_id", "journal_article_type_id", "publication_year", "publication_month", 
	"publication_day", "author", "editor", "reviewer", "article_title", "journal_title", "review_type_id", "edition", "volume", "issue", 
	"technical_report_number", "submitted_to", "submission_date", "city", "state", "country", "series", "sponsor", "beginning_page", 
	"ending_page", "url", "percent_authorship", "description", "author_date_citation", "bibliography_citation", "research_report_citation", 
	"research_report_ind", "impact_factor", "issn", "publisher", "publication_location", "collection", "site_last_viewed_date", "publication_media_type_id", 
	"status_id", "abstract_type_id", "peer_reviewed_ind", "submission_year", "submission_month", "submission_day", "presentation_role_id", 
	"presentation_location_descr", "presentation_location_type_id", "audience_name", "event_title", "invited_talk", "publication_title", 
	"old_compiler", "degree", "acceptance_rate", "presentation_start_year", "presentation_start_month", "presentation_start_day", "presentation_end_year", 
	"presentation_end_month", "presentation_end_day", "role_id"
	FROM osupro.publication
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
         FROM kmdata.publications p
         WHERE p.article_title = currWork.article_title
         AND (p.journal_title = currWork.journal_title OR p.journal_title IS NULL)
         AND (p.publication_type_id = currWork.publication_type_id OR p.publication_type_id IS NULL)
         AND (p.publication_year = currWork.publication_year OR p.publication_year IS NULL)
         AND (p.publication_month = currWork.publication_month OR p.publication_month IS NULL)
         AND (p.publication_day = currWork.publication_day OR p.publication_day IS NULL)
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
            SELECT b.id INTO v_intKMDataPublicationTypeID
            FROM osupro.publication_type_ref a
            INNER JOIN kmdata.publication_type_refs b ON a.publication_type_descr = b.publication_type_descr
            WHERE a.publication_type_id = currWork.publication_type_id;
   
            -- read from the sequence
            v_intPublicationID := nextval('kmdata.publications_id_seq');
   
            -- insert the article using the publication ID
            INSERT INTO kmdata.publications
               (id, work_id, publication_type_id, journal_article_type_id, publication_year, publication_month, 
                publication_day, author, editor, reviewer, article_title, journal_title, review_type_id, edition, volume, issue, 
                technical_report_number, submitted_to, submission_date, city, state, country, series, sponsor, beginning_page, 
                ending_page, url, percent_authorship, description, author_date_citation, bibliography_citation, research_report_citation, 
                research_report_ind, impact_factor, issn, publisher, publication_location, collection, site_last_viewed_date, publication_media_type_id, 
                status_id, abstract_type_id, peer_reviewed_ind, submission_year, submission_month, submission_day, presentation_role_id, 
                presentation_location_descr, presentation_location_type_id, audience_name, event_title, invited_talk, publication_title, 
                old_compiler, degree, acceptance_rate, presentation_start_year, presentation_start_month, presentation_start_day, presentation_end_year, 
                presentation_end_month, presentation_end_day, role_id)
            VALUES
               (v_intPublicationID, v_intWorkID, v_intKMDataPublicationTypeID, currWork.journal_article_type_id, currWork.publication_year, currWork.publication_month, 
                currWork.publication_day, currWork.author, currWork.editor, currWork.reviewer, currWork.article_title, currWork.journal_title, currWork.review_type_id, currWork.edition, currWork.volume, currWork.issue, 
                currWork.technical_report_number, currWork.submitted_to, currWork.submission_date, currWork.city, currWork.state, currWork.country, currWork.series, currWork.sponsor, currWork.beginning_page, 
                currWork.ending_page, currWork.url, currWork.percent_authorship, currWork.description, currWork.author_date_citation, currWork.bibliography_citation, currWork.research_report_citation, 
                currWork.research_report_ind, currWork.impact_factor, currWork.issn, currWork.publisher, currWork.publication_location, currWork.collection, currWork.site_last_viewed_date, currWork.publication_media_type_id, 
                currWork.status_id, currWork.abstract_type_id, currWork.peer_reviewed_ind, currWork.submission_year, currWork.submission_month, currWork.submission_day, currWork.presentation_role_id, 
                currWork.presentation_location_descr, currWork.presentation_location_type_id, currWork.audience_name, currWork.event_title, currWork.invited_talk, currWork.publication_title, 
                currWork.old_compiler, currWork.degree, currWork.acceptance_rate, currWork.presentation_start_year, currWork.presentation_start_month, currWork.presentation_start_day, currWork.presentation_end_year, 
                currWork.presentation_end_month, currWork.presentation_end_day, currWork.role_id);
   
         ELSE
   
            -- get the publication id
            SELECT p.id INTO v_intPublicationID
            FROM kmdata.publications p
            WHERE p.article_title = currWork.article_title
            AND (p.journal_title = currWork.journal_title OR p.journal_title IS NULL)
            AND (p.publication_type_id = currWork.publication_type_id OR p.publication_type_id IS NULL)
            AND (p.publication_year = currWork.publication_year OR p.publication_year IS NULL)
            AND (p.publication_month = currWork.publication_month OR p.publication_month IS NULL)
            AND (p.publication_day = currWork.publication_day OR p.publication_day IS NULL)
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
               (v_intPublicationID, v_intUserID);
         EXCEPTION
            WHEN OTHERS THEN
               INSERT INTO kmdata.import_errors (error_number, message_varchar) 
               VALUES (SQLSTATE, 'INSERT into kmdata.publication_authors failed with work_id == ' || 
                       CAST(v_intPublicationID AS CHAR) || ' and user_id == ' || CAST(v_intUserID AS CHAR) || '. Not inserted.');
         END;
   
      ELSE

         -- the count was not a single record
         INSERT INTO kmdata.import_errors (message_varchar) 
         VALUES ('Publications INSERT error (non-single match): ' || 
                 CAST(v_intUserCount AS CHAR) || ' users matched EMPLID ' || v_strAuthorEmplid || '. Record skipped.'
         );
         
      END IF;
      
   END LOOP;

   RETURN v_intNewItemID;
END;
$$ LANGUAGE plpgsql;
