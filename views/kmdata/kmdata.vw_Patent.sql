CREATE OR REPLACE VIEW kmdata.vw_Patent AS 
 SELECT w.id, w.resource_id, w.user_id, w.inventor, w.manufacturer, w.patent_number, w.percent_authorship, w.role_designator, w.sponsor, 
        w.title, w.url, w.created_at, w.updated_at, w.work_type_id, w.filed_date, w.issued_date
   FROM kmdata.works w
  WHERE w.work_type_id = 19;
