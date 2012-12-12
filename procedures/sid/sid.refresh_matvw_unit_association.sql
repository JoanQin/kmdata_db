CREATE OR REPLACE FUNCTION sid.refresh_matvw_unit_association (
) RETURNS VARCHAR AS $$
DECLARE
   v_ReturnString VARCHAR(4000);
   
BEGIN

   TRUNCATE TABLE sid.matvw_unit_association;

   INSERT INTO sid.matvw_unit_association
   (
        unit_association_type_id,
        unit_association_type_name,
        parent_type_name,
        parentunitid,
        child_type_name,
        childunitid
   )
   SELECT
        unit_association_type_id,
        unit_association_type_name,
        parent_type_name,
        parentunitid,
        child_type_name,
        childunitid
   FROM sid.vw_unit_association;

   v_ReturnString := 'SID associations refreshed.';

   RETURN v_ReturnString;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
