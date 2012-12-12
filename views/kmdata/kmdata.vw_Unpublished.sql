CREATE OR REPLACE VIEW kmdata.vw_Unpublished AS 
 SELECT w.id, w.resource_id, w.user_id, w.title, w.author_list, w.percent_authorship, 
        w.submission_dmy_single_date_id, sd1.day AS submission_day, sd1.month AS submission_month, sd1.year AS submission_year,
        w.status_id, w.review_type_id, w.created_at, w.updated_at, w.work_type_id, w.submitted_to
   FROM kmdata.works w
   LEFT JOIN kmdata.dmy_single_dates sd1 ON w.submission_dmy_single_date_id = sd1.id
  WHERE w.work_type_id = 10;
