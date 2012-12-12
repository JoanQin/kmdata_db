CREATE OR REPLACE VIEW ror.vw_Artwork AS 
 SELECT w.id, w.user_id AS person_id, w.artist, w.city, w.country, w.curator, 
        w.dimensions, w.exhibit_title, w.juried_ind, w.medium, w.percent_authorship, 
        w.exhibition_type_id, w.sponsor, w.state, w.title, w.url, w.venue, 
        w.creation_dmy_single_date_id, sd.day AS creation_day, sd.month AS creation_month, sd.year AS creation_year,
        w.exhibit_dmy_range_date_id, rd.start_day AS exhibit_start_day, rd.start_month AS exhibit_start_month, rd.start_year AS exhibit_start_year, 
        rd.end_day AS exhibit_end_day, rd.end_month AS exhibit_end_month, rd.end_year AS exhibit_end_year,
        w.created_at, w.updated_at, 
        CASE ail.is_public WHEN 1 THEN TRUE ELSE FALSE END AS is_public
   FROM kmdata.works w
   LEFT JOIN kmdata.dmy_single_dates sd ON w.creation_dmy_single_date_id = sd.id
   LEFT JOIN kmdata.dmy_range_dates rd ON w.exhibit_dmy_range_date_id = rd.id
   INNER JOIN kmdata.resources res ON w.resource_id = res.id
   INNER JOIN kmdata.sources src ON res.source_id = src.id
   INNER JOIN researchinview.activity_import_log ail ON w.resource_id = ail.resource_id
  WHERE w.work_type_id = 16
    AND src.source_name != 'osupro'
    AND ail.is_active = 1;
-- w.resource_id, w.work_type_id