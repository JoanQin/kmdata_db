CREATE OR REPLACE VIEW kmdata.vw_BookChapter AS 
 SELECT w.id, w.resource_id, w.user_id, w.author_list, w.city, w.country, w.edition, w.editor_list, w.percent_authorship, 
        w.publication_dmy_single_date_id, sd1.day AS publication_day, sd1.month AS publication_month, sd1.year AS publication_year,
        w.publisher, w.review_type_id, w.state, w.title, w.title_in, w.url, w.volume, 
        w.work_type_id, w.created_at, w.updated_at, w.isbn, w.lccn,
        w.beginning_page, w.ending_page, w.status_id, w.book_author
   FROM kmdata.works w
   LEFT JOIN kmdata.dmy_single_dates sd1 ON w.publication_dmy_single_date_id = sd1.id
  WHERE w.work_type_id = 8;
