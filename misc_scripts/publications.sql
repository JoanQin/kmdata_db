SELECT d.*, a.*, b.*, c.*
FROM kmdata.resources a
INNER JOIN kmdata.works b ON a.id = b.resource_id
INNER JOIN kmdata.publications c ON b.id = c.work_id
INNER JOIN kmdata.publication_type_refs d ON c.publication_type_id = d.id
WHERE 
--d.publication_type_descr = 'Journal Article'
--AND 
b.user_id = 726544;

select * from publication_type_refs;

select count(*) from kmdata.publications where publication_type_id = 1;
select count(*) from kmdata.publication_authors;

select * from kmdata.users where last_name = 'Wilkins' and first_name = 'John';
