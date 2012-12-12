CREATE OR REPLACE VIEW kmdata.vw_Artwork AS 
 SELECT w.id, w.resource_id, w.user_id, w.artist, w.city, w.country, w.curator, 
        w.dimensions, w.exhibit_title, w.juried_ind, w.medium, w.percent_authorship, 
        w.exhibition_type_id, w.sponsor, w.state, w.title, w.url, w.venue, 
        w.creation_dmy_single_date_id, sd.day AS creation_day, sd.month AS creation_month, sd.year AS creation_year,
        w.exhibit_dmy_range_date_id, rd.start_day AS exhibit_start_day, rd.start_month AS exhibit_start_month, rd.start_year AS exhibit_start_year, 
        rd.end_day AS exhibit_end_day, rd.end_month AS exhibit_end_month, rd.end_year AS exhibit_end_year,
        w.created_at, w.updated_at, w.work_type_id
   FROM kmdata.works w
   LEFT JOIN kmdata.dmy_single_dates sd ON w.creation_dmy_single_date_id = sd.id
   LEFT JOIN kmdata.dmy_range_dates rd ON w.exhibit_dmy_range_date_id = rd.id
  WHERE w.work_type_id = 16;