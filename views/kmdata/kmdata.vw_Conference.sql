CREATE OR REPLACE VIEW kmdata.vw_Conference AS 
 SELECT w.id, w.resource_id, w.user_id, w.title, w.journal_article_type_id, w.author_list, w.isbn, w.issn, w.impact_factor, w.issue, 
        w.journal_title, w.beginning_page, w.ending_page, w.percent_authorship, w.review_type_id, w.status_id, w.url, w.volume, w.created_at, 
        w.updated_at, w.work_type_id, w.book_title, w.city, w.state, w.country, w.event_title, w.edition, w.publisher, w.series, 
        w.publication_dmy_single_date_id, sd1.day AS publication_day, sd1.month AS publication_month, sd1.year AS publication_year,
        w.performance_start_date AS conference_start_date, w.publication_media_type_id, w.publication_type_id,	         
	           f.name as review_type,   a.work_type_name,
	           w.is_review,  
	          e.name as publication_status, w.number_of_citations,	          
	          g.name as publication_document_type,  h.name as book_type,
            b.narrative_text, c.is_public, c.is_active
   FROM kmdata.works w
   LEFT JOIN kmdata.dmy_single_dates sd1 ON w.publication_dmy_single_date_id = sd1.id
   left join kmdata.narratives b on w.resource_id = b.resource_id
      left join researchinview.activity_import_log c on c.resource_id = w.resource_id
      left join kmdata.work_types a on a.id = w.work_type_id
      left join researchinview.riv_publication_statuses e on e.id = w.status_id   
      left join researchinview.riv_review_types f on f.id = w.review_type_id
      left join researchinview.riv_publication_document_types g on g.id = w.publication_media_type_id
   left join researchinview.riv_book_types h on h.id = w.publication_type_id
  WHERE w.work_type_id = 13;
