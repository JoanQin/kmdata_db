CREATE OR REPLACE FUNCTION researchinview.get_month (
   p_DateString VARCHAR(255)
) RETURNS INTEGER AS $$
DECLARE
   v_Month INTEGER;
BEGIN
   v_Month := CAST(split_part(p_DateString, '/', 1) AS INTEGER);
   
   RETURN v_Month;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
