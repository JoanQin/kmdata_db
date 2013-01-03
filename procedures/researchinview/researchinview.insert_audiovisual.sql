CREATE OR REPLACE FUNCTION researchinview.insert_audiovisual (
   p_IntegrationActivityId VARCHAR(2000),
   p_IntegrationUserId VARCHAR(2000),
   p_IsPublic INTEGER,
   p_ExtendedAttribute1 VARCHAR(4000),
   p_ExtendedAttribute2 VARCHAR(4000),
   p_ExtendedAttribute3 VARCHAR(4000),
   p_ExtendedAttribute4 VARCHAR(4000),
   p_ExtendedAttribute5 VARCHAR(4000),
   p_BroadcastedOn VARCHAR(2000),
   p_City VARCHAR(2000),
   p_Completed VARCHAR(2000),
   p_Country VARCHAR(2000),
   p_DescriptionOfEffort TEXT,
   p_Director VARCHAR(2000),
   p_DistributedBy VARCHAR(2000),
   p_EndedOn VARCHAR(2000),
   p_Format VARCHAR(2000),
   p_Forthcoming VARCHAR(2000),
   p_NameOfArtist VARCHAR(2000),
   p_NetworkName VARCHAR(2000),
   p_PercentAuthorship INTEGER,
   p_Producer VARCHAR(2000),
   p_Role VARCHAR(2000),
   p_SponsoredBy VARCHAR(2000),
   p_StartedOn VARCHAR(2000),
   p_StateProvince VARCHAR(2000),
   p_StateProvinceOther VARCHAR(2000),
   p_TitleOfWork VARCHAR(2000),
   p_TypeOfWork VARCHAR(2000),
   p_TypeOfWorkOther VARCHAR(2000),
   p_URL VARCHAR(4000)
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
   v_BroadcastDateID BIGINT;
   v_PresentationDateID BIGINT;
BEGIN
   -- maps to current type
   v_WorkTypeID := kmdata.get_or_add_work_type_id('Audiovisual Work');
   
   -- select the user ID
   --v_UserID := p_IntegrationUserId;
   SELECT user_id INTO v_UserID
     FROM kmdata.user_identifiers
    WHERE emplid = p_IntegrationUserId;
   
   IF v_UserID IS NULL THEN
      RETURN 0;
   END IF;
   
   -- insert activity information
   v_ActivityID := researchinview.insert_activity('Audiovisual', p_IntegrationActivityId, p_IntegrationUserId, p_IsPublic, p_ExtendedAttribute1,
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
   --IF v_Role = '' THEN
   --   v_Role := p_RoleOther;
   --END IF;
   
   -- update information specific to artwork
   --p_BroadcastedOn, p_Completed, p_EndedOn, p_Forthcoming, p_Producer, p_StartedOn, p_TypeOfWork

   -- check to see if there is a record in works with this resource id
   SELECT COUNT(*) INTO v_WorksMatchCount
     FROM kmdata.works
    WHERE resource_id = v_ResourceID;

   IF v_WorksMatchCount = 0 THEN
   
      -- insert activity information
      v_WorkID := nextval('kmdata.works_id_seq');
   
      INSERT INTO kmdata.works
         (id, resource_id, user_id, city, country, director, distributor, format,
          artist, network, percent_authorship, role_designator, sponsor, state, 
          broadcast_dmy_single_date_id,
          presentation_dmy_range_date_id, 
          title, url, created_at, updated_at, work_type_id,
          completed, producer, sub_work_type_id, sub_work_type_other)
      VALUES
         (v_WorkID, v_ResourceID, v_UserID, p_City, p_Country, p_Director, substr(p_DistributedBy,1,255), substr(p_Format,1,255),
          substr(p_NameOfArtist,1,255), substr(p_NetworkName,1,255), p_PercentAuthorship, v_Role, substr(p_SponsoredBy,1,255), v_State, 
          kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_BroadcastedOn), researchinview.get_year(p_BroadcastedOn)),
          kmdata.add_dmy_range_date(NULL, researchinview.get_month(p_StartedOn), researchinview.get_year(p_StartedOn),
                                    NULL, researchinview.get_month(p_EndedOn), researchinview.get_year(p_EndedOn)),
          researchinview.strip_riv_tags(p_TitleOfWork), p_URL, current_timestamp, current_timestamp, v_WorkTypeID,
          p_Completed, p_Producer, CAST(p_TypeOfWork AS INTEGER), p_TypeOfWorkOther);

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
      SELECT id, broadcast_dmy_single_date_id, presentation_dmy_range_date_id 
        INTO v_WorkID, v_BroadcastDateID, v_PresentationDateID
        FROM kmdata.works
       WHERE resource_id = v_ResourceID;

      -- update the works table
      UPDATE kmdata.works
         SET user_id = v_UserID,
             city = p_City, 
             country = p_Country, 
             director = p_Director, 
             completed = p_Completed, 
             producer = p_Producer, 
             sub_work_type_id = CAST(p_TypeOfWork AS INTEGER), 
             sub_work_type_other = p_TypeOfWorkOther,
             distributor = substr(p_DistributedBy,1,255), 
             format = substr(p_Format,1,255),
             artist = substr(p_NameOfArtist,1,255), 
             network = substr(p_NetworkName,1,255), 
             percent_authorship = p_PercentAuthorship, 
             role_designator = v_Role, 
             sponsor = substr(p_SponsoredBy,1,255), 
             state = v_State, 
             title = researchinview.strip_riv_tags(p_TitleOfWork), 
             url = p_URL, 
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

      IF v_BroadcastDateID IS NULL THEN
         v_BroadcastDateID := kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_BroadcastedOn), researchinview.get_year(p_BroadcastedOn));
         
         UPDATE kmdata.works
            SET broadcast_dmy_single_date_id = v_BroadcastDateID
          WHERE id = v_WorkID;
      END IF;

      IF v_PresentationDateID IS NULL THEN
         v_PresentationDateID := kmdata.add_dmy_range_date(NULL, researchinview.get_month(p_StartedOn), researchinview.get_year(p_StartedOn),
                                    NULL, researchinview.get_month(p_EndedOn), researchinview.get_year(p_EndedOn));

         UPDATE kmdata.works
            SET presentation_dmy_range_date_id = v_PresentationDateID
          WHERE id = v_WorkID;
      END IF;

      -- update broadcast_dmy_single_date_id, 
      UPDATE kmdata.dmy_single_dates
         SET "day" = NULL,
             "month" = researchinview.get_month(p_BroadcastedOn),
             "year" = researchinview.get_year(p_BroadcastedOn)
       WHERE id = v_BroadcastDateID;
      
      -- update presentation_dmy_range_date_id,
      UPDATE kmdata.dmy_range_dates
         SET start_day = NULL,
             start_month = researchinview.get_month(p_StartedOn),
             start_year = researchinview.get_year(p_StartedOn),
             end_day = NULL,
             end_month = researchinview.get_month(p_EndedOn),
             end_year = researchinview.get_year(p_EndedOn)
       WHERE id = v_PresentationDateID;
       
   END IF;
   
   RETURN v_WorkID;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
