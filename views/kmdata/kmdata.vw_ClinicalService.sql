CREATE OR REPLACE VIEW kmdata.vw_ClinicalService AS
SELECT a.id, a.user_id, a.clinical_service_type_id,  a.start_date, a.end_date, 
       a.title, a.duration, a.location, a.department, a.description, a.output_text, 
       a.resource_id, a.created_at, a.updated_at, a.url, a.clinical_hours_per,  d.name as clinical_hour_val,               
       a.individuals_served, a.ongoing, yn.name as ongoing_val, a.role, c.name as role_val,
       a.role_other, a.total_hours_teaching_clinic, e.name as cip_val,
       b.name as service_type_val, al.is_public, al.is_active
  FROM kmdata.clinical_service a
  left join researchinview.activity_import_log al on al.resource_id = a.resource_id
  left join researchinview.riv_clinical_service_types b on a.clinical_service_type_id = b.id
  left join researchinview.riv_yes_no yn on yn.value = cast(a.ongoing as int)
  left join researchinview.riv_clinical_roles c on c.id = cast(a.role as int)
  left join researchinview.riv_clinical_hours_freq d on d.id = cast(a.clinical_hours_per as int)
  left join researchinview.riv_cip_lookup e on e.value = a.department;
