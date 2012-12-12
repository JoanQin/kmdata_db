-- need to be in a transaction to use cursors.
-- '(madrid | barcelona | seville | sevilla | bilbao) & (spain | españa)'
BEGIN;
SELECT kmdata.get_users_with_keyterms('cardiology | radiology', 'resultscursor');
FETCH ALL IN resultscursor;

-- run this separately to discard the result set
COMMIT;

/******
CHECK THE ETL LOGS TO SEE IF JOAN'S JOB RAN ON PRODUCTION AND THAT THE DEV FEEDS ARE WORKING
******/