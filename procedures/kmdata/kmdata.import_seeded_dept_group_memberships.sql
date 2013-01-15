CREATE OR REPLACE FUNCTION kmdata.import_seeded_dept_group_memberships (
) RETURNS VARCHAR AS $$
DECLARE

   -- there is nothing to update currently on the memberships...if we add a field then the below can be used to update fields
   --v_UpdateCursor CURSOR FOR
   --   SELECT a.dept_name, a.inst_group_code, a.user_id, a.inst_username, a.resource_id,
   --      b.dept_name AS "name"
   --      a.name AS curr_name
   --   FROM kmdata.vw_dept_memberships_seeded a
   --   INNER JOIN kmdata.groups b ON a.inst_group_code = b.inst_group_code
   --   INNER JOIN kmdata.group_memberships c ON b.id = c.group_id AND a.resource_id = c.resource_id
   --   INNER JOIN kmdata.group_categorizations d ON b.id = d.group_id
   --   INNER JOIN kmdata.group_categories e ON d.group_category_id = e.id AND e.name = 'HR Department List Faculty and Staff';

   -- The join to kmdata.user_appointments eliminates departments without members
   v_InsertCursor CURSOR FOR
      SELECT DISTINCT d.id AS group_id, chgmember.resource_id
      FROM
      (
         SELECT ai.inst_group_code, ai.resource_id
         FROM kmdata.vw_dept_memberships_seeded ai
         EXCEPT
         SELECT bi.inst_group_code, ei.resource_id
         FROM kmdata.groups bi
         INNER JOIN kmdata.group_categorizations ci ON bi.id = ci.group_id
         INNER JOIN kmdata.group_categories di ON ci.group_category_id = di.id AND di.name = 'HR Department List Faculty and Staff'
         INNER JOIN kmdata.group_memberships ei ON bi.id = ei.group_id
      ) chgmember
      INNER JOIN kmdata.groups d ON chgmember.inst_group_code = d.inst_group_code
      INNER JOIN kmdata.group_categorizations e ON d.id = e.group_id
      INNER JOIN kmdata.group_categories f ON e.group_category_id = f.id AND f.name = 'HR Department List Faculty and Staff';

   v_DeleteCursor CURSOR FOR
      SELECT gm.id
      FROM kmdata.group_memberships gm
      WHERE NOT EXISTS (
         SELECT b.id
         FROM kmdata.vw_dept_memberships_seeded a
         INNER JOIN kmdata.groups b ON a.inst_group_code = b.inst_group_code
         INNER JOIN kmdata.group_categorizations c ON b.id = c.group_id
         INNER JOIN kmdata.group_categories d ON c.group_category_id = d.id AND d.name = 'HR Department List Faculty and Staff'
         INNER JOIN kmdata.group_memberships e ON a.resource_id = e.resource_id AND b.id = e.group_id
         WHERE e.id = gm.id
      )
      AND gm.group_id IN (
         SELECT x.group_id
         FROM kmdata.group_categorizations x
         INNER JOIN kmdata.group_categories y ON x.group_category_id = y.id
         WHERE y.name = 'HR Department List Faculty and Staff'
      );

   v_GroupID BIGINT;
   v_DeptGroupMembersUpdated INTEGER;
   v_DeptGroupMembersInserted INTEGER;
   v_DeptGroupMembersDeleted INTEGER;
   v_ReturnString VARCHAR(4000);
   
BEGIN

   v_DeptGroupMembersUpdated := 0;
   v_DeptGroupMembersInserted := 0;
   v_DeptGroupMembersDeleted := 0;
   v_ReturnString := '';
   
   -- Step 1: delete current emails that are no longer here (Part A: delete groups not found; Part B: make sure these are the right category)
   FOR v_delMember IN v_DeleteCursor LOOP

      -- delete the group
      DELETE FROM kmdata.group_memberships WHERE id = v_delMember.id;

      v_DeptGroupMembersDeleted := v_DeptGroupMembersDeleted + 1;
   
   END LOOP;

   -- Step 2: update (not used currently
   /*FOR v_updMember IN v_UpdateCursor LOOP

      -- if this has changed then update
      IF COALESCE(v_updMember.name,'') != COALESCE(v_updMember.curr_name,'')
      THEN
      
         -- update the record
         UPDATE kmdata.group_memberships
            SET "name" = v_updMember.name
          WHERE id = v_updGroup.id;

         v_DeptGroupMembersUpdated := v_DeptGroupMembersUpdated + 1;
         
      END IF;
            
   END LOOP;*/

   -- Step 3: insert
   FOR v_insMember IN v_InsertCursor LOOP
      
      -- insert if not already there
      INSERT INTO kmdata.group_memberships
         (resource_id, group_id)
      VALUES
         (v_insMember.resource_id, v_insMember.group_id);

      v_DeptGroupMembersInserted := v_DeptGroupMembersInserted + 1;

   END LOOP;


   v_ReturnString := 'Seeded department group members sync completed. ' || CAST(v_DeptGroupMembersDeleted AS VARCHAR) || ' members deleted and ' || CAST(v_DeptGroupMembersInserted AS VARCHAR) || ' members inserted.';

   RETURN v_ReturnString;
END;
$$ LANGUAGE plpgsql;
