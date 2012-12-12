select count(*) from kmdata.works a
inner join kmdata.work_types b on a.work_type_id = b.id
where b.work_type_name = 'Outreach';

select * from kmdata.work_types limit 200;

select * from kmdata.location_types limit 200;

select count(*) from kmdata.work_locations;

select count(*) from osupro.outreach_county;

select * 
from kmdata.locations 
where location_type_id = 4;

SELECT b.county FROM osupro.outreach_county a INNER JOIN osupro.location_county_ref b ON a.county_id = b.id

select count(*) from kmdata.work_locations
where location_id in
(select id from kmdata.locations 
where location_type_id = 4);


SELECT DISTINCT g.id, g.resource_id, g.title, g.url, n1.narrative_text AS description_text,
   n2.narrative_text AS success_text, n3.narrative_text AS outcome_text, g.people_served, g.hours, 
   g.direct_cost, g.other_audience, g.other_result, g.other_subject, h.*
FROM kmdata.location_types a
INNER JOIN kmdata.locations b ON a.id = b.location_type_id
INNER JOIN kmdata.county_congressional_districts c ON b.geotype_id = c.county_geotype_id
INNER JOIN kmdata.county_congressional_districts d ON c.congressional_district_2010_geotype_id = d.congressional_district_2010_geotype_id
INNER JOIN kmdata.locations e ON d.county_geotype_id = e.geotype_id
INNER JOIN kmdata.work_locations f ON e.id = f.location_id
INNER JOIN kmdata.works g ON f.work_id = g.id
INNER JOIN kmdata.dmy_range_dates h ON g.outreach_dmy_range_date_id = h.id
LEFT JOIN kmdata.work_narratives wn1 ON g.id = wn1.work_id
LEFT JOIN kmdata.narratives n1 ON wn1.narrative_id = n1.id
LEFT JOIN kmdata.narrative_types nt1 ON n1.narrative_type_id = nt1.id
LEFT JOIN kmdata.work_narratives wn2 ON g.id = wn2.work_id
LEFT JOIN kmdata.narratives n2 ON wn2.narrative_id = n2.id
LEFT JOIN kmdata.narrative_types nt2 ON n2.narrative_type_id = nt2.id
LEFT JOIN kmdata.work_narratives wn3 ON g.id = wn3.work_id
LEFT JOIN kmdata.narratives n3 ON wn3.narrative_id = n3.id
LEFT JOIN kmdata.narrative_types nt3 ON n3.narrative_type_id = nt3.id
INNER JOIN kmdata.work_types wt ON g.work_type_id = wt.id
WHERE a.name = 'County'
AND b.name = 'FRANKLIN'
AND wt.work_type_name = 'Outreach'
AND nt1.narrative_desc = 'Outreach Description'
AND nt2.narrative_desc = 'Outreach Success'
AND nt3.narrative_desc = 'Outreach Outcome';

