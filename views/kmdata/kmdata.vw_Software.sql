CREATE OR REPLACE VIEW kmdata.vw_Software AS 
 
 SELECT w.id, w.resource_id, w.user_id, w.author_list, w.sponsor, w.percent_authorship, w.publisher, w.role_designator, w.title, w.medium, w.url, w.edition, 
 w.publication_dmy_single_date_id, sd1.day AS publication_day, sd1.month AS publication_month, sd1.year AS publication_year, 
 w.last_update_dmy_single_date_id, sd2.day AS last_update_day, sd2.month AS last_update_month, sd2.year AS last_update_year, 
 w.created_at, w.updated_at, w.work_type_id, w.distributor, w.sub_work_type_id, w.sub_work_type_other,   
       a.work_type_name,  b.name as type_of_work, 
        c.narrative_text, d.is_public, lo.is_active          
   FROM kmdata.works w
   LEFT JOIN kmdata.dmy_single_dates sd1 ON w.publication_dmy_single_date_id = sd1.id
   LEFT JOIN kmdata.dmy_single_dates sd2 ON w.last_update_dmy_single_date_id = sd2.id
   left join kmdata.work_types a on a.id = w.work_type_id
   left join researchinview.riv_software_type_of_work b on b.id = w.sub_work_type_id
   left join kmdata.narratives c on w.resource_id = c.resource_id
         left join researchinview.activity_import_log d on d.resource_id = w.resource_id
          left join researchinview.activity_import_log lo on w.resource_id = lo.resource_id
  WHERE w.work_type_id = 21;
