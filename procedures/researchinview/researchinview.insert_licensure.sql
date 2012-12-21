CREATE OR REPLACE FUNCTION researchinview.insert_licensure (
   p_IntegrationActivityId VARCHAR(2000),
   p_IntegrationUserId VARCHAR(2000),
   p_IsPublic INTEGER,
   p_ExtendedAttribute1 VARCHAR(4000),
   p_ExtendedAttribute2 VARCHAR(4000),
   p_ExtendedAttribute3 VARCHAR(4000),
   p_ExtendedAttribute4 VARCHAR(4000),
   p_ExtendedAttribute5 VARCHAR(4000),
   p_Abbreviation VARCHAR(2000),
   p_Active VARCHAR(2000),
   p_City VARCHAR(2000),
   p_Country VARCHAR(2000),
   p_Description TEXT,
   p_EndedOn VARCHAR(2000),
   p_InstitutionCommonNameId INTEGER,
   p_LicenseNumber VARCHAR(2000),
   p_LicenseTitle VARCHAR(2000),
   p_MedicaidNumber VARCHAR(2000),
   p_NPI VARCHAR(2000),
   p_StartedOn VARCHAR(2000),
   p_StateProvince VARCHAR(2000),
   p_StateProvinceOther VARCHAR(2000),
   p_UPIN VARCHAR(2000)
   ) RETURNS BIGINT AS $$
DECLARE
   v_ActivityID BIGINT;
   v_ResourceID BIGINT;
   v_DegreeCertID BIGINT;
   v_CertDescrID BIGINT;
   v_CertOutputTextID BIGINT;
   v_UserID BIGINT;
   v_DegreeCertsMatchCount BIGINT;
   v_InstitutionID BIGINT;
   v_State VARCHAR(255);
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
   v_ActivityID := researchinview.insert_activity('Licensure', p_IntegrationActivityId, p_IntegrationUserId, p_IsPublic, p_ExtendedAttribute1,
	p_ExtendedAttribute2, p_ExtendedAttribute3, p_ExtendedAttribute4, p_ExtendedAttribute5);

   -- get resource ID
   SELECT resource_id INTO v_ResourceID
     FROM researchinview.activity_import_log
    WHERE id = v_ActivityID;

   IF v_ResourceID IS NULL THEN
      v_ResourceID := add_new_resource('researchinview', 'degree_certifications');
   END IF;

   -- update activity table in the researchinview schema
   UPDATE researchinview.activity_import_log
      SET resource_id = v_ResourceID
    WHERE id = v_ActivityID;

   -- check to see if there is a record in degree_certifications with this resource id
   SELECT COUNT(*) INTO v_DegreeCertsMatchCount
     FROM kmdata.degree_certifications
    WHERE resource_id = v_ResourceID;


   -- map fields here

   -- don't have: p_Active, p_EndedOn, p_StartedOn

   -- institution
   v_InstitutionID := researchinview.insert_institution(p_InstitutionCommonNameId);

   -- state
   IF p_StateProvince IS NULL OR p_StateProvince = '' THEN
      v_State := p_StateProvinceOther;
   ELSE
      v_State := p_StateProvince;
   END IF;
   
   IF v_DegreeCertsMatchCount = 0 THEN
   
      -- insert activity information
      v_DegreeCertID := nextval('kmdata.degree_certifications_id_seq');

      -- insert into degree_certifications, certifying_body_id, start_year, start_month, end_year, end_month, subspecialty,  npi, upin, medicaid, 
      INSERT INTO kmdata.degree_certifications
         (id, user_id, institution_id, title, abbreviation, city, 
          country, medicaid, npi, state, upin, license_number, active,
          start_year, start_month, 
          end_year, end_month,
          resource_id, created_at, updated_at)
      VALUES
         (v_DegreeCertID, v_UserID, v_InstitutionID, researchinview.strip_riv_tags(p_LicenseTitle), p_Abbreviation, p_City,
          p_Country, p_MedicaidNumber, p_NPI, v_State, p_UPIN,  p_LicenseNumber, p_Active,
          researchinview.get_year(p_StartedOn), researchinview.get_month(p_StartedOn),
          researchinview.get_year(p_EndedOn), researchinview.get_month(p_EndedOn),
	  v_ResourceID, current_timestamp, current_timestamp);
	      
      
      -- add work description
      v_CertDescrID := kmdata.add_new_narrative('researchinview', 'Licensure Description', researchinview.strip_riv_tags(p_Description), p_IsPublic);
   
      INSERT INTO kmdata.degree_certification_narratives
         (degree_certification_id, narrative_id)
      VALUES
         (v_DegreeCertID, v_CertDescrID);
   
   ELSE
   
      -- get the work id
      SELECT id INTO v_DegreeCertID
        FROM kmdata.degree_certifications
       WHERE resource_id = v_ResourceID;

      -- update the works table
      UPDATE kmdata.degree_certifications
         SET user_id = v_UserID,
             active = p_Active,
             institution_id = v_InstitutionID, 
             title = researchinview.strip_riv_tags(p_LicenseTitle), 
             abbreviation = p_Abbreviation, 
             city = p_City, 
             country = p_Country, 
             medicaid = p_MedicaidNumber, 
             npi =  p_NPI, 
             state = v_State, 
             upin = p_UPIN, 
             license_number = p_LicenseNumber, 
             start_year = researchinview.get_year(p_StartedOn), 
             start_month = researchinview.get_month(p_StartedOn), 
             end_year = researchinview.get_year(p_EndedOn), 
             end_month = researchinview.get_month(p_EndedOn),
             updated_at = current_timestamp
       WHERE id = v_DegreeCertID;

      -- get the narrative ID for description of effort
      SELECT b.id INTO v_CertDescrID
        FROM kmdata.degree_certification_narratives a
        INNER JOIN kmdata.narratives b ON a.narrative_id = b.id
        INNER JOIN kmdata.narrative_types c ON b.narrative_type_id = c.id
       WHERE c.narrative_desc = 'Licensure Description'
         AND a.degree_certification_id = v_DegreeCertID
       LIMIT 1;

      -- update the text and private indicator
      UPDATE kmdata.narratives
         SET narrative_text = researchinview.strip_riv_tags(p_Description),
             private_ind = p_IsPublic
       WHERE id = v_CertDescrID;
      
   END IF;
   
   RETURN v_DegreeCertID;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
