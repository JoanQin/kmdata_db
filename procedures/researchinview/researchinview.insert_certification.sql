CREATE OR REPLACE FUNCTION researchinview.insert_certification (
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
   p_CertificationTitle VARCHAR(4000),
   p_Description TEXT,
   p_Discipline VARCHAR(4000),
   p_DisciplineOther VARCHAR(4000),
   p_EndedOn VARCHAR(2000),
   p_Institution INTEGER,
   p_LicenseNumber VARCHAR(2000),
   p_StartedOn VARCHAR(2000)
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
   v_Subspecialty VARCHAR(255);
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
   v_ActivityID := researchinview.insert_activity('Certification', p_IntegrationActivityId, p_IntegrationUserId, p_IsPublic, p_ExtendedAttribute1,
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

   -- institution
   v_InstitutionID := researchinview.insert_institution(p_Institution);

   -- Discpline/Specialty
   IF p_Discipline IS NOT NULL THEN
      -- go to the lookup
      SELECT a.name INTO v_Subspecialty
        FROM researchinview.riv_aamc_medical_specialties a
       WHERE a.id = CAST(p_Discipline AS BIGINT)
       LIMIT 1;
   ELSIF p_DisciplineOther IS NOT NULL THEN
      v_Subspecialty := SUBSTR(p_DisciplineOther,1,255);
   ELSE
      v_Subspecialty := NULL;
   END IF;
   
   IF v_DegreeCertsMatchCount = 0 THEN
   
      -- insert activity information
      v_DegreeCertID := nextval('kmdata.degree_certifications_id_seq');

      -- insert into degree_certifications, certifying_body_id, start_year, start_month, end_year, end_month, npi, upin, medicaid, 
      INSERT INTO kmdata.degree_certifications
         (id, user_id, institution_id, resource_id, title, 
          license_number, abbreviation, subspecialty,
          start_year, start_month,
          end_year, end_month,
          created_at, updated_at)
      VALUES
         (v_DegreeCertID, v_UserID, v_InstitutionID, v_ResourceID, researchinview.strip_riv_tags(p_CertificationTitle),
	  p_LicenseNumber, p_Abbreviation, v_Subspecialty,
	  researchinview.get_year(p_StartedOn), researchinview.get_month(p_StartedOn),
	  researchinview.get_year(p_EndedOn), researchinview.get_month(p_EndedOn),
	  current_timestamp, current_timestamp);
	      
      
      -- add work description
      v_CertDescrID := kmdata.add_new_narrative('researchinview', 'Certification Description', researchinview.strip_riv_tags(p_Description), p_IsPublic);
   
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
             institution_id = v_InstitutionID,
             title = researchinview.strip_riv_tags(p_CertificationTitle),
             license_number = p_LicenseNumber,
             abbreviation = p_Abbreviation,
             subspecialty = v_Subspecialty,
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
       WHERE c.narrative_desc = 'Certification Description'
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
