CREATE OR REPLACE VIEW vw_courseundergraduate AS 
SELECT a.id, a.resource_id, a.user_id, a.course_taught_type_id, a.number, a.professional_type_id, d.name as coursetype_val,
	a.credit_hour, a.description, a.role, 
          a.enrollment, a.institution_id, j.name as institution_val, a.instructional_method_id, e.name as instructionMethod_val,
          a.length, a.evaluation, a.formal_peer_evaluation_ind, g.name as peerEval_val,
          a.percent_taught, a.period_offered_id, c.name as period_val, a.formal_student_evaluation_ind, f.name as studentEval_val,
           a.title, a.year_offered, 
          a.created_at, a.updated_at, a.academic_calendar, b.name as calendar_val, a.academic_calendar_other, a.frequency, a.institution_group_other,
          a.integration_group_id, k.groupname as group_val, a.number_of_times, a.period_offered_other, a.subject_area, h.name as subjectArea_val,
          a.ended_on, al.is_public, al.is_active
  FROM kmdata.courses_taught a
  left join researchinview.activity_import_log al on a.resource_id = al.resource_id
  left join researchinview.riv_academic_calendar_types b on cast(a.academic_calendar as int) = b. id
  left join researchinview.riv_academic_calendar_timeframes c on c.id = cast(a.period_offered_id as int)
  left join researchinview.riv_course_types d on d.id = a.professional_type_id
  left join researchinview.riv_instruction_methods e on e.id = a.instructional_method_id
  left join researchinview.riv_yes_no f on f.value = a.formal_student_evaluation_ind
  left join researchinview.riv_yes_no g on g.value = a.formal_peer_evaluation_ind
  left join researchinview.riv_cip_lookup h on h.value = a.subject_area
  left join kmdata.institutions j on j.id = a.institution_id
  left join kmd_dev_riv_user.rivgroupdept k on k.deptid = a.integration_group_id;