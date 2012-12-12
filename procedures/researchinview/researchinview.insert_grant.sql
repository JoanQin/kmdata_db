CREATE OR REPLACE FUNCTION researchinview.insert_grant (
   p_IntegrationActivityId VARCHAR(2000),
   p_IntegrationUserId VARCHAR(2000),
   p_IsPublic INTEGER,
   p_ExtendedAttribute1 VARCHAR(4000),
   p_ExtendedAttribute2 VARCHAR(4000),
   p_ExtendedAttribute3 VARCHAR(4000),
   p_ExtendedAttribute4 VARCHAR(4000),
   p_ExtendedAttribute5 VARCHAR(4000),
   p_Agency VARCHAR(2000),
   p_AgencyOther VARCHAR(2000),
   p_AgencyOtherCity VARCHAR(2000),
   p_AgencyOtherCountry VARCHAR(2000),
   p_AgencyOtherStateProvince VARCHAR(2000),
   p_AgencyOtherStateProvinceOther VARCHAR(2000),
   p_ApplId INTEGER,
   p_CoInvestigator VARCHAR(2000),
   p_Currency VARCHAR(2000),
   p_DeniedOn VARCHAR(2000),
   p_DescriptionOfEffort TEXT,
   p_Duration INTEGER,
   p_EndedOn VARCHAR(2000),
   p_ExplanationOfRole VARCHAR(2000), -- this is a varchar(2000) in kmdata
   p_Fellowship VARCHAR(2000),
   p_FundingAgencyType VARCHAR(2000),
   p_FundingAgencyTypeOther VARCHAR(2000),
   p_FundingAmount BIGINT,
   p_FundingAmountBreakdown INTEGER,
   p_Goal TEXT,
   p_GrantNumber VARCHAR(2000),
   p_InitialDirectCost BIGINT,
   p_OnGoing VARCHAR(2000),
   p_OtherContributors TEXT,
   p_PercentAuthorship INTEGER,
   p_PrincipalInvestigator VARCHAR(2000),
   p_PriorityScore VARCHAR(2000),
   p_Role VARCHAR(2000),
   p_StartedOn VARCHAR(2000),
   p_Status VARCHAR(2000),
   p_SubmittedOn VARCHAR(2000),
   p_Title VARCHAR(2000),
   p_TypeOfGrant VARCHAR(2000)
) RETURNS BIGINT AS $$
DECLARE
   v_ActivityID BIGINT;
   v_ResourceID BIGINT;
   v_GrantID BIGINT;
   v_GrantDescrID BIGINT;
   v_GrantsMatchCount BIGINT;
   v_Agency VARCHAR(500);
   v_FundingAgency VARCHAR(1000);
   v_RoleID BIGINT;
   v_StatusID BIGINT;
   v_GrantTypeID BIGINT;
   v_UserID BIGINT;
   --v_State VARCHAR(2000);
   v_AgencyOtherStateProvince VARCHAR(1000);
   v_FundingAgencyType VARCHAR(1000);
BEGIN
   -- maps to Papers in Proceedings
   
   -- select the user ID
   --v_UserID := p_IntegrationUserId;
   SELECT user_id INTO v_UserID
     FROM kmdata.user_identifiers
    WHERE emplid = p_IntegrationUserId;
   
   IF v_UserID IS NULL THEN
      RETURN 0;
   END IF;
   
   -- insert activity information
   v_ActivityID := researchinview.insert_activity('Grant', p_IntegrationActivityId, p_IntegrationUserId, p_IsPublic, p_ExtendedAttribute1,
	p_ExtendedAttribute2, p_ExtendedAttribute3, p_ExtendedAttribute4, p_ExtendedAttribute5);

   -- get resource ID
   SELECT resource_id INTO v_ResourceID
     FROM researchinview.activity_import_log
    WHERE id = v_ActivityID;

   IF v_ResourceID IS NULL THEN
      v_ResourceID := add_new_resource('researchinview', 'grant_data');
   END IF;

   -- update activity table in the researchinview schema
   UPDATE researchinview.activity_import_log
      SET resource_id = v_ResourceID
    WHERE id = v_ActivityID;

   --v_State := p_StateProvince;
   --IF v_State IS NULL OR v_State = '' THEN
   --   v_State := p_StateProvinceOther;
   --END IF;
   
   -- update information specific to grants
   v_Agency := p_Agency;
   IF v_Agency IS NULL OR v_Agency = '' THEN
      v_Agency := p_AgencyOther;
   END IF;

   v_FundingAgency := p_FundingAgencyType;
   IF v_FundingAgency IS NULL OR v_FundingAgency = '' THEN
      v_FundingAgency := p_FundingAgencyTypeOther;
   END IF;

   v_RoleID := CAST(p_Role AS BIGINT);
   v_StatusID := CAST(p_Status AS BIGINT);
   v_GrantTypeID := CAST(p_TypeOfGrant AS BIGINT);

   IF p_AgencyOtherStateProvince IS NULL OR TRIM(p_AgencyOtherStateProvince) = '' THEN
      v_AgencyOtherStateProvince := p_AgencyOtherStateProvinceOther;
   ELSE
      v_AgencyOtherStateProvince := p_AgencyOtherStateProvince;
   END IF;
   
   IF p_FundingAgencyType IS NULL OR TRIM(p_FundingAgencyType) = '' THEN
      v_FundingAgencyType := p_FundingAgencyTypeOther;
   ELSE
      v_FundingAgencyType := p_FundingAgencyType;
   END IF;
   
   -- missing 
   -- p_AgencyOtherCity, p_AgencyOtherCountry, p_AgencyOtherStateProvince, p_AgencyOtherStateProvinceOther, p_ApplId,
   -- p_Currency, p_Duration, p_Fellowship, p_FundingAmountBreakdown, p_OnGoing, 
   -- *** Split to year,month,day: p_DeniedOn, p_EndedOn, p_StartedOn, p_SubmittedOn


   -- check to see if there is a record in grant_data with this resource id
   SELECT COUNT(*) INTO v_GrantsMatchCount
     FROM kmdata.grant_data
    WHERE resource_id = v_ResourceID;

   IF v_GrantsMatchCount = 0 THEN
   
      -- insert activity information
      v_GrantID := nextval('kmdata.grant_data_id_seq');
   
      INSERT INTO kmdata.grant_data
         (id, resource_id, source, co_investigator, description, explanation_of_role, agency, 
          amount_funded, goal, grant_number, direct_cost, other_contributors, percent_effort, principal_investigator,
          priority_score, role_id, status_id, title, grant_type_id, 
          start_year, start_month, start_day,
          end_year, end_month, end_day,
          submitted_year, submitted_month, submitted_day,
          denied_year, denied_month, denied_day,
          created_at, updated_at,
          agency_other, agency_other_city, agency_other_country, agency_other_state_province,
          currency, fellowship, funding_agency_type, funding_amount_breakdown, duration, funding_agency_type_other)
      VALUES
         (v_GrantID, v_ResourceID, v_Agency, p_CoInvestigator, researchinview.strip_riv_tags(p_DescriptionOfEffort), p_ExplanationOfRole, v_FundingAgency, 
          p_FundingAmount, p_Goal, p_GrantNumber, p_InitialDirectCost, p_OtherContributors, p_PercentAuthorship, p_PrincipalInvestigator, 
          p_PriorityScore, v_RoleID, v_StatusID, researchinview.strip_riv_tags(p_Title), v_GrantTypeID, 
          researchinview.get_year(p_StartedOn), researchinview.get_month(p_StartedOn), NULL,
          researchinview.get_year(p_EndedOn), researchinview.get_month(p_EndedOn), NULL,
          researchinview.get_year(p_SubmittedOn), researchinview.get_month(p_SubmittedOn), NULL,
          researchinview.get_year(p_DeniedOn), researchinview.get_month(p_DeniedOn), NULL,
          current_timestamp, current_timestamp,
          p_AgencyOther, p_AgencyOtherCity, p_AgencyOtherCountry, v_AgencyOtherStateProvince,
          p_Currency, p_Fellowship, v_FundingAgencyType, p_FundingAmountBreakdown, p_Duration, p_FundingAgencyTypeOther);

      -- add into user_grants
      INSERT INTO kmdata.user_grants
         (user_id, grant_data_id)
      VALUES
         (v_UserID, v_GrantID);

      -- add work description
      --v_GrantDescrID := kmdata.add_new_narrative('researchinview', 'Work Description', p_DescriptionOfEffort, p_IsPublic);
   
      --INSERT INTO kmdata.grant_narratives
      --   (work_id, narrative_id)
      --VALUES
      --   (v_GrantID, v_GrantDescrID);
   
   ELSE
   
      -- get the work id
      SELECT id INTO v_GrantID
        FROM kmdata.grant_data
       WHERE resource_id = v_ResourceID;

      -- update the works table
      UPDATE kmdata.grant_data
         SET source = v_Agency, 
             co_investigator = p_CoInvestigator, 
             description = researchinview.strip_riv_tags(p_DescriptionOfEffort), 
             explanation_of_role = p_ExplanationOfRole, 
             agency = v_FundingAgency, 
             amount_funded = p_FundingAmount, 
             goal = p_Goal, 
             grant_number = p_GrantNumber, 
             direct_cost = p_InitialDirectCost, 
             other_contributors = p_OtherContributors, 
             percent_effort = p_PercentAuthorship, 
             principal_investigator = p_PrincipalInvestigator,
             priority_score = p_PriorityScore, 
             role_id = v_RoleID, 
             status_id = v_StatusID, 
             title = researchinview.strip_riv_tags(p_Title), 
             grant_type_id = v_GrantTypeID,
             start_year = researchinview.get_year(p_StartedOn), 
             start_month = researchinview.get_month(p_StartedOn), 
             start_day = NULL,
             end_year = researchinview.get_year(p_EndedOn), 
             end_month = researchinview.get_month(p_EndedOn), 
             end_day = NULL,
             submitted_year = researchinview.get_year(p_SubmittedOn), 
             submitted_month = researchinview.get_month(p_SubmittedOn), 
             submitted_day = NULL,
             denied_year = researchinview.get_year(p_DeniedOn), 
             denied_month = researchinview.get_month(p_DeniedOn), 
             denied_day = NULL,
             updated_at = current_timestamp,
             agency_other = p_AgencyOther, 
             agency_other_city = p_AgencyOtherCity, 
             agency_other_country = p_AgencyOtherCountry, 
             agency_other_state_province = v_AgencyOtherStateProvince,
             currency = p_Currency, 
             fellowship = p_Fellowship, 
             funding_agency_type = v_FundingAgencyType, 
             funding_amount_breakdown = p_FundingAmountBreakdown, 
             duration = p_Duration,
             funding_agency_type_other = p_FundingAgencyTypeOther
       WHERE id = v_GrantID;

      -- get the narrative ID for description of effort
      --SELECT b.id INTO v_GrantDescrID
      --  FROM kmdata.grant_narratives a
      --  INNER JOIN kmdata.narratives b ON a.narrative_id = b.id
      --  INNER JOIN kmdata.narrative_types c ON b.narrative_type_id = c.id
      -- WHERE c.narrative_desc = 'Work Description'
      --   AND a.work_id = v_GrantID
      -- LIMIT 1;

      -- update the text and private indicator
      --UPDATE kmdata.narratives
      --   SET narrative_text = p_DescriptionOfEffort,
      --       private_ind = p_IsPublic
      -- WHERE id = v_GrantDescrID;
      
   END IF;
   
   RETURN v_GrantID;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
