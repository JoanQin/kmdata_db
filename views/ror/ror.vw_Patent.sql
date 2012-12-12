CREATE OR REPLACE VIEW ror.vw_Patent AS 
 SELECT w.id, w.user_id AS person_id, w.inventor, w.manufacturer, w.patent_number, w.percent_authorship, w.role_designator, w.sponsor, 
        w.title, w.url, w.created_at, w.updated_at, w.filed_date, w.issued_date, 
        CASE ail.is_public WHEN 1 THEN TRUE ELSE FALSE END AS is_public
   FROM kmdata.works w
   INNER JOIN kmdata.resources res ON w.resource_id = res.id
   INNER JOIN kmdata.sources src ON res.source_id = src.id
   INNER JOIN researchinview.activity_import_log ail ON w.resource_id = ail.resource_id
  WHERE w.work_type_id = 19
    AND src.source_name != 'osupro'
    AND ail.is_active = 1;
-- w.resource_id, w.work_type_id, 