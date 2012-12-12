CREATE OR REPLACE FUNCTION researchinview.strip_riv_tags (
   p_InputString TEXT
) RETURNS TEXT AS $$
DECLARE
   v_ReturnText TEXT;
BEGIN
   v_ReturnText := regexp_replace(regexp_replace(p_InputString, '\[begin-[a-z|A-Z]*\]', ''), '\[end-[a-z|A-Z]*\]', '');
   
   RETURN v_ReturnText;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
