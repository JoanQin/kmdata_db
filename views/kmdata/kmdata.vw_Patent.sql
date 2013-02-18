CREATE OR REPLACE VIEW kmdata.vw_Patent AS 
 SELECT works.id, works.resource_id, works.user_id, works.inventor, works.manufacturer, works.patent_number, works.percent_authorship, works.role_designator, 
 works.sponsor, works.title, works.url, works.created_at, works.updated_at, works.work_type_id, works.filed_date, works.issued_date,  
        a.work_type_name, 
         works.completed, works.issuing_organization, works.application_number, works.attorney_agent, works.patent_assignee, 
         works.patent_class, works.document_number,
         b.narrative_text, c.is_public
   FROM kmdata.works 
   left join kmdata.work_types a on works.work_type_id = a.id
   left join kmdata.narratives b on works.resource_id = b.resource_id
         left join researchinview.activity_import_log c on c.resource_id = works.resource_id
  WHERE works.work_type_id = 19 ;
