CREATE OR REPLACE VIEW kmdata.vw_Presentation AS 
 SELECT w.id, w.resource_id, w.user_id, w.title, w.event_title, w.presentation_role_id, w.percent_authorship, w.audience_name, 
        w.review_type_id, w.url, w.created_at, w.updated_at, w.work_type_id, w.city, w.state, w.country, w.presentation_location_descr, 
        w.presentation_dmy_single_date_id, sd1.day AS presentation_day, sd1.month AS presentation_month, sd1.year AS presentation_year
   FROM kmdata.works w
   LEFT JOIN kmdata.dmy_single_dates sd1 ON w.presentation_dmy_single_date_id = sd1.id
  WHERE w.work_type_id = 11;
