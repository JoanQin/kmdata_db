﻿CREATE OR REPLACE VIEW kmdata.vw_Software AS 
 SELECT w.id, w.resource_id, w.user_id, w.author_list, w.sponsor, w.percent_authorship, w.publisher, w.role_designator, w.title, w.medium, w.url, w.edition, 
        w.publication_dmy_single_date_id, sd1.day AS publication_day, sd1.month AS publication_month, sd1.year AS publication_year,
        w.last_update_dmy_single_date_id, sd2.day AS last_update_day, sd2.month AS last_update_month, sd2.year AS last_update_year,
        w.created_at, w.updated_at, w.work_type_id, w.distributor, w.sub_work_type_id, w.sub_work_type_other
   FROM kmdata.works w
   LEFT JOIN kmdata.dmy_single_dates sd1 ON w.publication_dmy_single_date_id = sd1.id
   LEFT JOIN kmdata.dmy_single_dates sd2 ON w.last_update_dmy_single_date_id = sd2.id
  WHERE w.work_type_id = 21;
