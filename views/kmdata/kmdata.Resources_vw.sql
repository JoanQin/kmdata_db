CREATE OR REPLACE VIEW kmdata.Resources_vw AS 
   SELECT r.id AS resource_id, t.table_name, s.source_name, t.id AS table_id, s.id AS source_id
     FROM kmdata.resources r
     INNER JOIN kmdata.kmdata_tables t ON r.kmdata_table_id = t.id
     INNER JOIN kmdata.sources s ON r.source_id = s.id;