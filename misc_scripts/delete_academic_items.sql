delete from osupro.outreach_associated_work where associated_work_item_id in (select item_id from osupro.academic_item where academic_item_type_id = 70);
delete from osupro.academic_item_ohio_link_locator_ref where item_id in (select item_id from osupro.academic_item where academic_item_type_id = 70);
delete from osupro.academic_item_ebsco_locator_ref where item_id in (select item_id from osupro.academic_item where academic_item_type_id = 70);
delete from osupro.academic_item_tr_locator_ref where item_id in (select item_id from osupro.academic_item where academic_item_type_id = 70);
delete from osupro.publication where item_id in (select item_id from osupro.academic_item where academic_item_type_id = 70);
delete from osupro.academic_item where academic_item_type_id = 70;