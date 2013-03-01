 CREATE OR REPLACE VIEW vw_editorships AS 
 SELECT a.id, a.resource_id, a.user_id, a.article_title, a.modifier_id, c.name as modifier_val, 
	a.currently_editor_ind, e.name as editor_val,
          a.publication_issue, a.publication_name, a.publication_type_id, d.name as publicationtype_val, 
          a.editorship_type_id, b.name as editorship_type_val,
           a.publication_volume, a.url, 
          a.start_year, a.end_year, a.publication_date, a.created_at, a.updated_at, al.is_public, al.is_active
   FROM kmdata.editorial_activity a
   LEFT JOIN researchinview.activity_import_log al ON a.resource_id = al.resource_id
   left join researchinview.riv_editorship_types b on b.id = a.editorship_type_id
   left join researchinview.riv_editorship_descriptors c on c.id = a.modifier_id
   left join researchinview.riv_editorship_publication_types d on d.id = a.publication_type_id
   left join researchinview.riv_yes_no e on e.value = a.currently_editor_ind;