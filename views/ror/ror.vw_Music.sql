CREATE OR REPLACE VIEW ror.vw_Music AS 
 SELECT w.id, w.user_id AS person_id, w.artist, w.city, w.director, w.country, w.curator, w.organizer, w.percent_authorship, w.title_in, 
        w.performance_company, w.role_designator, w.state, w.title, w.url, w.venue, w.created_at, w.updated_at, 
        w.presentation_dmy_single_date_id, sd1.day AS presentation_day, sd1.month AS presentation_month, sd1.year AS presentation_year,
        w.performance_start_date, w.performance_end_date, 
        CASE ail.is_public WHEN 1 THEN TRUE ELSE FALSE END AS is_public,
        COALESCE(w.extended_author_list, w.artist) AS extended_author_list
   FROM kmdata.works w
   LEFT JOIN kmdata.dmy_single_dates sd1 ON w.presentation_dmy_single_date_id = sd1.id
   INNER JOIN kmdata.resources res ON w.resource_id = res.id
   INNER JOIN kmdata.sources src ON res.source_id = src.id
   INNER JOIN researchinview.activity_import_log ail ON w.resource_id = ail.resource_id
  WHERE w.work_type_id = 17
    AND src.source_name != 'osupro'
    AND ail.is_active = 1;
-- w.resource_id, w.work_type_id, 