CREATE OR REPLACE FUNCTION kmdata.get_work_citation_by_resource_id (
   p_ResourceID BIGINT
) RETURNS VARCHAR AS $$
DECLARE
   v_RIVActivityName VARCHAR(100);
   v_WorkID BIGINT;
   v_Citation VARCHAR(4000);
BEGIN
   -- Step 1: Select the work ID and type
   SELECT ail.riv_activity_name, w.id
     INTO v_RIVActivityName, v_WorkID
     FROM researchinview.activity_import_log ail
     LEFT JOIN kmdata.works w ON ail.resource_id = w.resource_id
    WHERE ail.resource_id = p_ResourceID;

   -- Step 2: get and return the citation
   v_Citation := kmdata.get_work_citation(v_RIVActivityName, v_WorkID);
   RETURN v_Citation;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
