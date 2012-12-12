CREATE OR REPLACE FUNCTION researchinview.insert_book (
   p_IntegrationActivityId VARCHAR(2000),
   p_IntegrationUserId VARCHAR(2000),
   p_IsPublic INTEGER,
   p_ExtendedAttribute1 VARCHAR(4000),
   p_ExtendedAttribute2 VARCHAR(4000),
   p_ExtendedAttribute3 VARCHAR(4000),
   p_ExtendedAttribute4 VARCHAR(4000),
   p_ExtendedAttribute5 VARCHAR(4000),   
   p_Author VARCHAR(4000),
   p_City VARCHAR(4000),
   p_Country VARCHAR(4000),
   p_DescriptionOfEffort VARCHAR(4000),
   p_Edition VARCHAR(4000),
   p_Editor VARCHAR(4000),
   p_ISBN VARCHAR(4000),
   p_LCCN VARCHAR(4000),
   p_PercentAuthorship INTEGER,
   p_PublicationStatus VARCHAR(4000),
   p_PublishedOn VARCHAR(2000),
   p_Publisher VARCHAR(2000),
   p_Reviewed VARCHAR(2000),
   p_ReviewType VARCHAR(2000),
   p_StateProvince VARCHAR(2000),
   p_StateProvinceOther VARCHAR(2000),
   p_Title VARCHAR(4000),
   p_URL VARCHAR(4000),
   p_Volume VARCHAR(2000),
   p_WorkType VARCHAR(2000)
   ) RETURNS BIGINT AS $$
DECLARE
   v_ActivityID BIGINT;
   v_ResourceID BIGINT;
   v_WorkID BIGINT;
   v_WorkDescrID BIGINT;
   v_UserID BIGINT;
   v_KMDReviewType BIGINT;
   v_WorksMatchCount BIGINT;
   v_ReviewedInd BIGINT;
   v_PublicationDateID BIGINT;
   v_PublicationStatusID BIGINT;
   v_WorkTypeID BIGINT;
BEGIN
   -- select the user ID
   --v_UserID := p_IntegrationUserId;
   SELECT user_id INTO v_UserID
     FROM kmdata.user_identifiers
    WHERE emplid = p_IntegrationUserId;
   
   IF v_UserID IS NULL THEN
      RETURN 0;
   END IF;
   
   -- insert activity information
   v_ActivityID := researchinview.insert_activity('Book', p_IntegrationActivityId, p_IntegrationUserId, p_IsPublic, p_ExtendedAttribute1,
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

   -- get the publication status
   IF p_PublicationStatus IS NULL OR TRIM(p_PublicationStatus) = '' THEN
      v_PublicationStatusID := NULL;
   ELSE
      v_PublicationStatusID := p_PublicationStatus;
   END IF;

   -- get the sub work type
   IF p_WorkType IS NULL OR TRIM(p_WorkType) = '' THEN
      v_WorkTypeID := NULL;
   ELSE
      v_WorkTypeID := p_WorkType;
   END IF;


   -- map review type
   v_KMDReviewType := p_ReviewType;

   IF v_WorksMatchCount = 0 THEN
   
      -- insert activity information
      v_WorkID := nextval('kmdata.works_id_seq');

      -- description of effort (below), publication status, Reviewed

      INSERT INTO kmdata.works
         (id, resource_id, user_id, author_list, city, country, edition, editor_list, percent_authorship, 
          publisher, review_type_id, state, title, url, volume, work_type_id, publication_dmy_single_date_id, 
          created_at, updated_at, isbn, lccn, status_id, sub_work_type_id)
      VALUES
         (v_WorkID, v_ResourceID, v_UserID, p_Author, p_City, p_Country, p_Edition, p_Editor, p_PercentAuthorship, 
          p_Publisher, v_KMDReviewType, p_StateProvince, researchinview.strip_riv_tags(p_Title), p_URL, p_Volume, 6, kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_PublishedOn), researchinview.get_year(p_PublishedOn)),
          current_timestamp, current_timestamp, p_ISBN, p_LCCN, v_PublicationStatusID, v_WorkTypeID);
   
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
             author_list = p_Author,
             city = p_City,
             country = p_Country,
             edition = p_Edition,
             editor_list = p_Editor,
             percent_authorship = p_PercentAuthorship,
             publisher = p_Publisher,
             --peer_reviewed_ind = p_Reviewed,
             review_type_id = v_KMDReviewType,
             state = p_StateProvince,
             title = researchinview.strip_riv_tags(p_Title),
             url = p_URL,
             volume = p_Volume,
             updated_at = current_timestamp,
             isbn = p_ISBN,
             lccn = p_LCCN,
             status_id = v_PublicationStatusID,
             sub_work_type_id = v_WorkTypeID
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

      -- update publication_dmy_single_date_id, 
      UPDATE kmdata.dmy_single_dates
         SET "day" = NULL,
             "month" = researchinview.get_month(p_PublishedOn),
             "year" = researchinview.get_year(p_PublishedOn)
       WHERE id = v_PublicationDateID;
      
   END IF;
   
   RETURN v_WorkID;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
