CREATE OR REPLACE FUNCTION researchinview.insert_conference (
   p_IntegrationActivityId VARCHAR(2000),
   p_IntegrationUserId VARCHAR(2000),
   p_IsPublic INTEGER,
   p_ExtendedAttribute1 VARCHAR(4000),
   p_ExtendedAttribute2 VARCHAR(4000),
   p_ExtendedAttribute3 VARCHAR(4000),
   p_ExtendedAttribute4 VARCHAR(4000),
   p_ExtendedAttribute5 VARCHAR(4000),   
   p_Author VARCHAR(2000),
   p_BookTitle VARCHAR(4000),
   p_City VARCHAR(2000),
   p_ConferenceName VARCHAR(2000),
   p_ConferenceStartedOn VARCHAR(2000), -- MonthYear
   p_Country VARCHAR(2000),
   p_DescriptionOfEffort TEXT,
   p_DOI VARCHAR(2000),
   p_Edition VARCHAR(2000),
   p_ImpactFactor NUMERIC,
   p_ISBN VARCHAR(2000),
   p_ISSN VARCHAR(2000),
   p_Issues VARCHAR(4000),
   --p_IsSyncedWithResearcherID SMALLINT,
   p_JournalTitle VARCHAR(2000),
   p_NumberOfCitations INTEGER,
   p_Pages VARCHAR(2000),
   p_PercentAuthorship INTEGER,
   p_PMID VARCHAR(2000),
   p_PublicationDocumentType VARCHAR(2000),
   p_PublicationType VARCHAR(2000),
   p_PublishedOn VARCHAR(2000), -- MonthYear
   p_Publisher VARCHAR(2000),
   p_RepositoryHandle VARCHAR(2000),
   p_Reviewed VARCHAR(2000),
   p_ReviewType VARCHAR(2000),
   p_SeriesTitle VARCHAR(2000),
   p_StateProvince VARCHAR(2000),
   p_StateProvinceOther VARCHAR(2000),
   p_Status VARCHAR(2000),
   p_Title VARCHAR(2000),
   p_URL VARCHAR(4000),
   p_Volume VARCHAR(2000),
   p_WoSItemId VARCHAR(2000)
) RETURNS BIGINT AS $$
DECLARE
   v_ActivityID BIGINT;
   v_ResourceID BIGINT;
   v_WorkID BIGINT;
   v_WorkDescrID BIGINT;
   v_StartPage VARCHAR(200);
   v_EndPage VARCHAR(200);
   v_JournalArticleTypeID BIGINT;
   v_WorksMatchCount BIGINT;
   v_UserID BIGINT;
   v_State VARCHAR(2000);
   v_PublicationDateID BIGINT;
   ---v_PerformanceDate timestap without time zone;
BEGIN
   -- maps to Papers in Proceedings
   
   -- select the user ID
   --v_UserID := p_IntegrationUserId;
   SELECT user_id INTO v_UserID
     FROM kmdata.user_identifiers
    WHERE emplid = p_IntegrationUserId;
   
   IF v_UserID IS NULL THEN
      RETURN 0;
   END IF;
   
   -- insert activity information
   v_ActivityID := researchinview.insert_activity('Conference', p_IntegrationActivityId, p_IntegrationUserId, p_IsPublic, p_ExtendedAttribute1,
	p_ExtendedAttribute2, p_ExtendedAttribute3, p_ExtendedAttribute4, p_ExtendedAttribute5);

   -- get resource ID
   SELECT resource_id INTO v_ResourceID
     FROM researchinview.activity_import_log
    WHERE id = v_ActivityID;

   IF v_ResourceID IS NULL THEN
      v_ResourceID := add_new_resource('researchinview', 'works');
   END IF;

   -- update activity table in the researchinview schema
   UPDATE researchinview.activity_import_log
      SET resource_id = v_ResourceID
    WHERE id = v_ActivityID;

   -- get publication type
   -- get publication document type

   -- parse out the pages
   v_StartPage := trim(both ' ' from split_part(p_Pages, '-', 1));
   v_EndPage := trim(both ' ' from split_part(p_Pages, '-', 2));

   -- parse the date
   --p_PublishedDate

   v_State := p_StateProvince;
   IF v_State IS NULL OR v_State = '' THEN
      v_State := p_StateProvinceOther;
   END IF;
   
   --IF researchinview.get_year(p_ConferenceStartedOn) = 0 THEN
   --   v_PerformanceDate := CAST(NULL AS DATE);
   --ELSE
   --    v_PerformanceDate := DATE(researchinview.get_year(p_ConferenceStartedOn) || '-' || researchinview.get_month(p_ConferenceStartedOn) || '-1');
   --END IF;
   
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
         (id, resource_id, user_id, title, journal_article_type_id, author_list, 
          isbn, issn, impact_factor, issue, journal_title, beginning_page, ending_page, percent_authorship,
          review_type_id,  url, volume, created_at, updated_at, work_type_id,
          book_title, city, state, country, event_title, edition, publisher, series, is_review, status_id, number_of_citations,
          publication_dmy_single_date_id,
          performance_start_date,
          publication_media_type_id, publication_type_id)
      VALUES
         (v_WorkID, v_ResourceID, v_UserID, researchinview.strip_riv_tags(p_Title), v_JournalArticleTypeID, p_Author, 
          p_ISBN, p_ISSN, p_ImpactFactor, p_Issues, researchinview.strip_riv_tags(p_JournalTitle), v_StartPage, v_EndPage, p_PercentAuthorship, 
          CAST(p_ReviewType AS INTEGER), p_URL, p_Volume, current_timestamp, current_timestamp, 13,  -- 13 is paper in proceeding
          researchinview.strip_riv_tags(p_BookTitle), p_City, v_State, p_Country, p_ConferenceName, p_Edition, p_Publisher, 
          researchinview.strip_riv_tags(p_SeriesTitle), p_Reviewed, cast(p_Status as integer), p_NumberOfCitations,
          kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_PublishedOn), researchinview.get_year(p_PublishedOn)),
<<<<<<< HEAD
          case when researchinview.get_year(p_ConferenceStartedOn) = 0 then cast (null as timestamp) 
          else date (researchinview.get_year(p_ConferenceStartedOn) || '-' || researchinview.get_month(p_ConferenceStartedOn) || '-1') end, 
=======
          CASE WHEN researchinview.get_year(p_ConferenceStartedOn) = 0 Then CAST (null as date) ELSE 
          date (researchinview.get_year(p_ConferenceStartedOn) || '-' || researchinview.get_month(p_ConferenceStartedOn) || '-1')
          END, 
>>>>>>> 60ef8ccef4f050db9aa114544c8247a536a564ed
          CAST(p_PublicationDocumentType AS INTEGER), CAST(p_PublicationType AS BIGINT));

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
      SELECT id, publication_dmy_single_date_id
        INTO v_WorkID, v_PublicationDateID
        FROM kmdata.works
       WHERE resource_id = v_ResourceID;

      -- update the works table
      UPDATE kmdata.works
         SET user_id = v_UserID,
             title = researchinview.strip_riv_tags(p_Title), 
             journal_article_type_id = v_JournalArticleTypeID, 
             author_list = p_Author, 
             is_review =  p_Reviewed,
             number_of_citations = p_NumberOfCitations,
             status_id = cast(p_Status as integer),
             issn = p_ISSN, 
             isbn = p_ISBN,
             impact_factor = p_ImpactFactor, 
             issue = p_Issues, 
             journal_title = researchinview.strip_riv_tags(p_JournalTitle), 
             beginning_page = v_StartPage, 
             ending_page = v_EndPage, 
             percent_authorship = p_PercentAuthorship, 
             review_type_id = CAST(p_ReviewType AS INTEGER), 
             --status_id, 
             url = p_URL, 
             volume = p_Volume,
             updated_at = current_timestamp,
             book_title = researchinview.strip_riv_tags(p_BookTitle),
             city = p_City,
             state = v_State,
             country = p_Country,
             event_title = p_ConferenceName,
             edition = p_Edition,
             publisher = p_Publisher,
             series = researchinview.strip_riv_tags(p_SeriesTitle),
<<<<<<< HEAD
             performance_start_date = case when researchinview.get_year(p_ConferenceStartedOn) = 0 then cast(null as timestamp) 
             				else date (researchinview.get_year(p_ConferenceStartedOn) || '-' || researchinview.get_month(p_ConferenceStartedOn) || '-1') end,
=======
             performance_start_date = CASE WHEN researchinview.get_year(p_ConferenceStartedOn) = 0 THEN CAST(NULL AS DATE) 
             			ELSE date (researchinview.get_year(p_ConferenceStartedOn) || '-' || researchinview.get_month(p_ConferenceStartedOn) || '-1') END,
>>>>>>> 60ef8ccef4f050db9aa114544c8247a536a564ed
             publication_media_type_id = CAST(p_PublicationDocumentType AS INTEGER),
             publication_type_id = CAST(p_PublicationType AS BIGINT)
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
       
      IF v_PublicationDateID IS NULL THEN
         v_PublicationDateID := kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_PublishedOn), researchinview.get_year(p_PublishedOn));

         UPDATE kmdata.works
            SET publication_dmy_single_date_id = v_PublicationDateID
          WHERE id = v_WorkID;
      END IF;

      UPDATE kmdata.dmy_single_dates
         SET "day" = NULL,
             "month" = researchinview.get_month(p_PublishedOn),
             "year" = researchinview.get_year(p_PublishedOn)
       WHERE id = v_PublicationDateID;

      
   END IF;
   
   RETURN v_WorkID;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
