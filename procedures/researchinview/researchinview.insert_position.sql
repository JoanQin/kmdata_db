CREATE OR REPLACE FUNCTION researchinview.insert_position (
   p_IntegrationActivityId VARCHAR(2000),
   p_IntegrationUserId VARCHAR(2000),
   p_IsPublic INTEGER,
   p_ExtendedAttribute1 VARCHAR(4000),
   p_ExtendedAttribute2 VARCHAR(4000),
   p_ExtendedAttribute3 VARCHAR(4000),
   p_ExtendedAttribute4 VARCHAR(4000),
   p_ExtendedAttribute5 VARCHAR(4000),
   p_BusinessName VARCHAR(2000),
   p_City VARCHAR(2000),
   p_Country VARCHAR(2000),
   p_CurrentPosition VARCHAR(2000),
   p_Description VARCHAR(4000),
   p_Division VARCHAR(2000),
   p_EndedOn VARCHAR(2000),
   p_HigherEdCollege VARCHAR(2000),
   p_HigherEdPosition VARCHAR(2000),
   p_HigherEdPositionTitle VARCHAR(2000),
   p_HigherEdPositionTitleOther VARCHAR(2000),
   p_HigherEdSchool VARCHAR(2000),
   p_Institute VARCHAR(2000),
   p_InstitutionCommonNameId INTEGER,
   p_InstitutionGroupOther VARCHAR(2000),
   p_InstitutionGroupId VARCHAR(2000),
   p_PercentTime INTEGER,
   p_PositionTitle VARCHAR(2000),
   p_PositionType VARCHAR(2000),
   p_PositionTypeOther VARCHAR(2000),
   p_StartedOn VARCHAR(2000),
   p_StateProvince VARCHAR(2000),
   p_StateProvinceOther VARCHAR(2000),
   p_SubjectArea VARCHAR(2000)
   --p_HigherEdDepartment VARCHAR(2000),
) RETURNS BIGINT AS $$
DECLARE
   v_ActivityID BIGINT;
   v_ResourceID BIGINT;
   v_UserPositionID BIGINT;
   v_PositionsMatchCount BIGINT;
   v_UserID BIGINT;
   v_State VARCHAR(255);
   v_InstitutionID BIGINT;
   v_HigherEdPosTitle VARCHAR(2000);
   v_Unit VARCHAR(2000);
   v_PositionTypeText VARCHAR(2000);
   v_Current SMALLINT;
   v_StartDateID BIGINT;
   v_EndDateID BIGINT;
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
   v_ActivityID := researchinview.insert_activity('Position', p_IntegrationActivityId, p_IntegrationUserId, p_IsPublic, p_ExtendedAttribute1,
	p_ExtendedAttribute2, p_ExtendedAttribute3, p_ExtendedAttribute4, p_ExtendedAttribute5);

   -- get resource ID
   SELECT resource_id INTO v_ResourceID
     FROM researchinview.activity_import_log
    WHERE id = v_ActivityID;

   IF v_ResourceID IS NULL THEN
      v_ResourceID := add_new_resource('researchinview', 'user_positions');
   END IF;

   -- update activity table in the researchinview schema
   UPDATE researchinview.activity_import_log
      SET resource_id = v_ResourceID
    WHERE id = v_ActivityID;

   -- parse the date
   --p_PublishedDate
   
   -- update information specific to user positions
   v_State := p_StateProvince;
   IF p_StateProvince IS NULL OR p_StateProvince = '' THEN
      v_State := p_StateProvinceOther;
   END IF;

   v_InstitutionID := researchinview.insert_institution(p_InstitutionCommonNameId);

   v_HigherEdPosTitle := p_HigherEdPositionTitle;
   IF v_HigherEdPosTitle IS NULL OR v_HigherEdPosTitle = '' THEN
      v_HigherEdPosTitle := p_HigherEdPositionTitleOther;
   END IF;

   v_Unit := p_InstitutionGroupId;
   IF p_InstitutionGroupId IS NULL OR p_InstitutionGroupId = '' THEN
      v_Unit := p_InstitutionGroupOther;
   END IF;

   v_PositionTypeText := p_PositionType;
   IF v_PositionTypeText IS NULL OR v_PositionTypeText = '' THEN
      v_PositionTypeText := p_PositionTypeOther;
   END IF;

   v_Current := 0;
   IF p_CurrentPosition IS NULL OR p_CurrentPosition = '' THEN
      v_Current := 0;
   ELSIF p_CurrentPosition = '1' OR UPPER(p_CurrentPosition) = 'Y' OR UPPER(p_CurrentPosition) = 'YES' THEN
      v_Current := 1;
   ELSE
      v_Current := 0;
   END IF;

   -- check to see if there is a record in positions with this resource id
   SELECT COUNT(*) INTO v_PositionsMatchCount
     FROM kmdata.user_positions
    WHERE resource_id = v_ResourceID;

   IF v_PositionsMatchCount = 0 THEN
   
      -- insert activity information
      v_UserPositionID := nextval('kmdata.user_positions_user_id_seq');
   
      INSERT INTO kmdata.user_positions
         (id, user_id, business_name, city, state, country, current_ind, description,
          division, institution_id, higher_ed_college, higher_ed_position_title,
          higher_ed_school, institute, unit, percent_time, position_title, position_type, subject_area,
          started_dmy_single_date_id,
          ended_dmy_single_date_id,
          resource_id, created_at, updated_at)
      VALUES
         (v_UserPositionID, v_UserID, p_BusinessName, p_City, v_State, p_Country, v_Current, researchinview.strip_riv_tags(p_Description),
          p_Division, v_InstitutionID, p_HigherEdCollege, v_HigherEdPosTitle,
          p_HigherEdSchool, p_Institute, v_Unit, p_PercentTime, researchinview.strip_riv_tags(p_PositionTitle), v_PositionTypeText, p_SubjectArea,
          kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_StartedOn), researchinview.get_year(p_StartedOn)),
          kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_EndedOn), researchinview.get_year(p_EndedOn)),
          v_ResourceID, current_timestamp, current_timestamp);

   ELSE
   
      -- get the work id
      SELECT id, started_dmy_single_date_id, ended_dmy_single_date_id
        INTO v_UserPositionID, v_StartDateID, v_EndDateID
        FROM kmdata.user_positions
       WHERE resource_id = v_ResourceID;

      -- update the user_positions table
      UPDATE kmdata.user_positions
         SET user_id = v_UserID,
             business_name = p_BusinessName, 
             city = p_City, 
             state = v_State, 
             country = p_Country, 
             current_ind = v_Current, 
             description = researchinview.strip_riv_tags(p_Description),
             division = p_Division, 
             institution_id = v_InstitutionID, 
             higher_ed_college = p_HigherEdCollege, 
             higher_ed_position_title = v_HigherEdPosTitle,
             higher_ed_school = p_HigherEdSchool, 
             institute = p_Institute, 
             unit = v_Unit, 
             percent_time = p_PercentTime, 
             position_title = researchinview.strip_riv_tags(p_PositionTitle), 
             position_type = v_PositionTypeText, 
             subject_area = p_SubjectArea,
             updated_at = current_timestamp
       WHERE id = v_UserPositionID;

      -- single
      IF v_StartDateID IS NULL THEN
         v_StartDateID := kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_StartedOn), researchinview.get_year(p_StartedOn));

         UPDATE kmdata.user_positions
            SET started_dmy_single_date_id = v_StartDateID
          WHERE id = v_UserPositionID;
      END IF;
      
      -- single
      IF v_EndDateID IS NULL THEN
         v_EndDateID := kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_EndedOn), researchinview.get_year(p_EndedOn));

         UPDATE kmdata.user_positions
            SET ended_dmy_single_date_id = v_EndDateID
          WHERE id = v_UserPositionID;
      END IF;
      
      UPDATE kmdata.dmy_single_dates
         SET "day" = NULL,
             "month" = researchinview.get_month(p_StartedOn),
             "year" = researchinview.get_year(p_StartedOn)
       WHERE id = v_StartDateID;

      UPDATE kmdata.dmy_single_dates
         SET "day" = NULL,
             "month" = researchinview.get_month(p_EndedOn),
             "year" = researchinview.get_year(p_EndedOn)
       WHERE id = v_EndDateID;

   END IF;
   
   RETURN v_UserPositionID;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
