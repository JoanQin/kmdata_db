CREATE OR REPLACE FUNCTION kmdata.import_seeded_dept_groups (
) RETURNS VARCHAR AS $$
DECLARE

   v_UpdateCursor CURSOR FOR
      SELECT a.id, a.inst_group_code,
         b.dept_name AS "name", CAST(NULL AS VARCHAR) AS description, TRUE AS is_public,
         a.name AS curr_name, a.description AS curr_description, a.is_public AS curr_is_public
      FROM kmdata.groups a
      INNER JOIN kmdata.departments b ON a.inst_group_code = b.deptid
      INNER JOIN kmdata.group_categorizations c ON a.id = c.group_id
      INNER JOIN kmdata.group_categories d ON c.group_category_id = d.id
      WHERE d.name = 'HR Department List Faculty and Staff';

   -- The join to kmdata.user_appointments eliminates departments without members
   v_InsertCursor CURSOR FOR
      SELECT DISTINCT chgdept.inst_group_code, d.dept_name AS "name", CAST(NULL AS VARCHAR) AS description, TRUE AS is_public
      FROM
      (
         SELECT ai.deptid AS inst_group_code
         FROM kmdata.departments ai
         EXCEPT
         SELECT bi.inst_group_code
         FROM kmdata.groups bi
         INNER JOIN kmdata.group_categorizations ci ON bi.id = ci.group_id
         INNER JOIN kmdata.group_categories di ON ci.group_category_id = di.id
         WHERE di.name = 'HR Department List Faculty and Staff'
      ) chgdept
      INNER JOIN kmdata.departments d ON chgdept.inst_group_code = d.deptid
      INNER JOIN kmdata.user_appointments e ON d.deptid = e.department_id;

   v_HRGroupCategoryID BIGINT;
   v_GroupID BIGINT;
   v_DeptGroupsUpdated INTEGER;
   v_DeptGroupsInserted INTEGER;
   v_ReturnString VARCHAR(4000);
   
BEGIN

   -- check to make sure this category exists in the system
   SELECT id INTO v_HRGroupCategoryID
   FROM kmdata.group_categories
   WHERE name = 'HR Department List Faculty and Staff';

   IF v_HRGroupCategoryID IS NULL THEN
      -- get the next value from the sequence
      v_HRGroupCategoryID := nextval('kmdata.group_categories_new_id_seq');

      -- add the category
      INSERT INTO kmdata.group_categories
         (id, "name", system_only)
      VALUES
         (v_HRGroupCategoryID, 'HR Department List Faculty and Staff', TRUE);
   END IF;

   v_DeptGroupsUpdated := 0;
   v_DeptGroupsInserted := 0;
   v_ReturnString := '';
   
   -- Step 1: delete current emails that are no longer here (Part A: delete groups not found; Part B: make sure these are the right category)
   DELETE FROM kmdata.groups bd
   WHERE NOT EXISTS (
      SELECT b.id
      FROM kmdata.departments a
      INNER JOIN kmdata.groups b ON a.deptid = b.inst_group_code
      INNER JOIN kmdata.group_categorizations c ON b.id = c.group_id
      INNER JOIN kmdata.group_categories d ON c.group_category_id = d.id
      WHERE d.name = 'HR Department List Faculty and Staff'
      AND b.id = bd.id
   )
   AND bd.id IN (
      SELECT x.group_id
      FROM kmdata.group_categorizations x
      INNER JOIN kmdata.group_categories y ON x.group_category_id = y.id
      WHERE y.name = 'HR Department List Faculty and Staff'
   );

   -- Step 2: update
   FOR v_updGroup IN v_UpdateCursor LOOP

      -- if this has changed then update
      IF COALESCE(v_updGroup.name,'') != COALESCE(v_updGroup.curr_name,'')
         OR COALESCE(v_updGroup.description,'') != COALESCE(v_updGroup.curr_description,'')
         OR COALESCE(CASE v_updGroup.is_public WHEN TRUE THEN 'T' WHEN FALSE THEN 'F' ELSE NULL END,'') != COALESCE(CASE v_updGroup.curr_is_public WHEN TRUE THEN 'T' WHEN FALSE THEN 'F' ELSE NULL END,'')
      THEN
      
         -- update the record
         UPDATE kmdata.groups
            SET "name" = v_updGroup.name,
                description = v_updGroup.description,
                is_public = v_updGroup.is_public
          WHERE id = v_updGroup.id;

         v_DeptGroupsUpdated := v_DeptGroupsUpdated + 1;
         
      END IF;
            
   END LOOP;

   -- Step 3: insert
   FOR v_insGroup IN v_InsertCursor LOOP
      
      -- insert if not already there

      -- Step 1: groups
      v_GroupID := nextval('kmdata.groups_new_id_seq');
      
      INSERT INTO kmdata.groups (
	 id, "name", description, is_public, inst_group_code)
      VALUES (
         v_GroupID, v_insGroup.name, v_insGroup.description, v_insGroup.is_public, v_insGroup.inst_group_code); --kmdata.add_new_resource('kmdata', 'groups')

      -- Step 2: group_categorizations
      INSERT INTO kmdata.group_categorizations
         (group_id, group_category_id)
      VALUES
         (v_GroupID, v_HRGroupCategoryID);

      v_DeptGroupsInserted := v_DeptGroupsInserted + 1;

   END LOOP;


   v_ReturnString := 'Seeded department groups sync completed. ' || CAST(v_DeptGroupsUpdated AS VARCHAR) || ' groups updated and ' || CAST(v_DeptGroupsInserted AS VARCHAR) || ' groups inserted.';

   RETURN v_ReturnString;
END;
$$ LANGUAGE plpgsql;
