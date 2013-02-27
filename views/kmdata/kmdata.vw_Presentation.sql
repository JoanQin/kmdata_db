CREATE OR REPLACE VIEW kmdata.vw_Presentation AS 
 SELECT w.id, w.resource_id, w.user_id, w.title, w.event_title, w.presentation_role_id, w.percent_authorship, w.audience_name, 
        w.review_type_id, w.url, w.created_at, w.updated_at, w.work_type_id, w.city, w.state, w.country, w.presentation_location_descr, 
        w.presentation_dmy_single_date_id, sd1.day AS presentation_day, sd1.month AS presentation_month, sd1.year AS presentation_year,
          w.invited_talk,  f.name as review_type_name,	          
	            g.name as prosentation_role_name, w.reach_of_conference, h.name as conference_reach_type_name, 
	           w.session_name, w.speaker_name,
	             a.work_type_name,	          
           b.narrative_text, c.is_public, c.is_active
   FROM kmdata.works w
   LEFT JOIN kmdata.dmy_single_dates sd1 ON w.presentation_dmy_single_date_id = sd1.id
   LEFT JOIN kmdata.work_narratives wn ON w.id = wn.work_id
      LEFT JOIN kmdata.narratives b on wn.narrative_id = b.id
      left join researchinview.activity_import_log c on c.resource_id = w.resource_id
      left join kmdata.work_types a on a.id = w.work_type_id      
      left join researchinview.riv_review_types f on f.id = w.review_type_id
      left join researchinview.riv_presentation_roles g on g.id = w.presentation_role_id
   left join researchinview.riv_conference_reach_types h on h.id = cast(w.reach_of_conference as int)
  WHERE w.work_type_id = 11;
