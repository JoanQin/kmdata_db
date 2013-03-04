CREATE OR REPLACE VIEW kmdata.vw_internet AS 
select w.id, w.resource_id, w.user_id, w.author_list, w.frequency_of_publication, c.name as publication_freq_val,
	w.frequency_of_publication_other, w.medium, d.name as medium_val,
	w.percent_authorship, w.posted_on_dmy_single_date_id, e.month, e.year, w.title, w.title_of_weblog, w.url, w.work_type_id,
	b.work_type_name, w.created_at, w.updated_at,  al.is_public, al.is_active
from kmdata.works w
left join kmdata.work_types b on w.work_type_id = b.id
left join researchinview.activity_import_log al on al.resource_id = w.resource_id
left join researchinview.riv_publication_freq c on c.id = cast(w.frequency_of_publication as int)
left join researchinview.riv_internet_communication_medium d on d.id = cast(w.medium as int)
left join kmdata.dmy_single_dates e on e.id = w.posted_on_dmy_single_date_id 
where b.work_type_name = 'Internet' 