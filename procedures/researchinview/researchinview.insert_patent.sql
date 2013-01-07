CREATE OR REPLACE FUNCTION researchinview.insert_patent (
   p_IntegrationActivityId VARCHAR(2000),
   p_IntegrationUserId VARCHAR(2000),
   p_IsPublic INTEGER,
   p_ExtendedAttribute1 VARCHAR(4000),
   p_ExtendedAttribute2 VARCHAR(4000),
   p_ExtendedAttribute3 VARCHAR(4000),
   p_ExtendedAttribute4 VARCHAR(4000),
   p_ExtendedAttribute5 VARCHAR(4000),   
   p_ApplicationFiledOn VARCHAR(2000),
   p_ApplicationNumber VARCHAR(2000),
   p_AttorneyAgent VARCHAR(2000),
   p_DescriptionOfEffort TEXT,
   p_DocumentNumber VARCHAR(2000),
   p_Inventor VARCHAR(2000),
   p_IssuingOrganization VARCHAR(2000),
   p_Manufacturer VARCHAR(2000),
   p_PatentAssignee VARCHAR(2000),
   p_PatentClass VARCHAR(2000),
   p_PatentGranted VARCHAR(2000),
   p_PatentGrantedOn VARCHAR(2000),
   p_PatentNumber VARCHAR(2000),
   p_PercentAuthorship INTEGER,
   p_Role VARCHAR(2000),
   p_Sponsor VARCHAR(2000),
   p_Title VARCHAR(2000),
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
BEGIN
   -- maps to Patent
   v_WorkTypeID := kmdata.get_or_add_work_type_id('Invention or Patent');
   
   -- select the user ID
   --v_UserID := p_IntegrationUserId;
   SELECT user_id INTO v_UserID
     FROM kmdata.user_identifiers
    WHERE emplid = p_IntegrationUserId;
   
   IF v_UserID IS NULL THEN
      RETURN 0;
   END IF;
   
   -- insert activity information
   v_ActivityID := researchinview.insert_activity('Patent', p_IntegrationActivityId, p_IntegrationUserId, p_IsPublic, p_ExtendedAttribute1,
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

   -- update information specific to Patent
   -- p_ApplicationNumber, p_AttorneyAgent, p_IssuingOrganization, p_PatentAssignee, p_PatentClass
   -- p_DocumentNumber (THIS IS NOT IN THE DATA MAPPING SPREADSHEET)

   -- check to see if there is a record in works with this resource id
   SELECT COUNT(*) INTO v_WorksMatchCount
     FROM kmdata.works
    WHERE resource_id = v_ResourceID;

   IF v_WorksMatchCount = 0 THEN
   
      -- insert activity information
      v_WorkID := nextval('kmdata.works_id_seq');
   
      INSERT INTO kmdata.works
         (id, resource_id, user_id, inventor, manufacturer, patent_number, percent_authorship, completed,
          role_designator, sponsor, title, url, created_at, updated_at, work_type_id,
          filed_date, 
          issued_date, issuing_organization, application_number, attorney_agent, patent_assignee, patent_class, document_number )
      VALUES
         (v_WorkID, v_ResourceID, v_UserID, p_Inventor, p_Manufacturer, p_PatentNumber, p_PercentAuthorship, p_PatentGranted,
          p_Role, p_Sponsor, researchinview.strip_riv_tags(p_Title), p_URL, current_timestamp, current_timestamp, v_WorkTypeID,
          case when researchinview.get_year(p_ApplicationFiledOn) = 0 then cast (null as date) else 
          date (researchinview.get_year(p_ApplicationFiledOn) || '-' || researchinview.get_month(p_ApplicationFiledOn) || '-1') end,
          case when researchinview.get_year(p_PatentGrantedOn) = 0 then cast(null as date) else 
          date (researchinview.get_year(p_PatentGrantedOn) || '-' || researchinview.get_month(p_PatentGrantedOn) || '-1') end,
          p_IssuingOrganization, p_ApplicationNumber, p_AttorneyAgent, p_PatentAssignee, p_PatentClass, p_DocumentNumber);
      
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
      SELECT id INTO v_WorkID
        FROM kmdata.works
       WHERE resource_id = v_ResourceID;

      -- update the works table
      UPDATE kmdata.works
         SET user_id = v_UserID,
             inventor = p_Inventor, 
             manufacturer = p_Manufacturer, 
             completed = p_PatentGranted,
             patent_number = p_PatentNumber, 
             percent_authorship = p_PercentAuthorship, 
             role_designator = p_Role, 
             issuing_organization = p_IssuingOrganization,
             application_number = p_ApplicationNumber,
             attorney_agent = p_AttorneyAgent,
             patent_assignee = p_PatentAssignee, 
             patent_class = p_PatentClass,
             document_number = p_DocumentNumber,
             sponsor = p_Sponsor, 
             title = researchinview.strip_riv_tags(p_Title), 
             url = p_URL,
             updated_at = current_timestamp,
             work_type_id = v_WorkTypeID,
             filed_date = case when researchinvew.get_year(p_ApplicationFiledOn) = 0 then cast(null as date) else 
             		date (researchinview.get_year(p_ApplicationFiledOn) || '-' || researchinview.get_month(p_ApplicationFiledOn) || '-1') end,
             issued_date = case when researchinview.get_year(p_PatentGrantedOn) = 0 then cast(null as date) else 
             		date (researchinview.get_year(p_PatentGrantedOn) || '-' || researchinview.get_month(p_PatentGrantedOn) || '-1') end
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

   END IF;
   
   RETURN v_WorkID;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
