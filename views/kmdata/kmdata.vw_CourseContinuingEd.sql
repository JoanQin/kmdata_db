CREATE OR REPLACE VIEW vw_coursecontinuinged AS 
SELECT a.id, a.resource_id, a.user_id, a.course_taught_other_type_id, a.number, a.credit_hour, a.description, a.role, 
          a.enrollment, a.institution_id, i.name as instution_val, a.length, a.evaluation, a.percent_taught, a.formal_student_evaluation, f.name as studentEval_val, a.title, 
          a.one_day_event_ind, b.name as oneday_val, a.department, a.start_year, a.start_month, a.start_day, a.end_year, a.end_month, a.end_day,
          a.created_at, a.updated_at, a.academic_calendar, c.name as clendar_val, a.academic_calendar_other, a.city, a.country, a.course_type,
          e.name as coursetype_val, a.institution_group_other, a.integration_group_id, k.groupname as group_val,  a.number_of_times, a.peer_evaluated,
          g.name as peerEval_val, a.period_offered, d.name as period_val,
          a.period_offered_other, a.state_province, a.subject_area, h.name as subjectarea_val, al.is_public, al.is_active
  FROM kmdata.courses_taught_other a
  left join researchinview.activity_import_log al on a.resource_id = al.resource_id
  left join researchinview.riv_yes_no b on b.value = a.one_day_event_ind
  left join researchinview.riv_academic_calendar_types c on c.id = cast(a.academic_calendar as int)
  left join researchinview.riv_academic_calendar_timeframes d on d.id = cast(a.period_offered as int)
  left join researchinview.riv_continuing_education_course_types e on e.id = cast(a.course_type as int)
  left join researchinview.riv_yes_no f on f.value = a.formal_student_evaluation
  left join researchinview.riv_yes_no g on g.value = cast(a.peer_evaluated as int)
  left join researchinview.riv_cip_lookup h on h.value = a.subject_area
  left join kmdata.institutions i on i.id = a.institution_id
  left join kmd_dev_riv_user.rivgroupdept k on k.deptid = a.integration_group_id;