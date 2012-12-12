CREATE OR REPLACE FUNCTION kmdata.add_dmy_range_date (
   p_StartDay INTEGER,
   p_StartMonth INTEGER,
   p_StartYear BIGINT,
   p_EndDay INTEGER,
   p_EndMonth INTEGER,
   p_EndYear BIGINT
) RETURNS BIGINT AS $$
DECLARE
   v_DateID BIGINT := 0;
BEGIN
   -- select the  next sequence value
   v_DateID := nextval('kmdata.dmy_range_dates_id_seq');

   -- insert the single date
   INSERT INTO kmdata.dmy_range_dates
      (id, start_day, start_month, start_year, end_day, end_month, end_year)
   VALUES
      (v_DateID, p_StartDay, p_StartMonth, p_StartYear, p_EndDay, p_EndMonth, p_EndYear);

   -- return the sequence value
   RETURN v_DateID;
END;
$$ LANGUAGE plpgsql;
