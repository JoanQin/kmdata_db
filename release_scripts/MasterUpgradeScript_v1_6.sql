-- MasterUpdgradeScript_v1_6

/*  ********************************************************
    * New index for works text match on titles             *
		title
		journal_title
		event_title
		publication_title
		title_in
		exhibit_title
		episode_title
		book_title
    ********************************************************  */

-- original: 118MB
-- after:    149MB


-- Note: ALREADY ADDED ON PROD BEGIN
CREATE INDEX works_title_text_idx
  ON kmdata.works
  USING gin
  (to_tsvector('english', title));

CREATE INDEX works_journal_title_text_idx
  ON kmdata.works
  USING gin
  (to_tsvector('english', journal_title));

CREATE INDEX works_event_title_text_idx
  ON kmdata.works
  USING gin
  (to_tsvector('english', event_title));

CREATE INDEX works_publication_title_text_idx
  ON kmdata.works
  USING gin
  (to_tsvector('english', publication_title));

CREATE INDEX works_title_in_text_idx
  ON kmdata.works
  USING gin
  (to_tsvector('english', title_in));

CREATE INDEX works_exhibit_title_text_idx
  ON kmdata.works
  USING gin
  (to_tsvector('english', exhibit_title));

CREATE INDEX works_episode_title_text_idx
  ON kmdata.works
  USING gin
  (to_tsvector('english', episode_title));

CREATE INDEX works_book_title_text_idx
  ON kmdata.works
  USING gin
  (to_tsvector('english', book_title));
-- Note: ALREADY ADDED ON PROD END


-- applied 7/11/12
ALTER TABLE kmdata.degree_types ADD COLUMN riv_id BIGINT;

--SELECT 'UPDATE kmdata.degree_types SET riv_id = ' || riv_id || ' WHERE id = ' || id || ';'
--FROM kmdata.degree_types
--WHERE riv_id IS NOT NULL
--ORDER BY riv_id;

-- applied 7/11/12
UPDATE kmdata.degree_types SET riv_id = 1 WHERE id = 11;
UPDATE kmdata.degree_types SET riv_id = 2 WHERE id = 32;
UPDATE kmdata.degree_types SET riv_id = 3 WHERE id = 104;
UPDATE kmdata.degree_types SET riv_id = 4 WHERE id = 79;
UPDATE kmdata.degree_types SET riv_id = 5 WHERE id = 255;
UPDATE kmdata.degree_types SET riv_id = 6 WHERE id = 308;
UPDATE kmdata.degree_types SET riv_id = 7 WHERE id = 86;
UPDATE kmdata.degree_types SET riv_id = 8 WHERE id = 81;
UPDATE kmdata.degree_types SET riv_id = 9 WHERE id = 60;
UPDATE kmdata.degree_types SET riv_id = 10 WHERE id = 61;
UPDATE kmdata.degree_types SET riv_id = 11 WHERE id = 82;
UPDATE kmdata.degree_types SET riv_id = 12 WHERE id = 278;
UPDATE kmdata.degree_types SET riv_id = 13 WHERE id = 69;
UPDATE kmdata.degree_types SET riv_id = 14 WHERE id = 66;
UPDATE kmdata.degree_types SET riv_id = 15 WHERE id = 182;
UPDATE kmdata.degree_types SET riv_id = 16 WHERE id = 72;
UPDATE kmdata.degree_types SET riv_id = 17 WHERE id = 75;
UPDATE kmdata.degree_types SET riv_id = 18 WHERE id = 83;
UPDATE kmdata.degree_types SET riv_id = 19 WHERE id = 155;
UPDATE kmdata.degree_types SET riv_id = 20 WHERE id = 84;
UPDATE kmdata.degree_types SET riv_id = 21 WHERE id = 297;
UPDATE kmdata.degree_types SET riv_id = 22 WHERE id = 269;
UPDATE kmdata.degree_types SET riv_id = 23 WHERE id = 254;
UPDATE kmdata.degree_types SET riv_id = 24 WHERE id = 1;


-- applied 7/11/12
ALTER TABLE kmdata.degree_certifications ALTER COLUMN institution_id DROP NOT NULL;



-- Groups Schema updates 7/26/2012

-- rename old groups tables to not conflict with the new schema names
ALTER TABLE kmdata.groups RENAME TO groups_legacy;
ALTER TABLE kmdata.group_categories RENAME TO group_categories_legacy;

-- create new groups schema objects into KMData core


CREATE SEQUENCE kmdata.groups_new_id_seq;

CREATE TABLE kmdata.groups (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.groups_new_id_seq'),
                name VARCHAR(255) NOT NULL,
                description TEXT,
                is_public BOOLEAN,
                CONSTRAINT groups_new_pk PRIMARY KEY (id)
);
--ALTER TABLE kmdata.groups RENAME COLUMN private TO is_public;

ALTER SEQUENCE kmdata.groups_new_id_seq OWNED BY kmdata.groups.id;


CREATE SEQUENCE kmdata.group_nestings_id_seq;

CREATE TABLE kmdata.group_nestings (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.group_nestings_id_seq'),
                parent_group_id BIGINT NOT NULL,
                child_group_id BIGINT NOT NULL,
                CONSTRAINT group_nestings_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.group_nestings_id_seq OWNED BY kmdata.group_nestings.id;

ALTER TABLE kmdata.group_nestings ADD CONSTRAINT groups_group_nestings_fk
FOREIGN KEY (parent_group_id)
REFERENCES kmdata.groups (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.group_nestings ADD CONSTRAINT groups_group_nestings_fk1
FOREIGN KEY (child_group_id)
REFERENCES kmdata.groups (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

CREATE SEQUENCE kmdata.group_categories_new_id_seq;

CREATE TABLE kmdata.group_categories (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.group_categories_new_id_seq'),
                name VARCHAR(255) NOT NULL,
                CONSTRAINT group_categories_new_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.group_categories_new_id_seq OWNED BY kmdata.group_categories.id;

CREATE SEQUENCE kmdata.group_categorizations_id_seq;

CREATE TABLE kmdata.group_categorizations (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.group_categorizations_id_seq'),
                group_id BIGINT NOT NULL,
                group_category_id BIGINT NOT NULL,
                CONSTRAINT group_categorizations_pk PRIMARY KEY (id)
);
--ALTER TABLE kmdata.group_categorizations RENAME COLUMN category_id TO group_category_id;

ALTER SEQUENCE kmdata.group_categorizations_id_seq OWNED BY kmdata.group_categorizations.id;

ALTER TABLE kmdata.group_categorizations ADD CONSTRAINT group_categories_group_categorizations_fk
FOREIGN KEY (category_id)
REFERENCES kmdata.group_categories (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.group_categorizations ADD CONSTRAINT groups_group_categorizations_fk
FOREIGN KEY (group_id)
REFERENCES kmdata.groups (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

CREATE SEQUENCE kmdata.group_properties_id_seq;

CREATE TABLE kmdata.group_properties (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.group_properties_id_seq'),
                name VARCHAR(255) NOT NULL,
                description TEXT,
                datatype VARCHAR(30) NOT NULL,
                CONSTRAINT group_properties_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.group_properties_id_seq OWNED BY kmdata.group_properties.id;

CREATE SEQUENCE kmdata.group_property_values_id_seq;

CREATE TABLE kmdata.group_property_values (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.group_property_values_id_seq'),
                group_id BIGINT NOT NULL,
                group_property_id BIGINT NOT NULL,
                boolean_value BOOLEAN,
                string_value VARCHAR(4000),
                integer_value BIGINT,
                CONSTRAINT group_property_values_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.group_property_values_id_seq OWNED BY kmdata.group_property_values.id;

ALTER TABLE kmdata.group_property_values ADD CONSTRAINT group_properties_group_property_values_fk
FOREIGN KEY (group_property_id)
REFERENCES kmdata.group_properties (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.group_property_values ADD CONSTRAINT groups_group_property_values_fk
FOREIGN KEY (group_id)
REFERENCES kmdata.groups (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

CREATE SEQUENCE kmdata.group_permissions_id_seq;

CREATE TABLE kmdata.group_permissions (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.group_permissions_id_seq'),
                group_id BIGINT NOT NULL,
                permission_set INTEGER,
                managing_group_id BIGINT NOT NULL,
                CONSTRAINT group_permissions_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.group_permissions_id_seq OWNED BY kmdata.group_permissions.id;

ALTER TABLE kmdata.group_permissions ADD CONSTRAINT groups_group_permissions_fk
FOREIGN KEY (group_id)
REFERENCES kmdata.groups (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.group_permissions ADD CONSTRAINT groups_group_permissions_fk1
FOREIGN KEY (managing_group_id)
REFERENCES kmdata.groups (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

CREATE SEQUENCE kmdata.group_memberships_id_seq;

CREATE TABLE kmdata.group_memberships (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.group_memberships_id_seq'),
                resource_id BIGINT NOT NULL,
                group_id BIGINT NOT NULL,
                CONSTRAINT group_memberships_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.group_memberships_id_seq OWNED BY kmdata.group_memberships.id;

ALTER TABLE kmdata.group_memberships ADD CONSTRAINT groups_group_memberships_fk
FOREIGN KEY (group_id)
REFERENCES kmdata.groups (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.group_memberships ADD CONSTRAINT resources_group_memberships_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

CREATE SEQUENCE kmdata.group_exclusions_id_seq;

CREATE TABLE kmdata.group_exclusions (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.group_exclusions_id_seq'),
                group_id BIGINT NOT NULL,
                resource_id BIGINT NOT NULL,
                CONSTRAINT group_exclusions_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.group_exclusions_id_seq OWNED BY kmdata.group_exclusions.id;

ALTER TABLE kmdata.group_exclusions ADD CONSTRAINT groups_group_exclusions_fk
FOREIGN KEY (group_category_id)
REFERENCES kmdata.groups (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.group_exclusions ADD CONSTRAINT resources_group_exclusions_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


-- add an populate the column for kmdata_tables view names
ALTER TABLE kmdata.kmdata_tables ADD COLUMN app_view_name VARCHAR(255);

-- grant update permissions to Rails application user
--select 'UPDATE kmdata.kmdata_tables SET app_view_name = ''' || app_view_name || ''' WHERE table_name = ''' || table_name || ''';' as SQLCommandText
--from kmdata.kmdata_tables;

UPDATE kmdata.kmdata_tables SET app_view_name = 'vw_People' WHERE table_name = 'users';
UPDATE kmdata.kmdata_tables SET app_view_name = 'vw_Works' WHERE table_name = 'works';
UPDATE kmdata.kmdata_tables SET app_view_name = 'vw_Narratives' WHERE table_name = 'narratives';
UPDATE kmdata.kmdata_tables SET app_view_name = 'vw_Institutions' WHERE table_name = 'institutions';
UPDATE kmdata.kmdata_tables SET app_view_name = 'vw_DegreeCertification' WHERE table_name = 'degree_certifications';
UPDATE kmdata.kmdata_tables SET app_view_name = 'vw_PersonServices' WHERE table_name = 'user_services';
UPDATE kmdata.kmdata_tables SET app_view_name = 'vw_PersonHonorsAwards' WHERE table_name = 'user_honors_awards';
UPDATE kmdata.kmdata_tables SET app_view_name = 'groups' WHERE table_name = 'groups';
UPDATE kmdata.kmdata_tables SET app_view_name = 'vw_PersonAddresses' WHERE table_name = 'user_addresses';
UPDATE kmdata.kmdata_tables SET app_view_name = 'vw_PersonPhones' WHERE table_name = 'user_phones';
UPDATE kmdata.kmdata_tables SET app_view_name = 'vw_PersonAppointments' WHERE table_name = 'user_appointments';
UPDATE kmdata.kmdata_tables SET app_view_name = 'vw_Departments' WHERE table_name = 'departments';
UPDATE kmdata.kmdata_tables SET app_view_name = 'vw_PersonPositions' WHERE table_name = 'user_positions';
UPDATE kmdata.kmdata_tables SET app_view_name = 'vw_PersonLanguages' WHERE table_name = 'user_languages';
UPDATE kmdata.kmdata_tables SET app_view_name = 'vw_PersonPreferredNames' WHERE table_name = 'user_preferred_names';
UPDATE kmdata.kmdata_tables SET app_view_name = 'vw_GrantData' WHERE table_name = 'grant_data';
UPDATE kmdata.kmdata_tables SET app_view_name = 'vw_EditorialActivity' WHERE table_name = 'editorial_activity';
UPDATE kmdata.kmdata_tables SET app_view_name = 'vw_Membership' WHERE table_name = 'membership';
UPDATE kmdata.kmdata_tables SET app_view_name = 'vw_ProfessionalActivity' WHERE table_name = 'professional_activity';
UPDATE kmdata.kmdata_tables SET app_view_name = 'vw_ClinicalService' WHERE table_name = 'clinical_service';
UPDATE kmdata.kmdata_tables SET app_view_name = 'vw_ClinicalTrials' WHERE table_name = 'clinical_trials';
UPDATE kmdata.kmdata_tables SET app_view_name = 'vw_Advising' WHERE table_name = 'advising';
UPDATE kmdata.kmdata_tables SET app_view_name = 'vw_StrategicInitiatives' WHERE table_name = 'strategic_initiatives';
UPDATE kmdata.kmdata_tables SET app_view_name = 'vw_CoursesTaught' WHERE table_name = 'courses_taught';
UPDATE kmdata.kmdata_tables SET app_view_name = 'vw_CoursesTaughtOther' WHERE table_name = 'courses_taught_other';
UPDATE kmdata.kmdata_tables SET app_view_name = 'vw_PersonEmails' WHERE table_name = 'user_emails';
UPDATE kmdata.kmdata_tables SET app_view_name = 'campuses' WHERE table_name = 'campuses';
UPDATE kmdata.kmdata_tables SET app_view_name = 'colleges' WHERE table_name = 'colleges';
UPDATE kmdata.kmdata_tables SET app_view_name = 'offerings' WHERE table_name = 'offerings';
UPDATE kmdata.kmdata_tables SET app_view_name = 'courses' WHERE table_name = 'courses';



-- COURSE CHANGES:
CREATE SEQUENCE kmdata.acad_departments_id_seq;

CREATE TABLE kmdata.acad_departments (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.acad_departments_id_seq'),
                department_name VARCHAR(1000) NOT NULL,
                college_id BIGINT NOT NULL,
                abbreviation VARCHAR(50),
                dept_code VARCHAR(25) NOT NULL,
                resource_id BIGINT NOT NULL,
                CONSTRAINT acad_departments_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.acad_departments_id_seq OWNED BY kmdata.acad_departments.id;

ALTER TABLE kmdata.acad_departments ADD CONSTRAINT resources_departments_fk1
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.acad_departments ADD CONSTRAINT colleges_departments_fk
FOREIGN KEY (college_id)
REFERENCES kmdata.colleges (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

CREATE SEQUENCE kmdata.courses_id_seq;

CREATE TABLE kmdata.courses (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.courses_id_seq'),
                course_name VARCHAR(500) NOT NULL,
                acad_department_id BIGINT NOT NULL,
                course_number VARCHAR(10) NOT NULL,
                year_term_code VARCHAR(50),
                description TEXT,
                resource_id BIGINT NOT NULL,
                CONSTRAINT courses_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.courses_id_seq OWNED BY kmdata.courses.id;

ALTER TABLE kmdata.courses ADD CONSTRAINT resources_courses_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.courses ADD CONSTRAINT departments_courses_fk
FOREIGN KEY (acad_department_id)
REFERENCES kmdata.acad_departments (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

CREATE SEQUENCE kmdata.course_syllabi_id_seq;

CREATE TABLE kmdata.course_syllabi (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.course_syllabi_id_seq'),
                course_id BIGINT NOT NULL,
                description TEXT,
                syllabus_url VARCHAR(4000),
                resource_id BIGINT NOT NULL,
                CONSTRAINT course_syllabi_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.course_syllabi_id_seq OWNED BY kmdata.course_syllabi.id;

ALTER TABLE kmdata.course_syllabi ADD CONSTRAINT resources_course_syllabus_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.course_syllabi ADD CONSTRAINT courses_course_syllabus_fk
FOREIGN KEY (course_id)
REFERENCES kmdata.courses (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

CREATE SEQUENCE kmdata.offerings_id_seq;

CREATE TABLE kmdata.offerings (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.offerings_id_seq'),
                course_id BIGINT NOT NULL,
                year_term_code VARCHAR(50),
                call_number VARCHAR(50) NOT NULL,
                resource_id BIGINT NOT NULL,
                CONSTRAINT offerings_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.offerings_id_seq OWNED BY kmdata.offerings.id;

ALTER TABLE kmdata.offerings ADD CONSTRAINT resources_offerings_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.offerings ADD CONSTRAINT courses_offerings_fk
FOREIGN KEY (course_id)
REFERENCES kmdata.courses (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

CREATE SEQUENCE kmdata.terms_id_seq;

CREATE TABLE kmdata.terms (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.terms_id_seq'),
                term_code VARCHAR(10) NOT NULL,
                description VARCHAR(255),
                CONSTRAINT terms_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.terms_id_seq OWNED BY kmdata.terms.id;

CREATE SEQUENCE kmdata.sections_id_seq;

CREATE TABLE kmdata.sections (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.sections_id_seq'),
                offering_id BIGINT NOT NULL,
                term_id BIGINT NOT NULL,
                call_number VARCHAR(50) NOT NULL,
                resource_id BIGINT NOT NULL,
                CONSTRAINT sections_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.sections_id_seq OWNED BY kmdata.sections.id;

ALTER TABLE kmdata.sections ADD CONSTRAINT terms_sections_fk
FOREIGN KEY (term_id)
REFERENCES kmdata.terms (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.sections ADD CONSTRAINT resources_sections_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.sections ADD CONSTRAINT offerings_sections_fk
FOREIGN KEY (offering_id)
REFERENCES kmdata.offerings (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

CREATE SEQUENCE kmdata.academic_careers_id_seq;

CREATE TABLE kmdata.academic_careers (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.academic_careers_id_seq'),
                name VARCHAR(255) NOT NULL,
                CONSTRAINT academic_careers_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.academic_careers_id_seq OWNED BY kmdata.academic_careers.id;

CREATE SEQUENCE kmdata.enrollment_roles_id_seq;

CREATE TABLE kmdata.enrollment_roles (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.enrollment_roles_id_seq'),
                name VARCHAR(255) NOT NULL,
                CONSTRAINT enrollment_roles_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.enrollment_roles_id_seq OWNED BY kmdata.enrollment_roles.id;

CREATE SEQUENCE kmdata.enrollments_id_seq;

CREATE TABLE kmdata.enrollments (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.enrollments_id_seq'),
                section_id BIGINT NOT NULL,
                user_id BIGINT NOT NULL,
                role_id BIGINT NOT NULL,
                career_id BIGINT NOT NULL,
                resource_id BIGINT NOT NULL,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT enrollments_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.enrollments_id_seq OWNED BY kmdata.enrollments.id;

CREATE UNIQUE INDEX enrollment_unique_set_idx
 ON kmdata.enrollments
 ( section_id, user_id, role_id, career_id );

ALTER TABLE kmdata.enrollments ADD CONSTRAINT academic_careers_enrollment_fk
FOREIGN KEY (career_id)
REFERENCES kmdata.academic_careers (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.enrollments ADD CONSTRAINT enrollment_roles_enrollment_fk
FOREIGN KEY (role_id)
REFERENCES kmdata.enrollment_roles (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.enrollments ADD CONSTRAINT resources_enrollment_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.enrollments ADD CONSTRAINT sections_enrollment_fk
FOREIGN KEY (section_id)
REFERENCES kmdata.sections (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.enrollments ADD CONSTRAINT users_enrollment_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

CREATE SEQUENCE kmdata.textbooks_id_seq;

CREATE TABLE kmdata.textbooks (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.textbooks_id_seq'),
                work_id BIGINT,
                resource_id BIGINT NOT NULL,
                CONSTRAINT textbooks_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.textbooks_id_seq OWNED BY kmdata.textbooks.id;

ALTER TABLE kmdata.textbooks ADD CONSTRAINT resources_textbooks_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.textbooks ADD CONSTRAINT works_textbooks_fk
FOREIGN KEY (work_id)
REFERENCES kmdata.works (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

CREATE SEQUENCE kmdata.section_textbooks_id_seq;

CREATE TABLE kmdata.section_textbooks (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.section_textbooks_id_seq'),
                section_id BIGINT NOT NULL,
                textbook_id BIGINT NOT NULL,
                CONSTRAINT section_textbooks_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.section_textbooks_id_seq OWNED BY kmdata.section_textbooks.id;

ALTER TABLE kmdata.section_textbooks ADD CONSTRAINT sections_section_textbooks_fk
FOREIGN KEY (section_id)
REFERENCES kmdata.sections (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.section_textbooks ADD CONSTRAINT textbooks_section_textbooks_fk
FOREIGN KEY (textbook_id)
REFERENCES kmdata.textbooks (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

CREATE SEQUENCE kmdata.day_of_wk_cds_id_seq;

CREATE TABLE kmdata.day_of_wk_cds (
                id INTEGER NOT NULL DEFAULT nextval('kmdata.day_of_wk_cds_id_seq'),
                week_letter_code VARCHAR(1) NOT NULL,
                day_abbrev VARCHAR(4) NOT NULL,
                day_long VARCHAR(50) NOT NULL,
                CONSTRAINT day_of_wk_cds_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.day_of_wk_cds_id_seq OWNED BY kmdata.day_of_wk_cds.id;

CREATE SEQUENCE kmdata.buildings_id_seq;

CREATE TABLE kmdata.buildings (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.buildings_id_seq'),
                name VARCHAR(500),
                building_code VARCHAR(250),
                name_abbrev VARCHAR(50),
                campus_id BIGINT NOT NULL,
                location_id BIGINT,
                resource_id BIGINT NOT NULL,
                CONSTRAINT buildings_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.buildings_id_seq OWNED BY kmdata.buildings.id;

ALTER TABLE kmdata.buildings ADD CONSTRAINT locations_buildings_fk
FOREIGN KEY (location_id)
REFERENCES kmdata.locations (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.buildings ADD CONSTRAINT resources_buildings_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.buildings ADD CONSTRAINT campuses_buildings_fk
FOREIGN KEY (campus_id)
REFERENCES kmdata.campuses (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

CREATE SEQUENCE kmdata.section_weekly_mtgs_id_seq;

CREATE TABLE kmdata.section_weekly_mtgs (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.section_weekly_mtgs_id_seq'),
                section_id BIGINT NOT NULL,
                day_of_wk_cd_id INTEGER NOT NULL,
                start_time VARCHAR(50) NOT NULL,
                end_time VARCHAR(50) NOT NULL,
                building_id BIGINT NOT NULL,
                room_no VARCHAR(50) NOT NULL,
                CONSTRAINT section_weekly_mtgs_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.section_weekly_mtgs_id_seq OWNED BY kmdata.section_weekly_mtgs.id;

CREATE UNIQUE INDEX section_weekly_mtgs_idx
 ON kmdata.section_weekly_mtgs
 ( section_id, day_of_wk_cd_id, start_time, end_time );

ALTER TABLE kmdata.section_weekly_mtgs ADD CONSTRAINT day_of_wk_cds_section_weekly_mtgs_fk
FOREIGN KEY (day_of_wk_cd_id)
REFERENCES kmdata.day_of_wk_cds (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.section_weekly_mtgs ADD CONSTRAINT buildings_section_weekly_mtgs_fk
FOREIGN KEY (building_id)
REFERENCES kmdata.buildings (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.section_weekly_mtgs ADD CONSTRAINT sections_section_weekly_mtgs_fk
FOREIGN KEY (section_id)
REFERENCES kmdata.sections (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;






CREATE INDEX users_last_name_lower_idx
 ON kmdata.users
 ( lower(last_name) );

CREATE INDEX users_first_name_lower_idx
 ON kmdata.users
 ( lower(first_name) );


 
-- FTP/Samba Excel file upload
CREATE SEQUENCE researchinview.new_users_xl_stage_id_seq;

CREATE TABLE researchinview.new_users_xl_stage (
                id BIGINT NOT NULL DEFAULT nextval('researchinview.new_users_xl_stage_id_seq'),
                inst_username VARCHAR(50) NOT NULL,
                user_type SMALLINT NOT NULL,
                group_integration_id VARCHAR(2000) NOT NULL,
                processed_ind VARCHAR(1) DEFAULT 'N' NOT NULL,
                imported_date TIMESTAMP DEFAULT current_timestamp NOT NULL,
                CONSTRAINT new_users_xl_stage_pk PRIMARY KEY (id)
);


ALTER SEQUENCE researchinview.new_users_xl_stage_id_seq OWNED BY researchinview.new_users_xl_stage.id;

CREATE UNIQUE INDEX new_users_xl_stage_user_idx
 ON researchinview.new_users_xl_stage
 ( inst_username );



 
-- tables for phones and addresses

CREATE TABLE peoplesoft.ps_addresses (
                emplid VARCHAR(11) NOT NULL,
                address_type VARCHAR(4) NOT NULL,
                effdt TIMESTAMP NOT NULL,
                eff_status VARCHAR(1) NOT NULL,
                country VARCHAR(3) NOT NULL,
                address1 VARCHAR(55) NOT NULL,
                address2 VARCHAR(55) NOT NULL,
                address3 VARCHAR(55) NOT NULL,
                address4 VARCHAR(55) NOT NULL,
                city VARCHAR(30) NOT NULL,
                num1 VARCHAR(6) NOT NULL,
                num2 VARCHAR(6) NOT NULL,
                house_type VARCHAR(2) NOT NULL,
                addr_field1 VARCHAR(2) NOT NULL,
                addr_field2 VARCHAR(4) NOT NULL,
                addr_field3 VARCHAR(4) NOT NULL,
                county VARCHAR(30) NOT NULL,
                state VARCHAR(6) NOT NULL,
                postal VARCHAR(12) NOT NULL,
                geo_code VARCHAR(11) NOT NULL,
                in_city_limit VARCHAR(1) NOT NULL,
                address1_ac VARCHAR(55) NOT NULL,
                address2_ac VARCHAR(55) NOT NULL,
                address3_ac VARCHAR(55) NOT NULL,
                city_ac VARCHAR(30) NOT NULL,
                reg_region VARCHAR(5) NOT NULL,
                lastupdoprid VARCHAR(30) NOT NULL,
                CONSTRAINT ps_addresses_pk PRIMARY KEY (emplid, address_type, effdt)
);


CREATE TABLE peoplesoft.ps_personal_phone (
                emplid VARCHAR(11) NOT NULL,
                phone_type VARCHAR(4) NOT NULL,
                country_code VARCHAR(3) NOT NULL,
                phone VARCHAR(24) NOT NULL,
                extension VARCHAR(6) NOT NULL,
                pref_phone_flag VARCHAR(1) NOT NULL,
                CONSTRAINT ps_personal_phone_pk PRIMARY KEY (emplid, phone_type)
);



ALTER TABLE kmdata.user_phones ADD COLUMN country_code VARCHAR(3) NOT NULL;
ALTER TABLE kmdata.user_phones ADD COLUMN extension VARCHAR(6) NOT NULL;
ALTER TABLE kmdata.user_phones ADD COLUMN pref_phone_flag VARCHAR(1) NOT NULL;


ALTER TABLE kmdata.group_categories ADD COLUMN system_only BOOLEAN;


--**************************************
--*  Add the following stored procedures
--**************************************
-- 
-- kmdata.import_user_addresses_from_ps     --> wait until SID rollout
-- kmdata.import_user_phones_from_ps        --> wait until SID rollout

-- *** citation function ***
-- kmdata.cit_nvl
-- kmdata.get_work_citation
-- kmdata.get_work_citation_by_resource_id
--
-- *** view ***
-- ror.vw_WorkCitations
