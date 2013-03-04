CREATE OR REPLACE VIEW kmdata.vw_Journal AS 
 SELECT w.id, w.resource_id, w.user_id, w.article_title, w.journal_article_type_id, w.author_list, w.issn, w.impact_factor, 
        w.issue, w.journal_title, w.beginning_page, w.ending_page, w.percent_authorship, 
        w.publication_dmy_single_date_id, sd1.day AS publication_day, sd1.month AS publication_month, sd1.year AS publication_year,
        w.review_type_id, w.status_id, w.url, w.volume, w.created_at, w.updated_at, w.work_type_id, w.citation_count,
        COALESCE(w.extended_author_list, w.author_list) AS extended_author_list,
         g.name as journal_article_type_name,  	          
	         w.is_review,
	         f.name as review_type_name,  e.name as publication_status,   a.work_type_name,	         
           b.narrative_text, c.is_public,  c.is_active, k.name as is_review_val
   FROM kmdata.works w
   LEFT JOIN kmdata.dmy_single_dates sd1 ON w.publication_dmy_single_date_id = sd1.id
   LEFT JOIN kmdata.work_narratives wn ON w.id = wn.work_id
      LEFT JOIN kmdata.narratives b on wn.narrative_id = b.id
      left join researchinview.activity_import_log c on c.resource_id = w.resource_id
      left join kmdata.work_types a on a.id = w.work_type_id
      left join researchinview.riv_publication_statuses e on e.id = w.status_id   
      left join researchinview.riv_review_types f on f.id = w.review_type_id
   left join researchinview.riv_journal_article_types g on g.id = w.journal_article_type_id
   left join researchinview.riv_yes_no k on k.value = cast(w.is_review as int)
  WHERE w.work_type_id = 4;
