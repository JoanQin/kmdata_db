--**************************************
--*  Add the following stored procedures
--**************************************
-- 
-- kmdata.import_user_addresses_from_ps     --> wait until SID rollout
-- kmdata.import_user_phones_from_ps        --> wait until SID rollout


--**************************************
--* move researchinview.riv_institutions to production --> DONE ON PRODUCTION AS OF 12/10/2012
--**************************************


ALTER TABLE peoplesoft.ps_user_appointments ADD COLUMN building_code VARCHAR(10);

ALTER TABLE kmdata.user_appointments ADD COLUMN building_code VARCHAR(10);

ALTER TABLE kmdata.acad_departments ADD COLUMN ods_department_number VARCHAR(255) NOT NULL;

ALTER TABLE kmdata.colleges ADD COLUMN acad_group VARCHAR(5); --NOT NULL

ALTER TABLE kmdata.courses ADD COLUMN path VARCHAR(255) NOT NULL;

CREATE TABLE sid.OSU_UNIT_TYPE (
                id INTEGER NOT NULL,
                name VARCHAR(50) NOT NULL,
                description VARCHAR(255) NOT NULL,
                createDate TIMESTAMP NOT NULL,
                CONSTRAINT osu_unit_type_pk PRIMARY KEY (id)
);


CREATE TABLE sid.OSU_UNIT_ASSOCIATION_TYPE (
                parentUnitTypeId INTEGER NOT NULL,
                childUnitTypeId INTEGER NOT NULL,
                id INTEGER NOT NULL,
                description VARCHAR(255) NOT NULL,
                createDate TIMESTAMP NOT NULL,
                modifyDate TIMESTAMP,
                CONSTRAINT osu_unit_association_type_pk PRIMARY KEY (parentUnitTypeId, childUnitTypeId)
);


CREATE TABLE sid.OSU_UNIT_ASSOCIATION (
                id BIGINT NOT NULL,
                associationTypeId INTEGER NOT NULL,
                parentUnitId BIGINT NOT NULL,
                childUnitId BIGINT NOT NULL,
                parentUnitTypeId BIGINT NOT NULL,
                childUnitTypeId INTEGER NOT NULL,
                createDate TIMESTAMP NOT NULL,
                modifyDate TIMESTAMP,
                CONSTRAINT osu_unit_association_pk PRIMARY KEY (id, associationTypeId)
);


CREATE TABLE sid.OSU_UNIT (
                id BIGINT NOT NULL,
                unitTypeId INTEGER NOT NULL,
                sourceId SMALLINT NOT NULL,
                statusId SMALLINT NOT NULL,
                unitClassificationId SMALLINT,
                sourceSystemKeys VARCHAR(800) NOT NULL,
                shortTitle VARCHAR(100),
                longTitle VARCHAR(255) NOT NULL,
                description VARCHAR(255),
                cmsUnitCode VARCHAR(255) NOT NULL,
                lockId SMALLINT NOT NULL,
                createDate TIMESTAMP NOT NULL,
                modifyDate TIMESTAMP,
                CONSTRAINT osu_unit_pk PRIMARY KEY (id)
);


CREATE TABLE sid.OSU_USER_ROLE (
                id INTEGER NOT NULL,
                targetSystemId SMALLINT NOT NULL,
                roleName VARCHAR(255) NOT NULL,
                externalSystemRoleId INTEGER,
                defaultRole SMALLINT NOT NULL,
                canEnroll SMALLINT NOT NULL,
                createDate TIMESTAMP NOT NULL,
                modifyDate TIMESTAMP,
                rank INTEGER,
                sourceRoleName VARCHAR(50),
                sourceId SMALLINT,
                targetSystemRoleValue INTEGER,
                CONSTRAINT osu_user_role_pk PRIMARY KEY (id)
);


CREATE TABLE sid.OSU_SECTION (
                id BIGINT NOT NULL,
                yearQuarterCode VARCHAR(50) NOT NULL,
                checkDigit CHAR(10) NOT NULL,
                callNumber VARCHAR(50) NOT NULL,
                gradeAuthority SMALLINT NOT NULL,
                instructor VARCHAR(255),
                building VARCHAR(50),
                room VARCHAR(50),
                startTime VARCHAR(50),
                endTime VARCHAR(50),
                CONSTRAINT osu_section_pk PRIMARY KEY (id)
);


CREATE TABLE sid.OSU_TERM_CODE (
                termCode VARCHAR(50) NOT NULL,
                unitClassificationId SMALLINT NOT NULL,
                cmsUnitCode VARCHAR(50) NOT NULL,
                shortTitle VARCHAR(50) NOT NULL,
                description VARCHAR(50),
                active SMALLINT NOT NULL,
                createDate TIMESTAMP NOT NULL,
                modifyDate TIMESTAMP,
                startDate TIMESTAMP,
                endDate TIMESTAMP,
                CONSTRAINT osu_term_code_pk PRIMARY KEY (termCode)
);


CREATE TABLE sid.OSU_OFFERING (
                id BIGINT NOT NULL,
                yearQuarterCode VARCHAR(50) NOT NULL,
                campusId VARCHAR(50) NOT NULL,
                instructorOfRecord VARCHAR(255),
                courseNumber VARCHAR(10) NOT NULL,
                departmentNumber VARCHAR(50) NOT NULL,
                callNumber VARCHAR(50) NOT NULL,
                filePath VARCHAR(255) NOT NULL,
                CONSTRAINT osu_offering_pk PRIMARY KEY (id)
);


CREATE TABLE sid.OSU_UNIT_ENROLLMENT (
                id BIGINT NOT NULL,
                userId BIGINT NOT NULL,
                roleId INTEGER NOT NULL,
                unitId BIGINT NOT NULL,
                sourceId SMALLINT NOT NULL,
                statusId SMALLINT NOT NULL,
                enrollmentType VARCHAR(50) NOT NULL,
                lockId SMALLINT NOT NULL,
                reviewDate TIMESTAMP,
                createDate TIMESTAMP NOT NULL,
                modifyDate TIMESTAMP,
                CONSTRAINT osu_unit_enrollment_pk PRIMARY KEY (id)
);


CREATE TABLE sid.OSU_COURSE (
                id BIGINT NOT NULL,
                departmentNumber VARCHAR(50) NOT NULL,
                courseNumber VARCHAR(10) NOT NULL,
                yearQuarterCode VARCHAR(50) NOT NULL,
                path VARCHAR(255) NOT NULL,
                CONSTRAINT osu_course_pk PRIMARY KEY (id)
);


CREATE TABLE sid.PS_BLDG_TBL (
                BLDG_CD VARCHAR(10) NOT NULL,
                EFFDT TIMESTAMP NOT NULL,
                EFF_STATUS VARCHAR(1) NOT NULL,
                DESCR VARCHAR(30) NOT NULL,
                DESCRSHORT VARCHAR(10) NOT NULL
);


CREATE TABLE sid.OSU_DEPARTMENT (
                id BIGINT NOT NULL,
                abbreviation VARCHAR(50) NOT NULL,
                odsDepartmentNumber VARCHAR(255) NOT NULL,
                fiscalNumber VARCHAR(50),
                Defunct SMALLINT,
                CONSTRAINT osu_department_pk PRIMARY KEY (id)
);

CREATE TABLE sid.OSU_COLLEGE (
                id BIGINT NOT NULL,
                dean VARCHAR(50) NOT NULL,
                mainOffice VARCHAR(50) NOT NULL,
                abbreviation VARCHAR(50) NOT NULL,
                CONSTRAINT osu_college_pk PRIMARY KEY (id)
);




CREATE TABLE sid.matvw_unit_association (
                unit_association_type_id INTEGER NOT NULL,
                unit_association_type_name VARCHAR(255) NOT NULL,
                parent_type_name VARCHAR(50) NOT NULL,
                parentunitid BIGINT NOT NULL,
                child_type_name VARCHAR(50) NOT NULL,
                childunitid BIGINT NOT NULL
);


CREATE INDEX matvw_unit_association_typename_idx
 ON sid.matvw_unit_association
 ( unit_association_type_name );

CREATE INDEX matvw_unit_association_parentunitid_idx
 ON sid.matvw_unit_association
 ( parentunitid );

CREATE INDEX matvw_unit_association_childunitid_idx
 ON sid.matvw_unit_association
 ( childunitid );

CREATE INDEX osu_course_altkey_idx
 ON sid.OSU_COURSE
 ( departmentNumber, courseNumber, yearQuarterCode );

 
CREATE INDEX acad_departments_abbreviation_idx
 ON kmdata.acad_departments
 ( abbreviation );

CREATE INDEX acad_departments_dept_code_idx
 ON kmdata.acad_departments
 ( dept_code );

CREATE INDEX courses_acad_department_id_idx
 ON kmdata.courses
 ( acad_department_id );


ALTER TABLE kmdata.offerings ADD COLUMN offering_name VARCHAR(500) NOT NULL;

ALTER TABLE kmdata.sections ADD COLUMN section_name VARCHAR(500) NOT NULL;

ALTER TABLE kmdata.courses DROP COLUMN year_term_code;

-- move in ror.vw_Buildings
-- update ror.vw_PersonAppointments
-- move in new Course schema views in ror




CREATE TABLE sid.PS_SUBJECT_TBL (
                institution VARCHAR(5),
                subject VARCHAR(25),
                effdt TIMESTAMP,
                src_sys_id VARCHAR(5),
                eff_status VARCHAR(1),
                descr VARCHAR(30),
                descrshort VARCHAR(10),
                acad_org VARCHAR(10),
                split_owner VARCHAR(1),
                ext_subject_area VARCHAR(4),
                cip_code VARCHAR(13),
                hegis_code VARCHAR(8),
                descrformal VARCHAR(50),
                use_blind_grading VARCHAR(1),
                study_field VARCHAR(10),
                load_error VARCHAR(1),
                data_origin VARCHAR(1),
                created_ew_dttm TIMESTAMP,
                lastupd_ew_dttm TIMESTAMP,
                batch_sid NUMERIC(10)
);

CREATE SEQUENCE kmdata.subjects_id_seq;

CREATE TABLE kmdata.subjects (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.subjects_id_seq'),
                subject_name VARCHAR(30),
                subject_abbrev VARCHAR(25),
                acad_org VARCHAR(10),
                cip_code VARCHAR(13),
                formal_descr VARCHAR(50),
                CONSTRAINT subjects_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.subjects_id_seq OWNED BY kmdata.subjects.id;

ALTER TABLE kmdata.subjects ADD COLUMN resource_id BIGINT NOT NULL;

ALTER TABLE kmdata.subjects ADD CONSTRAINT resources_subjects_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


ALTER TABLE kmdata.courses ADD COLUMN subject_id BIGINT NOT NULL;
ALTER TABLE kmdata.courses ADD COLUMN active SMALLINT DEFAULT 1 NOT NULL;
ALTER TABLE kmdata.courses DROP COLUMN path;
ALTER TABLE kmdata.courses DROP COLUMN acad_department_id;


ALTER TABLE sid.OSU_COURSE ADD COLUMN descr VARCHAR(30);
ALTER TABLE sid.OSU_COURSE ADD COLUMN course_title_long VARCHAR(100);

ALTER TABLE kmdata.courses ADD COLUMN course_name_abbrev VARCHAR(30);

ALTER TABLE kmdata.offerings DROP COLUMN call_number;
ALTER TABLE kmdata.offerings DROP COLUMN year_term_code;
ALTER TABLE kmdata.offerings ADD COLUMN term_session_id BIGINT NOT NULL;
ALTER TABLE kmdata.offerings ADD COLUMN acad_department_id BIGINT NOT NULL;

ALTER TABLE kmdata.campuses ADD COLUMN ps_location_name VARCHAR(10);
-- AND COPY DATA FROM ABOVE

ALTER TABLE kmdata.offerings ALTER COLUMN offering_name DROP NOT NULL;

DROP TABLE sid.osu_section;
CREATE TABLE sid.OSU_SECTION (
                yearQuarterCode VARCHAR(50) NOT NULL,
                checkDigit CHAR(10) NOT NULL,
                callNumber VARCHAR(50) NOT NULL,
                gradeAuthority SMALLINT NOT NULL,
                instructor VARCHAR(255),
                building VARCHAR(50),
                room VARCHAR(50),
                startTime VARCHAR(50),
                endTime VARCHAR(50),
                offeringYearQuarterCode VARCHAR(50),
                offeringCallNumber VARCHAR(50),
                campusId VARCHAR(50),
                departmentNumber VARCHAR(50),
                courseNumber VARCHAR(10),
                session_code VARCHAR(3),
                acad_group VARCHAR(5),
                acad_org VARCHAR(10),
                mon VARCHAR(1),
                tues VARCHAR(1),
                wed VARCHAR(1),
                thurs VARCHAR(1),
                fri VARCHAR(1),
                sat VARCHAR(1),
                sun VARCHAR(1),
                start_dt TIMESTAMP,
                end_dt TIMESTAMP,
                meeting_time_start TIMESTAMP,
                meeting_time_end TIMESTAMP,
                facility_id VARCHAR(10),
                mtg_pat_crse_id VARCHAR(6)
);
COMMENT ON COLUMN sid.OSU_SECTION.mtg_pat_crse_id IS 'If this is null then there is no meeting pattern.';


CREATE INDEX osu_section_altkey1_idx
 ON sid.OSU_SECTION
 ( yearQuarterCode, callNumber, campusId, departmentNumber, courseNumber, session_code, acad_group, acad_org );


ALTER TABLE kmdata.section_weekly_mtgs ALTER COLUMN day_of_wk_cd_id DROP NOT NULL;

ALTER TABLE kmdata.sections DROP COLUMN call_number;
ALTER TABLE kmdata.sections DROP COLUMN term_id;
ALTER TABLE kmdata.sections ADD COLUMN class_number VARCHAR(50) NOT NULL;
ALTER TABLE kmdata.sections ADD COLUMN section_type VARCHAR(10);
ALTER TABLE kmdata.sections ADD COLUMN parent_section_id BIGINT;

ALTER TABLE kmdata.sections ALTER COLUMN section_name DROP NOT NULL;

ALTER TABLE kmdata.section_weekly_mtgs ALTER COLUMN start_time DROP NOT NULL;
ALTER TABLE kmdata.section_weekly_mtgs ALTER COLUMN end_time DROP NOT NULL;
ALTER TABLE kmdata.section_weekly_mtgs ALTER COLUMN room_no DROP NOT NULL;

ALTER TABLE sid.OSU_OFFERING ADD COLUMN acad_org VARCHAR(10);

ALTER TABLE kmdata.enrollments ALTER COLUMN career_id DROP NOT NULL;



DROP TABLE sid.OSU_UNIT_ENROLLMENT;


CREATE TABLE sid.OSU_UNIT_ENROLLMENT (
                userId BIGINT NOT NULL,
                yearQuarterCode VARCHAR(50),
                callNumber VARCHAR(50),
                campusId VARCHAR(50),
                departmentNumber VARCHAR(50),
                courseNumber VARCHAR(10),
                session_code VARCHAR(3),
                acad_group VARCHAR(5),
                acad_org VARCHAR(10),
                emplid VARCHAR(255),
                instr_role VARCHAR(4)
);


CREATE INDEX osu_unit_enrollment_sect_idx
 ON sid.OSU_UNIT_ENROLLMENT
 ( yearQuarterCode, callNumber, campusId, departmentNumber, courseNumber, session_code, acad_group, acad_org, emplid, instr_role );


--ALTER TABLE sid.OSU_UNIT_ENROLLMENT DROP COLUMN id;

ALTER TABLE kmdata.enrollment_roles ADD COLUMN rank INTEGER;

INSERT INTO kmdata.enrollment_roles
   (id, name, rank)
SELECT id, rolename, rank
  FROM sid.osu_user_role;
  

ALTER TABLE kmdata.section_weekly_mtgs ALTER COLUMN building_id DROP NOT NULL;



-- 'SI' -> 'Secondary Instructor', 
-- 'PI' -> 'Primary Instructor', 
-- 'GR' -> 'Grader',
-- 'GS' -> 'Guest Speaker',
-- 'TA' -> 'Teaching Assistant', 
-- 'LA' -> 'Lab Assistant', 

ALTER TABLE kmdata.enrollments ALTER COLUMN role_id DROP NOT NULL;

ALTER TABLE kmdata.enrollment_roles ADD COLUMN role_code VARCHAR(4);

UPDATE kmdata.enrollments SET role_id = NULL;

DELETE FROM kmdata.enrollment_roles;

INSERT INTO kmdata.enrollment_roles (id, name, rank, role_code) VALUES (1, 'Primary Instructor', 12, 'PI');
INSERT INTO kmdata.enrollment_roles (id, name, rank, role_code) VALUES (2, 'Secondary Instructor', 10, 'SI');
INSERT INTO kmdata.enrollment_roles (id, name, rank, role_code) VALUES (3, 'Teaching Assistant', 8, 'TA');
INSERT INTO kmdata.enrollment_roles (id, name, rank, role_code) VALUES (4, 'Lab Assistant', 6, 'LA');
INSERT INTO kmdata.enrollment_roles (id, name, rank, role_code) VALUES (5, 'Grader', 4, 'GR');
INSERT INTO kmdata.enrollment_roles (id, name, rank, role_code) VALUES (6, 'Guest Speaker', 2, 'GS');

-- TRUNCATE TABLE kmdata.enrollments

ALTER TABLE kmdata.enrollments ALTER COLUMN role_id SET NOT NULL;


-- Changes to kmdata.section_weekly_mtgs
DROP INDEX kmdata.section_weekly_mtgs_idx;
ALTER TABLE kmdata.section_weekly_mtgs DROP COLUMN day_of_wk_cd_id;
ALTER TABLE kmdata.section_weekly_mtgs ADD COLUMN days_of_week VARCHAR(7);
ALTER TABLE kmdata.section_weekly_mtgs ADD COLUMN start_date TIMESTAMP;
ALTER TABLE kmdata.section_weekly_mtgs ADD COLUMN end_date TIMESTAMP;


--CHECK TO MAKE SURE THAT CAMPUSES HAS THE ps_location_name

ALTER TABLE researchinview.activity_import_log ADD COLUMN is_active SMALLINT DEFAULT 1 NOT NULL;



-- Bar Admission, Community Partner, University Partner

CREATE SEQUENCE kmdata.bar_admission_id_seq;

CREATE TABLE kmdata.bar_admission (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.bar_admission_id_seq'),
                user_id BIGINT NOT NULL,
                active VARCHAR(255),
                admitted_on_dmy_single_date_id BIGINT,
                country VARCHAR(500),
                state VARCHAR(255),
                resource_id BIGINT NOT NULL,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT bar_admission_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.bar_admission_id_seq OWNED BY kmdata.bar_admission.id;

ALTER TABLE kmdata.bar_admission ADD CONSTRAINT dmy_single_dates_bar_admission_fk
FOREIGN KEY (admitted_on_dmy_single_date_id)
REFERENCES kmdata.dmy_single_dates (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.bar_admission ADD CONSTRAINT resources_bar_admission_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.bar_admission ADD CONSTRAINT users_bar_admission_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

CREATE SEQUENCE kmdata.community_partner_id_seq;

CREATE TABLE kmdata.community_partner (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.community_partner_id_seq'),
                user_id BIGINT NOT NULL,
                title VARCHAR(2000),
                organization VARCHAR(500),
                contact_within_organization VARCHAR(1000),
                description_of_role VARCHAR(2000),
                city VARCHAR(500),
                state VARCHAR(255),
                country VARCHAR(500),
                url VARCHAR(500),
                resource_id BIGINT NOT NULL,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT community_partner_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.community_partner_id_seq OWNED BY kmdata.community_partner.id;

ALTER TABLE kmdata.community_partner ADD CONSTRAINT resources_community_partner_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.community_partner ADD CONSTRAINT users_community_partner_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

CREATE SEQUENCE kmdata.university_partner_id_seq;

CREATE TABLE kmdata.university_partner (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.university_partner_id_seq'),
                user_id BIGINT NOT NULL,
                partner_user_id BIGINT NOT NULL,
                description_of_role VARCHAR(2000),
                resource_id BIGINT NOT NULL,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT university_partner_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.university_partner_id_seq OWNED BY kmdata.university_partner.id;

ALTER TABLE kmdata.university_partner ADD CONSTRAINT resources_university_partner_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.university_partner ADD CONSTRAINT users_university_partner_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.university_partner ADD CONSTRAINT users_university_partner_fk1
FOREIGN KEY (partner_user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- grants on new tables

GRANT ALL ON TABLE kmdata.bar_admission TO kmdata;
GRANT SELECT ON TABLE kmdata.bar_admission TO ceti;
GRANT SELECT ON TABLE kmdata.bar_admission TO kmd_riv_tr_import_user;
GRANT SELECT ON TABLE kmdata.bar_admission TO kmd_dev_riv_user;
--GRANT SELECT ON TABLE kmdata.bar_admission TO kmd_report_user;

GRANT ALL ON TABLE kmdata.community_partner TO kmdata;
GRANT SELECT ON TABLE kmdata.community_partner TO ceti;
GRANT SELECT ON TABLE kmdata.community_partner TO kmd_riv_tr_import_user;
GRANT SELECT ON TABLE kmdata.community_partner TO kmd_dev_riv_user;
--GRANT SELECT ON TABLE kmdata.community_partner TO kmd_report_user;

GRANT ALL ON TABLE kmdata.university_partner TO kmdata;
GRANT SELECT ON TABLE kmdata.university_partner TO ceti;
GRANT SELECT ON TABLE kmdata.university_partner TO kmd_riv_tr_import_user;
GRANT SELECT ON TABLE kmdata.university_partner TO kmd_dev_riv_user;
--GRANT SELECT ON TABLE kmdata.university_partner TO kmd_report_user;





CREATE SEQUENCE kmdata.outreach_id_seq;

CREATE TABLE kmdata.outreach (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.outreach_id_seq'),
                work_id BIGINT NOT NULL,
                title VARCHAR(255),
                url VARCHAR(255),
                description TEXT,
                success TEXT,
                outcome TEXT,
                people_served INTEGER,
                hours NUMERIC(9,2),
                direct_cost NUMERIC(9,2),
                other_audience VARCHAR(255),
                other_result VARCHAR(255),
                other_subject VARCHAR(255),
                output_text TEXT,
                outreach_start_year INTEGER,
                outreach_start_month INTEGER,
                outreach_start_day INTEGER,
                outreach_end_year INTEGER,
                outreach_end_month INTEGER,
                outreach_end_day INTEGER,
                CONSTRAINT outreach_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.outreach_id_seq OWNED BY kmdata.outreach.id;

ALTER TABLE kmdata.outreach ADD CONSTRAINT works_outreach_fk
FOREIGN KEY (work_id)
REFERENCES kmdata.works (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

GRANT ALL ON TABLE kmdata.outreach TO kmdata;
GRANT SELECT ON TABLE kmdata.outreach TO ceti;
GRANT SELECT ON TABLE kmdata.outreach TO kmd_riv_tr_import_user;
GRANT SELECT ON TABLE kmdata.outreach TO kmd_dev_riv_user;
--GRANT SELECT ON TABLE kmdata.outreach TO kmd_report_user;



ALTER TABLE kmdata.works ADD COLUMN created_by VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN original_publication_type VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN issuing_organization VARCHAR(500);
ALTER TABLE kmdata.works ADD COLUMN type_of_activity VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN type_of_activity_other VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN frequency_of_publication VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN frequency_of_publication_other VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN posted_on_dmy_single_date_id BIGINT;
ALTER TABLE kmdata.works ADD COLUMN title_of_weblog VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN enacted VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN enacted_on_dmy_single_date_id BIGINT;
ALTER TABLE kmdata.works ADD COLUMN legal_number VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN is_review VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN reviewed_subject VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN series_ended_on_dmy_single_date_id BIGINT;
ALTER TABLE kmdata.works ADD COLUMN series_frequency VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN series_frequency_other VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN series_ongoing VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN series_started_on_dmy_single_date_id BIGINT;
ALTER TABLE kmdata.works ADD COLUMN single_or_series INTEGER;

-- 4 foreign keys
ALTER TABLE kmdata.works ADD CONSTRAINT dmy_single_dates_works_fk9
FOREIGN KEY (posted_on_dmy_single_date_id)
REFERENCES kmdata.dmy_single_dates (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.works ADD CONSTRAINT dmy_single_dates_works_fk10
FOREIGN KEY (enacted_on_dmy_single_date_id)
REFERENCES kmdata.dmy_single_dates (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.works ADD CONSTRAINT dmy_single_dates_works_fk11
FOREIGN KEY (series_ended_on_dmy_single_date_id)
REFERENCES kmdata.dmy_single_dates (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.works ADD CONSTRAINT dmy_single_dates_works_fk12
FOREIGN KEY (series_started_on_dmy_single_date_id)
REFERENCES kmdata.dmy_single_dates (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;



ALTER TABLE kmdata.outreach ADD COLUMN academic_calendar VARCHAR(255);
ALTER TABLE kmdata.outreach ADD COLUMN academic_calendar_other VARCHAR(255);
ALTER TABLE kmdata.outreach ADD COLUMN countries VARCHAR(2000);
ALTER TABLE kmdata.outreach ADD COLUMN currency VARCHAR(255);
ALTER TABLE kmdata.outreach ADD COLUMN included_activities VARCHAR(2000);
ALTER TABLE kmdata.outreach ADD COLUMN initiative VARCHAR(255);
ALTER TABLE kmdata.outreach ADD COLUMN initiative_type VARCHAR(255);
ALTER TABLE kmdata.outreach ADD COLUMN ongoing VARCHAR(255);
ALTER TABLE kmdata.outreach ADD COLUMN organization_id INTEGER;
ALTER TABLE kmdata.outreach ADD COLUMN percent_effort INTEGER;
ALTER TABLE kmdata.outreach ADD COLUMN timeframes_offered VARCHAR(255);
ALTER TABLE kmdata.outreach ADD COLUMN timeframes_offered_other VARCHAR(255);
ALTER TABLE kmdata.outreach ADD COLUMN total_hours INTEGER;


-- kmdata outreach changes per Joan 12/4/2012
ALTER TABLE kmdata.outreach DROP COLUMN work_id;
ALTER TABLE kmdata.outreach ADD COLUMN resource_id BIGINT NOT NULL;

ALTER TABLE kmdata.outreach ADD CONSTRAINT resources_outreach_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;



CREATE SEQUENCE kmdata.outreach_users_id_seq;

CREATE TABLE kmdata.outreach_users (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.outreach_users_id_seq'),
                outreach_id BIGINT NOT NULL,
                user_id BIGINT NOT NULL,
                CONSTRAINT outreach_users_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.outreach_users_id_seq OWNED BY kmdata.outreach_users.id;

ALTER TABLE kmdata.outreach_users ADD CONSTRAINT outreach_outreach_users_fk
FOREIGN KEY (outreach_id)
REFERENCES kmdata.outreach (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.outreach_users ADD CONSTRAINT users_outreach_users_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


ALTER TABLE kmdata.advising ALTER COLUMN institution_id DROP NOT NULL;


ALTER TABLE kmdata.works ADD COLUMN extended_author_list VARCHAR(4000);



-- Joan's changes per 12/10/2012
ALTER TABLE kmdata.outreach ADD COLUMN created_at TIMESTAMP NOT NULL;
ALTER TABLE kmdata.outreach ADD COLUMN updated_at TIMESTAMP NOT NULL;
ALTER TABLE kmdata.advising ALTER COLUMN institution_id DROP NOT NULL;
alter table kmdata.user_services alter column institution_id drop not null;
alter table kmdata.professional_activity alter column activity_name type varchar(1000);
alter table kmdata.courses_taught_other alter column institution_id drop not null;
alter table kmdata.courses_taught alter column institution_id drop not null;
alter table kmdata.courses_taught alter column title type varchar(1000);
alter table kmdata.user_languages alter column writing_proficiency drop not null;
alter table kmdata.user_languages alter column reading_proficiency drop not null;
alter table kmdata.user_languages alter column speaking_proficiency drop not null;
alter table kmdata.degree_certifications alter column npi type varchar(1000);
alter table kmdata.degree_certifications alter column upin type varchar(1000);
alter table kmdata.degree_certifications alter column medicaid type varchar(1000);
-- add new column extended_author_list --> this is addressed above
alter table kmdata.user_preferred_names alter column email type varchar(1000);
ALTER TABLE kmdata.strategic_initiatives ALTER COLUMN institution_id DROP NOT NULL;



-- Joan's changes per 12/17/2012
ALTER TABLE kmdata.works ADD COLUMN report_number VARCHAR(255);

ALTER TABLE kmdata.advising ADD COLUMN accomplishments VARCHAR(255);
ALTER TABLE kmdata.advising ADD COLUMN accomplishments_other VARCHAR(2000);
ALTER TABLE kmdata.advising ADD COLUMN advisee_advisor_codepartment VARCHAR(255);
ALTER TABLE kmdata.advising ADD COLUMN ongoing VARCHAR(255);
ALTER TABLE kmdata.advising ADD COLUMN major VARCHAR(255);
ALTER TABLE kmdata.advising ADD COLUMN minor VARCHAR(255);
ALTER TABLE kmdata.advising ADD COLUMN university_id VARCHAR(255);
ALTER TABLE kmdata.advising ADD COLUMN current_position_other VARCHAR(255);
ALTER TABLE kmdata.advising ADD COLUMN student_id BIGINT;


-- Joan's changes per 12/18/2012
ALTER TABLE kmdata.strategic_initiatives ADD COLUMN activity_other VARCHAR(255);
ALTER TABLE kmdata.strategic_initiatives ADD COLUMN institution_group_other VARCHAR(255);
ALTER TABLE kmdata.strategic_initiatives ADD COLUMN integration_group_id VARCHAR(255);
ALTER TABLE kmdata.strategic_initiatives ADD COLUMN url VARCHAR(2000);
ALTER TABLE kmdata.strategic_initiatives ADD COLUMN ended_on VARCHAR(255);
ALTER TABLE kmdata.strategic_initiatives ADD COLUMN started_on VARCHAR(255);
ALTER TABLE kmdata.strategic_initiatives ADD COLUMN role_other VARCHAR(255);



-- John W's group change 12/18/2012
ALTER TABLE kmdata.groups ADD COLUMN inst_group_code VARCHAR(255);

ALTER TABLE kmdata.membership ADD COLUMN ongoing VARCHAR(255);
ALTER TABLE kmdata.membership ADD COLUMN organization_id INTEGER;
ALTER TABLE kmdata.works ADD COLUMN reach_of_conference VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN session_name VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN speaker_name VARCHAR(2000);

-- Joan's changes 12/20/2012
ALTER TABLE kmdata.user_preferred_names ADD COLUMN additional_citizenship VARCHAR(255);
ALTER TABLE kmdata.user_preferred_names ADD COLUMN citizenship VARCHAR(255);
ALTER TABLE kmdata.user_preferred_names ADD COLUMN gender VARCHAR(255);
ALTER TABLE kmdata.user_preferred_names ADD COLUMN nih_era_commons_name VARCHAR(255);
ALTER TABLE kmdata.user_preferred_names ADD COLUMN opted_out_of_researcher_id_setup INTEGER;
ALTER TABLE kmdata.user_preferred_names ADD COLUMN previously_used_email_addressess VARCHAR(2000);
ALTER TABLE kmdata.user_preferred_names ADD COLUMN researcher_id VARCHAR(255);
ALTER TABLE kmdata.user_preferred_names ADD COLUMN researcher_id_email_address VARCHAR(255);
ALTER TABLE kmdata.user_preferred_names ADD COLUMN sync_with_researcher_id VARCHAR(255);

ALTER TABLE kmdata.works ADD COLUMN application_number VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN attorney_agent VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN patent_assignee VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN patent_class VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN document_number VARCHAR(255);

ALTER TABLE kmdata.works ADD COLUMN producer VARCHAR(255);

ALTER TABLE kmdata.degree_certifications ADD COLUMN active VARCHAR(255);


-- Joan's changes 12/21/2012
ALTER TABLE kmdata.grant_data ADD COLUMN appl_id INTEGER;
ALTER TABLE kmdata.grant_data ADD COLUMN ongoing VARCHAR(255);

ALTER TABLE kmdata.courses_taught ADD COLUMN academic_calendar VARCHAR(255);
ALTER TABLE kmdata.courses_taught ADD COLUMN academic_calendar_other VARCHAR(255);
ALTER TABLE kmdata.courses_taught ADD COLUMN frequency VARCHAR(255);
ALTER TABLE kmdata.courses_taught ADD COLUMN institution_group_other VARCHAR(255);
ALTER TABLE kmdata.courses_taught ADD COLUMN integration_group_id VARCHAR(255);
ALTER TABLE kmdata.courses_taught ADD COLUMN number_of_times INTEGER;
ALTER TABLE kmdata.courses_taught ADD COLUMN period_offered_other VARCHAR(255);
ALTER TABLE kmdata.courses_taught ADD COLUMN subject_area VARCHAR(255);
ALTER TABLE kmdata.courses_taught ADD COLUMN ended_on VARCHAR(255);

ALTER TABLE kmdata.courses_taught_other ADD COLUMN academic_calendar VARCHAR(255);
ALTER TABLE kmdata.courses_taught_other ADD COLUMN academic_calendar_other VARCHAR(255);
ALTER TABLE kmdata.courses_taught_other ADD COLUMN city VARCHAR(255);
ALTER TABLE kmdata.courses_taught_other ADD COLUMN country VARCHAR(255);
ALTER TABLE kmdata.courses_taught_other ADD COLUMN course_type VARCHAR(255);
ALTER TABLE kmdata.courses_taught_other ADD COLUMN institution_group_other VARCHAR(255);
ALTER TABLE kmdata.courses_taught_other ADD COLUMN integration_group_id VARCHAR(255);
ALTER TABLE kmdata.courses_taught_other ADD COLUMN number_of_times INTEGER;
ALTER TABLE kmdata.courses_taught_other ADD COLUMN peer_evaluated VARCHAR(255);
ALTER TABLE kmdata.courses_taught_other ADD COLUMN period_offered VARCHAR(255);
ALTER TABLE kmdata.courses_taught_other ADD COLUMN period_offered_other VARCHAR(255);
ALTER TABLE kmdata.courses_taught_other ADD COLUMN state_province VARCHAR(255);
ALTER TABLE kmdata.courses_taught_other ADD COLUMN subject_area VARCHAR(1000);

ALTER TABLE kmdata.professional_activity ADD COLUMN activity_category_other VARCHAR(255);
ALTER TABLE kmdata.professional_activity ADD COLUMN type_of_activity_other VARCHAR(255);

ALTER TABLE kmdata.works ADD COLUMN number_of_citations INTEGER;
ALTER TABLE kmdata.user_services ADD COLUMN percent_effort VARCHAR(255);
ALTER TABLE kmdata.user_services ADD COLUMN url VARCHAR(2000);




-- *********************************************************************************
-- NOTE:
-- kmdata.term and kmdata.term_session were manually populated for the current terms
-- *********************************************************************************

-- Table: sid.osu_offering

DROP TABLE sid.osu_offering;

CREATE TABLE sid.osu_offering
(
  yearquartercode character varying(50) NOT NULL,
  campusid character varying(50) NOT NULL,
  coursenumber character varying(10) NOT NULL,
  departmentnumber character varying(50) NOT NULL,
  session_code character varying(3),
  acad_group character varying(5),
  acad_org character varying(10)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE sid.osu_offering
  OWNER TO kmdata;


/*
SELECT 'UPDATE kmdata.colleges SET acad_group = '''||a.acad_group||''' WHERE abbreviation = '''||a.abbreviation||''';'
FROM kmdata.colleges a;
*/
  
UPDATE kmdata.colleges SET acad_group = 'ADM' WHERE abbreviation = 'Administra';
UPDATE kmdata.colleges SET acad_group = 'AGR' WHERE abbreviation = 'FAES';
UPDATE kmdata.colleges SET acad_group = 'AHR' WHERE abbreviation = 'Arch';
UPDATE kmdata.colleges SET acad_group = 'AMP' WHERE abbreviation = 'Allied Med';
UPDATE kmdata.colleges SET acad_group = 'ART' WHERE abbreviation = 'The Arts';
UPDATE kmdata.colleges SET acad_group = 'ASC' WHERE abbreviation = 'Arts&Sci';
UPDATE kmdata.colleges SET acad_group = 'ATI' WHERE abbreviation = 'AgrTchInst';
UPDATE kmdata.colleges SET acad_group = 'BIO' WHERE abbreviation = 'Bio Sci';
UPDATE kmdata.colleges SET acad_group = 'BUS' WHERE abbreviation = 'Business';
UPDATE kmdata.colleges SET acad_group = 'CED' WHERE abbreviation = 'Cont Educ';
UPDATE kmdata.colleges SET acad_group = 'CMN' WHERE abbreviation = 'Comm';
UPDATE kmdata.colleges SET acad_group = 'DEN' WHERE abbreviation = 'Dentistry';
UPDATE kmdata.colleges SET acad_group = 'DHY' WHERE abbreviation = 'Dental Hyg';
UPDATE kmdata.colleges SET acad_group = 'EDU' WHERE abbreviation = 'Education';
UPDATE kmdata.colleges SET acad_group = 'EHE' WHERE abbreviation = 'EDU & HEC';
UPDATE kmdata.colleges SET acad_group = 'ENG' WHERE abbreviation = 'Eng';
UPDATE kmdata.colleges SET acad_group = 'ENR' WHERE abbreviation = 'Env&NatRe';
UPDATE kmdata.colleges SET acad_group = 'ESC' WHERE abbreviation = 'Earth Sci';
UPDATE kmdata.colleges SET acad_group = 'EXP' WHERE abbreviation = 'Explore';
UPDATE kmdata.colleges SET acad_group = 'GRD' WHERE abbreviation = 'Grad Schl';
UPDATE kmdata.colleges SET acad_group = 'HEC' WHERE abbreviation = 'Human Ecol';
UPDATE kmdata.colleges SET acad_group = 'HRS' WHERE abbreviation = 'HlthRhbtSc';
UPDATE kmdata.colleges SET acad_group = 'HUM' WHERE abbreviation = 'Humanities';
UPDATE kmdata.colleges SET acad_group = 'JGS' WHERE abbreviation = 'JG Pub Aff';
UPDATE kmdata.colleges SET acad_group = 'JUR' WHERE abbreviation = 'Journalism';
UPDATE kmdata.colleges SET acad_group = 'LAW' WHERE abbreviation = 'Law';
UPDATE kmdata.colleges SET acad_group = 'MED' WHERE abbreviation = 'Medicine';
UPDATE kmdata.colleges SET acad_group = 'MPS' WHERE abbreviation = 'Math&PhySc';
UPDATE kmdata.colleges SET acad_group = 'MUS' WHERE abbreviation = 'Music';
UPDATE kmdata.colleges SET acad_group = 'NRE' WHERE abbreviation = 'Natural Re';
UPDATE kmdata.colleges SET acad_group = 'NUR' WHERE abbreviation = 'Nursing';
UPDATE kmdata.colleges SET acad_group = 'OAA' WHERE abbreviation = 'Acad Affrs';
UPDATE kmdata.colleges SET acad_group = 'OPS' WHERE abbreviation = 'OPS';
UPDATE kmdata.colleges SET acad_group = 'OPT' WHERE abbreviation = 'Optometry';
UPDATE kmdata.colleges SET acad_group = 'PBH' WHERE abbreviation = 'PublicHlth';
UPDATE kmdata.colleges SET acad_group = 'PHP34' WHERE abbreviation = 'Pharm 3&4';
UPDATE kmdata.colleges SET acad_group = 'PHR' WHERE abbreviation = 'Pharmacy';
UPDATE kmdata.colleges SET acad_group = 'SBS' WHERE abbreviation = 'Soc&BhvSci';
UPDATE kmdata.colleges SET acad_group = 'SWK' WHERE abbreviation = 'SocialWork';
UPDATE kmdata.colleges SET acad_group = 'USS' WHERE abbreviation = 'UgStuAcaSv';
UPDATE kmdata.colleges SET acad_group = 'UVC' WHERE abbreviation = 'UVC';
UPDATE kmdata.colleges SET acad_group = 'VME' WHERE abbreviation = 'Vet Med';

