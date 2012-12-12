CREATE OR REPLACE FUNCTION researchinview.insert_clinicaltrial (
   p_IntegrationActivityId VARCHAR(2000),
   p_IntegrationUserId VARCHAR(2000),
   p_IsPublic INTEGER,
   p_ExtendedAttribute1 VARCHAR(4000),
   p_ExtendedAttribute2 VARCHAR(4000),
   p_ExtendedAttribute3 VARCHAR(4000),
   p_ExtendedAttribute4 VARCHAR(4000),
   p_ExtendedAttribute5 VARCHAR(4000),
   p_ApprovedOn VARCHAR(2000), 
   p_City VARCHAR(2000),
   p_ClinicalTrialsIdentifier VARCHAR(2000),
   p_ConditionStudied VARCHAR(2000),
   p_Country VARCHAR(2000),
   p_DescriptionOfEffort TEXT, 
   p_EndedOn VARCHAR(2000),
   p_HumanSubjects VARCHAR(2000),
   p_InterventionAnalyzed VARCHAR(2000),
   p_Investigator VARCHAR(2000),
   p_Ongoing VARCHAR(2000),
   p_PercentEffort INTEGER,
   p_ProtocolId VARCHAR(2000),
   p_RegulatoryApproval VARCHAR(2000),
   p_RegulatoryApprovalOther VARCHAR(2000),
   p_Role VARCHAR(2000),
   p_RoleOther VARCHAR(2000),
   p_SiteName VARCHAR(2000),
   p_Sponsor VARCHAR(2000),
   p_StartedOn VARCHAR(2000),
   p_StateProvince VARCHAR(2000),
   p_StateProvinceOther VARCHAR(2000),
   p_TitleOfTrial VARCHAR(2000),
   p_URL VARCHAR(4000),
   p_VertebrateAnimalsUsed VARCHAR(2000)
   ) RETURNS BIGINT AS $$
DECLARE
   v_ActivityID BIGINT;
   v_ResourceID BIGINT;
   v_ClinicalTrialID BIGINT;
   v_UserID BIGINT;
   v_ClinicalTrialsMatchCount BIGINT;
   v_RoleTypeID INTEGER;
   v_State VARCHAR(255);
   v_RegulatoryApproval VARCHAR(2000);
BEGIN
   -- fields not used: p_ApprovedOn, p_ClinicalTrialsIdentifier, p_ConditionStudied, p_HumanSubjects, p_InterventionAnalyzed, p_Ongoing, p_PercentEffort,
   --  p_RegulatoryApproval, p_RegulatoryApprovalOther, p_RoleOther, p_SiteName, p_VertebrateAnimalsUsed
   -- skipped: p_EndedOn, p_StartedOn, 

   -- select the user ID
   --v_UserID := p_IntegrationUserId;
   SELECT user_id INTO v_UserID
     FROM kmdata.user_identifiers
    WHERE emplid = p_IntegrationUserId;
   
   IF v_UserID IS NULL THEN
      RETURN 0;
   END IF;
   
   -- insert activity information
   v_ActivityID := researchinview.insert_activity('ClinicalTrial', p_IntegrationActivityId, p_IntegrationUserId, p_IsPublic, p_ExtendedAttribute1,
	p_ExtendedAttribute2, p_ExtendedAttribute3, p_ExtendedAttribute4, p_ExtendedAttribute5);

   -- get resource ID
   SELECT resource_id INTO v_ResourceID
     FROM researchinview.activity_import_log
    WHERE id = v_ActivityID;

   IF v_ResourceID IS NULL THEN
      v_ResourceID := add_new_resource('researchinview', 'clinical_trials');
   END IF;

   -- update activity table in the researchinview schema
   UPDATE researchinview.activity_import_log
      SET resource_id = v_ResourceID
    WHERE id = v_ActivityID;

   -- check to see if there is a record in clinical_trials with this resource id
   SELECT COUNT(*) INTO v_ClinicalTrialsMatchCount
     FROM kmdata.clinical_trials
    WHERE resource_id = v_ResourceID;


   -- map fields here

   v_RoleTypeID := CAST(p_Role AS INTEGER);

   v_State := p_StateProvince;
   IF v_State IS NULL OR v_State = '' THEN
      v_State := p_StateProvinceOther;
   END IF;

   -- these are not used: 
   -- ommitted: p_EndedOn, p_StartedOn
   /*
	approvedOn
	conditionstudied
	interventionAnalyzed
	percentEffort
	regulatoryApproval
	regulatoryApprovalOther
	roleother
	sitename
   */

   IF p_RegulatoryApproval IS NULL OR TRIM(v_RegulatoryApproval) = '' THEN
      v_RegulatoryApproval := p_RegulatoryApprovalOther;
   ELSE
      v_RegulatoryApproval := p_RegulatoryApproval;
   END IF;
   
   IF v_ClinicalTrialsMatchCount = 0 THEN
   
      -- insert activity information
      v_ClinicalTrialID := nextval('kmdata.clinical_trials_id_seq');

      -- NOT READY: p_ProtocolId -> split into 4 fields
      INSERT INTO kmdata.clinical_trials
         (id, user_id, location_city, country, summary, principal_investigator, role_type_id, 
          sponsor, location_state, title, url, 
          start_year, start_month, start_day, 
          end_year, end_month, end_day, 
          created_at, updated_at, resource_id,
          approved_on, 
          condition_studied, intervention_analyzed, percent_effort,
          regulatory_approval, role_other, site_name)
      VALUES
         (v_ClinicalTrialID, v_UserID, p_City, p_Country, researchinview.strip_riv_tags(p_DescriptionOfEffort), p_Investigator, v_RoleTypeID, 
          p_Sponsor, v_State, researchinview.strip_riv_tags(p_TitleOfTrial), p_URL, 
          researchinview.get_year(p_StartedOn), researchinview.get_month(p_StartedOn), NULL,
          researchinview.get_year(p_EndedOn), researchinview.get_month(p_EndedOn), NULL,
          current_timestamp, current_timestamp, v_ResourceID,
          date (researchinview.get_year(p_ApprovedOn) || '-' || researchinview.get_month(p_ApprovedOn) || '-1'),
          p_ConditionStudied, p_InterventionAnalyzed, p_PercentEffort,
          v_RegulatoryApproval, p_RoleOther, p_SiteName);
      
   ELSE
   
      -- get the narrative
      SELECT id INTO v_ClinicalTrialID
        FROM kmdata.clinical_trials
       WHERE resource_id = v_ResourceID;

      -- update the clinical_trials table
      UPDATE kmdata.clinical_trials
         SET user_id = v_UserID, 
             location_city = p_City, 
             country = p_Country, 
             summary = researchinview.strip_riv_tags(p_DescriptionOfEffort), 
             principal_investigator = p_Investigator, 
             role_type_id = v_RoleTypeID, 
             sponsor = p_Sponsor, 
             location_state = v_State, 
             title = researchinview.strip_riv_tags(p_TitleOfTrial), 
             url = p_URL,
             start_year = researchinview.get_year(p_StartedOn), 
             start_month = researchinview.get_month(p_StartedOn), 
             start_day = NULL, 
             end_year = researchinview.get_year(p_EndedOn), 
             end_month = researchinview.get_month(p_EndedOn), 
             end_day = NULL, 
             updated_at = current_timestamp,
             approved_on = date (researchinview.get_year(p_ApprovedOn) || '-' || researchinview.get_month(p_ApprovedOn) || '-1'), 
             condition_studied = p_ConditionStudied, 
             intervention_analyzed = p_InterventionAnalyzed, 
             percent_effort = p_PercentEffort,
             regulatory_approval = v_RegulatoryApproval, 
             role_other = p_RoleOther, 
             site_name = p_SiteName
       WHERE id = v_ClinicalTrialID;

   END IF;
   
   RETURN v_ClinicalTrialID;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
