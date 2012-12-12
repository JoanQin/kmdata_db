SELECT * 
FROM kmdata.user_appointments
WHERE user_id = (SELECT user_id FROM kmdata.user_identifiers WHERE inst_username = 'wilkins.92')
LIMIT 200;

-- 1136078 has lots of citation count

SELECT * FROM kmdata.user_identifiers WHERE user_id = 1136078;

SELECT COUNT(*) FROM kmdata.user_appointments;


SELECT COUNT(*) FROM peoplesoft.ps_user_appointments;
SELECT kmdata.import_appointments_from_ps();
   
-- PRE COUNT:      59487
-- TO BE DELETED:   8479
-- NET:            51008
-- TO BE TOTALED:  59751
-- POST TOTAL:     59554

SELECT * FROM kmdata.user_appointments WHERE rcd_num > 0 ORDER BY user_id, rcd_num;

SELECT * FROM kmdata.user_appointments WHERE user_id = 2933;


SELECT COUNT(*) FROM peoplesoft.personal_data_addressinfo;
SELECT COUNT(*) FROM kmdata.user_addresses;
-- PEOPLESOFT COUNT: 1287497
-- PRE COUNT:        1222824
-- TO BE DELETED:         32
-- NET:              1222792
-- TO BE TOTALED:    1287497
-- POST TOTAL:       1285248


SELECT kmdata.import_user_addresses_from_ps(); -- minutes/seconds: about 2 minutes

SELECT kmdata.get_or_add_address_type_id('campus'); -- 1

   SELECT COUNT(*) FROM kmdata.user_addresses ua
   WHERE NOT EXISTS (
      SELECT b.user_id, ua.address_type_id
      FROM peoplesoft.personal_data_addressinfo a
      INNER JOIN kmdata.user_identifiers b ON a.emplid = b.emplid
      WHERE b.user_id = ua.user_id
      AND ua.address_type_id = 1
   )
   AND ua.address_type_id = 1;



-- pre count:            0
-- post count:           244354
-- should be at or less: 244958
-- ADD INDEXES!!!
SELECT kmdata.import_user_emails_from_ps();

SELECT COUNT(*) FROM kmdata.user_emails;
SELECT COUNT(*) FROM peoplesoft.ps_email_addresses;
