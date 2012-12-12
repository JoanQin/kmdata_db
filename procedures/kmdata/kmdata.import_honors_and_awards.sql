CREATE OR REPLACE FUNCTION kmdata.import_honors_and_awards (
) RETURNS BIGINT AS $$
DECLARE
   v_intNewItemID BIGINT;
   v_UserHonorsAwardsID BIGINT;
   v_ResourceID BIGINT;
   v_SelectedNarrID BIGINT;
   v_CompNarrID BIGINT;
   v_OutputTextNarrID BIGINT;
   
   honorsQuery CURSOR FOR 
      SELECT e.user_id, d.id AS honor_type_id, a.name, a.monetary_component_ind, a.monetary_amount,
         a.fellow_ind, a.internal_ind, f.id AS institution_id, a.sponsor, a.subject, a.start_year,
         a.end_year, a.selected, a.competitiveness, a.output_text, 0 AS private_ind
      FROM osupro.honor a
      INNER JOIN osupro.academic_item b ON a.item_id = b.item_id
      INNER JOIN osupro.honor_type_ref c ON a.honor_type_id = c.id
      INNER JOIN kmdata.honor_types d ON c.type = d.type
      INNER JOIN kmdata.user_identifiers e ON b.profile_emplid = e.emplid
      LEFT JOIN kmdata.institutions f ON a.institution_id = f.pro_id;

   --SELECT item_id, year, approach_goals_results, approach, goals, results, output_text
   --FROM osupro.teaching_approach
BEGIN
   -- select and return the existing id
   v_intNewItemID := 0;

   -- loop through biographical narratives
   FOR currHonor IN honorsQuery LOOP

      -- get the resource id
      v_ResourceID := kmdata.add_new_resource('osupro', 'user_honors_awards');
      
      -- get the next sequence ID
      v_UserHonorsAwardsID := nextval('kmdata.user_honors_awards_id_seq');

      -- insert the honors and awards record
      INSERT INTO kmdata.user_honors_awards
         (id, user_id, resource_id, honor_type_id, name,
          monetary_component_ind, monetary_amount, fellow_ind, internal_ind,
          institution_id, sponsor, subject, start_year, end_year)
      VALUES
         (v_UserHonorsAwardsID, currHonor.user_id, v_ResourceID, currHonor.honor_type_id, currHonor.name,
          currHonor.monetary_component_ind, currHonor.monetary_amount, currHonor.fellow_ind, currHonor.internal_ind,
          currHonor.institution_id, currHonor.sponsor, currHonor.subject, currHonor.start_year, currHonor.end_year);

      -- add the narratives (3)
      IF currHonor.selected IS NOT NULL AND TRIM(currHonor.selected) != '' THEN

         v_SelectedNarrID := kmdata.add_new_narrative('osupro', 'User Honors Selected', currHonor.selected, currHonor.private_ind, currHonor.user_id);
      
         INSERT INTO kmdata.user_honors_awards_narratives (user_honors_awards_id, narrative_id)
            VALUES (v_UserHonorsAwardsID, v_SelectedNarrID);
            
      END IF;
      
      IF currHonor.competitiveness IS NOT NULL AND TRIM(currHonor.competitiveness) != '' THEN

         v_CompNarrID := kmdata.add_new_narrative('osupro', 'User Honors Competitiveness', currHonor.competitiveness, currHonor.private_ind, currHonor.user_id);

         INSERT INTO kmdata.user_honors_awards_narratives (user_honors_awards_id, narrative_id)
            VALUES (v_UserHonorsAwardsID, v_CompNarrID);
            
      END IF;
      
      IF currHonor.output_text IS NOT NULL AND TRIM(currHonor.output_text) != '' THEN

         v_OutputTextNarrID := kmdata.add_new_narrative('osupro', 'User Honors Output Text', currHonor.output_text, currHonor.private_ind, currHonor.user_id);

         INSERT INTO kmdata.user_honors_awards_narratives (user_honors_awards_id, narrative_id)
            VALUES (v_UserHonorsAwardsID, v_OutputTextNarrID);
            
      END IF;

   END LOOP;

   RETURN v_intNewItemID;
END;
$$ LANGUAGE plpgsql;
