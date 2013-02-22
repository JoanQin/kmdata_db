CREATE OR REPLACE VIEW kmdata.vw_Press AS 
 SELECT   w.id, w.resource_id, w.user_id,   w.article_title, w.author_list, w.is_review,
          w.issn, w.issue, w.beginning_page, w.ending_page, w.percent_authorship, w.frequency_of_publication, g.name as publication_frequency,
          w.frequency_of_publication_other, w.publication_title, w.publication_type_id, h.name as press_publication_type,
          w.publication_dmy_single_date_id, 
          w.publisher, w.peer_reviewed_ind, w.reviewer_list, w.reviewed_subject, w.review_type_id, f.name as review_type_name,
          w.series_ended_on_dmy_single_date_id, sd2.year as series_end_year, sd2.month as series_end_month,sd2.day as series_end_day,
          w.series_frequency, w.series_frequency_other, w.series_ongoing, 
          w.series_started_on_dmy_single_date_id, sd3.year as series_start_year, sd3.month as series_start_month, sd3.day as series_start_day,
          w.title, w.single_or_series, w.url, w.volume, w.created_at, w.updated_at,  w.work_type_id, a.work_type_name, 
           sd1.year as publicatin_year, sd1.month as publication_month, sd1.day as publication_day, b.narrative_text, c.is_public,  c.is_active
   FROM kmdata.works w
   LEFT JOIN kmdata.dmy_single_dates sd1 ON w.publication_dmy_single_date_id = sd1.id
   left join kmdata.narratives b on w.resource_id = b.resource_id
   left join researchinview.activity_import_log c on c.resource_id = w.resource_id
   left join kmdata.work_types a on a.id = w.work_type_id
   left join researchinview.riv_review_types f on f.id = w.review_type_id
   left join researchinview.riv_publication_freq g on g.id = cast(w.frequency_of_publication as int)
   left join researchinview.riv_press_publication_types h on h.id = w.publication_type_id
   LEFT JOIN kmdata.dmy_single_dates sd2 ON w.series_ended_on_dmy_single_date_id = sd2.id
   LEFT JOIN kmdata.dmy_single_dates sd3 ON w.series_started_on_dmy_single_date_id = sd3.id
  WHERE w.work_type_id = 54;