 CREATE OR REPLACE VIEW vw_figure AS 
 SELECT a.id, a.resource_id, a.user_id, a.author_list, a.city, a.country, a.created_by, 
	a.creation_dmy_single_date_id, sd2.month as creation_month, sd2.year as creation_year, 
	a.isbn, a.journal_title, a.original_publication_type,
         b.name as originaltype_val, a.beginning_page, a.ending_page, a.percent_authorship, a.publication_type_id, 
         c.name as type_val, a.publication_dmy_single_date_id, sd.month as publication_month, sd.year as publication_year, 
         a.publisher, a.state, a.title, a.publication_title,  
         a.url, a.volume, a.work_type_id, wt.work_type_name, kn.narrative_text,
          a.created_at, a.updated_at, a.issuing_organization, al.is_public, al.is_active
   FROM kmdata.works a
   LEFT JOIN researchinview.activity_import_log al ON a.resource_id = al.resource_id
   left join kmdata.work_types wt on wt.id = a.work_type_id
   left join kmdata.work_narratives wn on wn.work_id = a.id
   left join kmdata.narratives kn on kn.id = wn.narrative_id
   left join kmdata.dmy_single_dates sd on sd.id = a.publication_dmy_single_date_id
   left join kmdata.dmy_single_dates sd2 on sd2.id = a.creation_dmy_single_date_id
   left join researchinview.riv_equations_original_publication_types b on b.id = cast(a.original_publication_type as int)
   left join researchinview.riv_figure_types c on c.id = a.publication_type_id
   where wt.work_type_name = 'Figure';