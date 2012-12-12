CREATE OR REPLACE FUNCTION kmdata.import_degrees_and_certifications (
) RETURNS BIGINT AS $$
DECLARE

   DegreesCursor CURSOR FOR SELECT d.user_id, c.id AS institution_id, f.id AS degree_type_id, a.start_year, a.start_month,
         a.end_year, a.end_month, h.id AS cip_code_id, a.area_of_study, a.terminal_ind, a.description, a.output_text
      FROM osupro.degree a
      INNER JOIN osupro.academic_item b ON a.item_id = b.item_id
      INNER JOIN kmdata.institutions c ON a.institution_id = c.pro_id
      INNER JOIN kmdata.user_identifiers d ON b.profile_emplid = d.emplid
      LEFT JOIN osupro.degree_type_ref e ON a.degree_type_id = e.id
      LEFT JOIN kmdata.degree_types f ON e.description_abbreviation = f.description_abbreviation 
         AND e.transcript_abbreviation = f.transcript_abbreviation 
         AND e.degree_description = f.degree_description
      LEFT JOIN osupro.cip_code_ref g ON a.cip_code_id = g.id
      LEFT JOIN kmdata.cip_codes h ON g.code = h.code;

   CertificationsCursor CURSOR FOR SELECT d.user_id, c.id AS institution_id, a.title, f.id AS certifying_body_id, a.subspecialty, a.license_number,
         a.npi, a.upin, a.medicaid, a.abbreviation, a.start_year, a.start_month,a.end_year, a.end_month, a.description, a.output_text
      FROM osupro.certification a
      INNER JOIN osupro.academic_item b ON a.item_id = b.item_id
      INNER JOIN kmdata.institutions c ON a.institution_id = c.pro_id
      INNER JOIN kmdata.user_identifiers d ON b.profile_emplid = d.emplid
      LEFT JOIN osupro.certification_certifying_body_ref e ON a.certifying_body_id = e.id
      LEFT JOIN kmdata.certifying_bodies f ON e.certifying_body = f.certifying_body;

   v_LocationID BIGINT;
   v_MatchCount BIGINT;
   v_ResourceID BIGINT;
   v_DegreeCertID BIGINT;
   v_NarrativeID BIGINT;
   v_ReturnValue INTEGER := 0;
   v_DegreeMatchCount BIGINT;
   v_CertficationMatchCount BIGINT;
BEGIN
   
   FOR currRecord IN DegreesCursor LOOP

      SELECT COUNT(*) INTO v_DegreeMatchCount
      FROM kmdata.degree_certifications
      WHERE user_id = currRecord.user_id
      AND institution_id = currRecord.institution_id
      AND degree_type_id = currRecord.degree_type_id;

      IF v_DegreeMatchCount < 1 THEN
	      -- get the resource ID
	      v_ResourceID := kmdata.add_new_resource('osupro', 'degree_certifications');

	      v_DegreeCertID := nextval('kmdata.degree_certifications_id_seq');

	      INSERT INTO kmdata.degree_certifications
		 (id, user_id, institution_id, degree_type_id, resource_id, start_year, start_month, end_year, end_month,
		  cip_code_id, area_of_study, terminal_ind)
	      VALUES
		 (v_DegreeCertID, currRecord.user_id, currRecord.institution_id, currRecord.degree_type_id, v_ResourceID, currRecord.start_year, currRecord.start_month, currRecord.end_year, currRecord.end_month,
		  currRecord.cip_code_id, currRecord.area_of_study, currRecord.terminal_ind);
	      
	      -- narrative_type: Degree Description
	      IF currRecord.description IS NOT NULL AND TRIM(currRecord.description) != '' THEN
	      
		 v_NarrativeID := kmdata.add_new_narrative('osupro', 'Degree Description', CAST(currRecord.description AS TEXT), 0);
		 
		 INSERT INTO kmdata.degree_certification_narratives
		    (degree_certification_id, narrative_id)
		 VALUES
		    (v_DegreeCertID, v_NarrativeID);
		    
	      END IF;
	      
	      -- narrative_type: Degree Ouput Text
	      IF currRecord.output_text IS NOT NULL AND TRIM(currRecord.output_text) != '' THEN
	      
		 v_NarrativeID := kmdata.add_new_narrative('osupro', 'Degree Output Text', CAST(currRecord.output_text AS TEXT), 0);
		 
		 INSERT INTO kmdata.degree_certification_narratives
		    (degree_certification_id, narrative_id)
		 VALUES
		    (v_DegreeCertID, v_NarrativeID);
		    
	      END IF;
      ELSE
         -- issue update
         SELECT id INTO v_DegreeCertID
         FROM kmdata.degree_certifications
         WHERE user_id = currRecord.user_id
         AND institution_id = currRecord.institution_id
         AND degree_type_id = currRecord.degree_type_id;

         UPDATE kmdata.degree_certifications
         SET start_year = currRecord.start_year, 
            start_month = currRecord.start_month, 
            end_year = currRecord.end_year, 
            end_month = currRecord.end_month,
	    cip_code_id = currRecord.cip_code_id, 
	    area_of_study = currRecord.area_of_study, 
	    terminal_ind = currRecord.terminal_ind
         WHERE id = v_DegreeCertID;

         UPDATE kmdata.narratives
         SET narrative_text = CAST(currRecord.description AS TEXT)
         WHERE id IN (SELECT a.narrative_id
                     FROM kmdata.degree_certification_narratives a
                     INNER JOIN kmdata.narratives b ON a.narrative_id = b.id
                     INNER JOIN kmdata.narrative_types c ON b.narrative_type_id = c.id
                     WHERE a.degree_certification_id = v_DegreeCertID
                     AND c.narrative_desc = 'Degree Description');
         UPDATE kmdata.narratives
         SET narrative_text = CAST(currRecord.output_text AS TEXT)
         WHERE id IN (SELECT a.narrative_id
                     FROM kmdata.degree_certification_narratives a
                     INNER JOIN kmdata.narratives b ON a.narrative_id = b.id
                     INNER JOIN kmdata.narrative_types c ON b.narrative_type_id = c.id
                     WHERE a.degree_certification_id = v_DegreeCertID
                     AND c.narrative_desc = 'Degree Output Text');
      END IF;
   END LOOP;

   FOR currRecord IN CertificationsCursor LOOP

      SELECT COUNT(*) INTO v_CertficationMatchCount
      FROM kmdata.degree_certifications
      WHERE user_id = currRecord.user_id
      AND institution_id = currRecord.institution_id
      AND certifying_body_id = currRecord.certifying_body_id;
      
      IF v_CertficationMatchCount < 1 THEN
	      
	      -- get the resource ID
	      v_ResourceID := kmdata.add_new_resource('osupro', 'degree_certifications');
	      
	      v_DegreeCertID := nextval('kmdata.degree_certifications_id_seq');

	      INSERT INTO kmdata.degree_certifications
		 (id, user_id, institution_id, certifying_body_id, resource_id, title, start_year, start_month, end_year, end_month,
		  subspecialty, license_number, npi, upin, medicaid, abbreviation)
	      VALUES
		 (v_DegreeCertID, currRecord.user_id, currRecord.institution_id, currRecord.certifying_body_id, v_ResourceID, currRecord.title, currRecord.start_year, currRecord.start_month, currRecord.end_year, currRecord.end_month,
		  currRecord.subspecialty, currRecord.license_number, currRecord.npi, currRecord.upin, currRecord.medicaid, currRecord.abbreviation);
	      
	      -- narrative_type: Certification Description
	      IF currRecord.description IS NOT NULL AND TRIM(currRecord.description) != '' THEN
	      
		 v_NarrativeID := kmdata.add_new_narrative('osupro', 'Certification Description', CAST(currRecord.description AS TEXT), 0);
		 
		 INSERT INTO kmdata.degree_certification_narratives
		    (degree_certification_id, narrative_id)
		 VALUES
		    (v_DegreeCertID, v_NarrativeID);
		    
	      END IF;
	      
	      -- narrative_type: Certification Output Text
	      IF currRecord.output_text IS NOT NULL AND TRIM(currRecord.output_text) != '' THEN
	      
		 v_NarrativeID := kmdata.add_new_narrative('osupro', 'Certification Output Text', CAST(currRecord.output_text AS TEXT), 0);
		 
		 INSERT INTO kmdata.degree_certification_narratives
		    (degree_certification_id, narrative_id)
		 VALUES
		    (v_DegreeCertID, v_NarrativeID);
		    
	      END IF;
      ELSE
         -- issue update
         SELECT id INTO v_DegreeCertID
         FROM kmdata.degree_certifications
         WHERE user_id = currRecord.user_id
         AND institution_id = currRecord.institution_id
         AND certifying_body_id = currRecord.certifying_body_id;

         UPDATE kmdata.degree_certifications
         SET title = currRecord.title, 
            start_year = currRecord.start_year, 
            start_month = currRecord.start_month, 
            end_year = currRecord.end_year, 
            end_month = currRecord.end_month,
            subspecialty = currRecord.subspecialty, 
	    license_number = currRecord.license_number, 
	    npi = currRecord.npi, 
	    upin = currRecord.upin, 
	    medicaid = currRecord.medicaid, 
	    abbreviation = currRecord.abbreviation
         WHERE id = v_DegreeCertID;

         UPDATE kmdata.narratives
         SET narrative_text = CAST(currRecord.description AS TEXT)
         WHERE id IN (SELECT a.narrative_id
                     FROM kmdata.degree_certification_narratives a
                     INNER JOIN kmdata.narratives b ON a.narrative_id = b.id
                     INNER JOIN kmdata.narrative_types c ON b.narrative_type_id = c.id
                     WHERE a.degree_certification_id = v_DegreeCertID
                     AND c.narrative_desc = 'Certification Description');
         UPDATE kmdata.narratives
         SET narrative_text = CAST(currRecord.output_text AS TEXT)
         WHERE id IN (SELECT a.narrative_id
                     FROM kmdata.degree_certification_narratives a
                     INNER JOIN kmdata.narratives b ON a.narrative_id = b.id
                     INNER JOIN kmdata.narrative_types c ON b.narrative_type_id = c.id
                     WHERE a.degree_certification_id = v_DegreeCertID
                     AND c.narrative_desc = 'Certification Output Text');
      END IF;
      
   END LOOP;
   
   -- return value
   RETURN v_ReturnValue;
END;
$$ LANGUAGE plpgsql;
