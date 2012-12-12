CREATE OR REPLACE FUNCTION osupro.GetNewItemID (
   intAcademicItemTypeID BIGINT,
   intOldIntID BIGINT
) RETURNS BIGINT AS $$
DECLARE
   intNewItemID INTEGER;
BEGIN
   -- select and return the existing id
   SELECT item_id INTO intNewItemID
   FROM osupro.academic_item
   WHERE academic_item_type_id = intAcademicItemTypeID
   AND old_int_id = intOldIntID;

   RETURN intNewItemID;
END;
$$ LANGUAGE plpgsql;
