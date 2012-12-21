CREATE OR REPLACE FUNCTION researchinview.insert_degree (
   p_IntegrationActivityId VARCHAR(2000),
   p_IntegrationUserId VARCHAR(2000),
   p_IsPublic INTEGER,
   p_ExtendedAttribute1 VARCHAR(4000),
   p_ExtendedAttribute2 VARCHAR(4000),
   p_ExtendedAttribute3 VARCHAR(4000),
   p_ExtendedAttribute4 VARCHAR(4000),
   p_ExtendedAttribute5 VARCHAR(4000),
   p_ConferredOn VARCHAR(2000),
   p_DegreeType VARCHAR(2000),
   p_DegreeTypeOther VARCHAR(2000),
   p_FieldOfStudy VARCHAR(2000),
   p_Honorific TEXT,
   p_InstitutionCommonNameId INTEGER,
   p_StartedOn VARCHAR(2000),
   p_TerminalDegree VARCHAR(2000)
) RETURNS BIGINT AS $$
DECLARE
   v_ActivityID BIGINT;
   v_ResourceID BIGINT;
   v_DegreeCertificationID BIGINT;
   v_DegreesMatchCount BIGINT;
   v_UserID BIGINT;
   v_State VARCHAR(255);
   v_InstitutionID BIGINT;
   v_NarrativeID BIGINT;
   v_TerminalInd SMALLINT;
   v_AreaOfStudy VARCHAR(2000);
   v_DegreeTypeID BIGINT;
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
   v_ActivityID := researchinview.insert_activity('Degree', p_IntegrationActivityId, p_IntegrationUserId, p_IsPublic, p_ExtendedAttribute1,
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

   -- parse the date
   --p_PublishedDate

   --TODO: p_DegreeType, p_ConferredOn (end date), p_StartedOn
   
   -- update information specific to degrees and certifications
   v_InstitutionID := researchinview.insert_institution(p_InstitutionCommonNameId);

   IF p_TerminalDegree IS NULL OR p_TerminalDegree = '' THEN
      v_TerminalInd := 0;
   ELSIF p_TerminalDegree = '1' OR UPPER(p_TerminalDegree) = 'Y' OR UPPER(p_TerminalDegree) = 'YES' THEN 
      v_TerminalInd := 1;
   ELSE
      v_TerminalInd := 0;
   END IF;

   v_AreaOfStudy := p_FieldOfStudy;
   IF v_AreaOfStudy IS NULL OR v_AreaOfStudy = '' THEN
      v_AreaOfStudy := p_ExtendedAttribute1;
   END IF;

   -- map degree types  v_DegreeTypeID
   IF p_DegreeType IS NOT NULL THEN
      -- lookup based on RIV degree type ID
      SELECT a.id INTO v_DegreeTypeID
        FROM kmdata.degree_types a
       WHERE a.riv_id = CAST(p_DegreeType AS BIGINT);
   ELSIF p_DegreeTypeOther IS NOT NULL THEN
      -- lookup based on RIV Other description, basically a fuzzy search attempt
      SELECT a.id INTO v_DegreeTypeID
        FROM kmdata.degree_types a
       WHERE REPLACE(a.description_abbreviation,'.','') = p_DegreeTypeOther;
   ELSE
      -- no match
      v_DegreeTypeID := NULL;
   END IF;

   -- check to see if there is a record in positions with this resource id
   SELECT COUNT(*) INTO v_DegreesMatchCount
     FROM kmdata.degree_certifications
    WHERE resource_id = v_ResourceID;

   IF v_DegreesMatchCount = 0 THEN
   
      -- insert activity information
      v_DegreeCertificationID := nextval('kmdata.degree_certifications_id_seq');
   
      INSERT INTO kmdata.degree_certifications
         (id, user_id, institution_id, area_of_study, terminal_ind, --cip_code_id
          degree_type_id, area_of_study,
          start_year, start_month, 
          end_year, end_month, 
          resource_id, created_at, updated_at)
      VALUES
         (v_DegreeCertificationID, v_UserID, v_InstitutionID, p_FieldOfStudy, v_TerminalInd, --CIP code
          v_DegreeTypeID, v_AreaOfStudy,
          researchinview.get_year(p_StartedOn), researchinview.get_month(p_StartedOn),
          researchinview.get_year(p_ConferredOn), researchinview.get_month(p_ConferredOn),
          v_ResourceID, current_timestamp, current_timestamp);
      
      v_NarrativeID := kmdata.add_new_narrative('researchinview', 'Degree Description', researchinview.strip_riv_tags(p_Honorific), p_IsPublic);

      INSERT INTO kmdata.degree_certification_narratives
         (degree_certification_id, narrative_id)
      VALUES
         (v_DegreeCertificationID, v_NarrativeID);
         
   ELSE
   
      -- get the degree id
      SELECT id INTO v_DegreeCertificationID
        FROM kmdata.degree_certifications
       WHERE resource_id = v_ResourceID;

      -- update the degree_certifications table
      UPDATE kmdata.degree_certifications
         SET user_id = v_UserID,
             institution_id = v_InstitutionID, 
             area_of_study = v_AreaOfStudy,
             --cip_code_id = p_FieldOfStudy, 
             terminal_ind = v_TerminalInd,
             degree_type_id = v_DegreeTypeID,
             start_year = researchinview.get_year(p_StartedOn), 
             start_month = researchinview.get_month(p_StartedOn), 
             end_year = researchinview.get_year(p_ConferredOn), 
             end_month = researchinview.get_month(p_ConferredOn),
             updated_at = current_timestamp
       WHERE id = v_DegreeCertificationID;

      -- get the narrative ID for degree description
      SELECT b.id INTO v_NarrativeID
        FROM kmdata.degree_certification_narratives a
        INNER JOIN kmdata.narratives b ON a.narrative_id = b.id
        INNER JOIN kmdata.narrative_types c ON b.narrative_type_id = c.id
       WHERE c.narrative_desc = 'Degree Description'
         AND a.degree_certification_id = v_DegreeCertificationID
       LIMIT 1;

      -- update the text and private indicator
      UPDATE kmdata.narratives
         SET narrative_text = researchinview.strip_riv_tags(p_Honorific),
             private_ind = p_IsPublic
       WHERE id = v_NarrativeID;
      
   END IF;
   
   RETURN v_DegreeCertificationID;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
