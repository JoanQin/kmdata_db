create or replace view kmdata.vw_UniversityPartner as
select a.id, a.resource_id, a.user_id, a.partner_user_id, a.description_of_role, a.created_at, a.updated_at,
	b.is_active
from kmdata.university_partner a
left join researchinview.activity_import_log b on a.resource_id = b.resource_id