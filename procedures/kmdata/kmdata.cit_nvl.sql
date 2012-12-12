CREATE OR REPLACE FUNCTION kmdata.cit_nvl (
   p_InString VARCHAR(4000),
   p_AppendString VARCHAR(4000),
   p_AltString VARCHAR(4000)
) RETURNS VARCHAR AS $$
DECLARE
BEGIN
   IF p_InString IS NULL OR TRIM(p_InString) = '' THEN
      RETURN p_AltString;
   ELSE
      RETURN p_InString || p_AppendString;
   END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
