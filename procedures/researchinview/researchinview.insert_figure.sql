CREATE OR REPLACE FUNCTION researchinview.insert_figure (
   p_IntegrationActivityId VARCHAR(2000),
   p_IntegrationUserId VARCHAR(2000),
   p_IsPublic INTEGER,
   p_ExtendedAttribute1 VARCHAR(4000),
   p_ExtendedAttribute2 VARCHAR(4000),
   p_ExtendedAttribute3 VARCHAR(4000),
   p_ExtendedAttribute4 VARCHAR(4000),
   p_ExtendedAttribute5 VARCHAR(4000),     
   p_DescriptionOfEffort VARCHAR(4000),
   p_IssuingOrganization VARCHAR(4000),
   p_Authors VARCHAR(4000),
   p_City VARCHAR(2000),
   p_Country VARCHAR(2000),
   p_CreatedBy VARCHAR(2000),
   p_CreatedOn VARCHAR(2000),
   p_ISBN VARCHAR(2000),
   p_JournalTitle VARCHAR(4000),
   p_OriginalPublicationType VARCHAR(2000),
   p_Pages VARCHAR(2000),
   p_PercentAuthorship INTEGER,
   p_PublicationType VARCHAR(2000),
   p_PublishedDate VARCHAR(2000),
   p_Publisher VARCHAR(2000),
   p_StateProvince VARCHAR(2000),
   p_StateProvinceOther VARCHAR(2000),
   p_Title VARCHAR(4000),
   p_TitleOfOriginalPublication VARCHAR(4000),
   p_URL VARCHAR(4000),
   p_Volume VARCHAR(2000)
   ) RETURNS BIGINT AS $$
DECLARE
   v_ActivityID BIGINT;
   v_ResourceID BIGINT;
   v_WorkID BIGINT;
   v_WorkDescrID BIGINT;
   v_UserID BIGINT;
   v_WorksMatchCount BIGINT;
   v_PublicationDateID BIGINT;
   v_CreationDateID BIGINT;
   v_StartPage VARCHAR(200);
   v_EndPage VARCHAR(200);
   v_WorkTypeID BIGINT;
   v_State VARCHAR(200);
BEGIN
   
   -- select the user ID
   --v_UserID := p_IntegrationUserId;
   SELECT user_id INTO v_UserID
     FROM kmdata.user_identifiers
    WHERE emplid = p_IntegrationUserId;
   
   IF v_UserID IS NULL THEN
      RETURN 0;
   END IF;

   -- maps to Figure
   v_WorkTypeID := kmdata.get_or_add_work_type_id('Figure');

    -- parse out the pages
   v_StartPage := trim(both ' ' from split_part(p_Pages, '-', 1));
   v_EndPage := trim(both ' ' from split_part(p_Pages, '-', 2));

   v_State := p_StateProvince;
   IF v_State IS NULL OR v_State = '' THEN
      v_State := p_StateProvinceOther;
   END IF;
   
   -- insert activity information
   v_ActivityID := researchinview.insert_activity('Figure', p_IntegrationActivityId, p_IntegrationUserId, p_IsPublic, p_ExtendedAttribute1,
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

   -- check to see if there is a record in works with this resource id
   SELECT COUNT(*) INTO v_WorksMatchCount
     FROM kmdata.works
    WHERE resource_id = v_ResourceID;


   IF v_WorksMatchCount = 0 THEN
   
      -- insert activity information
      v_WorkID := nextval('kmdata.works_id_seq');

      -- description of effort (below), publication status, Reviewed

      INSERT INTO kmdata.works
         (id, resource_id, user_id, author_list, city, country, created_by, creation_dmy_single_date_id, isbn, journal_title, original_publication_type,
         beginning_page, ending_page, percent_authorship, publication_type_id, publication_dmy_single_date_id, publisher, state, title, publication_title,  url, volume, work_type_id,
          created_at, updated_at, issuing_organization)
      VALUES
         (v_WorkID, v_ResourceID, v_UserID, p_Authors, p_City, p_Country, p_CreatedBy, kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_CreatedOn), researchinview.get_year(p_CreatedOn)), 
         p_ISBN, p_JournalTitle, p_OriginalPublicationType, 
         v_StartPage, v_EndPage, p_PercentAuthorship, CAST(coalesce(p_PublicationType, '0') AS integer), kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_PublishedDate), researchinview.get_year(p_PublishedDate)),
         p_Publisher, v_State, p_Title, p_TitleOfOriginalPublication,  p_URL, p_Volume, v_WorkTypeID, 
          current_timestamp, current_timestamp, p_IssuingOrganization);
   
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
      SELECT id, publication_dmy_single_date_id, creation_dmy_single_date_id
        INTO v_WorkID, v_PublicationDateID, v_CreationDateID
        FROM kmdata.works
       WHERE resource_id = v_ResourceID;

      -- update the works table
      UPDATE kmdata.works
         SET user_id = v_UserID,
             author_list = p_Authors,
             city = p_City,
             country = p_Country,
             created_by = p_CreatedBy,
             isbn = p_ISBN,
             issuing_organization = p_IssuingOrganization,
             journal_title = p_JournalTitle,
             original_publication_type = p_OriginalPublicationType,
             beginning_page = v_StartPage,
             ending_page = v_EndPage,
             percent_authorship = p_PercentAuthorship,
             publication_type_id = CAST(coalesce(p_PublicationType, '0') AS integer),
             publisher = p_Publisher,
             state = v_State,
             title = p_Title,
             publication_title = p_TitleOfOriginalPublication,
             volume = p_Volume,
             url = p_URL,
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


      -- publication_dmy_single_date_id, v_PublicationDateID
      IF v_PublicationDateID IS NULL THEN
         v_PublicationDateID := kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_PublishedDate), researchinview.get_year(p_PublishedDate));
         
         UPDATE kmdata.works
            SET publication_dmy_single_date_id = v_PublicationDateID
          WHERE id = v_WorkID;
      END IF;

      UPDATE kmdata.dmy_single_dates
         SET "day" = NULL,
             "month" = researchinview.get_month(p_PublishedDate),
             "year" = researchinview.get_year(p_PublishedDate)
       WHERE id = v_PublicationDateID;

      -- creation_dmy_single_date_id, v_CreationDateID
      IF v_CreationDateID IS NULL THEN
         v_CreationDateID := kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_CreatedOn), researchinview.get_year(p_CreatedOn));
         
         UPDATE kmdata.works
            SET creation_dmy_single_date_id = v_CreationDateID
          WHERE id = v_WorkID;
      END IF;

      UPDATE kmdata.dmy_single_dates
         SET "day" = NULL,
             "month" = researchinview.get_month(p_CreatedOn),
             "year" = researchinview.get_year(p_CreatedOn)
       WHERE id = v_CreationDateID;
      
      
   END IF;
   
   RETURN v_WorkID;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
