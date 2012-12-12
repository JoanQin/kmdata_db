CREATE OR REPLACE VIEW ror.vw_Journal AS 
 SELECT w.id, w.user_id AS person_id, w.article_title, w.journal_article_type_id, w.author_list, w.issn, w.impact_factor, 
        w.issue, w.journal_title, w.beginning_page, w.ending_page, w.percent_authorship, 
        w.publication_dmy_single_date_id, sd1.day AS publication_day, sd1.month AS publication_month, sd1.year AS publication_year,
        w.review_type_id, w.status_id, w.url, w.volume, w.created_at, w.updated_at, w.citation_count, 
        CASE ail.is_public WHEN 1 THEN TRUE ELSE FALSE END AS is_public,
        COALESCE(w.extended_author_list, w.author_list) AS extended_author_list
   FROM kmdata.works w
   LEFT JOIN kmdata.dmy_single_dates sd1 ON w.publication_dmy_single_date_id = sd1.id
   INNER JOIN kmdata.resources res ON w.resource_id = res.id
   INNER JOIN kmdata.sources src ON res.source_id = src.id
   INNER JOIN researchinview.activity_import_log ail ON w.resource_id = ail.resource_id
  WHERE w.work_type_id = 4
    AND src.source_name != 'osupro'
    AND ail.is_active = 1;
-- w.resource_id, w.work_type_id, 