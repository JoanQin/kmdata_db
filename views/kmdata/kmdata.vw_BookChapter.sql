CREATE OR REPLACE VIEW kmdata.vw_BookChapter AS 
SELECT w.id, w.resource_id, w.user_id, w.author_list, w.city, w.country, w.edition, w.editor_list, w.percent_authorship, 
w.publication_dmy_single_date_id, sd1.day AS publication_day, sd1.month AS publication_month, sd1.year AS publication_year, 
w.publisher, w.review_type_id, w.state, w.title, w.title_in, w.url, w.volume, w.work_type_id, w.created_at, w.updated_at, 
w.isbn, w.lccn, w.beginning_page, w.ending_page, w.status_id, w.book_author,       
        w.is_review,                
	          f.name as review_type, 
	          a.work_type_name,  e.name as publication_status, 
            b.narrative_text, c.is_public, c.is_active
   FROM kmdata.works w
   LEFT JOIN kmdata.dmy_single_dates sd1 ON w.publication_dmy_single_date_id = sd1.id
   left join kmdata.narratives b on w.resource_id = b.resource_id
      left join researchinview.activity_import_log c on c.resource_id = w.resource_id
      left join kmdata.work_types a on a.id = w.work_type_id
      left join researchinview.riv_publication_statuses e on e.id = w.status_id   
   left join researchinview.riv_review_types f on f.id = w.review_type_id

  WHERE w.work_type_id = 8;
