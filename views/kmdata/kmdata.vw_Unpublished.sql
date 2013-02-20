CREATE OR REPLACE VIEW kmdata.vw_Unpublished AS 
 SELECT w.id, w.resource_id, w.user_id, w.title, w.author_list, w.percent_authorship, 
        w.submission_dmy_single_date_id, sd1.day AS submission_day, sd1.month AS submission_month, sd1.year AS submission_year,
        w.status_id, w.review_type_id, w.created_at, w.updated_at, w.work_type_id, w.submitted_to,
         w.completed,	          
	           f.name as review_type_name,  a.work_type_name,
	           w.extended_author_list,  e.name as publication_status,
            b.narrative_text, c.is_public, c.is_active
   FROM kmdata.works w
   LEFT JOIN kmdata.dmy_single_dates sd1 ON w.submission_dmy_single_date_id = sd1.id
   left join kmdata.narratives b on w.resource_id = b.resource_id
      left join researchinview.activity_import_log c on c.resource_id = w.resource_id
      left join kmdata.work_types a on a.id = w.work_type_id
      left join researchinview.riv_unpublish_submission_status e on e.id = w.status_id   
   left join researchinview.riv_review_types f on f.id = w.review_type_id
  WHERE w.work_type_id = 10;
