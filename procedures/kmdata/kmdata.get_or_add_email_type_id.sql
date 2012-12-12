CREATE OR REPLACE FUNCTION kmdata.get_or_add_email_type_id (
   p_EmailTypeName VARCHAR(255)
) RETURNS BIGINT AS $$
DECLARE
   v_EmailTypeMatchCount BIGINT := 0;
   v_EmailTypeID BIGINT := 0;
BEGIN

   SELECT COUNT(*) INTO v_EmailTypeMatchCount
   FROM kmdata.email_types
   WHERE email_type_name = p_EmailTypeName;

   IF v_EmailTypeMatchCount > 0 THEN

      --select the ID
      SELECT MIN(id) INTO v_EmailTypeID
      FROM kmdata.email_types
      WHERE email_type_name = p_EmailTypeName;
      
   ELSE

      -- insert the record
      v_EmailTypeID := nextval('kmdata.email_types_id_seq');

      INSERT INTO kmdata.email_types
         (id, email_type_name)
      VALUES
         (v_EmailTypeID, p_EmailTypeName);
         
   END IF;
   
   RETURN v_EmailTypeID;
END;
$$ LANGUAGE plpgsql;
