CREATE OR REPLACE FUNCTION researchinview.insert_strategicinitiative (
   p_IntegrationActivityId VARCHAR(2000),
   p_IntegrationUserId VARCHAR(2000),
   p_IsPublic INTEGER,
   p_ExtendedAttribute1 VARCHAR(4000),
   p_ExtendedAttribute2 VARCHAR(4000),
   p_ExtendedAttribute3 VARCHAR(4000),
   p_ExtendedAttribute4 VARCHAR(4000),
   p_ExtendedAttribute5 VARCHAR(4000),
   p_Activity VARCHAR(2000),
   p_ActivityOther VARCHAR(2000),
   p_CurrentlyActive VARCHAR(2000),
   p_DescriptionOfEffort TEXT, 
   p_EndedOn VARCHAR(2000),
   p_InstitutionCommonNameID INTEGER,
   p_InstitutionGroupOther VARCHAR(2000),
   p_IntegrationGroupId VARCHAR(2000),
   p_Role VARCHAR(2000),
   p_RoleOther VARCHAR(2000),
   p_StartedOn VARCHAR(2000),
   p_URL VARCHAR(4000)
   ) RETURNS BIGINT AS $$
DECLARE
   v_ActivityID BIGINT;
   v_ResourceID BIGINT;
   v_StrategicInitiativeID BIGINT;
   v_UserID BIGINT;
   v_StratInitMatchCount BIGINT;
   v_RoleTypeID INTEGER;
   v_Inst BIGINT;
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
   v_ActivityID := researchinview.insert_activity('StrategicInitiative', p_IntegrationActivityId, p_IntegrationUserId, p_IsPublic, p_ExtendedAttribute1,
	p_ExtendedAttribute2, p_ExtendedAttribute3, p_ExtendedAttribute4, p_ExtendedAttribute5);

   -- get resource ID
   SELECT resource_id INTO v_ResourceID
     FROM researchinview.activity_import_log
    WHERE id = v_ActivityID;

   IF v_ResourceID IS NULL THEN
      v_ResourceID := add_new_resource('researchinview', 'strategic_initiatives');
   END IF;

   -- update activity table in the researchinview schema
   UPDATE researchinview.activity_import_log
      SET resource_id = v_ResourceID
    WHERE id = v_ActivityID;

   -- check to see if there is a record in strategic_initiatives with this resource id
   SELECT COUNT(*) INTO v_StratInitMatchCount
     FROM kmdata.strategic_initiatives
    WHERE resource_id = v_ResourceID;


   -- map fields here

   v_RoleTypeID := CAST(p_Role AS INTEGER);

   -- fields not used: p_ActivityOther, p_InstitutionGroupOther, p_IntegrationGroupId, p_URL
   -- skipped:  p_EndedOn, p_StartedOn

   v_Inst := researchinview.insert_institution(p_InstitutionCommonNameID);

   IF v_StratInitMatchCount = 0 THEN
   
      -- insert activity information
      v_StrategicInitiativeID := nextval('kmdata.strategic_initiatives_id_seq');

      INSERT INTO kmdata.strategic_initiatives
         (id, user_id, activity_id, active_ind, summary, institution_id, role_name, 
          start_year, end_year,
          created_at, updated_at, resource_id)
      VALUES
         (v_StrategicInitiativeID, v_UserID, CAST(p_Activity AS BIGINT), CAST(p_CurrentlyActive AS SMALLINT), researchinview.strip_riv_tags(p_DescriptionOfEffort), v_Inst, p_Role, 
          researchinview.get_year(p_StartedOn), researchinview.get_year(p_EndedOn), 
          current_timestamp, current_timestamp, v_ResourceID);

   ELSE
   
      -- get the narrative
      SELECT id INTO v_StrategicInitiativeID
        FROM kmdata.strategic_initiatives
       WHERE resource_id = v_ResourceID;

      -- update the strategic initiatitves table
      UPDATE kmdata.strategic_initiatives
         SET user_id = v_UserID, 
             activity_id = CAST(p_Activity AS BIGINT), 
             active_ind = CAST(p_CurrentlyActive AS SMALLINT), 
             summary = researchinview.strip_riv_tags(p_DescriptionOfEffort), 
             institution_id = v_Inst, 
             role_name = p_Role,
             start_year = researchinview.get_year(p_StartedOn), 
             end_year = researchinview.get_year(p_EndedOn),
             updated_at = current_timestamp
       WHERE id = v_StrategicInitiativeID;

   END IF;
   
   RETURN v_StrategicInitiativeID;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
