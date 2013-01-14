CREATE OR REPLACE VIEW ror.vw_StrategicInitiatives AS
SELECT w.id, w.user_id AS person_id, institution_id, role_name, activity_id, summary, 
       start_year, end_year, active_ind, w.created_at, 
       w.updated_at, 
       CASE ail.is_public WHEN 1 THEN TRUE ELSE FALSE END AS is_public
  FROM kmdata.strategic_initiatives w
  INNER JOIN kmdata.resources res ON w.resource_id = res.id
  INNER JOIN kmdata.sources src ON res.source_id = src.id
  INNER JOIN researchinview.activity_import_log ail ON w.resource_id = ail.resource_id
 WHERE src.source_name != 'osupro'
   AND ail.is_active = 1;
-- output_text, w.resource_id, 

ALTER TABLE ror.vw_StrategicInitiatives
  OWNER TO kmdata;
GRANT ALL ON TABLE ror.vw_StrategicInitiatives TO kmdata;
GRANT SELECT ON TABLE ror.vw_StrategicInitiatives TO kmd_ror_app_user;
GRANT SELECT ON TABLE ror.vw_StrategicInitiatives TO kmd_dev_riv_user;
--GRANT SELECT ON TABLE ror.vw_StrategicInitiatives TO kmd_report_user;
