-- faculty and degree location
SELECT u.last_name, u.first_name, ui.emplid, r.name AS role_name, loc.name AS location_name, loc.state, lt.name AS location_type_name
FROM kmdata.roles r
INNER JOIN kmdata.user_roles ur ON r.id = ur.role_id
INNER JOIN kmdata.users u ON ur.user_id = u.id
INNER JOIN kmdata.user_identifiers ui ON u.id = ui.user_id
INNER JOIN kmdata.degree_certifications dc ON u.id = dc.user_id
INNER JOIN kmdata.institutions i ON dc.institution_id = i.id
INNER JOIN kmdata.locations loc ON i.location_id = loc.id
INNER JOIN kmdata.location_types lt ON loc.location_type_id = lt.id
WHERE r.name LIKE '%Professor%' OR r.name LIKE '%Faculty%';
