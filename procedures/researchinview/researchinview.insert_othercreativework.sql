CREATE OR REPLACE FUNCTION researchinview.insert_othercreativework (
   p_IntegrationActivityId VARCHAR(2000),
   p_IntegrationUserId VARCHAR(2000),
   p_IsPublic INTEGER,
   p_ExtendedAttribute1 VARCHAR(4000),
   p_ExtendedAttribute2 VARCHAR(4000),
   p_ExtendedAttribute3 VARCHAR(4000),
   p_ExtendedAttribute4 VARCHAR(4000),
   p_ExtendedAttribute5 VARCHAR(4000),
   p_AuthorNames VARCHAR(2000),
   p_BroadcastedOn VARCHAR(2000), 
   p_Completed VARCHAR(2000),
   p_DescriptionOfEffort TEXT,
   p_EndedOn VARCHAR(2000),
   p_Format VARCHAR(2000),
   p_Forthcoming VARCHAR(2000),
   p_PercentContribution INTEGER,
   p_Role VARCHAR(2000),
   p_SponsoredBy VARCHAR(2000),
   p_StartedOn VARCHAR(2000),
   p_TitleOfWork VARCHAR(2000),
   p_TypeOfWork VARCHAR(2000),
   p_URL VARCHAR(4000)
) RETURNS BIGINT AS $$
DECLARE
   v_WorkTypeID BIGINT;
   v_ActivityID BIGINT;
   v_ResourceID BIGINT;
   v_WorkID BIGINT;
   v_WorkDescrEffortID BIGINT;
   v_WorksMatchCount BIGINT;
   v_UserID BIGINT;
   v_Forthcoming INTEGER;
   v_CreationDateID BIGINT;
   v_PresentationDateID BIGINT;
BEGIN
   -- maps to Artwork
   v_WorkTypeID := kmdata.get_or_add_work_type_id('Other Creative Work');
   
   -- select the user ID
   --v_UserID := p_IntegrationUserId;
   SELECT user_id INTO v_UserID
     FROM kmdata.user_identifiers
    WHERE emplid = p_IntegrationUserId;
   
   IF v_UserID IS NULL THEN
      RETURN 0;
   END IF;
   
   -- insert activity information
   v_ActivityID := researchinview.insert_activity('OtherCreativeWork', p_IntegrationActivityId, p_IntegrationUserId, p_IsPublic, p_ExtendedAttribute1,
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

   IF p_Forthcoming = '2' THEN
      v_Forthcoming := 1;
   ELSIF p_Forthcoming = '1' THEN
      v_Forthcoming := 2;
   ELSIF p_Forthcoming = '3' THEN
      v_Forthcoming := NULL;
   ELSE
      v_Forthcoming := NULL;
   END IF;
   
   -- update information specific to artwork
   --p_BroadcastedOn, p_Completed, p_EndedOn, p_StartedOn, p_TypeOfWork, 

   -- check to see if there is a record in works with this resource id
   SELECT COUNT(*) INTO v_WorksMatchCount
     FROM kmdata.works
    WHERE resource_id = v_ResourceID;

   IF v_WorksMatchCount = 0 THEN
   
      -- insert activity information
      v_WorkID := nextval('kmdata.works_id_seq');
   
      INSERT INTO kmdata.works
         (id, resource_id, user_id, author_list, format, forthcoming_id, percent_authorship, 
          role_designator, sponsor, title, url, 
          creation_dmy_single_date_id, -- broadcasted on
          presentation_dmy_range_date_id, -- started on / ended on
          created_at, updated_at, work_type_id)
      VALUES
         (v_WorkID, v_ResourceID, v_UserID, p_AuthorNames, p_Format, v_Forthcoming, p_PercentContribution, 
          p_Role, p_SponsoredBy, researchinview.strip_riv_tags(p_TitleOfWork), p_URL, 
          kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_BroadcastedOn), researchinview.get_year(p_BroadcastedOn)),
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

   ELSE
   
      -- get the work id
      SELECT id, creation_dmy_single_date_id, presentation_dmy_range_date_id
        INTO v_WorkID, v_CreationDateID, v_PresentationDateID
        FROM kmdata.works
       WHERE resource_id = v_ResourceID;

      -- update the works table
      UPDATE kmdata.works
         SET user_id = v_UserID,
             author_list = p_AuthorNames, 
             format = p_Format, 
             forthcoming_id = v_Forthcoming, 
             percent_authorship = p_PercentContribution, 
             role_designator = p_Role, 
             sponsor = p_SponsoredBy, 
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

      -- single
      IF v_CreationDateID IS NULL THEN
         v_CreationDateID := kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_BroadcastedOn), researchinview.get_year(p_BroadcastedOn));

         UPDATE kmdata.works
            SET creation_dmy_single_date_id = v_CreationDateID
          WHERE id = v_WorkID;
      END IF;

      -- range
      IF v_PresentationDateID IS NULL THEN
         v_PresentationDateID := kmdata.add_dmy_range_date(NULL, researchinview.get_month(p_StartedOn), researchinview.get_year(p_StartedOn),
                                                           NULL, researchinview.get_month(p_EndedOn), researchinview.get_year(p_EndedOn));

         UPDATE kmdata.works
            SET presentation_dmy_range_date_id = v_PresentationDateID
          WHERE id = v_WorkID;
      END IF;

      UPDATE kmdata.dmy_single_dates
         SET "day" = NULL,
             "month" = researchinview.get_month(p_BroadcastedOn),
             "year" = researchinview.get_year(p_BroadcastedOn)
       WHERE id = v_CreationDateID;

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
