CREATE OR REPLACE FUNCTION kmdata.get_routine_param_signature (
   p_SpecificCatalog VARCHAR(255),
   p_SpecificSchema VARCHAR(255),
   P_SpecificName VARCHAR(255)
) RETURNS VARCHAR AS $$
DECLARE
   CUR_Params CURSOR FOR
      SELECT ordinal_position, data_type 
      FROM information_schema.parameters 
      WHERE specific_catalog = p_SpecificCatalog
        AND specific_schema = p_SpecificSchema
        AND specific_name = P_SpecificName
        AND parameter_mode = 'IN'
      ORDER BY ordinal_position ASC;

   v_IsFirst BOOLEAN;
   v_ReturnSignature VARCHAR(4000);
BEGIN
   v_ReturnSignature := '(';
   v_IsFirst := TRUE;

   FOR lcr_Param IN CUR_Params LOOP
      IF v_IsFirst THEN
         v_IsFirst := FALSE;
      ELSE
         v_ReturnSignature := v_ReturnSignature || ', ';
      END IF;

      v_ReturnSignature := v_ReturnSignature || lcr_Param.data_type;
   END LOOP;

   v_ReturnSignature := v_ReturnSignature || ')';

   RETURN v_ReturnSignature;
END;
$$ LANGUAGE plpgsql;
