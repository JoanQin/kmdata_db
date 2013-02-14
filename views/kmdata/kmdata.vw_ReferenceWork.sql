CREATE OR REPLACE VIEW kmdata.vw_ReferenceWork AS 
 SELECT w.id, w.resource_id, w.user_id, w.title, w.author_list, w.beginning_page, w.ending_page, w.percent_authorship, 
        w.publication_dmy_single_date_id, sd1.day AS publication_day, sd1.month AS publication_month, sd1.year AS publication_year,
        w.review_type_id, w.status_id, w.url, w.volume, w.created_at, w.updated_at, w.work_type_id, w.city, w.country, w.state, w.isbn,
        w.author_list as author, w.editor_list as editor, w.publication_title as title_of_publication, 
	w.title as title_of_entry, w.sub_work_type_id as type_of_work_id, d.name as type_of_work, 
	w.status_id as publication_status_id, e.name as publication_status,
	w.is_review as reviewed_item, w.percent_authorship, b.narrative_text as description_of_effort,
	w.isbn, w.url, b.private_ind as privacy, w.beginning_page, w.ending_page, w.publisher, w.city, w.state, w.country,
	w.volume, w.edition, sd1.day as published_on_year, sd1.month as published_on_month, sd1.year as published_on_year
   FROM kmdata.works w
   LEFT JOIN kmdata.dmy_single_dates sd1 ON w.publication_dmy_single_date_id = sd1.id
   left join kmdata.narratives b on w.resource_id = b.resource_id
   left join researchinview.riv_reference_work_types d on d.id = w.sub_work_type_id
   left join researchinview.riv_publication_statuses e on e.id = w.status_id
  WHERE w.work_type_id = 5;
