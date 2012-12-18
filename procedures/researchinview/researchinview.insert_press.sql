-- Function: researchinview.insert_press(character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, character varying)

-- DROP FUNCTION researchinview.insert_press(character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, character varying);

CREATE OR REPLACE FUNCTION researchinview.insert_press(
p_integrationactivityid character varying, 
p_integrationuserid character varying, 
p_ispublic integer, 
p_extendedattribute1 character varying, 
p_extendedattribute2 character varying, 
p_extendedattribute3 character varying, 
p_extendedattribute4 character varying, 
p_extendedattribute5 character varying, 
p_articletitle character varying, 
p_author character varying, 
p_descriptionofeffort character varying, 
p_isreview character varying, 
p_issn character varying, 
p_issue character varying, 
p_pages character varying, 
p_percenteffort integer, 
p_publicationfrequency character varying, 
p_publicationfrequencyother character varying, 
p_publicationname character varying, 
p_publicationtype character varying, 
p_publishedon character varying, 
p_publisher character varying, 
p_reviewed character varying, 
p_reviewedperson character varying, 
p_reviewedsubject character varying, 
p_reviewtype character varying, 
p_seriesendedon character varying, 
p_seriesfrequency character varying, 
p_seriesfrequencyother character varying, 
p_seriesongoing character varying, 
p_seriesstartedon character varying, 
p_seriestitle character varying, 
p_singleorseries integer, 
p_url character varying, 
p_volume character varying
)
  RETURNS bigint AS
$BODY$
DECLARE
   v_ActivityID BIGINT;
   v_ResourceID BIGINT;
   v_WorkID BIGINT;
   v_WorkDescrID BIGINT;
   v_StartPage VARCHAR(200);
   v_EndPage VARCHAR(200);
   v_WorksMatchCount BIGINT;
   v_UserID BIGINT;
   v_PublishedDateID BIGINT;
   v_SeriesEndedOnDateID BIGINT;
   v_SeriesStartedOnDateID BIGINT;
   v_ReviewType BIGINT;
   v_WorkTypeID BIGINT;
BEGIN

   -- maps to Artwork
   v_WorkTypeID := kmdata.get_or_add_work_type_id('Press');
   
   -- select the user ID
   --v_UserID := p_IntegrationUserId;
   SELECT user_id INTO v_UserID
     FROM kmdata.user_identifiers
    WHERE emplid = p_IntegrationUserId;

   -- NULL check
   IF v_UserID IS NULL THEN
      RETURN 0;
   END IF;
   
   -- insert activity information
   v_ActivityID := researchinview.insert_activity('Press', p_IntegrationActivityId, p_IntegrationUserId, p_IsPublic, p_ExtendedAttribute1,
	p_ExtendedAttribute2, p_ExtendedAttribute3, p_ExtendedAttribute4, p_ExtendedAttribute5);

   -- get resource ID
   SELECT resource_id INTO v_ResourceID
     FROM researchinview.activity_import_log
    WHERE id = v_ActivityID;

   IF v_ResourceID IS NULL THEN
      v_ResourceID := kmdata.add_new_resource('researchinview', 'works');
   END IF;

   -- update activity table in the researchinview schema
   UPDATE researchinview.activity_import_log
      SET resource_id = v_ResourceID
    WHERE id = v_ActivityID;


   -- parse out the pages
   v_StartPage := trim(both ' ' from split_part(p_Pages, '-', 1));
   v_EndPage := trim(both ' ' from split_part(p_Pages, '-', 2));

   -- parse the date
   --p_PublishedDate

   IF p_ReviewType IS NULL OR TRIM(p_ReviewType) = '' THEN
      v_ReviewType := NULL;
   ELSIF TRIM(p_ReviewType) IN ('1','2') THEN
      v_ReviewType := TRIM(p_ReviewType);
   ELSE
      v_ReviewType := NULL;
   END IF;

   
   -- update information specific to journal articles
      --doi (Digital Object Identifier), description of effort (below), !synced w/ researcherid, #citations, pmid, repository handle,
      --reviewed (pro data was 1), WoS item id

   -- check to see if there is a record in works with this resource id
   SELECT COUNT(*) INTO v_WorksMatchCount
     FROM kmdata.works
    WHERE resource_id = v_ResourceID;

   IF v_WorksMatchCount = 0 THEN
   
      -- insert activity information
      v_WorkID := nextval('kmdata.works_id_seq');
   
      INSERT INTO kmdata.works
         (id, resource_id, user_id, article_title, author_list, is_review,
          issn, issue, beginning_page, ending_page, percent_authorship, frequency_of_publication, 
          frequency_of_publication_other, publication_title, publication_type_id,
          publication_dmy_single_date_id, 
          publisher, peer_reviewed_ind, reviewer_list, reviewed_subject, review_type_id, 
          series_ended_on_dmy_single_date_id, 
          series_frequency, series_frequency_other, series_ongoing, 
          series_started_on_dmy_single_date_id, 
          title, single_or_series, url, volume, created_at, updated_at, work_type_id)
      VALUES
         (v_WorkID, v_ResourceID, v_UserID, researchinview.strip_riv_tags(p_ArticleTitle), p_Author, p_IsReview,
          p_ISSN, p_Issue, v_StartPage, v_EndPage, p_PercentEffort, p_PublicationFrequency, 
          p_PublicationFrequencyOther, researchinview.strip_riv_tags(p_PublicationName), cast(p_PublicationType as integer),
          kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_PublishedOn), researchinview.get_year(p_PublishedOn)), 
          p_Publisher, cast(p_Reviewed as integer), p_ReviewedPerson, p_ReviewedSubject, v_ReviewType, 
          kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_SeriesEndedOn), researchinview.get_year(p_SeriesEndedOn)), 
          p_SeriesFrequency, p_SeriesFrequencyOther, p_SeriesOngoing, 
          kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_SeriesStartedOn), researchinview.get_year(p_SeriesStartedOn)), 
          p_SeriesTitle, p_SingleOrSeries, p_URL, p_Volume, current_timestamp, current_timestamp, v_WorkTypeID);

      -- add work author
      INSERT INTO kmdata.work_authors
         (work_id, user_id)
      VALUES
         (v_WorkID, v_UserID);
          
      -- add work description
      v_WorkDescrID := kmdata.add_new_narrative('researchinview', 'Work Description', researchinview.strip_riv_tags(p_DescriptionOfEffort), p_IsPublic);
   
      INSERT INTO kmdata.work_narratives
         (work_id, narrative_id)
      VALUES
         (v_WorkID, v_WorkDescrID);
   
   ELSE
   
      -- get the work id
      SELECT id, publication_dmy_single_date_id, series_ended_on_dmy_single_date_id, series_started_on_dmy_single_date_id
        INTO v_WorkID, v_PublishedDateID, v_SeriesEndedOnDateID, v_SeriesStartedOnDateID
        FROM kmdata.works
       WHERE resource_id = v_ResourceID;

      -- update the works table
      UPDATE kmdata.works
         SET user_id = v_UserID,
             article_title = researchinview.strip_riv_tags(p_ArticleTitle), 
             author_list = p_Author, 
             is_review = p_IsReview,
             issn = p_ISSN, 
             issue = p_Issue, 
             beginning_page = v_StartPage, 
             ending_page = v_EndPage, 
             percent_authorship = p_PercentEffort, 
             frequency_of_publication = p_PublicationFrequency,
             frequency_of_publication_other = p_PublicationFrequencyOther,
             publication_title = researchinview.strip_riv_tags(p_PublicationName),
             publication_type_id = cast(p_PublicationType as integer),
             -- publication_dmy_single_date_id
             publisher = p_Publisher,
             peer_reviewed_ind = cast(p_Reviewed as integer),
             reviewer_list = p_ReviewedPerson,
             reviewed_subject = p_ReviewedSubject,
             review_type_id = v_ReviewType, 
             -- series_ended_on_dmy_single_date_id
             series_frequency = p_SeriesFrequency,
             series_frequency_other = p_SeriesFrequencyOther,
             series_ongoing = p_SeriesOngoing,
             -- series_started_on_dmy_single_date_id
             title = p_SeriesTitle,
             single_or_series = p_SingleOrSeries,
             url = p_URL, 
             volume = p_Volume,
             updated_at = current_timestamp
       WHERE id = v_WorkID;

      -- get the narrative ID for description of effort
      SELECT b.id INTO v_WorkDescrID
        FROM kmdata.work_narratives a
        INNER JOIN kmdata.narratives b ON a.narrative_id = b.id
        INNER JOIN kmdata.narrative_types c ON b.narrative_type_id = c.id
       WHERE c.narrative_desc = 'Work Description'
         AND a.work_id = v_WorkID
       LIMIT 1;

      -- update the text and private indicator
      UPDATE kmdata.narratives
         SET narrative_text = researchinview.strip_riv_tags(p_DescriptionOfEffort),
             private_ind = p_IsPublic
       WHERE id = v_WorkDescrID;


      -- publication_dmy_single_date_id
      IF v_PublishedDateID IS NULL THEN
         v_PublishedDateID := kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_PublishedOn), researchinview.get_year(p_PublishedOn));
         
         UPDATE kmdata.works
            SET publication_dmy_single_date_id = v_PublishedDateID
          WHERE id = v_WorkID;
      END IF;

      UPDATE kmdata.dmy_single_dates
         SET "day" = NULL,
             "month" = researchinview.get_month(p_PublishedOn),
             "year" = researchinview.get_year(p_PublishedOn)
       WHERE id = v_PublishedDateID;


      -- series_ended_on_dmy_single_date_id
      IF v_SeriesEndedOnDateID IS NULL THEN
         v_SeriesEndedOnDateID := kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_SeriesEndedOn), researchinview.get_year(p_SeriesEndedOn));
         
         UPDATE kmdata.works
            SET series_ended_on_dmy_single_date_id = v_SeriesEndedOnDateID
          WHERE id = v_WorkID;
      END IF;

      UPDATE kmdata.dmy_single_dates
         SET "day" = NULL,
             "month" = researchinview.get_month(p_SeriesEndedOn),
             "year" = researchinview.get_year(p_SeriesEndedOn)
       WHERE id = v_SeriesEndedOnDateID;


      -- series_started_on_dmy_single_date_id
      IF v_SeriesStartedOnDateID IS NULL THEN
         v_SeriesStartedOnDateID := kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_SeriesStartedOn), researchinview.get_year(p_SeriesStartedOn));
         
         UPDATE kmdata.works
            SET series_started_on_dmy_single_date_id = v_SeriesStartedOnDateID
          WHERE id = v_WorkID;
      END IF;

      UPDATE kmdata.dmy_single_dates
         SET "day" = NULL,
             "month" = researchinview.get_month(p_SeriesStartedOn),
             "year" = researchinview.get_year(p_SeriesStartedOn)
       WHERE id = v_SeriesStartedOnDateID;

      
   END IF;
   
   RETURN v_WorkID;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;
ALTER FUNCTION researchinview.insert_press(character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, character varying)
  OWNER TO kmdata;
