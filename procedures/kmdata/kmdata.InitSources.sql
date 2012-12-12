CREATE OR REPLACE FUNCTION kmdata.InitSources (
) RETURNS BIGINT AS $$
DECLARE
   v_intResourceID BIGINT := 0;
BEGIN

   INSERT INTO kmdata.sources (source_name) VALUES ('peoplesoft');
   INSERT INTO kmdata.sources (source_name) VALUES ('osupro');
   INSERT INTO kmdata.sources (source_name) VALUES ('ksa');
   INSERT INTO kmdata.sources (source_name) VALUES ('expertise');
   INSERT INTO kmdata.sources (source_name) VALUES ('strategic_planning');

   RETURN v_intResourceID;
END;
$$ LANGUAGE plpgsql;
