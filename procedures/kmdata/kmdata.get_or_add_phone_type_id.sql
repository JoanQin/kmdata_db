CREATE OR REPLACE FUNCTION kmdata.get_or_add_phone_type_id (
   p_PhoneTypeName VARCHAR(255)
) RETURNS BIGINT AS $$
DECLARE
   v_PhoneTypeMatchCount BIGINT := 0;
   v_PhoneTypeID BIGINT := 0;
BEGIN

   SELECT COUNT(*) INTO v_PhoneTypeMatchCount
   FROM kmdata.phone_types
   WHERE phone_type_name = p_PhoneTypeName;

   IF v_PhoneTypeMatchCount > 0 THEN

      --select the ID
      SELECT MIN(id) INTO v_PhoneTypeID
      FROM kmdata.phone_types
      WHERE phone_type_name = p_PhoneTypeName;
      
   ELSE

      -- insert the record
      v_PhoneTypeID := nextval('kmdata.phone_types_id_seq');

      INSERT INTO kmdata.phone_types
         (id, phone_type_name)
      VALUES
         (v_PhoneTypeID, p_PhoneTypeName);
         
   END IF;
   
   RETURN v_PhoneTypeID;
END;
$$ LANGUAGE plpgsql;
