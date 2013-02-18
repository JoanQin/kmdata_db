CREATE OR REPLACE VIEW kmdata.vw_TechnicalReport AS 
 SELECT w.id, w.resource_id, w.user_id, w.title, w.author_list, w.editor_list, w.issue, w.percent_authorship, w.review_type_id, w.status_id, 
        w.url, w.volume, w.created_at, w.updated_at, w.work_type_id, w.city, w.state, w.country, w.edition, w.publisher, w.isbn, 
        w.publication_dmy_single_date_id, sd1.day AS publication_day, sd1.month AS publication_month, sd1.year AS publication_year,      
	            w.publication_type_id, d.name as technical_report_type, w.report_number,
	           f.name as review_type,  e.name as status_type,    a.work_type_name,
	               w.is_review,
           b.narrative_text, c.is_public
   FROM kmdata.works w
   LEFT JOIN kmdata.dmy_single_dates sd1 ON w.publication_dmy_single_date_id = sd1.id
   left join kmdata.narratives b on w.resource_id = b.resource_id
      left join researchinview.riv_technical_report_types d on d.id = w.publication_type_id
      left join researchinview.riv_publication_statuses e on e.id = w.status_id
      left join researchinview.activity_import_log c on c.resource_id = w.resource_id
   left join researchinview.riv_review_types f on f.id = w.review_type_id
      left join kmdata.work_types a on a.id = w.work_type_id
  WHERE w.work_type_id = 7;
