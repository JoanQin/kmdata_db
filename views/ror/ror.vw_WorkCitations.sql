CREATE OR REPLACE VIEW ror.vw_WorkCitations AS 
   SELECT ail.riv_activity_name, w.id AS work_id, ail.resource_id, kmdata.get_work_citation(ail.riv_activity_name, w.id) AS citation
     FROM researchinview.activity_import_log ail
     INNER JOIN kmdata.works w ON ail.resource_id = w.resource_id;
