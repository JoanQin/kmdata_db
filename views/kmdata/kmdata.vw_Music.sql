CREATE OR REPLACE VIEW kmdata.vw_Music AS 
SELECT w.id, w.resource_id, w.user_id, w.artist, w.city, w.director, w.country, w.curator, w.organizer, w.percent_authorship, w.title_in, 
w.performance_company, w.role_designator, w.state, w.title, w.url, w.venue, w.created_at, w.updated_at, w.work_type_id, 
w.presentation_dmy_single_date_id, sd1.day AS presentation_day, sd1.month AS presentation_month, sd1.year AS presentation_year, w.performance_start_date, 
w.performance_end_date, COALESCE(w.extended_author_list, w.artist) AS extended_author_list,
         a.name as music_role, 
        c.work_type_name,       
         w.sub_work_type_id, b.name as type_of_work, w.producer, w.completed, w.ongoing, w.performance, d.narrative_text, e.is_public,  e.is_active,
         yn1.name as completed_val, yn2.name as ongoing_val, yn3.name as performance_val
   FROM kmdata.works w
   LEFT JOIN kmdata.dmy_single_dates sd1 ON w.presentation_dmy_single_date_id = sd1.id
   left join researchinview.riv_music_roles a on a.id = cast(w.role_designator as int)
   left join researchinview.riv_music_work_types b on b.id = w.sub_work_type_id
   left join kmdata.work_types c on c.id = w.work_type_id
   LEFT JOIN kmdata.work_narratives wn ON w.id = wn.work_id
   LEFT JOIN kmdata.narratives d on wn.narrative_id = d.id
   left join researchinview.activity_import_log e on e.resource_id = w.resource_id
      left join researchinview.riv_yes_no yn1 on yn1.value = cast(w.completed as int)
      left join researchinview.riv_yes_no yn2 on yn2.value = cast(w.ongoing as int)
   left join researchinview.riv_yes_no yn3 on yn3.value = cast(performance as int)
  WHERE w.work_type_id = 17;
