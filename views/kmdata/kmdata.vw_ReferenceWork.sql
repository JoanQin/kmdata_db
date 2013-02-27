CREATE OR REPLACE VIEW kmdata.vw_ReferenceWork AS 
SELECT w.id, w.resource_id, w.user_id, w.title, w.author_list, w.beginning_page, w.ending_page, w.percent_authorship,
w.publication_dmy_single_date_id, sd1.day AS publication_day, sd1.month AS publication_month, sd1.year AS publication_year, 
w.review_type_id, w.status_id, w.url, w.volume, w.created_at, w.updated_at, w.work_type_id, w.city, w.country, w.state, w.isbn,
         a.work_type_name, 
         w.editor_list as editor, w.publication_title as title_of_publication, 
	 w.sub_work_type_id as type_of_work_id, d.name as type_of_work, 
	 e.name as publication_status,
	w.is_review as reviewed_item,  b.narrative_text as description_of_effort,
	  b.private_ind as privacy, c.is_public,   w.publisher, 
	 w.edition, g.name as review_type_name, c.is_active
   FROM kmdata.works w
   LEFT JOIN kmdata.dmy_single_dates sd1 ON w.publication_dmy_single_date_id = sd1.id
   LEFT JOIN kmdata.work_narratives wn ON w.id = wn.work_id
      LEFT JOIN kmdata.narratives b on wn.narrative_id = b.id
   left join researchinview.riv_reference_work_types d on d.id = w.sub_work_type_id
   left join researchinview.riv_publication_statuses e on e.id = w.status_id
   left join researchinview.activity_import_log c on c.resource_id = w.resource_id
   left join kmdata.work_types a on a.id = w.work_type_id
   left join researchinview.riv_review_types g on w.review_type_id = g.id
  WHERE w.work_type_id = 5 ;
