CREATE OR REPLACE VIEW vw_consultants AS 
SELECT a.id, a.resource_id, a.user_id, a.activity_type_id, b.name as activityCategory_val,
	a.activity_name, a.city, a.country, a.key_achievements,  a.for_fee_ind, e.name as fee_val,
          a.one_day_event_ind, d.name as onetime_val, a.org_name, a.state, a.activity_sub_type_id, 
          c.name as activityType_val,  a.url, a.created_at, a.updated_at, a.activity_category_other,
          a.type_of_activity_other, a.start_year, a.start_month, a.start_day,
          a.end_year, a.end_month, a.end_day, al.is_public, al.is_active
   FROM kmdata.professional_activity a
   left join researchinview.activity_import_log al on a.resource_id = al.resource_id
   left join researchinview.riv_consultant_category_activity b on b.id = a.activity_type_id
   left join researchinview.riv_consultant_activity_types c on a.activity_sub_type_id = c.id
   left join researchinview.riv_yes_no d on a.one_day_event_ind = d.value
   left join researchinview.riv_yes_no e on e.value = a.for_fee_ind;