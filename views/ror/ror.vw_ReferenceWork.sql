CREATE OR REPLACE VIEW ror.vw_ReferenceWork AS 
 SELECT w.id, w.user_id AS person_id, w.title, w.author_list, w.beginning_page, w.ending_page, w.percent_authorship, 
        w.publication_dmy_single_date_id, sd1.day AS publication_day, sd1.month AS publication_month, sd1.year AS publication_year,
        w.review_type_id, w.status_id, w.url, w.volume, w.created_at, w.updated_at, w.city, w.country, w.state, w.isbn,
        CASE ail.is_public WHEN 1 THEN TRUE ELSE FALSE END AS is_public
   FROM kmdata.works w
   LEFT JOIN kmdata.dmy_single_dates sd1 ON w.publication_dmy_single_date_id = sd1.id
   INNER JOIN kmdata.resources res ON w.resource_id = res.id
   INNER JOIN kmdata.sources src ON res.source_id = src.id
   INNER JOIN researchinview.activity_import_log ail ON w.resource_id = ail.resource_id
  WHERE w.work_type_id = 5
    AND src.source_name != 'osupro'
    AND ail.is_active = 1;
-- w.resource_id, w.work_type_id, 