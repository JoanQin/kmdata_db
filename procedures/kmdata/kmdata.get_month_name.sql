CREATE OR REPLACE FUNCTION kmdata.get_month_name (
   p_MonthValue INTEGER
) RETURNS VARCHAR AS $$
DECLARE
BEGIN
   RETURN TRIM(to_char(to_timestamp(p_MonthValue::text, 'MM'), 'TMMonth'));
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
