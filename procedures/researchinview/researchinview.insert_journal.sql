CREATE OR REPLACE FUNCTION researchinview.insert_journal (
   p_IntegrationActivityId VARCHAR(2000),
   p_IntegrationUserId VARCHAR(2000),
   p_IsPublic INTEGER,
   p_ExtendedAttribute1 VARCHAR(4000),
   p_ExtendedAttribute2 VARCHAR(4000),
   p_ExtendedAttribute3 VARCHAR(4000),
   p_ExtendedAttribute4 VARCHAR(4000),
   p_ExtendedAttribute5 VARCHAR(4000),   
   p_ArticleTitle VARCHAR(2000),
   p_ArticleType VARCHAR(2000),
   p_Author VARCHAR(2000),
   p_DOI VARCHAR(2000),
   p_DescriptionOfEffort VARCHAR(4000),
   p_ISSN VARCHAR(2000),
   p_ImpactFactor NUMERIC,
   --p_IsSyncedWithResearcherID SMALLINT,
   p_Issue VARCHAR(2000),
   p_JournalTitle VARCHAR(2000),
   p_NumberOfCitations INTEGER,
   p_PMID VARCHAR(2000),
   p_Pages VARCHAR(2000),
   p_PercentAuthorship INTEGER,
   p_PublishedDate VARCHAR(2000), -- MonthYear
   p_RepositoryHandle VARCHAR(2000),
   p_ReviewType VARCHAR(2000),
   p_Reviewed VARCHAR(2000),
   p_Status VARCHAR(2000),
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
   v_PublishedDateID BIGINT;
   v_ReviewType BIGINT;
   v_Status BIGINT;
   v_AuthorStr VARCHAR(2000);
BEGIN
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
   v_ActivityID := researchinview.insert_activity('Journal', p_IntegrationActivityId, p_IntegrationUserId, p_IsPublic, p_ExtendedAttribute1,
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

   -- get journal article type
   -- PRO: 1=Peer-reviewed ; 2=Editor-reviewed
   v_JournalArticleTypeID := p_ArticleType;

   -- parse out the pages
   v_StartPage := trim(both ' ' from split_part(p_Pages, '-', 1));
   v_EndPage := trim(both ' ' from split_part(p_Pages, '-', 2));

   -- parse the date
   --p_PublishedDate

   v_AuthorStr := left(p_Author, 1999);


   IF p_ReviewType IS NULL OR TRIM(p_ReviewType) = '' THEN
      v_ReviewType := NULL;
   ELSE
      v_ReviewType := p_ReviewType;
   END IF;

   IF p_Status IS NULL OR TRIM(p_Status) = '' THEN
      v_Status := NULL;
   ELSE
      v_Status := p_Status;
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
         (id, resource_id, user_id, article_title, journal_article_type_id, author_list, 
          issn, impact_factor, issue, journal_title, beginning_page, ending_page, percent_authorship, 
          publication_dmy_single_date_id, extended_author_list,
          review_type_id, status_id, url, volume, created_at, updated_at, work_type_id,
          citation_count)
      VALUES
         (v_WorkID, v_ResourceID, v_UserID, researchinview.strip_riv_tags(p_ArticleTitle), v_JournalArticleTypeID, v_AuthorStr, p_ISSN, p_ImpactFactor, p_Issue, researchinview.strip_riv_tags(p_JournalTitle),
          v_StartPage, v_EndPage, p_PercentAuthorship, 
          kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_PublishedDate), researchinview.get_year(p_PublishedDate)), 
          CASE when length(p_Author) > 1999 THEN p_Author ELSE NULL END,
          v_ReviewType, v_Status, p_URL, p_Volume, current_timestamp, current_timestamp, 4, -- 4 is journal article
          p_NumberOfCitations);

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
        INTO v_WorkID, v_PublishedDateID
        FROM kmdata.works
       WHERE resource_id = v_ResourceID;

      -- update the works table
      UPDATE kmdata.works
         SET user_id = v_UserID,
             article_title = researchinview.strip_riv_tags(p_ArticleTitle), 
             journal_article_type_id = v_JournalArticleTypeID, 
             author_list = v_AuthorStr, 
             extended_author_list =  CASE when length(p_Author) > 1999 THEN p_Author ELSE NULL END,
             issn = p_ISSN, 
             impact_factor = p_ImpactFactor, 
             issue = p_Issue, 
             journal_title = researchinview.strip_riv_tags(p_JournalTitle), 
             beginning_page = v_StartPage, 
             ending_page = v_EndPage, 
             percent_authorship = p_PercentAuthorship, 
             review_type_id = v_ReviewType, 
             status_id = v_Status, 
             url = p_URL, 
             volume = p_Volume,
             citation_count = p_NumberOfCitations,
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

      IF v_PublishedDateID IS NULL THEN
         v_PublishedDateID := kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_PublishedDate), researchinview.get_year(p_PublishedDate));
         
         UPDATE kmdata.works
            SET publication_dmy_single_date_id = v_PublishedDateID
          WHERE id = v_WorkID;
      END IF;

      -- update publication_dmy_single_date_id, 
      UPDATE kmdata.dmy_single_dates
         SET "day" = NULL,
             "month" = researchinview.get_month(p_PublishedDate),
             "year" = researchinview.get_year(p_PublishedDate)
       WHERE id = v_PublishedDateID;
      
   END IF;
   
   RETURN v_WorkID;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
