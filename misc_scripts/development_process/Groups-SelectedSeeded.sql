SELECT g.name, u.last_name, u.first_name, ui.inst_username
FROM kmdata.groups g
INNER JOIN kmdata.group_memberships gm ON g.id = gm.group_id
INNER JOIN kmdata.users u ON gm.resource_id = u.resource_id
INNER JOIN kmdata.user_identifiers ui ON u.id = ui.user_id
WHERE g.name = 'Engineering Computing Services'
ORDER BY u.last_name, ui.inst_username;