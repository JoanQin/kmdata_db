SELECT * FROM ror.vw_conference WHERE id IN (395927, 400602, 507400);
SELECT * FROM kmdata.vw_conference WHERE id IN (395927, 400602, 507400);

SELECT * FROM researchinview.activity_import_log where resource_id IN (5521518, 5530868, 5860065);

SELECT a.*, b.*, d.*, c.*
FROM kmdata.resources a
INNER JOIN kmdata.sources b ON a.source_id = b.id
INNER JOIN kmdata.vw_conference c ON a.id = c.resource_id
INNER JOIN researchinview.activity_import_log d ON a.id = d.resource_id
WHERE a.id IN (5521518, 5530868, 5860065);
