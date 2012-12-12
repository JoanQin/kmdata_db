CREATE OR REPLACE FUNCTION kmdata.transfer_publications (
) RETURNS BIGINT AS $$
DECLARE
   v_intNewItemID BIGINT;
   v_DescriptionNarrativeCount BIGINT;
   v_DescriptionNarrativeID BIGINT;
   worksQuery CURSOR FOR SELECT
        work_id, "publication_type_id", "journal_article_type_id", "publication_year", "publication_month", 
	"publication_day", "author", "editor", "reviewer", "article_title", "journal_title", "review_type_id", "edition", "volume", "issue", 
	"technical_report_number", "submitted_to", "submission_date", "city", "state", "country", "series", "sponsor", "beginning_page", 
	"ending_page", "url", "percent_authorship", "description", "author_date_citation", "bibliography_citation", "research_report_citation", 
	"research_report_ind", "impact_factor", "issn", "publisher", "publication_location", "collection", "site_last_viewed_date", "publication_media_type_id", 
	"status_id", "abstract_type_id", "peer_reviewed_ind", "submission_year", "submission_month", "submission_day", "presentation_role_id", 
	"presentation_location_descr", "presentation_location_type_id", "audience_name", "event_title", "invited_talk", "publication_title", 
	"old_compiler", "degree", "acceptance_rate", "presentation_start_year", "presentation_start_month", "presentation_start_day", "presentation_end_year", 
	"presentation_end_month", "presentation_end_day", "role_id", wt.id AS work_type_id
	FROM kmdata.publications pub
	LEFT JOIN kmdata.publication_type_refs ptr ON pub.publication_type_id = ptr.id
	LEFT JOIN kmdata.work_types wt ON ptr.publication_type_descr = wt.work_type_name;
BEGIN
   -- select and return the existing id
   v_intNewItemID := 0;

   FOR currWork IN worksQuery LOOP

      -- insert dates and return id's
      --   note: this is done inline in the update statement

      -- update the narratives for this work
      SELECT COUNT(*) INTO v_DescriptionNarrativeCount
      FROM kmdata.work_narratives a
      INNER JOIN kmdata.narratives b ON a.narrative_id = b.id
      INNER JOIN kmdata.narrative_types c ON b.narrative_type_id = c.id
      WHERE a.work_id = currWork.work_id
      AND c.narrative_desc = 'Work Description';

      IF v_DescriptionNarrativeCount < 1 AND currWork.description IS NOT NULL AND TRIM(currWork.description) != '' THEN

         -- add to the narrative table
         v_DescriptionNarrativeID := kmdata.add_new_narrative('osupro', 'Work Description', currWork.description, 0);

         -- add to work_narratives
         INSERT INTO kmdata.work_narratives
            (work_id, narrative_id)
         VALUES
            (currWork.work_id, v_DescriptionNarrativeID);
         
      END IF;

      -- update the current work
      UPDATE kmdata.works
         SET work_type_id = currWork.work_type_id,
             journal_article_type_id = currWork.journal_article_type_id,
             publication_dmy_single_date_id = COALESCE(publication_dmy_single_date_id, kmdata.add_dmy_single_date(currWork.publication_day, currWork.publication_month, currWork.publication_year)), --[publicationDate],
             author_list = currWork.author,
             editor_list = currWork.editor,
             reviewer_list = currWork.reviewer,
             article_title = currWork.article_title,
             journal_title = currWork.journal_title,
             review_type_id = currWork.review_type_id,
             edition = currWork.edition,
             volume = currWork.volume,
             issue = currWork.issue,
             technical_report_number = currWork.technical_report_number,
             submitted_to = currWork.submitted_to,
             submission_date = currWork.submission_date,
             city = currWork.city,
             state = currWork.state,
             country = currWork.country,
             series = currWork.series,
             sponsor = currWork.sponsor,
             beginning_page = currWork.beginning_page,
             ending_page = currWork.ending_page,
             url = currWork.url,
             percent_authorship = currWork.percent_authorship,
             --description = currWork.description,
             author_date_citation = currWork.author_date_citation,
             bibliography_citation = currWork.bibliography_citation,
             research_report_citation = currWork.research_report_citation,
             research_report_ind = currWork.research_report_ind,
             impact_factor = currWork.impact_factor,
             issn = currWork.issn,
             publisher = currWork.publisher,
             publication_location = currWork.publication_location,
             collection = currWork.collection,
             site_last_viewed_date = currWork.site_last_viewed_date,
             publication_media_type_id = currWork.publication_media_type_id,
             status_id = currWork.status_id,
             abstract_type_id = currWork.abstract_type_id,
             peer_reviewed_ind = currWork.peer_reviewed_ind,
             submission_dmy_single_date_id = COALESCE(submission_dmy_single_date_id, kmdata.add_dmy_single_date(currWork.submission_day, currWork.submission_month, currWork.submission_year)), --[submissionDate],
             presentation_role_id = currWork.presentation_role_id,
             presentation_location_descr = currWork.presentation_location_descr,
             presentation_location_type_id = currWork.presentation_location_type_id,
             audience_name = currWork.audience_name,
             event_title = currWork.event_title,
             invited_talk = currWork.invited_talk,
             publication_title = currWork.publication_title,
             old_compiler = currWork.old_compiler,
             degree = currWork.degree,
             acceptance_rate = currWork.acceptance_rate,
             presentation_dmy_range_date_id = COALESCE(presentation_dmy_range_date_id, kmdata.add_dmy_range_date(currWork.presentation_start_day, currWork.presentation_start_month, currWork.presentation_start_year, 
                     currWork.presentation_end_day, currWork.presentation_end_month, currWork.presentation_end_year)), --[presentationRangeDate],
             role_id = currWork.role_id
       WHERE id = currWork.work_id;
       
   END LOOP;

   RETURN v_intNewItemID;
END;
$$ LANGUAGE plpgsql;
