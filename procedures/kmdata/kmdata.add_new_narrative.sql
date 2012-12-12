CREATE OR REPLACE FUNCTION kmdata.add_new_narrative (
   p_SourceName VARCHAR(255),
   p_NarrativeTypeName VARCHAR(255),
   p_NarrativeText TEXT,
   p_PrivateInd INTEGER,
   p_CreatedAt TIMESTAMP DEFAULT current_timestamp,
   p_UpdatedAt TIMESTAMP DEFAULT current_timestamp
) RETURNS BIGINT AS $$
DECLARE
   v_ResourceID BIGINT;
   v_NarrativeTypeCount BIGINT;
   v_NarrativeTypeID BIGINT;
   v_NarrativeID BIGINT;
BEGIN

   -- get the new resource ID from the sequence
   v_ResourceID := kmdata.add_new_resource(p_SourceName, 'narratives');

   -- get the narrative type ID
   SELECT COUNT(*) INTO v_NarrativeTypeCount
   FROM kmdata.narrative_types
   WHERE narrative_desc = p_NarrativeTypeName;

   IF v_NarrativeTypeCount > 0 THEN
   
      -- select the type id
      SELECT MIN(id) INTO v_NarrativeTypeID
      FROM kmdata.narrative_types
      WHERE narrative_desc = p_NarrativeTypeName;
      
   ELSE

      -- get the sequence number
      v_NarrativeTypeID := nextval('kmdata.narrative_types_id_seq');
      
      -- insert the narrative type
      INSERT INTO kmdata.narrative_types
         (id, narrative_desc)
      VALUES
         (v_NarrativeTypeID, p_NarrativeTypeName);
      
   END IF;

   -- get the narrative ID
   v_NarrativeID := nextval('kmdata.narratives_id_seq');

   -- insert the narrative
   INSERT INTO kmdata.narratives
      (id, narrative_type_id, narrative_text, private_ind, 
       created_at, updated_at, resource_id)
   VALUES
      (v_NarrativeID, v_NarrativeTypeID, p_NarrativeText, p_PrivateInd,
       p_CreatedAt, p_UpdatedAt, v_ResourceID);
      
   RETURN v_NarrativeID;
END;
$$ LANGUAGE plpgsql;
