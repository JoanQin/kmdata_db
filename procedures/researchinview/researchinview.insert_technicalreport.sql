CREATE OR REPLACE FUNCTION researchinview.insert_technicalreport (
   p_IntegrationActivityId VARCHAR(2000),
   p_IntegrationUserId VARCHAR(2000),
   p_IsPublic INTEGER,
   p_ExtendedAttribute1 VARCHAR(4000),
   p_ExtendedAttribute2 VARCHAR(4000),
   p_ExtendedAttribute3 VARCHAR(4000),
   p_ExtendedAttribute4 VARCHAR(4000),
   p_ExtendedAttribute5 VARCHAR(4000),   
   p_Author VARCHAR(2000),
   p_City VARCHAR(2000),
   p_Country VARCHAR(2000),
   p_DescriptionOfEffort TEXT,
   p_Edition VARCHAR(2000),
   p_Editor VARCHAR(2000),
   p_ISBN VARCHAR(2000),
   p_Issue VARCHAR(4000),
   p_PercentAuthorship INTEGER,
   p_PublicationType VARCHAR(2000),
   p_PublishedOn VARCHAR(2000), -- MonthYear
   p_Publisher VARCHAR(2000),
   p_ReportNumber VARCHAR(2000),
   p_Reviewed VARCHAR(2000),
   p_ReviewType VARCHAR(2000),
   p_StateProvince VARCHAR(2000),
   p_StateProvinceOther VARCHAR(2000),
   p_Status VARCHAR(2000),
   p_Title VARCHAR(2000),
   p_URL VARCHAR(4000),
   p_Volume VARCHAR(2000)
) RETURNS BIGINT AS $$
DECLARE
   v_ActivityID BIGINT;
   v_ResourceID BIGINT;
   v_WorkID BIGINT;
   v_WorkDescrID BIGINT;
   v_JournalArticleTypeID BIGINT;
   v_WorksMatchCount BIGINT;
   v_UserID BIGINT;
   v_State VARCHAR(2000);
   v_PublicationDateID BIGINT;
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
   v_ActivityID := researchinview.insert_activity('TechnicalReport', p_IntegrationActivityId, p_IntegrationUserId, p_IsPublic, p_ExtendedAttribute1,
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

   -- parse the date
   --p_PublishedOn

   v_State := p_StateProvince;
   IF v_State IS NULL OR v_State = '' THEN
      v_State := p_StateProvinceOther;
   END IF;
   
   -- update information specific to technical report
      --reviewed (pro data was 1), report number, isbn, publication type, status

   -- check to see if there is a record in works with this resource id
   SELECT COUNT(*) INTO v_WorksMatchCount
     FROM kmdata.works
    WHERE resource_id = v_ResourceID;

   IF v_WorksMatchCount = 0 THEN
   
      -- insert activity information
      v_WorkID := nextval('kmdata.works_id_seq');
   
      INSERT INTO kmdata.works
         (id, resource_id, user_id, title, author_list, editor_list, 
          issue, percent_authorship, publication_type_id, report_number,
          review_type_id, status_id, url, volume, created_at, updated_at, work_type_id,
          city, state, country, edition, publisher, isbn, is_review,
          publication_dmy_single_date_id)
      VALUES
         (v_WorkID, v_ResourceID, v_UserID, researchinview.strip_riv_tags(p_Title), p_Author, p_Editor, 
          p_Issue, p_PercentAuthorship,  CAST(p_PublicationType AS INTEGER), p_ReportNumber,
          CAST(p_ReviewType AS INTEGER), CAST(p_Status AS INTEGER), p_URL, p_Volume, current_timestamp, current_timestamp, 7,  -- 7 is bulletin and technical report
          p_City, v_State, p_Country, p_Edition, p_Publisher, p_ISBN, p_Reviewed,
          kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_PublishedOn), researchinview.get_year(p_PublishedOn)));

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
             editor_list = p_Editor,
             is_review = p_Reviewed,
             issue = p_Issue, 
             percent_authorship = p_PercentAuthorship, 
             publication_type_id = CAST(p_PublicationType as INTEGER),
             review_type_id = CAST(p_ReviewType AS INTEGER), 
             status_id = CAST(p_Status AS INTEGER), 
             url = p_URL, 
             report_number = p_ReportNumber,
             volume = p_Volume,
             updated_at = current_timestamp,
             city = p_City,
             state = v_State,
             country = p_Country,
             edition = p_Edition,
             publisher = p_Publisher,
             isbn = p_ISBN
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
