CREATE OR REPLACE FUNCTION kmdata.add_dmy_single_date (
   p_Day INTEGER,
   p_Month INTEGER,
   p_Year BIGINT
) RETURNS BIGINT AS $$
DECLARE
   v_DateID BIGINT := 0;
BEGIN
   -- select the  next sequence value
   v_DateID := nextval('kmdata.dmy_single_dates_id_seq');

   -- insert the single date
   INSERT INTO kmdata.dmy_single_dates
      (id, day, month, year)
   VALUES
      (v_DateID, p_Day, p_Month, p_Year);

   -- return the sequence value
   RETURN v_DateID;
END;
$$ LANGUAGE plpgsql;
