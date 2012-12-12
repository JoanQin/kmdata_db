CREATE OR REPLACE FUNCTION kmdata.get_or_add_source_id (
   p_SourceName VARCHAR(255)
) RETURNS BIGINT AS $$
DECLARE
   v_SourceMatchCount BIGINT := 0;
   v_SourceID BIGINT := 0;
BEGIN

   SELECT COUNT(*) INTO v_SourceMatchCount
   FROM kmdata.sources
   WHERE source_name = p_SourceName;

   IF v_SourceMatchCount > 0 THEN

      --select the ID
      SELECT MIN(id) INTO v_SourceID
      FROM kmdata.sources
      WHERE source_name = p_SourceName;
      
   ELSE

      -- insert the record
      v_SourceID := nextval('kmdata.sources_id_seq');

      INSERT INTO kmdata.sources
         (id, source_name)
      VALUES
         (v_SourceID, p_SourceName);
         
   END IF;
   
   RETURN v_SourceID;
END;
$$ LANGUAGE plpgsql;
