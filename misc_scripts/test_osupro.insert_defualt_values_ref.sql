CREATE OR REPLACE FUNCTION osupro.insert_default_values_ref( 
   intcategory bigint, 
   chvdefaultname character varying, 
   chvdefaultvalue character varying
) RETURNS BIGINT AS $$
DECLARE
BEGIN
   INSERT INTO osupro.default_values_ref
      (category, default_name, default_value)
   VALUES
      (intCategory, chvDefaultName, chvDefaultValue);

   RETURN 1;
END;
$$ LANGUAGE plpgsql;
