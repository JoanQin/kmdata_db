CREATE OR REPLACE VIEW kmdata.vw_OtherCreativeWork AS 
 SELECT w.id, w.resource_id, w.user_id, w.author_list, w.format, w.forthcoming_id, a.name as forthcoming, w.percent_authorship, w.role_designator, 
        w.sponsor, w.title, w.url, 
        w.creation_dmy_single_date_id, sd.day AS creation_day, sd.month AS creation_month, sd.year AS creation_year,
        w.presentation_dmy_range_date_id, rd.start_day AS presentation_start_day, rd.start_month AS presentation_start_month, rd.start_year AS presentation_start_year,
        rd.end_day AS presentation_end_day, rd.end_month AS presentation_end_month, rd.end_year AS presentation_end_year,
        w.created_at, w.updated_at, w.work_type_id, b.work_type_name,
        w.sub_work_type_other, w.completed
   FROM kmdata.works w
   LEFT JOIN kmdata.dmy_single_dates sd ON w.creation_dmy_single_date_id = sd.id
   LEFT JOIN kmdata.dmy_range_dates rd ON w.presentation_dmy_range_date_id = rd.id
   left join researchinview.riv_forthcoming a on a.id = w.forthcoming_id
   left join kmdata.work_types b on b.id = w.work_type_id
  WHERE w.work_type_id = 23;
