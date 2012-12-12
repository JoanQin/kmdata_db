select 'GRANT SELECT ON '||schemaname||'.'||tablename||' TO CHANGEME;'
from pg_tables 
where schemaname = 'researchinview'
ORDER BY schemaname, tablename;



select 'GRANT SELECT ON '||schemaname||'.'||viewname||' TO kmd_dev_riv_user;'
from pg_views 
where schemaname = 'ror'
ORDER BY schemaname, viewname;


SELECT * FROM pg_views LIMIT 200;

