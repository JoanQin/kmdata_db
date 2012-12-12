CREATE OR REPLACE FUNCTION kmdata.import_courses_from_ps (
) RETURNS VARCHAR AS $$
DECLARE
   v_intResourceID BIGINT;
   v_ReturnString VARCHAR(4000);
BEGIN


   v_ReturnString := 'Courses import completed. ' || CAST(v_UsersUpdated AS VARCHAR) || ' users updated and ' || CAST(v_UsersInserted AS VARCHAR) || ' users inserted.';

   RETURN v_ReturnString;
END;
$$ LANGUAGE plpgsql;
