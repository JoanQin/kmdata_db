CREATE OR REPLACE VIEW kmdata.vw_Audiovisual AS 
   SELECT w.id, w.resource_id, w.user_id, w.city, w.country, w.director, w.distributor, 
        w.format, w.artist, w.network, w.percent_authorship, w.role_designator, w.sponsor, 
        w.state, 
        w.broadcast_dmy_single_date_id, sd1.day AS broadcast_day, sd1.month AS broadcast_month, sd1.year AS broadcast_year,
        w.presentation_dmy_range_date_id, sd2.start_day, sd2.start_month, sd2.start_year, sd2.end_day, sd2.end_month, sd2.end_year,
        w.title, w.url, 
        w.created_at, w.updated_at, w.work_type_id,
	           a.work_type_name,
	         w.completed, w.producer, w.sub_work_type_id, w.sub_work_type_other, e.name as audiovisual_work_name,
            b.narrative_text, c.is_public, c.is_active, f.name as completed_val
   FROM kmdata.works w
   LEFT JOIN kmdata.dmy_single_dates sd1 ON w.broadcast_dmy_single_date_id = sd1.id
   LEFT JOIN kmdata.dmy_range_dates sd2 ON w.presentation_dmy_range_date_id = sd2.id
   LEFT JOIN kmdata.work_narratives wn ON w.id = wn.work_id
      LEFT JOIN kmdata.narratives b on wn.narrative_id = b.id
         left join researchinview.activity_import_log c on c.resource_id = w.resource_id
         left join kmdata.work_types a on a.id = w.work_type_id
      left join researchinview.riv_audiovisual_work_types e on e.id = w.sub_work_type_id
      left join researchinview.riv_yes_no_recurring f on f.value = cast(w.completed as int)
  WHERE w.work_type_id = 18;