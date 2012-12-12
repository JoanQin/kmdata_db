CREATE OR REPLACE VIEW kmdata.vw_CoursesTaught AS
SELECT id, user_id, course_taught_type_id, professional_type_id, instructional_method_id, 
       instructional_method_other, title, "number", length, institution_id, 
       department, credit_hour, year_offered, period_offered_id, description, 
       percent_taught, role, enrollment, formal_student_evaluation_ind, 
       evaluation, output_text, formal_peer_evaluation_ind, resource_id, 
       created_at, updated_at
  FROM kmdata.courses_taught;
