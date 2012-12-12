CREATE OR REPLACE FUNCTION researchinview.insert_legal (
   p_IntegrationActivityId VARCHAR(2000),
   p_IntegrationUserId VARCHAR(2000),
   p_IsPublic INTEGER,
   p_ExtendedAttribute1 VARCHAR(4000),
   p_ExtendedAttribute2 VARCHAR(4000),
   p_ExtendedAttribute3 VARCHAR(4000),
   p_ExtendedAttribute4 VARCHAR(4000),
   p_ExtendedAttribute5 VARCHAR(4000),     
   p_DescriptionOfEffort VARCHAR(4000),
   p_Enacted VARCHAR(4000),
   p_EnactedOn VARCHAR(4000),
   p_IssuingOrganization VARCHAR(4000),
   p_Number VARCHAR(2000),
   p_PercentAuthorship integer,
   p_Role VARCHAR(2000),
   p_RoleOther VARCHAR(2000),
   p_Sponsor VARCHAR(4000),
   p_SubmittedOn VARCHAR(2000),
   p_SubmittedTo VARCHAR(2000),
   p_Title VARCHAR(4000),
   p_TypeOfActivity VARCHAR(2000),
   p_TypeOfActivityOther VARCHAR(2000),
   p_URL VARCHAR(4000)
   ) RETURNS BIGINT AS $$
DECLARE
   v_ActivityID BIGINT;
   v_ResourceID BIGINT;
   v_WorkID BIGINT;
   v_WorkDescrID BIGINT;
   v_UserID BIGINT;
   v_WorksMatchCount BIGINT;
   v_WorkTypeID BIGINT;
   v_EnactedOnDateID BIGINT;
   v_SubmittedOnDateID BIGINT;

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
   v_WorkTypeID := kmdata.get_or_add_work_type_id('Legal');
   
   -- insert activity information
   v_ActivityID := researchinview.insert_activity('Legal', p_IntegrationActivityId, p_IntegrationUserId, p_IsPublic, p_ExtendedAttribute1,
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
         (id, resource_id, user_id, enacted, enacted_on_dmy_single_date_id, 
          issuing_organization, legal_number, percent_authorship, role_id, role_designator, sponsor, 
          submission_dmy_single_date_id, 
          submitted_to, title, type_of_activity, type_of_activity_other, url, work_type_id,
          created_at, updated_at)
      VALUES
         (v_WorkID, v_ResourceID, v_UserID, p_Enacted, kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_EnactedOn), researchinview.get_year(p_EnactedOn)), 
          p_IssuingOrganization, p_Number, p_PercentAuthorship, CAST(coalesce(p_Role, '0') AS integer), p_RoleOther, p_Sponsor, 
          kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_SubmittedOn), researchinview.get_year(p_SubmittedOn)), 
	  p_SubmittedTo, researchinview.strip_riv_tags(p_Title), p_TypeOfActivity, p_TypeOfActivityOther, p_URL,  v_WorkTypeID, 
          current_timestamp, current_timestamp);
   
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
      SELECT id, enacted_on_dmy_single_date_id, submission_dmy_single_date_id
        INTO v_WorkID, v_EnactedOnDateID, v_SubmittedOnDateID
        FROM kmdata.works
       WHERE resource_id = v_ResourceID;

      -- update the works table
      UPDATE kmdata.works
         SET user_id = v_UserID,
             enacted = p_Enacted,
             --enacted_on_dmy_single_date_id (below)
             issuing_organization = p_IssuingOrganization,
             legal_number = p_Number,
             percent_authorship = p_PercentAuthorship,
             role_id = CAST(coalesce(p_Role, '0') AS integer),
             role_designator = p_RoleOther,
             sponsor = p_Sponsor,
             --submission_dmy_single_date_id (below)
             submitted_to = p_SubmittedTo,
             title = p_Title,
             type_of_activity = p_TypeOfActivity,
             type_of_activity_other = p_TypeOfActivityOther,
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


      -- process enacted on date
      IF v_EnactedOnDateID IS NULL THEN
         v_EnactedOnDateID := kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_EnactedOn), researchinview.get_year(p_EnactedOn));
         
         UPDATE kmdata.works
            SET enacted_on_dmy_single_date_id = v_EnactedOnDateID
          WHERE id = v_WorkID;
      END IF;

      UPDATE kmdata.dmy_single_dates
         SET "day" = NULL,
             "month" = researchinview.get_month(p_EnactedOn),
             "year" = researchinview.get_year(p_EnactedOn)
       WHERE id = v_EnactedOnDateID;


      -- process submitted on date
      IF v_SubmittedOnDateID IS NULL THEN
         v_SubmittedOnDateID := kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_SubmittedOn), researchinview.get_year(p_SubmittedOn));
         
         UPDATE kmdata.works
            SET submission_dmy_single_date_id = v_SubmittedOnDateID
          WHERE id = v_WorkID;
      END IF;

      UPDATE kmdata.dmy_single_dates
         SET "day" = NULL,
             "month" = researchinview.get_month(p_SubmittedOn),
             "year" = researchinview.get_year(p_SubmittedOn)
       WHERE id = v_SubmittedOnDateID;
      
      
   END IF;
   
   RETURN v_WorkID;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
