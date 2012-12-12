CREATE OR REPLACE FUNCTION kmdata.import_user_services (
) RETURNS BIGINT AS $$
DECLARE

   AdminServiceCursor CURSOR FOR SELECT c.user_id, 
      a.group_name, a.subcommittee_name, a.workgroup_name, 
      a.start_year, a.active_ind, a.end_year, a.student_affairs_ind,
      a.notes, a.output_text, g.id AS service_unit_id, h.id AS service_role_id, i.id AS service_role_modifier_id,
      k.id AS institution_id
   FROM osupro.administrative_service a
   INNER JOIN osupro.academic_item b ON a.item_id = b.item_id
   INNER JOIN kmdata.user_identifiers c ON b.profile_emplid = c.emplid
   LEFT JOIN osupro.administrative_service_unit_ref d ON a.administrative_service_unit_id = d.id
   LEFT JOIN osupro.administrative_service_role_ref e ON a.administrative_service_role_id = e.id
   LEFT JOIN osupro.administrative_service_role_modifier_ref f ON a.administrative_service_role_modifier_id = f.id
   LEFT JOIN kmdata.service_units g ON d.unit = g.unit
   LEFT JOIN kmdata.service_roles h ON e.role = h.role
   LEFT JOIN kmdata.service_role_modifiers i ON f.modifier = i.modifier
   LEFT JOIN osupro.institute_ref j ON a.institution_id = j.id
   LEFT JOIN kmdata.institutions k ON j.id = k.pro_id
   WHERE k.id IS NOT NULL;

   -- RESOURCEID, INSTITUTIONID, SERVICEUNITID, SERVICEROLEMODIFIERID, SERICEROLEDID,

   v_ResourceID BIGINT;
   v_UserServiceID BIGINT;
   v_NotesNarrID BIGINT;
   v_OutputTextNarrID BIGINT;
   v_ReturnValue INTEGER := 0;
BEGIN
   -- loop through the cursor
   FOR currSvc IN AdminServiceCursor LOOP

      -- get the resource
      v_ResourceID := kmdata.add_new_resource('osupro', 'user_services');

      -- get the next sequence ID
      v_UserServiceID := nextval('kmdata.user_services_id_seq');

      -- insert the user_services record
      INSERT INTO kmdata.user_services
         (id, user_id, resource_id, institution_id, service_unit_id, group_name,
          subcommittee_name, workgroup_name, service_role_id, service_role_modifier_id,
          start_year, active_ind, end_year, student_affairs_ind)
      VALUES
         (v_UserServiceID, currSvc.user_id, v_ResourceID, currSvc.institution_id, currSvc.service_unit_id, currSvc.group_name,
          currSvc.subcommittee_name, currSvc.workgroup_name, currSvc.service_role_id, currSvc.service_role_modifier_id,
          currSvc.start_year, currSvc.active_ind, currSvc.end_year, currSvc.student_affairs_ind);

      -- insert the notes record under narratives
      IF currSvc.notes IS NOT NULL AND TRIM(currSvc.notes) != '' THEN
      
         v_NotesNarrID := kmdata.add_new_narrative('osupro', 'User Service Notes', currSvc.notes, 0, currSvc.user_id);

         INSERT INTO kmdata.user_service_narratives (user_service_id, narrative_id)
            VALUES (v_UserServiceID, v_NotesNarrID);
         
      END IF;

      -- insert the output text record under narratives
      IF currSvc.output_text IS NOT NULL AND TRIM(currSvc.output_text) != '' THEN

         v_OutputTextNarrID := kmdata.add_new_narrative('osupro', 'User Service Output Text', currSvc.output_text, 0, currSvc.user_id);

         INSERT INTO kmdata.user_service_narratives (user_service_id, narrative_id)
            VALUES (v_UserServiceID, v_OutputTextNarrID);
         
      END IF;
      
   END LOOP;
   
   -- return value
   RETURN v_ReturnValue;
END;
$$ LANGUAGE plpgsql;
