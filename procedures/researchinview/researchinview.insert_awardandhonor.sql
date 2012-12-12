CREATE OR REPLACE FUNCTION researchinview.insert_awardandhonor (
   p_IntegrationActivityId VARCHAR(2000),
   p_IntegrationUserId VARCHAR(2000),
   p_IsPublic INTEGER,
   p_ExtendedAttribute1 VARCHAR(4000),
   p_ExtendedAttribute2 VARCHAR(4000),
   p_ExtendedAttribute3 VARCHAR(4000),
   p_ExtendedAttribute4 VARCHAR(4000),
   p_ExtendedAttribute5 VARCHAR(4000),   
   p_AmountOfAward BIGINT,
   p_AwardedOn VARCHAR(2000),
   p_Currency VARCHAR(2000),
   p_Eligibility VARCHAR(2000),
   p_EligibilityOther VARCHAR(2000),
   p_EndedOn VARCHAR(2000),
   p_Fellowship VARCHAR(2000),
   p_InstitutionCommonNameId INTEGER,
   p_MonetaryComponent VARCHAR(2000),
   p_NameOfAward VARCHAR(2000),
   p_ReachOfAward VARCHAR(2000),
   p_SelectionProcess VARCHAR(2000),
   p_SelectionProcessOther VARCHAR(2000),
   p_Sponsor VARCHAR(2000),
   p_SubjectArea VARCHAR(2000),
   p_TypeOfAward VARCHAR(2000),
   p_TypeOfAwardOther VARCHAR(2000),
   p_URL VARCHAR(4000)
   ) RETURNS BIGINT AS $$
DECLARE
   v_ActivityID BIGINT;
   v_ResourceID BIGINT;
   v_AwardAndHonorID BIGINT;
   v_AwardDescrID BIGINT;
   v_UserID BIGINT;
   v_AwardsMatchCount BIGINT;
   v_Fellow SMALLINT;
   v_Inst BIGINT;
   v_MonetaryComponent SMALLINT;
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
   v_ActivityID := researchinview.insert_activity('AwardAndHonor', p_IntegrationActivityId, p_IntegrationUserId, p_IsPublic, p_ExtendedAttribute1,
	p_ExtendedAttribute2, p_ExtendedAttribute3, p_ExtendedAttribute4, p_ExtendedAttribute5);

   -- get resource ID
   SELECT resource_id INTO v_ResourceID
     FROM researchinview.activity_import_log
    WHERE id = v_ActivityID;

   IF v_ResourceID IS NULL THEN
      v_ResourceID := add_new_resource('researchinview', 'user_honors_awards');
   END IF;

   -- update activity table in the researchinview schema
   UPDATE researchinview.activity_import_log
      SET resource_id = v_ResourceID
    WHERE id = v_ActivityID;

   -- check to see if there is a record in user_honors_awards with this resource id
   SELECT COUNT(*) INTO v_AwardsMatchCount
     FROM kmdata.user_honors_awards
    WHERE resource_id = v_ResourceID;


   --map fields

   -- skip: p_Currency, p_Eligibility, p_ReachOfAward, p_SelectionProcess, p_SelectionProcessOther, p_TypeOfAwardOther, p_URL
   -- save for later: p_AwardedOn, p_EndedOn, 

   v_Fellow := 0;
   IF upper(p_Fellowship) = 'Y' OR p_Fellowship = '1' THEN
      v_Fellow := 1;
   END IF;

   v_Inst := researchinview.insert_institution(p_InstitutionCommonNameID);

   v_MonetaryComponent := 0;
   IF upper(p_MonetaryComponent) = 'Y' OR p_MonetaryComponent = '1' THEN
      v_MonetaryComponent := 1;
   END IF;


   IF v_AwardsMatchCount = 0 THEN
   
      -- insert activity information
      v_AwardAndHonorID := nextval('kmdata.user_honors_awards_id_seq');

      INSERT INTO kmdata.user_honors_awards
         (id, resource_id, user_id, monetary_amount, fellow_ind, institution_id, monetary_component_ind, 
          honor_name, sponsor, subject, honor_type_id, competitiveness, selected, 
          start_year,
          end_year,
          created_at, updated_at)
      VALUES
         (v_AwardAndHonorID, v_ResourceID, v_UserID, p_AmountOfAward, v_Fellow, v_Inst, v_MonetaryComponent, 
          p_NameOfAward, p_Sponsor, p_SubjectArea, 2, p_Eligibility, p_SelectionProcess,  --CAST(p_TypeOfAward AS INTEGER), 
          researchinview.get_year(p_AwardedOn),
          researchinview.get_year(p_EndedOn),
          current_timestamp, current_timestamp);
   
   ELSE
   
      -- get the work id
      SELECT id INTO v_AwardAndHonorID
        FROM kmdata.user_honors_awards
       WHERE resource_id = v_ResourceID;

      -- update the user_honors_awards table
      UPDATE kmdata.user_honors_awards
         SET user_id = v_UserID,
             monetary_amount = p_AmountOfAward, 
             fellow_ind = v_Fellow, 
             institution_id = v_Inst, 
             monetary_component_ind = v_MonetaryComponent, 
             honor_name = p_NameOfAward, 
             sponsor = p_Sponsor, 
             subject = p_SubjectArea, 
             honor_type_id = 2, --CAST(p_TypeOfAward AS INTEGER),
             competitiveness = p_Eligibility, 
             selected = p_SelectionProcess,
             start_year = researchinview.get_year(p_AwardedOn),
             end_year = researchinview.get_year(p_EndedOn),
             updated_at = current_timestamp
       WHERE id = v_AwardAndHonorID;

   END IF;
   
   RETURN v_AwardAndHonorID;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
