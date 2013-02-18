CREATE OR REPLACE VIEW kmdata.vw_Patent AS 
  SELECT w.id, w.resource_id, w.user_id, w.inventor, w.manufacturer, w.patent_number, w.percent_authorship, w.role_designator, w.sponsor, 
        w.title, w.url, w.created_at, w.updated_at, w.work_type_id, a.work_type_name, w.filed_date, w.issued_date,
         w.completed, w.issuing_organization, w.application_number, w.attorney_agent, w.patent_assignee, w.patent_class, w.document_number
   FROM kmdata.works w
   left join kmdata.work_types a on w.work_type_id = a.id
  WHERE w.work_type_id = 19;
