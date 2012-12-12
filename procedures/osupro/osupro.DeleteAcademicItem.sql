CREATE OR REPLACE FUNCTION osupro.DeleteAcademicItem (
   p_AcademicItemTypeID BIGINT,
   p_OldID BIGINT
) RETURNS BIGINT AS $$
DECLARE
   v_PrimaryDataTable VARCHAR(50);
   v_SecondaryDataTable VARCHAR(50);
   v_NewID BIGINT;
BEGIN
   -- get the primary and secondary data table names for this record
   SELECT primary_data_table, secondary_data_table
   INTO v_PrimaryDataTable, v_SecondaryDataTable
   FROM osupro.academic_item_type_ref
   WHERE academic_item_type_id = p_AcademicItemTypeID;

   SELECT item_id
   INTO v_NewID
   FROM osupro.academic_item
   WHERE academic_item_type_id = p_AcademicItemTypeID
   AND old_int_id = p_OldID;

   -- delete from import ref cross tables
   DELETE FROM osupro.academic_item_ohio_link_locator_ref WHERE item_id = v_NewID;
   DELETE FROM osupro.academic_item_ebsco_locator_ref WHERE item_id = v_NewID;
   DELETE FROM osupro.academic_item_tr_locator_ref WHERE item_id = v_NewID;

   -- delete from the secondary table if it exists
   IF v_SecondaryDataTable IS NOT NULL AND v_SecondaryDataTable != '' THEN
      EXECUTE 'DELETE FROM osupro.' || v_SecondaryDataTable || ' WHERE item_id = $1' USING v_NewID;
   END IF;

   -- delete from the primary table if it exists
   IF v_PrimaryDataTable IS NOT NULL AND v_PrimaryDataTable != '' THEN
      EXECUTE 'DELETE FROM osupro.' || v_PrimaryDataTable || ' WHERE item_id = $1' USING v_NewID;
   END IF;

   -- delete from academic_item
   DELETE FROM osupro.academic_item
   WHERE item_id = v_NewID;

   -- dummy return for Kettle
   RETURN 1;
END;
$$ LANGUAGE plpgsql;
