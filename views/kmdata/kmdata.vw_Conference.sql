CREATE OR REPLACE VIEW kmdata.vw_Conference AS 
 SELECT w.id, w.resource_id, w.user_id, w.title, w.journal_article_type_id, w.author_list, w.isbn, w.issn, w.impact_factor, w.issue, 
        w.journal_title, w.beginning_page, w.ending_page, w.percent_authorship, w.review_type_id, w.status_id, w.url, w.volume, w.created_at, 
        w.updated_at, w.work_type_id, w.book_title, w.city, w.state, w.country, w.event_title, w.edition, w.publisher, w.series, 
        w.publication_dmy_single_date_id, sd1.day AS publication_day, sd1.month AS publication_month, sd1.year AS publication_year,
        w.performance_start_date AS conference_start_date, w.publication_media_type_id, w.publication_type_id
   FROM kmdata.works w
   LEFT JOIN kmdata.dmy_single_dates sd1 ON w.publication_dmy_single_date_id = sd1.id
  WHERE w.work_type_id = 13;
