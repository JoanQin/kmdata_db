CREATE OR REPLACE VIEW kmdata.vw_Music AS 
 SELECT w.id, w.resource_id, w.user_id, w.artist, w.city, w.director, w.country, w.curator, w.organizer, w.percent_authorship, w.title_in, 
        w.performance_company, w.role_designator, w.state, w.title, w.url, w.venue, w.created_at, w.updated_at, w.work_type_id, 
        w.presentation_dmy_single_date_id, sd1.day AS presentation_day, sd1.month AS presentation_month, sd1.year AS presentation_year,
        w.performance_start_date, w.performance_end_date,
        COALESCE(w.extended_author_list, w.artist) AS extended_author_list
   FROM kmdata.works w
   LEFT JOIN kmdata.dmy_single_dates sd1 ON w.presentation_dmy_single_date_id = sd1.id
  WHERE w.work_type_id = 17;
