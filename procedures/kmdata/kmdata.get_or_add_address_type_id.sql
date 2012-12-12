CREATE OR REPLACE FUNCTION kmdata.get_or_add_address_type_id (
   p_AddressTypeName VARCHAR(255)
) RETURNS BIGINT AS $$
DECLARE
   v_AddressTypeMatchCount BIGINT := 0;
   v_AddressTypeID BIGINT := 0;
BEGIN

   SELECT COUNT(*) INTO v_AddressTypeMatchCount
   FROM kmdata.address_types
   WHERE address_type_name = p_AddressTypeName;

   IF v_AddressTypeMatchCount > 0 THEN

      --select the ID
      SELECT MIN(id) INTO v_AddressTypeID
      FROM kmdata.address_types
      WHERE address_type_name = p_AddressTypeName;
      
   ELSE

      -- insert the record
      v_AddressTypeID := nextval('kmdata.address_types_id_seq');

      INSERT INTO kmdata.address_types
         (id, address_type_name)
      VALUES
         (v_AddressTypeID, p_AddressTypeName);
         
   END IF;
   
   RETURN v_AddressTypeID;
END;
$$ LANGUAGE plpgsql;
