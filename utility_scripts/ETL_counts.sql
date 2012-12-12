select count(*) from osupro.publication where publication_type_id = 2

select count(*) from osupro.publication

SELECT ptr.publication_type_descr, COUNT(*) AS Total
FROM osupro.publication p
INNER JOIN osupro.publication_type_ref ptr ON p.publication_type_id = ptr.publication_type_id
GROUP BY ptr.publication_type_descr

select count(*) from osupro.creative_work

SELECT cwtr.creative_work_type_descr, COUNT(*) AS Total
FROM osupro.creative_work cw
INNER JOIN osupro.creative_work_type_ref cwtr ON cw.creative_work_type_id = cwtr.creative_work_type_id
GROUP BY cwtr.creative_work_type_descr

select count(*) from osupro.academic_item;

select aitr.academic_item_type_descr, COUNT(*) AS Total
from osupro.academic_item ai
left join osupro.academic_item_type_ref aitr on ai.academic_item_type_id = aitr.academic_item_type_id
group by aitr.academic_item_type_descr
order by 1;