create or replace view vw_outreach as 
SELECT a.id, a.resource_id, a.academic_calendar, b.name as calendar_val, a.academic_calendar_other, a.countries, a.currency, a.description, 
	a.direct_cost, a.outreach_end_year, a.outreach_end_month, a.hours, a.included_activities, 
	kmd_dev_riv_user.getoutreachactivities(a.included_activities) as activities_val, a.initiative, a.initiative_type, 
	 f.name as initiative_val, a.people_served, a.ongoing, c.name as ongoing_val, a.organization_id,
	a.percent_effort, a.outreach_start_year, a.outreach_start_month, a.success, a.other_audience, d.name as audience_val, 
	a.timeframes_offered, e.name as offered_val, a.timeframes_offered_other, a.total_hours, a.created_at, a.updated_at, 
	al.is_public, al.is_active
   FROM kmdata.outreach a   
   left join researchinview.activity_import_log al on al.resource_id = a.resource_id   
   left join researchinview.riv_academic_calendar_types b on b.id = cast(a.academic_calendar as int)    
   left join researchinview.riv_yes_no c on c.value = cast(a.ongoing as int)
   left join researchinview.riv_outreach_targetted_audiences d on d.id = cast(a.other_audience as int)
   left join researchinview.riv_academic_calendar_timeframes e on e.id = cast(a.timeframes_offered as int)
   left join researchinview.riv_outreach_intitiative_types f on f.id = cast(a.initiative_type as int)