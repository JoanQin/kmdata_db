CREATE OR REPLACE FUNCTION researchinview.insert_artwork (
   p_IntegrationActivityId VARCHAR(2000),
   p_IntegrationUserId VARCHAR(2000),
   p_IsPublic INTEGER,
   p_ExtendedAttribute1 VARCHAR(4000),
   p_ExtendedAttribute2 VARCHAR(4000),
   p_ExtendedAttribute3 VARCHAR(4000),
   p_ExtendedAttribute4 VARCHAR(4000),
   p_ExtendedAttribute5 VARCHAR(4000),   
   p_Artist VARCHAR(2000),
   p_City VARCHAR(2000),
   p_Completed VARCHAR(2000),
   p_CompletedOn VARCHAR(2000),
   p_Country VARCHAR(2000),
   p_Curator VARCHAR(2000),
   p_DescriptionOfEffort TEXT,
   p_DescriptionOfRole TEXT,
   p_Dimensions VARCHAR(4000),
   p_EndedOn VARCHAR(2000),
   p_ExhibitionTitle VARCHAR(2000),
   p_Juried VARCHAR(2000),
   p_Medium VARCHAR(2000),
   p_Ongoing VARCHAR(2000),
   p_OtherArtist VARCHAR(2000),
   p_PercentAuthorship INTEGER,
   p_Solo VARCHAR(2000),
   p_Sponsor VARCHAR(2000),
   p_StartedOn VARCHAR(2000),
   p_StateProvince VARCHAR(2000),
   p_StateProvinceOther VARCHAR(2000),
   p_TitleOfWork VARCHAR(2000),
   p_TypeOfWork VARCHAR(2000),
   p_URL VARCHAR(4000),
   p_Venue VARCHAR(2000)
) RETURNS BIGINT AS $$
DECLARE
   v_WorkTypeID BIGINT;
   v_ActivityID BIGINT;
   v_ResourceID BIGINT;
   v_WorkID BIGINT;
   v_WorkDescrEffortID BIGINT;
   v_WorkDescrRoleID BIGINT;
   v_WorksMatchCount BIGINT;
   v_UserID BIGINT;
   v_State VARCHAR(2000);
   v_JuriedInd SMALLINT;
   v_CreationDateID BIGINT;
   v_ExhibitDateID BIGINT;
BEGIN
   -- maps to Artwork
   v_WorkTypeID := kmdata.get_or_add_work_type_id('Artwork');
   
   -- select the user ID
   --v_UserID := p_IntegrationUserId;
   SELECT user_id INTO v_UserID
     FROM kmdata.user_identifiers
    WHERE emplid = p_IntegrationUserId;
   
   IF v_UserID IS NULL THEN
      RETURN 0;
   END IF;
   
   -- insert activity information
   v_ActivityID := researchinview.insert_activity('Artwork', p_IntegrationActivityId, p_IntegrationUserId, p_IsPublic, p_ExtendedAttribute1,
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

   -- ****************************************
   -- additional field mappings and processing
   -- ****************************************

   v_State := p_StateProvince;
   IF v_State IS NULL OR v_State = '' THEN
      v_State := p_StateProvinceOther;
   END IF;

   IF upper(p_Juried) = 'YES' OR p_Juried = '1' THEN
      v_JuriedInd := 1;
   ELSE
      v_JuriedInd := 0;
   END IF;
   
   -- update information specific to artwork
   --p_Completed, p_CompletedOn, p_EndedOn, p_Ongoing, p_OtherArtist!, p_Solo->exhibition_type_id, p_StartedOn, p_TypeOfWork

   -- check to see if there is a record in works with this resource id
   SELECT COUNT(*) INTO v_WorksMatchCount
     FROM kmdata.works
    WHERE resource_id = v_ResourceID;

   IF v_WorksMatchCount = 0 THEN
   
      -- insert activity information
      v_WorkID := nextval('kmdata.works_id_seq');
   
      INSERT INTO kmdata.works
         (id, resource_id, user_id, artist, city, country, curator, dimensions, exhibit_title,
          juried_ind, medium, percent_authorship, exhibition_type_id, sponsor, state, title, url, venue,
          creation_dmy_single_date_id, 
          exhibit_dmy_range_date_id,
          created_at, updated_at, work_type_id)
      VALUES
         (v_WorkID, v_ResourceID, v_UserID, p_Artist, p_City, p_Country, p_Curator, p_Dimensions, researchinview.strip_riv_tags(p_ExhibitionTitle),
          v_JuriedInd, p_Medium, p_PercentAuthorship, NULL, p_Sponsor, v_State, researchinview.strip_riv_tags(p_TitleOfWork), p_URL, p_Venue,
          kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_CompletedOn), researchinview.get_year(p_CompletedOn)),
          kmdata.add_dmy_range_date(NULL, researchinview.get_month(p_StartedOn), researchinview.get_year(p_StartedOn),
                                    NULL, researchinview.get_month(p_EndedOn), researchinview.get_year(p_EndedOn)),
          current_timestamp, current_timestamp, v_WorkTypeID);

      -- add work author
      INSERT INTO kmdata.work_authors
         (work_id, user_id)
      VALUES
         (v_WorkID, v_UserID);
          
      -- add work description of effort
      v_WorkDescrEffortID := kmdata.add_new_narrative('researchinview', 'Work Description', researchinview.strip_riv_tags(p_DescriptionOfEffort), p_IsPublic);
   
      INSERT INTO kmdata.work_narratives
         (work_id, narrative_id)
      VALUES
         (v_WorkID, v_WorkDescrEffortID);

      -- add work description of role
      v_WorkDescrRoleID := kmdata.add_new_narrative('researchinview', 'Work Description of Role', researchinview.strip_riv_tags(p_DescriptionOfRole), p_IsPublic);

      INSERT INTO kmdata.work_narratives
         (work_id, narrative_id)
      VALUES
         (v_WorkID, v_WorkDescrRoleID);
   
   ELSE
   
      -- get the work id
      SELECT id, creation_dmy_single_date_id, exhibit_dmy_range_date_id 
        INTO v_WorkID, v_CreationDateID, v_ExhibitDateID
        FROM kmdata.works
       WHERE resource_id = v_ResourceID;

      -- update the works table
      UPDATE kmdata.works
         SET user_id = v_UserID,
             artist = p_Artist, 
             city = p_City, 
             country = p_Country, 
             curator = p_Curator, 
             dimensions = p_Dimensions, 
             exhibit_title = researchinview.strip_riv_tags(p_ExhibitionTitle),
             juried_ind = v_JuriedInd, 
             medium = p_Medium, 
             percent_authorship = p_PercentAuthorship, 
             --exhibition_type_id = , 
             sponsor = p_Sponsor, 
             state = v_State, 
             title = researchinview.strip_riv_tags(p_TitleOfWork), 
             url = p_URL, 
             venue = p_Venue,
             updated_at = current_timestamp,
             work_type_id = v_WorkTypeID
       WHERE id = v_WorkID;

      -- get the narrative ID for description of effort
      SELECT b.id INTO v_WorkDescrEffortID
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
       WHERE id = v_WorkDescrEffortID;

      -- get the narrative ID for description of role
      SELECT b.id INTO v_WorkDescrRoleID
        FROM kmdata.work_narratives a
        INNER JOIN kmdata.narratives b ON a.narrative_id = b.id
        INNER JOIN kmdata.narrative_types c ON b.narrative_type_id = c.id
       WHERE c.narrative_desc = 'Work Description of Role'
         AND a.work_id = v_WorkID
       LIMIT 1;

      -- update the text and private indicator
      UPDATE kmdata.narratives
         SET narrative_text = researchinview.strip_riv_tags(p_DescriptionOfRole),
             private_ind = p_IsPublic
       WHERE id = v_WorkDescrRoleID;

      IF v_CreationDateID IS NULL THEN
         v_CreationDateID := kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_CompletedOn), researchinview.get_year(p_CompletedOn));
         
         UPDATE kmdata.works
            SET creation_dmy_single_date_id = v_CreationDateID
          WHERE id = v_WorkID;
      END IF;

      IF v_ExhibitDateID IS NULL THEN
         v_ExhibitDateID := kmdata.add_dmy_range_date(NULL, researchinview.get_month(p_StartedOn), researchinview.get_year(p_StartedOn),
                                    NULL, researchinview.get_month(p_EndedOn), researchinview.get_year(p_EndedOn));

         UPDATE kmdata.works
            SET exhibit_dmy_range_date_id = v_ExhibitDateID
          WHERE id = v_WorkID;
      END IF;

      -- update creation_dmy_single_date_id, 
      UPDATE kmdata.dmy_single_dates
         SET "day" = NULL,
             "month" = researchinview.get_month(p_CompletedOn),
             "year" = researchinview.get_year(p_CompletedOn)
       WHERE id = v_CreationDateID;
      
      -- update exhibit_dmy_range_date_id,
      UPDATE kmdata.dmy_range_dates
         SET start_day = NULL,
             start_month = researchinview.get_month(p_StartedOn),
             start_year = researchinview.get_year(p_StartedOn),
             end_day = NULL,
             end_month = researchinview.get_month(p_EndedOn),
             end_year = researchinview.get_year(p_EndedOn)
       WHERE id = v_ExhibitDateID;
       
   END IF;
   
   RETURN v_WorkID;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
