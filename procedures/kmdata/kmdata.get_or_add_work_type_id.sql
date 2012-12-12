CREATE OR REPLACE FUNCTION kmdata.get_or_add_work_type_id (
   p_WorkTypeName VARCHAR(255)
) RETURNS BIGINT AS $$
DECLARE
   v_WorkTypeMatchCount BIGINT := 0;
   v_WorkTypeID BIGINT := 0;
BEGIN

   SELECT COUNT(*) INTO v_WorkTypeMatchCount
   FROM kmdata.work_types
   WHERE work_type_name = p_WorkTypeName;

   IF v_WorkTypeMatchCount > 0 THEN

      --select the ID
      SELECT MIN(id) INTO v_WorkTypeID
      FROM kmdata.work_types
      WHERE work_type_name = p_WorkTypeName;
      
   ELSE

      -- insert the record
      v_WorkTypeID := nextval('kmdata.work_types_id_seq');

      INSERT INTO kmdata.work_types
         (id, work_type_name)
      VALUES
         (v_WorkTypeID, p_WorkTypeName);
         
   END IF;
   
   RETURN v_WorkTypeID;
END;
$$ LANGUAGE plpgsql;
