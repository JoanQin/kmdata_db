CREATE OR REPLACE FUNCTION kmdata.get_or_add_kmdata_table_id (
   p_KMDataTableName VARCHAR(255)
) RETURNS BIGINT AS $$
DECLARE
   v_KMDataMatchCount BIGINT := 0;
   v_KMDataTableID BIGINT := 0;
BEGIN

   SELECT COUNT(*) INTO v_KMDataMatchCount
   FROM kmdata.kmdata_tables
   WHERE table_name = p_KMDataTableName;

   IF v_KMDataMatchCount > 0 THEN

      --select the ID
      SELECT MIN(id) INTO v_KMDataTableID
      FROM kmdata.kmdata_tables
      WHERE table_name = p_KMDataTableName;
      
   ELSE

      -- insert the record
      v_KMDataTableID := nextval('kmdata.kmdata_tables_id_seq');

      INSERT INTO kmdata.kmdata_tables
         (id, table_name)
      VALUES
         (v_KMDataTableID, p_KMDataTableName);
         
   END IF;
   
   RETURN v_KMDataTableID;
END;
$$ LANGUAGE plpgsql;
