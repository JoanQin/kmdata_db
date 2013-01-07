CREATE OR REPLACE FUNCTION researchinview.insert_music (
   p_IntegrationActivityId VARCHAR(2000),
   p_IntegrationUserId VARCHAR(2000),
   p_IsPublic INTEGER,
   p_ExtendedAttribute1 VARCHAR(4000),
   p_ExtendedAttribute2 VARCHAR(4000),
   p_ExtendedAttribute3 VARCHAR(4000),
   p_ExtendedAttribute4 VARCHAR(4000),
   p_ExtendedAttribute5 VARCHAR(4000),
   p_ArtistComposer VARCHAR(2000),
   p_City VARCHAR(2000),
   p_Completed VARCHAR(2000),
   p_CompletedOn VARCHAR(2000),
   p_ConductorDirector VARCHAR(2000),
   p_Country VARCHAR(2000),
   p_Curator VARCHAR(2000),
   p_DescriptionOfEffort TEXT,
   p_EndedOn VARCHAR(2000),
   p_Ongoing VARCHAR(2000),
   p_Organizer VARCHAR(2000),
   p_PercentAuthorship INTEGER,
   p_Performance VARCHAR(4000),
   p_PerformanceTitle VARCHAR(2000),
   p_PerformanceTroupe VARCHAR(2000),
   p_Producer VARCHAR(2000),
   p_Role VARCHAR(2000),
   p_RoleOther VARCHAR(2000),
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
   v_Role VARCHAR(2000);
   v_CompletedDateID BIGINT;
   v_ArtistStr VARCHAR(255);
BEGIN
   -- maps to current type
   v_WorkTypeID := kmdata.get_or_add_work_type_id('Musical Work or Performance');
   
   -- select the user ID
   --v_UserID := p_IntegrationUserId;
   SELECT user_id INTO v_UserID
     FROM kmdata.user_identifiers
    WHERE emplid = p_IntegrationUserId;
   
   IF v_UserID IS NULL THEN
      RETURN 0;
   END IF;

   v_ArtistStr := left(p_ArtistComposer, 254);
   -- insert activity information
   v_ActivityID := researchinview.insert_activity('Music', p_IntegrationActivityId, p_IntegrationUserId, p_IsPublic, p_ExtendedAttribute1,
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

   -- process p_Role and p_RoleOther for role_designator
   v_Role := p_Role;
   IF v_Role = '' THEN
      v_Role := p_RoleOther;
   END IF;
   
   -- update information specific to artwork
   --p_CompletedOn, p_Completed, p_EndedOn, p_Ongoing, p_Performance, p_Producer, 
   --p_StartedOn, p_TypeOfWork

   -- check to see if there is a record in works with this resource id
   SELECT COUNT(*) INTO v_WorksMatchCount
     FROM kmdata.works
    WHERE resource_id = v_ResourceID;

   IF v_WorksMatchCount = 0 THEN
   
      -- insert activity information
      v_WorkID := nextval('kmdata.works_id_seq');
   
      INSERT INTO kmdata.works
         (id, resource_id, user_id, artist, city, director, country, curator, sub_work_type_id,
          organizer, percent_authorship, title_in, performance_company, role_designator, 
          state, title, url, venue, created_at, updated_at, work_type_id, extended_author_list,
          presentation_dmy_single_date_id, --completed on
          performance_start_date,
          performance_end_date,  producer, completed, ongoing, performance)
      VALUES
         (v_WorkID, v_ResourceID, v_UserID, v_ArtistStr, p_City, p_ConductorDirector, p_Country, p_Curator, CAST(p_TypeOfWork AS INTEGER),
          p_Organizer, p_PercentAuthorship, researchinview.strip_riv_tags(p_PerformanceTitle), p_PerformanceTroupe, v_Role, 
          v_State, researchinview.strip_riv_tags(p_TitleOfWork), p_URL, p_Venue, current_timestamp, current_timestamp, v_WorkTypeID, 
          CASE WHEN length(p_ArtistComposer) > 254 THEN p_ArtistComposer ELSE NULL END,
          kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_CompletedOn), researchinview.get_year(p_CompletedOn)),
          date (researchinview.get_year(p_StartedOn) || '-' || researchinview.get_month(p_StartedOn) || '-1'),
          date (researchinview.get_year(p_EndedOn) || '-' || researchinview.get_month(p_EndedOn) || '-1'),  p_Producer, p_Completed, 
          p_Ongoing, p_Performance);
 
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

   ELSE
   
      -- get the work id
      SELECT id, presentation_dmy_single_date_id
        INTO v_WorkID, v_CompletedDateID
        FROM kmdata.works
       WHERE resource_id = v_ResourceID;

      -- update the works table
      UPDATE kmdata.works
         SET user_id = v_UserID,
             artist = v_ArtistStr, 
             extended_author_list = CASE WHEN length(p_ArtistComposer) > 254 THEN p_ArtistComposer ELSE NULL END,
             city = p_City, 
             completed = p_Completed,
             producer = p_Producer,
             director = p_ConductorDirector, 
             country = p_Country, 
             performance = p_Performance,
             ongoing = p_Ongoing,
             curator = p_Curator, 
             organizer = p_Organizer, 
             percent_authorship = p_PercentAuthorship, 
             title_in = researchinview.strip_riv_tags(p_PerformanceTitle), 
             performance_company = p_PerformanceTroupe, 
             role_designator = v_Role, 
             state = v_State, 
             title = researchinview.strip_riv_tags(p_TitleOfWork), 
             url = p_URL, 
             venue = p_Venue, 
             updated_at = current_timestamp,
             work_type_id = v_WorkTypeID,
             sub_work_type_id = CAST(p_TypeOfWork AS INTEGER),
             performance_start_date = date (researchinview.get_year(p_StartedOn) || '-' || researchinview.get_month(p_StartedOn) || '-1'),
             performance_end_date = date (researchinview.get_year(p_EndedOn) || '-' || researchinview.get_month(p_EndedOn) || '-1')
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

      --v_CompletedDateID
      IF v_CompletedDateID IS NULL THEN
         v_CompletedDateID := kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_CompletedOn), researchinview.get_year(p_CompletedOn));
         
         UPDATE kmdata.works
            SET presentation_dmy_single_date_id = v_CompletedDateID
          WHERE id = v_WorkID;
      END IF;

      -- update presentation_dmy_single_date_id, 
      UPDATE kmdata.dmy_single_dates
         SET "day" = NULL,
             "month" = researchinview.get_month(p_CompletedOn),
             "year" = researchinview.get_year(p_CompletedOn)
       WHERE id = v_CompletedDateID;

   END IF;
   
   RETURN v_WorkID;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
