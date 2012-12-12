CREATE OR REPLACE VIEW kmdata.vw_TechnicalReport AS 
 SELECT w.id, w.resource_id, w.user_id, w.title, w.author_list, w.editor_list, w.issue, w.percent_authorship, w.review_type_id, w.status_id, 
        w.url, w.volume, w.created_at, w.updated_at, w.work_type_id, w.city, w.state, w.country, w.edition, w.publisher, w.isbn, 
        w.publication_dmy_single_date_id, sd1.day AS publication_day, sd1.month AS publication_month, sd1.year AS publication_year
   FROM kmdata.works w
   LEFT JOIN kmdata.dmy_single_dates sd1 ON w.publication_dmy_single_date_id = sd1.id
  WHERE w.work_type_id = 7;
