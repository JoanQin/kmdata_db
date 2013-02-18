CREATE OR REPLACE VIEW kmdata.vw_Audiovisual AS 
   SELECT w.id, w.resource_id, w.user_id, w.city, w.country, w.director, w.distributor, 
        w.format, w.artist, w.network, w.percent_authorship, w.role_designator, w.sponsor, 
        w.state, 
        w.broadcast_dmy_single_date_id, sd1.day AS broadcast_day, sd1.month AS broadcast_month, sd1.year AS broadcast_year,
        w.presentation_dmy_range_date_id, sd2.day AS presentation_day, sd2.month AS presentation_month, sd2.year AS presentation_year,
        w.title, w.url, 
        w.created_at, w.updated_at, w.work_type_id,
	           a.work_type_name,
	         w.completed, w.producer, w.sub_work_type_id, w.sub_work_type_other, e.name as audiovisual_work_name,
            b.narrative_text, c.is_public
   FROM kmdata.works w
   LEFT JOIN kmdata.dmy_single_dates sd1 ON w.broadcast_dmy_single_date_id = sd1.id
   LEFT JOIN kmdata.dmy_single_dates sd2 ON w.presentation_dmy_range_date_id = sd2.id
   left join kmdata.narratives b on w.resource_id = b.resource_id
         left join researchinview.activity_import_log c on c.resource_id = w.resource_id
         left join kmdata.work_types a on a.id = w.work_type_id
      left join researchinview.riv_audiovisual_work_types e on e.id = w.sub_work_type_id
  WHERE w.work_type_id = 18;