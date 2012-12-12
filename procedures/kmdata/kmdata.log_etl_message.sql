CREATE OR REPLACE FUNCTION kmdata.log_etl_message (
   p_SourceType VARCHAR(30),
   p_SourceName VARCHAR(30),
   p_MessageText VARCHAR(2000)
) RETURNS BIGINT AS $$
DECLARE
   v_ReturnValue BIGINT;
BEGIN
   v_ReturnValue := 0;

   INSERT INTO kmdata.etl_log
      (source_type, source_name, message_time, message_text)
   VALUES
      (p_SourceType, p_SourceName, current_timestamp, p_MessageText);
   
   RETURN v_ReturnValue;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
