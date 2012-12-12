CREATE OR REPLACE FUNCTION kmdata.add_new_resource (
   p_SourceName VARCHAR(255),
   p_KMDataTableName VARCHAR(255)
) RETURNS BIGINT AS $$
DECLARE
   v_ResourceID BIGINT;
BEGIN

   -- get the new resource ID from the sequence
   v_ResourceID := nextval('kmdata.resources_id_seq');

   -- insert the record
   INSERT INTO kmdata.resources
      (id, source_id, kmdata_table_id)
   VALUES
      (v_ResourceID, kmdata.get_or_add_source_id(p_SourceName), kmdata.get_or_add_kmdata_table_id(p_KMDataTableName));
      
   RETURN v_ResourceID;
END;
$$ LANGUAGE plpgsql;
