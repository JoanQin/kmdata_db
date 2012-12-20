CREATE OR REPLACE FUNCTION researchinview.insert_personal (
   p_IntegrationActivityId VARCHAR(2000),
   p_IntegrationUserId VARCHAR(2000),
   p_IsPublic INTEGER,
   p_ExtendedAttribute1 VARCHAR(4000),
   p_ExtendedAttribute2 VARCHAR(4000),
   p_ExtendedAttribute3 VARCHAR(4000),
   p_ExtendedAttribute4 VARCHAR(4000),
   p_ExtendedAttribute5 VARCHAR(4000),
   p_AdditionalCitizenship VARCHAR(2000),
   p_Address1 VARCHAR(2000),
   p_Address2 VARCHAR(2000),
   p_Citizenship VARCHAR(2000),
   p_City VARCHAR(2000),
   p_Country VARCHAR(2000),
   p_EmailAddress VARCHAR(2000),
   p_FaxNumber VARCHAR(2000),
   p_FirstName VARCHAR(2000),
   p_Gender VARCHAR(2000),
   p_LastName VARCHAR(2000),
   p_MiddleName VARCHAR(2000),
   p_NihEraCommonsName VARCHAR(2000),
   p_OptedOutOfResearcherIDSetup INTEGER,
   p_PhoneNumber VARCHAR(2000),
   p_Prefix VARCHAR(2000),
   p_PreviouslyUsedEmailAddresses VARCHAR(4000),
   p_PublishingName VARCHAR(2000),
   p_ResearcherID VARCHAR(2000),
   p_ResearcherIDEmailAddress VARCHAR(2000),
   p_StateProvince VARCHAR(2000),
   p_StateProvinceOther VARCHAR(2000),
   p_Suffix VARCHAR(2000),
   p_SyncWithResearcherID VARCHAR(2000),
   p_URL VARCHAR(4000),
   p_ZIPCode VARCHAR(2000)
) RETURNS BIGINT AS $$
DECLARE
   v_ActivityID BIGINT;
   v_ResourceID BIGINT;
   v_PersonalID BIGINT;
   v_PersonalMatchCount BIGINT;
   v_UserID BIGINT;
   v_State VARCHAR(2000);
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
   v_ActivityID := researchinview.insert_activity('Personal', p_IntegrationActivityId, p_IntegrationUserId, p_IsPublic, p_ExtendedAttribute1,
	p_ExtendedAttribute2, p_ExtendedAttribute3, p_ExtendedAttribute4, p_ExtendedAttribute5);

   -- get resource ID
   SELECT resource_id INTO v_ResourceID
     FROM researchinview.activity_import_log
    WHERE id = v_ActivityID;

   IF v_ResourceID IS NULL THEN
      v_ResourceID := add_new_resource('researchinview', 'user_preferred_names');
   END IF;

   -- update activity table in the researchinview schema
   UPDATE researchinview.activity_import_log
      SET resource_id = v_ResourceID
    WHERE id = v_ActivityID;

   -- ****************************************
   -- additional field mappings and processing
   -- ****************************************

   v_State := p_StateProvince;
   IF v_State IS NULL OR v_State = '' THEN
      v_State := p_StateProvinceOther;
   END IF;


   -- check to see if there is a record in user_preferred_names with this resource id
   SELECT COUNT(*) INTO v_PersonalMatchCount
     FROM kmdata.user_preferred_names
    WHERE resource_id = v_ResourceID;

   IF v_PersonalMatchCount = 0 THEN
   
      -- insert activity information
      v_PersonalID := nextval('kmdata.user_preferred_names_id_seq');
   
      INSERT INTO kmdata.user_preferred_names
         (id, resource_id, user_id, address, address_2, city, country, email, fax, 
          first_name, last_name, middle_name, phone, prefix, preferred_publishing_name, 
          state, suffix, url, zip, additional_citizenship, citizenship, gender, nih_era_commons_name,
          created_at, updated_at, opted_out_of_researcher_id_setup, previously_used_email_addressess, 
          researcher_id, researcher_id_email_address, sync_with_researcher_id )
      VALUES
         (v_PersonalID, v_ResourceID, v_UserID, p_Address1, p_Address2, p_City, p_Country, p_EmailAddress, p_FaxNumber, 
          p_FirstName, p_LastName, p_MiddleName, p_PhoneNumber, p_Prefix, p_PublishingName, 
          v_State, p_Suffix, p_URL, p_ZIPCode, p_AdditionalCitizenship, p_Citizenship, p_Gender, p_NihEraCommonsName.
          current_timestamp, current_timestamp, p_OptedOutOfResearcherIDSetup, p_PreviouslyUsedEmailAddresses,
          p_ResearcherID, p_ResearcherIDEmailAddress, p_SyncWithResearcherID );

   ELSE
   
      -- get the user preferred name id
      SELECT id INTO v_PersonalID
        FROM kmdata.user_preferred_names
       WHERE resource_id = v_ResourceID;

      -- update the user_preferred_names table
      UPDATE kmdata.user_preferred_names
         SET user_id = v_UserID,
             address = p_Address1, 
             address_2 = p_Address2, 
             city = p_City, 
             country = p_Country, 
             email = p_EmailAddress, 
             fax = p_FaxNumber, 
             first_name = p_FirstName, 
             last_name = p_LastName, 
             middle_name = p_MiddleName, 
             phone = p_PhoneNumber, 
             prefix = p_Prefix, 
             preferred_publishing_name = p_PublishingName, 
             state = v_State, 
             suffix = p_Suffix, 
             url = p_URL, 
             zip = p_ZIPCode, 
             additional_citizenship = p_AdditionalCitizenship,
             citizenship = p_Citizenship,
             gender = p_Gender,
             nih_era_commons_name = p_NihEraCommonsName,
             opted_out_of_researcher_id_setup = p_OptedOutOfResearcherIDSetup,
             previously_used_email_addressess = p_PreviouslyUsedEmailAddresses,
             researcher_id = p_ResearcherID,
             researcher_id_email_address = p_ResearcherIDEmailAddress,
             sync_with_researcher_id = p_SyncWithResearcherID,
             updated_at = current_timestamp
       WHERE id = v_PersonalID;

   END IF;
   
   RETURN v_PersonalID;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
