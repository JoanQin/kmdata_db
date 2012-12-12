CREATE OR REPLACE FUNCTION researchinview.get_year (
   p_DateString VARCHAR(255)
) RETURNS INTEGER AS $$
DECLARE
   v_Year INTEGER;
BEGIN
   v_Year := CAST(split_part(p_DateString, '/', 2) AS INTEGER);
   
   RETURN v_Year;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
