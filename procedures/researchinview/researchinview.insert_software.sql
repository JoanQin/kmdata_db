CREATE OR REPLACE FUNCTION researchinview.insert_software (
   p_IntegrationActivityId VARCHAR(2000),
   p_IntegrationUserId VARCHAR(2000),
   p_IsPublic INTEGER,
   p_ExtendedAttribute1 VARCHAR(4000),
   p_ExtendedAttribute2 VARCHAR(4000),
   p_ExtendedAttribute3 VARCHAR(4000),
   p_ExtendedAttribute4 VARCHAR(4000),
   p_ExtendedAttribute5 VARCHAR(4000),
   p_AuthorNames VARCHAR(2000),
   p_DescriptionOfEffort TEXT,
   p_Distributor VARCHAR(2000),
   p_LastUpdatedOn VARCHAR(2000),
   p_PercentContribution INTEGER,
   p_PublishedOn VARCHAR(2000),
   p_Publisher VARCHAR(2000),
   p_Role VARCHAR(2000),
   p_TitleOfWork VARCHAR(2000),
   p_TypeOfWork VARCHAR(2000),
   p_TypeOfWorkOther VARCHAR(2000),
   p_URL VARCHAR(4000),
   p_VersionNumber VARCHAR(2000)
) RETURNS BIGINT AS $$
DECLARE
   v_WorkTypeID BIGINT;
   v_ActivityID BIGINT;
   v_ResourceID BIGINT;
   v_WorkID BIGINT;
   v_WorkDescrEffortID BIGINT;
   v_WorksMatchCount BIGINT;
   v_UserID BIGINT;
   v_Role VARCHAR(2000);
   v_TypeDescr VARCHAR(255);
   v_PublicationDateID BIGINT;
   v_LastUpdateDateID BIGINT;
   v_TypeOfWork BIGINT;
BEGIN
   -- maps to current type
   v_WorkTypeID := kmdata.get_or_add_work_type_id('Software or Online Multimedia');
   
   -- select the user ID
   --v_UserID := p_IntegrationUserId;
   SELECT user_id INTO v_UserID
     FROM kmdata.user_identifiers
    WHERE emplid = p_IntegrationUserId;
   
   IF v_UserID IS NULL THEN
      RETURN 0;
   END IF;
   
   -- insert activity information
   v_ActivityID := researchinview.insert_activity('Software', p_IntegrationActivityId, p_IntegrationUserId, p_IsPublic, p_ExtendedAttribute1,
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

   -- process p_Role and p_RoleOther for role_designator
   v_Role := p_Role;
   --IF v_Role = '' THEN
   --   v_Role := p_RoleOther;
   --END IF;

   -- p_TypeOfWork of 4 means other
   v_TypeDescr := p_TypeOfWorkOther;
   IF p_TypeOfWork = '1' THEN
      v_TypeDescr := 'Database';
   ELSIF p_TypeOfWork = '2' THEN
      v_TypeDescr := 'Computer Program/Software';
   ELSIF p_TypeOfWork = '3' THEN
      v_TypeDescr := 'Website';
   END IF;
   
   -- update information specific to artwork
   --p_LastUpdatedOn, p_PublishedOn, 

   IF p_TypeOfWork IS NULL OR TRIM(p_TypeOfWork) = '' THEN
      v_TypeOfWork := NULL;
   ELSE
      v_TypeOfWork := p_TypeOfWork;
   END IF;

   -- check to see if there is a record in works with this resource id
   SELECT COUNT(*) INTO v_WorksMatchCount
     FROM kmdata.works
    WHERE resource_id = v_ResourceID;

   IF v_WorksMatchCount = 0 THEN
   
      -- insert activity information
      v_WorkID := nextval('kmdata.works_id_seq');
   
      INSERT INTO kmdata.works
         (id, resource_id, user_id, author_list, sponsor, percent_authorship, publisher, 
          role_designator, title, medium, url, edition, 
          publication_dmy_single_date_id,
          last_update_dmy_single_date_id,
          created_at, updated_at, work_type_id,
          distributor, sub_work_type_id, sub_work_type_other)
      VALUES
         (v_WorkID, v_ResourceID, v_UserID, p_AuthorNames, p_Distributor, p_PercentContribution, p_Publisher, 
          v_Role, researchinview.strip_riv_tags(p_TitleOfWork), v_TypeDescr, p_URL, p_VersionNumber, 
          kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_PublishedOn), researchinview.get_year(p_PublishedOn)),
          kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_LastUpdatedOn), researchinview.get_year(p_LastUpdatedOn)),
          current_timestamp, current_timestamp, v_WorkTypeID,
          p_Distributor, v_TypeOfWork, p_TypeOfWorkOther);

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
      SELECT id, publication_dmy_single_date_id, last_update_dmy_single_date_id
        INTO v_WorkID, v_PublicationDateID, v_LastUpdateDateID
        FROM kmdata.works
       WHERE resource_id = v_ResourceID;

      -- update the works table
      UPDATE kmdata.works
         SET user_id = v_UserID,
             author_list = p_AuthorNames, 
             sponsor = p_Distributor, 
             percent_authorship = p_PercentContribution, 
             publisher = p_Publisher, 
             role_designator = v_Role, 
             title = researchinview.strip_riv_tags(p_TitleOfWork), 
             medium = v_TypeDescr, 
             url = p_URL, 
             edition = p_VersionNumber,
             updated_at = current_timestamp,
             work_type_id = v_WorkTypeID,
             distributor = p_Distributor, 
             sub_work_type_id = v_TypeOfWork, 
             sub_work_type_other = p_TypeOfWorkOther
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

      --p_PublishedOn
      IF v_PublicationDateID IS NULL THEN
         v_PublicationDateID := kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_PublishedOn), researchinview.get_year(p_PublishedOn));
         
         UPDATE kmdata.works
            SET publication_dmy_single_date_id = v_PublicationDateID
          WHERE id = v_WorkID;
      END IF;

      --p_LastUpdatedOn
      IF v_LastUpdateDateID IS NULL THEN
         v_LastUpdateDateID := kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_LastUpdatedOn), researchinview.get_year(p_LastUpdatedOn));

         UPDATE kmdata.works
            SET last_update_dmy_single_date_id = v_LastUpdateDateID
          WHERE id = v_WorkID;
      END IF;

      -- update presentation_dmy_single_date_id, 
      UPDATE kmdata.dmy_single_dates
         SET "day" = NULL,
             "month" = researchinview.get_month(p_PublishedOn),
             "year" = researchinview.get_year(p_PublishedOn)
       WHERE id = v_PublicationDateID;

      UPDATE kmdata.dmy_single_dates
         SET "day" = NULL,
             "month" = researchinview.get_month(p_LastUpdatedOn),
             "year" = researchinview.get_year(p_LastUpdatedOn)
       WHERE id = v_LastUpdateDateID;

   END IF;
   
   RETURN v_WorkID;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
