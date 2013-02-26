CREATE OR REPLACE VIEW ror.vw_Campuses AS 
 SELECT a.id, a.campus_name, a.institution_id, a.location_id, a.resource_id, a.ps_location_name, a.campus_code
   FROM kmdata.campuses a;

ALTER TABLE ror.vw_Campuses
  OWNER TO kmdata;
GRANT ALL ON TABLE ror.vw_Campuses TO kmdata;
GRANT SELECT ON TABLE ror.vw_Campuses TO kmd_ror_app_user;
GRANT SELECT ON TABLE ror.vw_Campuses TO kmd_dev_riv_user;
--GRANT SELECT ON TABLE ror.vw_Campuses TO kmd_report_user;


CREATE OR REPLACE VIEW ror.vw_Colleges AS 
 SELECT a.id, a.acad_group, a.college_name, a.abbreviation, a.resource_id
   FROM kmdata.colleges a;

ALTER TABLE ror.vw_Colleges
  OWNER TO kmdata;
GRANT ALL ON TABLE ror.vw_Colleges TO kmdata;
GRANT SELECT ON TABLE ror.vw_Colleges TO kmd_ror_app_user;
GRANT SELECT ON TABLE ror.vw_Colleges TO kmd_dev_riv_user;
--GRANT SELECT ON TABLE ror.vw_Colleges TO kmd_report_user;


CREATE OR REPLACE VIEW ror.vw_AcadDepartments AS 
 SELECT a.id, a.department_name, a.college_id, a.abbreviation, a.resource_id, a.dept_code, a.ods_department_number
   FROM kmdata.acad_departments a;

ALTER TABLE ror.vw_AcadDepartments
  OWNER TO kmdata;
GRANT ALL ON TABLE ror.vw_AcadDepartments TO kmdata;
GRANT SELECT ON TABLE ror.vw_AcadDepartments TO kmd_ror_app_user;
GRANT SELECT ON TABLE ror.vw_AcadDepartments TO kmd_dev_riv_user;
--GRANT SELECT ON TABLE ror.vw_AcadDepartments TO kmd_report_user;


CREATE OR REPLACE VIEW ror.vw_Courses AS 
 SELECT a.id, a.ps_course_id, a.course_name, a.course_name_abbrev, a.active, 
        a.description, a.repeatable, a.grading_basis, a.units_acad_prog, a.resource_id
   FROM kmdata.courses a;

ALTER TABLE ror.vw_Courses
  OWNER TO kmdata;
GRANT ALL ON TABLE ror.vw_Courses TO kmdata;
GRANT SELECT ON TABLE ror.vw_Courses TO kmd_ror_app_user;
GRANT SELECT ON TABLE ror.vw_Courses TO kmd_dev_riv_user;
--GRANT SELECT ON TABLE ror.vw_Courses TO kmd_report_user;


CREATE OR REPLACE VIEW ror.vw_Offerings AS 
 SELECT a.id, a.course_id, a.ps_course_offer_number, a.college_id,
        a.subject_id, a.course_number, a.campus_id, a.department_id, a.acad_career, 
        a.schedule_print, a.catalog_print, a.sched_print_instr, a.resource_id
   FROM kmdata.offerings a;

ALTER TABLE ror.vw_Offerings
  OWNER TO kmdata;
GRANT ALL ON TABLE ror.vw_Offerings TO kmdata;
GRANT SELECT ON TABLE ror.vw_Offerings TO kmd_ror_app_user;
GRANT SELECT ON TABLE ror.vw_Offerings TO kmd_dev_riv_user;
--GRANT SELECT ON TABLE ror.vw_Offerings TO kmd_report_user;


CREATE OR REPLACE VIEW ror.vw_Sections AS 
 SELECT a.id, a.offering_id, a.term_session_id, a.ps_class_section, a.class_number, 
        a.enrollment_total, a.enrollment_capacity, a.waitlist_total, a.ssr_component,
        a.schedule_print, a.print_topic, a.instruction_mode, a.resource_id
   FROM sections a;

ALTER TABLE ror.vw_Sections
  OWNER TO kmdata;
GRANT ALL ON TABLE ror.vw_Sections TO kmdata;
GRANT SELECT ON TABLE ror.vw_Sections TO kmd_ror_app_user;
GRANT SELECT ON TABLE ror.vw_Sections TO kmd_dev_riv_user;
--GRANT SELECT ON TABLE ror.vw_Sections TO kmd_report_user;


CREATE OR REPLACE VIEW ror.vw_Enrollments AS 
 SELECT a.id, a.section_weekly_mtg_id, a.ps_instr_assign_seq, a.user_id AS person_id, a.role_id, 
        a.sched_print_instr, a.resource_id, a.created_at, a.updated_at
   FROM kmdata.enrollments a;

ALTER TABLE ror.vw_Enrollments
  OWNER TO kmdata;
GRANT ALL ON TABLE ror.vw_Enrollments TO kmdata;
GRANT SELECT ON TABLE ror.vw_Enrollments TO kmd_ror_app_user;
GRANT SELECT ON TABLE ror.vw_Enrollments TO kmd_dev_riv_user;
--GRANT SELECT ON TABLE ror.vw_Enrollments TO kmd_report_user;


CREATE OR REPLACE VIEW ror.vw_EnrollmentRoles AS 
 SELECT a.id, a.name, a.rank, a.role_code
   FROM kmdata.enrollment_roles a;

ALTER TABLE ror.vw_EnrollmentRoles
  OWNER TO kmdata;
GRANT ALL ON TABLE ror.vw_EnrollmentRoles TO kmdata;
GRANT SELECT ON TABLE ror.vw_EnrollmentRoles TO kmd_ror_app_user;
GRANT SELECT ON TABLE ror.vw_EnrollmentRoles TO kmd_dev_riv_user;
--GRANT SELECT ON TABLE ror.vw_EnrollmentRoles TO kmd_report_user;


CREATE OR REPLACE VIEW ror.vw_AcademicCareers AS 
 SELECT a.id, a.name
   FROM kmdata.academic_careers a;

ALTER TABLE ror.vw_AcademicCareers
  OWNER TO kmdata;
GRANT ALL ON TABLE ror.vw_AcademicCareers TO kmdata;
GRANT SELECT ON TABLE ror.vw_AcademicCareers TO kmd_ror_app_user;
GRANT SELECT ON TABLE ror.vw_AcademicCareers TO kmd_dev_riv_user;
--GRANT SELECT ON TABLE ror.vw_AcademicCareers TO kmd_report_user;



CREATE OR REPLACE VIEW ror.vw_Subjects AS 
 SELECT a.id, a.subject_name, a.subject_abbrev, a.acad_org, a.cip_code, a.formal_descr, a.resource_id
   FROM kmdata.subjects a;

ALTER TABLE ror.vw_Subjects
  OWNER TO kmdata;
GRANT ALL ON TABLE ror.vw_Subjects TO kmdata;
GRANT SELECT ON TABLE ror.vw_Subjects TO kmd_ror_app_user;
GRANT SELECT ON TABLE ror.vw_Subjects TO kmd_dev_riv_user;
--GRANT SELECT ON TABLE ror.vw_Subjects TO kmd_report_user;


CREATE OR REPLACE VIEW ror.vw_Terms AS 
 SELECT a.id, a.term_code, a.description
   FROM kmdata.terms a;

ALTER TABLE ror.vw_Terms
  OWNER TO kmdata;
GRANT ALL ON TABLE ror.vw_Terms TO kmdata;
GRANT SELECT ON TABLE ror.vw_Terms TO kmd_ror_app_user;
GRANT SELECT ON TABLE ror.vw_Terms TO kmd_dev_riv_user;
--GRANT SELECT ON TABLE ror.vw_Terms TO kmd_report_user;


CREATE OR REPLACE VIEW ror.vw_TermSessions AS 
 SELECT a.id, a.term_id, a.session_code
   FROM kmdata.term_sessions a;

ALTER TABLE ror.vw_TermSessions
  OWNER TO kmdata;
GRANT ALL ON TABLE ror.vw_TermSessions TO kmdata;
GRANT SELECT ON TABLE ror.vw_TermSessions TO kmd_ror_app_user;
GRANT SELECT ON TABLE ror.vw_TermSessions TO kmd_dev_riv_user;
--GRANT SELECT ON TABLE ror.vw_TermSessions TO kmd_report_user;


CREATE OR REPLACE VIEW ror.vw_SectionWeeklyMtgs AS
 SELECT a.id, a.section_id, a.ps_class_mtg_number, a.start_time, a.end_time, 
        a.building_id, a.room_no, a.days_of_week, a.start_date, a.end_date, a.resource_id
   FROM kmdata.section_weekly_mtgs a;

ALTER TABLE ror.vw_SectionWeeklyMtgs
  OWNER TO kmdata;
GRANT ALL ON TABLE ror.vw_SectionWeeklyMtgs TO kmdata;
GRANT SELECT ON TABLE ror.vw_SectionWeeklyMtgs TO kmd_ror_app_user;
GRANT SELECT ON TABLE ror.vw_SectionWeeklyMtgs TO kmd_dev_riv_user;
--GRANT SELECT ON TABLE ror.vw_SectionWeeklyMtgs TO kmd_report_user;




--TEMPLATE:
/*
CREATE OR REPLACE VIEW ror.vw_ AS 
 SELECT 
   FROM advising a;

ALTER TABLE ror.vw_
  OWNER TO kmdata;
GRANT ALL ON TABLE ror.vw_ TO kmdata;
GRANT SELECT ON TABLE ror.vw_ TO kmd_ror_app_user;
GRANT SELECT ON TABLE ror.vw_ TO kmd_dev_riv_user;
GRANT SELECT ON TABLE ror.vw_ TO kmd_report_user;
*/

