CREATE OR REPLACE VIEW kmdata.vw_Artwork AS 
SELECT w.id, w.resource_id, w.user_id, w.artist, w.city, w.country, w.curator, w.dimensions, w.exhibit_title, w.juried_ind, w.medium, 
w.percent_authorship, w.exhibition_type_id, w.sponsor, w.state, w.title, w.url, w.venue, 
w.creation_dmy_single_date_id, sd.day AS creation_day, sd.month AS creation_month, sd.year AS creation_year, 
w.exhibit_dmy_range_date_id, rd.start_day AS exhibit_start_day, rd.start_month AS exhibit_start_month, rd.start_year AS exhibit_start_year, 
rd.end_day AS exhibit_end_day, rd.end_month AS exhibit_end_month, rd.end_year AS exhibit_end_year, w.created_at, w.updated_at, w.work_type_id,       
	    a.work_type_name, w.completed, w.ongoing, w.other_artist, w.solo, f.name as solo_name, w.sub_work_type_id, e.name as artwork_type_name,
           b.narrative_text, c.is_public, c.is_active, b2.narrative_text as roleDescription, g.name as completed_val, g2.name as juried_val, g3.name as ongoing_val
   FROM kmdata.works w
   LEFT JOIN kmdata.dmy_single_dates sd ON w.creation_dmy_single_date_id = sd.id
   LEFT JOIN kmdata.work_narratives wn ON w.id = wn.work_id
      LEFT JOIN kmdata.narratives b on wn.narrative_id = b.id
      left join kmdata.work_narratives wn2 on w.id = wn2.work_id
      left join kmdata.narratives b2 on wn2.narrative_id = b2.id
         left join researchinview.activity_import_log c on c.resource_id = w.resource_id
         left join kmdata.work_types a on a.id = w.work_type_id
         left join researchinview.riv_artwork_types e on e.id = w.sub_work_type_id  
         left join researchinview.riv_artwork_solo_group f on f.id = cast(w.solo as int)
         left join researchinview.riv_yes_no g on g.value = cast(w.completed as int)
	 left join researchinview.riv_yes_no g2 on g2.value = cast(w.juried_ind as int)
         left join researchinview.riv_yes_no g3 on g3.value = cast(w.ongoing as int)
  LEFT JOIN kmdata.dmy_range_dates rd ON w.exhibit_dmy_range_date_id = rd.id
  WHERE w.work_type_id = 16 and b.narrative_type_id = 46 and b2.narrative_type_id = 51;