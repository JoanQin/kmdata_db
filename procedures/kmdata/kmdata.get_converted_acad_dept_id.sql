CREATE OR REPLACE FUNCTION kmdata.get_converted_acad_dept_id (
   p_InputDepartmentID VARCHAR(10)
) RETURNS VARCHAR AS $$
DECLARE
   v_ProcessedDepartmentID VARCHAR(10);
BEGIN
   v_ProcessedDepartmentID := REPLACE(p_InputDepartmentID, 'D', '') || '0';

   RETURN v_ProcessedDepartmentID;
END;
$$ LANGUAGE plpgsql;
