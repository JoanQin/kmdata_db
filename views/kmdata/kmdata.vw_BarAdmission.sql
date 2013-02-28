create or replace view vw_baradmission as 
SELECT a.id, a.resource_id, a.user_id, a.active, 
case when a.active = '1' then 'Active' when a.active = '2' then 'Inactive' else null end as active_val,
a.admitted_on_dmy_single_date_id, b.month, b.year, a.country, a.state, a.created_at, a.updated_at
   FROM kmdata.bar_admission a
   left join kmdata.dmy_single_dates b on a.admitted_on_dmy_single_date_id = b.id