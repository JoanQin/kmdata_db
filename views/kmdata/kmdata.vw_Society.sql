create or replace view vw_society as
select a.id, a.resource_id, a.user_id, a.organization_city, a.organization_country, a.notes, a.group_name,
	a.organization_name, b.name as institution_val, a.membership_role_id, c.name as role_val,
	a.membership_role_modifier_id, d.name as role_modifier_val, a.organization_state, a.organization_website,
	a.start_year, a.start_month, a.start_day, a.ongoing, e.name as ongoing_val, a.organization_id, a.end_year, a.end_month, a.end_day, a.created_at,
	a.updated_at, al.is_active, al.is_public
from  kmdata.membership a
left join researchinview.activity_import_log al on al.resource_id = a.resource_id  
left join researchinview.riv_institutions b on b.id = cast(a.organization_name as int)   
left join researchinview.riv_professional_society_roles c on c.id = a.membership_role_id  
left join researchinview.riv_professional_society_role_modifiers d on d.id = a.membership_role_modifier_id
left join researchinview.riv_yes_no e on e.value = cast(a.ongoing as int)