SELECT c.first_name, c.last_name, b.inst_username, a.title, a.working_title, d.name, d.building_code
FROM kmdata.user_appointments a
INNER JOIN kmdata.user_identifiers b ON a.user_id = b.user_id
INNER JOIN kmdata.users c ON b.user_id = c.id
LEFT JOIN kmdata.buildings d ON a.building_code = d.building_code
WHERE b.inst_username = 'wilkins.92';