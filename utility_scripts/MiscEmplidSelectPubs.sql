select count(*) from osupro.publication;

select count(*) from osupro.academic_item;

select count(*) from osupro.ebsco_locator;
select count(*) from osupro.academic_item_ebsco_locator_ref;
select * from osupro.ebsco_locator limit 50;

select * from osupro.academic_item_ebsco_locator_ref limit 50;

select * 
from osupro.publication p
inner join osupro.academic_item ai on p.item_id = ai.item_id
left join osupro.academic_item_ebsco_locator_ref lr on ai.item_id = lr.item_id
left join osupro.ebsco_locator el on lr.ebsco_locator_id = el.ebsco_locator_id
where ai.profile_emplid = '06169467'
limit 200

select count(*) as item_count, ebsco_locator_id
from osupro.academic_item_ebsco_locator_ref
group by ebsco_locator_id
order by 1 desc

