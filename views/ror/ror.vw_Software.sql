CREATE OR REPLACE VIEW ror.vw_Software AS 
 SELECT w.id, w.user_id AS person_id, w.author_list, w.sponsor, w.percent_authorship, w.publisher, w.role_designator, w.title, w.medium, w.url, w.edition, 
        w.publication_dmy_single_date_id, sd1.day AS publication_day, sd1.month AS publication_month, sd1.year AS publication_year,
        w.last_update_dmy_single_date_id, sd2.day AS last_update_day, sd2.month AS last_update_month, sd2.year AS last_update_year,
        w.created_at, w.updated_at, w.distributor, w.sub_work_type_id, w.sub_work_type_other, 
        CASE ail.is_public WHEN 1 THEN TRUE ELSE FALSE END AS is_public
   FROM kmdata.works w
   LEFT JOIN kmdata.dmy_single_dates sd1 ON w.publication_dmy_single_date_id = sd1.id
   LEFT JOIN kmdata.dmy_single_dates sd2 ON w.last_update_dmy_single_date_id = sd2.id
   INNER JOIN kmdata.resources res ON w.resource_id = res.id
   INNER JOIN kmdata.sources src ON res.source_id = src.id
   INNER JOIN researchinview.activity_import_log ail ON w.resource_id = ail.resource_id
  WHERE w.work_type_id = 21
    AND src.source_name != 'osupro'
    AND ail.is_active = 1;
-- w.resource_id, w.work_type_id, 