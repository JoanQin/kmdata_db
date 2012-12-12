SELECT *
FROM ror.vw_Journal a
INNER JOIN kmdata.user_identifiers b ON a.person_id = b.user_id
WHERE b.inst_username = 'bakshi.2'
AND a.publication_year = 2011;

-- Before work ID was in: 503599, person 32044
SELECT b.inst_username, sd1.day, sd1.month, sd1.year, a.*
FROM kmdata.works a
INNER JOIN kmdata.user_identifiers b ON a.user_id = b.user_id
LEFT JOIN dmy_single_dates sd1 ON a.publication_dmy_single_date_id = sd1.id
WHERE b.inst_username = 'bakshi.2'
AND sd1.year = 2011
AND a.work_type_id = 4;

SELECT * FROM kmdata.user_identifiers WHERE inst_username = 'bakshi.2';


-- Before work ID was in: 503599, person 32044
SELECT b.inst_username, sd1.day, sd1.month, sd1.year, a.*
FROM kmdata.works a
INNER JOIN kmdata.user_identifiers b ON a.user_id = b.user_id
LEFT JOIN dmy_single_dates sd1 ON a.publication_dmy_single_date_id = sd1.id
WHERE b.inst_username = 'wilkins.92'
AND sd1.year = 2012
AND a.work_type_id = 4;

