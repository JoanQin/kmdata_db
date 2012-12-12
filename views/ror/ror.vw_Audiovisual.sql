CREATE OR REPLACE VIEW ror.vw_Audiovisual AS 
 SELECT w.id, w.user_id AS person_id, w.city, w.country, w.director, w.distributor, 
        w.format, w.artist, w.network, w.percent_authorship, w.role_designator, w.sponsor, 
        w.state, 
        w.broadcast_dmy_single_date_id, sd1.day AS broadcast_day, sd1.month AS broadcast_month, sd1.year AS broadcast_year,
        w.presentation_dmy_range_date_id, sd2.day AS presentation_day, sd2.month AS presentation_month, sd2.year AS presentation_year,
        w.title, w.url, 
        w.created_at, w.updated_at, 
        CASE ail.is_public WHEN 1 THEN TRUE ELSE FALSE END AS is_public
   FROM kmdata.works w
   LEFT JOIN kmdata.dmy_single_dates sd1 ON w.broadcast_dmy_single_date_id = sd1.id
   LEFT JOIN kmdata.dmy_single_dates sd2 ON w.presentation_dmy_range_date_id = sd2.id
   INNER JOIN kmdata.resources res ON w.resource_id = res.id
   INNER JOIN kmdata.sources src ON res.source_id = src.id
   INNER JOIN researchinview.activity_import_log ail ON w.resource_id = ail.resource_id
  WHERE w.work_type_id = 18
    AND src.source_name != 'osupro'
    AND ail.is_active = 1;
-- w.resource_id, w.work_type_id