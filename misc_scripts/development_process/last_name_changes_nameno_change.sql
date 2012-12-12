SELECT *
FROM kmdata.users u
INNER JOIN kmdata.user_identifiers ui ON u.id = ui.user_id
WHERE ui.inst_username IN ('kerr.248','bennett.895','harris-green.1','bryan.218') or ui.emplid = '01105101';

-- For user Tiffany N.S. Bennett ("01105101"): 'sutton.163' -> 'bennett.895'

