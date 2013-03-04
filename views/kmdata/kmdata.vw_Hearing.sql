create or replace view vw_hearing as 
select w.id, w.resource_id, w.user_id, w.issuing_organization, w.percent_authorship, w.presentation_dmy_single_date_id,
	sd.month, sd.year, w.role_id, c.name as role_val, w.role_designator, w.sponsor, w.submitted_to, w.title, 
	w.type_of_activity, d.name as publication_type_val, w.type_of_activity_other, w.url, w.work_type_id,
	b.work_type_name, w.created_at, w.updated_at, kn.narrative_text, al.is_public, al.is_active
from kmdata.works w
left join kmdata.work_types b on w.work_type_id = b.id
left join researchinview.activity_import_log al on al.resource_id = w.resource_id
left join kmdata.work_narratives wn on wn.work_id = w.id
left join kmdata.narratives kn on kn.id = wn.narrative_id
left join kmdata.dmy_single_dates sd on sd.id = w.presentation_dmy_single_date_id
left join researchinview.riv_legal_roles c on c.id = w.role_id
left join researchinview.riv_hearing_publication_types d on d.id = cast(w.type_of_activity as int)
where b.work_type_name = 'Hearing' 