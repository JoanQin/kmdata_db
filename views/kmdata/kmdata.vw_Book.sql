﻿CREATE OR REPLACE VIEW kmdata.vw_Book AS 
 SELECT w.id, w.resource_id, w.user_id, w.author_list, w.city, w.country, w.edition, w.percent_authorship, 
        w.publisher, w.review_type_id, w.state, w.title, w.url, w.volume, w.work_type_id, 
        w.publication_dmy_single_date_id, sd1.day AS publication_day, sd1.month AS publication_month, sd1.year AS publication_year,
        w.created_at, w.updated_at, w.isbn, w.lccn, w.editor_list, w.status_id, w.sub_work_type_id
   FROM kmdata.works w
   LEFT JOIN kmdata.dmy_single_dates sd1 ON w.publication_dmy_single_date_id = sd1.id
  WHERE w.work_type_id = 6;