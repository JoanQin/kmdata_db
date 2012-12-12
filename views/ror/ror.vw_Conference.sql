CREATE OR REPLACE VIEW ror.vw_Conference AS 
 SELECT w.id, w.user_id AS person_id, w.title, w.journal_article_type_id, w.author_list, w.isbn, w.issn, w.impact_factor, w.issue, 
        w.journal_title, w.beginning_page, w.ending_page, w.percent_authorship, w.review_type_id, w.status_id, w.url, w.volume, w.created_at, 
        w.updated_at, w.book_title, w.city, w.state, w.country, w.event_title, w.edition, w.publisher, w.series, 
        w.publication_dmy_single_date_id, sd1.day AS publication_day, sd1.month AS publication_month, sd1.year AS publication_year,
        w.performance_start_date AS conference_start_date, w.publication_media_type_id, w.publication_type_id, 
        CASE ail.is_public WHEN 1 THEN TRUE ELSE FALSE END AS is_public
   FROM kmdata.works w
   LEFT JOIN kmdata.dmy_single_dates sd1 ON w.publication_dmy_single_date_id = sd1.id
   INNER JOIN kmdata.resources res ON w.resource_id = res.id
   INNER JOIN kmdata.sources src ON res.source_id = src.id
   INNER JOIN researchinview.activity_import_log ail ON w.resource_id = ail.resource_id
  WHERE w.work_type_id = 13
    AND src.source_name != 'osupro'
    AND ail.is_active = 1;
-- w.resource_id, w.work_type_id, 