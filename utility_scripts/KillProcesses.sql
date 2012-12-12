ALTER ROLE ceti WITH CONNECTION LIMIT 15;

SELECT 
    pg_terminate_backend(procpid) 
FROM 
    pg_stat_activity 
WHERE 
    -- don't kill my own connection!
    procpid <> pg_backend_pid()
    AND usename = 'ceti'
    -- don't kill the connections to other databases
    AND datname = 'kmdata_dev'
    ;
