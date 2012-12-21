CREATE OR REPLACE FUNCTION researchinview.insert_committee (
   p_IntegrationActivityId VARCHAR(2000),
   p_IntegrationUserId VARCHAR(2000),
   p_IsPublic INTEGER,
   p_ExtendedAttribute1 VARCHAR(4000),
   p_ExtendedAttribute2 VARCHAR(4000),
   p_ExtendedAttribute3 VARCHAR(4000),
   p_ExtendedAttribute4 VARCHAR(4000),
   p_ExtendedAttribute5 VARCHAR(4000),
   p_CommitteeGroup VARCHAR(2000),
   p_CommitteeLevel VARCHAR(2000),
   p_DescriptionOfEffort TEXT, 
   p_EndedOn VARCHAR(2000),
   p_InstitutionCommonNameID INTEGER,
   p_OnCommittee VARCHAR(2000),
   p_PercentEffort INTEGER,
   p_Role VARCHAR(2000),
   p_RoleModifier VARCHAR(2000),
   p_StartedOn VARCHAR(2000),
   p_Subcommittee VARCHAR(2000),
   p_URL VARCHAR(4000),
   p_Workgroup VARCHAR(2000)
   ) RETURNS BIGINT AS $$
DECLARE
   v_ActivityID BIGINT;
   v_ResourceID BIGINT;
   v_CommitteeID BIGINT;
   v_UserID BIGINT;
   v_CommitteesMatchCount BIGINT;
   v_RoleTypeID INTEGER;
   v_Inst BIGINT;
   v_ActiveInd SMALLINT;
   v_WorkDescrID BIGINT;
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
   v_ActivityID := researchinview.insert_activity('Committee', p_IntegrationActivityId, p_IntegrationUserId, p_IsPublic, p_ExtendedAttribute1,
	p_ExtendedAttribute2, p_ExtendedAttribute3, p_ExtendedAttribute4, p_ExtendedAttribute5);

   -- get resource ID
   SELECT resource_id INTO v_ResourceID
     FROM researchinview.activity_import_log
    WHERE id = v_ActivityID;

   IF v_ResourceID IS NULL THEN
      v_ResourceID := add_new_resource('researchinview', 'user_services');
   END IF;

   -- update activity table in the researchinview schema
   UPDATE researchinview.activity_import_log
      SET resource_id = v_ResourceID
    WHERE id = v_ActivityID;

   -- check to see if there is a record in user_services with this resource id
   SELECT COUNT(*) INTO v_CommitteesMatchCount
     FROM kmdata.user_services
    WHERE resource_id = v_ResourceID;


   -- map fields here

   v_RoleTypeID := CAST(p_Role AS INTEGER);

   -- fields not used: p_PercentEffort, p_URL
   -- skipped: p_EndedOn, p_StartedOn, 

   v_Inst := researchinview.insert_institution(p_InstitutionCommonNameID);

   v_ActiveInd := 1;
   IF upper(p_OnCommittee) = 'N' OR p_OnCommittee = '0' THEN
      v_ActiveInd := 0;
   END IF;
  
   IF v_CommitteesMatchCount = 0 THEN
   
      -- insert activity information
      v_CommitteeID := nextval('kmdata.user_services_id_seq');

      -- NOT READY: p_ProtocolId -> split into 4 fields
      INSERT INTO kmdata.user_services
         (id, user_id, group_name, service_unit_id, institution_id, active_ind, service_role_id, 
          service_role_modifier_id, subcommittee_name, workgroup_name, 
          start_year, end_year, percent_effort, url,
          created_at, updated_at, resource_id)
      VALUES
         (v_CommitteeID, v_UserID, p_CommitteeGroup, CAST(p_CommitteeLevel AS INTEGER), v_Inst, v_ActiveInd, v_RoleTypeID, 
          CAST(p_RoleModifier AS INTEGER), p_Subcommittee, p_Workgroup, 
          researchinview.get_year(p_StartedOn), researchinview.get_year(p_EndedOn), p_PercentEffort, p_URL,
          current_timestamp, current_timestamp, v_ResourceID);

      -- add narrative
      --p_DescriptionOfEffort
      v_WorkDescrID := kmdata.add_new_narrative('researchinview', 'User Service Notes', researchinview.strip_riv_tags(p_DescriptionOfEffort), p_IsPublic);
   
      INSERT INTO kmdata.user_service_narratives
         (user_service_id, narrative_id)
      VALUES
         (v_CommitteeID, v_WorkDescrID);
   
      
   ELSE
   
      -- get the narrative
      SELECT id INTO v_CommitteeID
        FROM kmdata.user_services
       WHERE resource_id = v_ResourceID;

      -- update the user_services table
      UPDATE kmdata.user_services
         SET user_id = v_UserID, 
             group_name = p_CommitteeGroup, 
             service_unit_id = CAST(p_CommitteeLevel AS INTEGER), 
             institution_id = v_Inst, 
             percent_effort = p_PercentEffort, 
             url = p_URL,
             active_ind = v_ActiveInd, 
             service_role_id = v_RoleTypeID, 
             service_role_modifier_id = CAST(p_RoleModifier AS INTEGER), 
             subcommittee_name = p_Subcommittee, 
             workgroup_name = p_Workgroup,
             start_year = researchinview.get_year(p_StartedOn), 
             end_year = researchinview.get_year(p_EndedOn), 
             updated_at = current_timestamp
       WHERE id = v_CommitteeID;

      -- get the narrative ID for description of effort
      SELECT b.id INTO v_WorkDescrID
        FROM kmdata.user_service_narratives a
        INNER JOIN kmdata.narratives b ON a.narrative_id = b.id
        INNER JOIN kmdata.narrative_types c ON b.narrative_type_id = c.id
       WHERE c.narrative_desc = 'User Service Notes'
         AND a.user_service_id = v_CommitteeID
       LIMIT 1;

      -- update the text and private indicator
      UPDATE kmdata.narratives
         SET narrative_text = researchinview.strip_riv_tags(p_DescriptionOfEffort),
             private_ind = p_IsPublic
       WHERE id = v_WorkDescrID;
      
   END IF;
   
   RETURN v_CommitteeID;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
