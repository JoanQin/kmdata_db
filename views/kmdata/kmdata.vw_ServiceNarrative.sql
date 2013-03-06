create or replace view vw_ServiceNarrative as 
select  a.id, a.narrative_type_id, a.narrative_text, a.private_ind, a.created_at,
	a.updated_at, a.resource_id, b.user_id, al.is_active, na.narrative_desc
from kmdata.narratives a
left join kmdata.user_narratives b on a.id = b.narrative_id
left join researchinview.activity_import_log al on al.resource_id = a.resource_id
left join kmdata.narrative_types na on na.id = a.narrative_type_id
where na.narrative_desc = 'Service Activities'