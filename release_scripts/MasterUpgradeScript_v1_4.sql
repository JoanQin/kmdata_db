-- ****************************************************************
-- * This file picks up after the clone of production to dev & qa *
-- ****************************************************************

-- stored procedures to import
CREATE OR REPLACE FUNCTION researchinview.insert_editorship ();
CREATE OR REPLACE FUNCTION researchinview.insert_society ();


ALTER TABLE kmdata.editorial_activity ADD COLUMN url VARCHAR(500);

-- createdb -O kmdata kmdata_qa
--ALTER DATABASE kmdata_prod RENAME TO kmdata_dev;

ALTER TABLE kmdata.membership ALTER COLUMN membership_role_id DROP NOT NULL;
ALTER TABLE kmdata.membership ALTER COLUMN membership_role_modifier_id DROP NOT NULL;

-- *** DEV is caught up to production ***

-- following changes were first applied to dev

CREATE SEQUENCE kmdata.professional_activity_id_seq;

CREATE TABLE kmdata.professional_activity (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.professional_activity_id_seq'),
                user_id BIGINT NOT NULL,
                activity_type_id INTEGER,
                activity_sub_type_id INTEGER,
                activity_name VARCHAR(255),
                other VARCHAR(255),
                org_name VARCHAR(255),
                start_date TIMESTAMP,
                end_date TIMESTAMP,
                start_year INTEGER,
                start_month INTEGER,
                start_day INTEGER,
                end_year INTEGER,
                end_month INTEGER,
                end_day INTEGER,
                for_fee_ind SMALLINT,
                site_name VARCHAR(255),
                city VARCHAR(255),
                state VARCHAR(255),
                country VARCHAR(255),
                url VARCHAR(255),
                key_achievements TEXT,
                output_text TEXT,
                one_day_event_ind SMALLINT,
                resource_id BIGINT NOT NULL,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT professional_activity_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.professional_activity_id_seq OWNED BY kmdata.professional_activity.id;

ALTER TABLE kmdata.professional_activity ADD CONSTRAINT resources_professional_activity_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.professional_activity ADD CONSTRAINT users_professional_activity_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;




CREATE SEQUENCE kmdata.clinical_service_id_seq;

CREATE TABLE kmdata.clinical_service (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.clinical_service_id_seq'),
                user_id BIGINT NOT NULL,
                clinical_service_type_id INTEGER NOT NULL,
                start_date TIMESTAMP,
                end_date TIMESTAMP,
                title VARCHAR(255),
                duration VARCHAR(255),
                location VARCHAR(255),
                department VARCHAR(255),
                description TEXT,
                output_text TEXT,
                resource_id BIGINT NOT NULL,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT clinical_service_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.clinical_service_id_seq OWNED BY kmdata.clinical_service.id;

ALTER TABLE kmdata.clinical_service ADD CONSTRAINT resources_clinical_service_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.clinical_service ADD CONSTRAINT users_clinical_service_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


ALTER TABLE kmdata.clinical_service ADD COLUMN url VARCHAR(500);


-- clinical trials

CREATE SEQUENCE kmdata.clinical_trials_id_seq;

CREATE TABLE kmdata.clinical_trials (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.clinical_trials_id_seq'),
                user_id BIGINT NOT NULL,
                title VARCHAR(1000),
                principal_investigator VARCHAR(255),
                sponsor VARCHAR(255),
                location_city VARCHAR(255),
                location_state VARCHAR(255),
                country VARCHAR(255),
                start_date TIMESTAMP,
                end_date TIMESTAMP,
                start_year INTEGER,
                start_month INTEGER,
                start_day INTEGER,
                end_year INTEGER,
                end_month INTEGER,
                end_day INTEGER,
                protocol_id VARCHAR(255),
                study_id VARCHAR(255),
                clinical_trial_id VARCHAR(255),
                secondary_id_3 VARCHAR(255),
                url VARCHAR(255),
                summary TEXT,
                research_report_ind SMALLINT DEFAULT 0 NOT NULL,
                role_type_id INTEGER,
                output_text TEXT,
                research_report_citation TEXT,
                amount_funded NUMERIC,
                resource_id BIGINT NOT NULL,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT clinical_trials_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.clinical_trials_id_seq OWNED BY kmdata.clinical_trials.id;

ALTER TABLE kmdata.clinical_trials ADD CONSTRAINT resources_clinical_trial_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.clinical_trials ADD CONSTRAINT users_clinical_trial_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;



ALTER TABLE kmdata.user_services ADD COLUMN created_at TIMESTAMP NOT NULL DEFAULT current_timestamp;
ALTER TABLE kmdata.user_services ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT current_timestamp;


--add advising
CREATE SEQUENCE kmdata.advising_id_seq;

CREATE TABLE kmdata.advising (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.advising_id_seq'),
                user_id BIGINT NOT NULL,
                institution_id INTEGER,
                advisee_type_id INTEGER,
                username VARCHAR(50),
                first_name VARCHAR(50),
                last_name VARCHAR(50),
                level_id INTEGER,
                role_id INTEGER,
                start_year INTEGER,
                start_month INTEGER,
                start_day INTEGER,
                end_year INTEGER,
                end_month INTEGER,
                end_day INTEGER,
                graduated SMALLINT,
                graduation_year INTEGER,
                student_group VARCHAR(255),
                title VARCHAR(500),
                advisee_current_position VARCHAR(255),
                notes TEXT,
                output_text TEXT,
                graduate_completed INTEGER,
                table_type VARCHAR(50),
                resource_id BIGINT NOT NULL,
                created_at TIMESTAMP NOT NULL,
                upated_at TIMESTAMP NOT NULL,
                CONSTRAINT advising_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.advising_id_seq OWNED BY kmdata.advising.id;

ALTER TABLE kmdata.advising ADD CONSTRAINT resources_advising_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.advising ADD CONSTRAINT users_advising_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


ALTER TABLE kmdata.advising ALTER COLUMN institution_id TYPE BIGINT;
ALTER TABLE kmdata.advising ALTER COLUMN institution_id SET NOT NULL;

ALTER TABLE kmdata.advising ADD CONSTRAINT institutions_advising_fk
FOREIGN KEY (institution_id)
REFERENCES kmdata.institutions (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.advising RENAME COLUMN upated_at TO updated_at;


-- Strategic initiatives

CREATE SEQUENCE kmdata.strategic_initiatives_id_seq;

CREATE TABLE kmdata.strategic_initiatives (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.strategic_initiatives_id_seq'),
                user_id BIGINT NOT NULL,
                institution_id BIGINT NOT NULL,
                role_name VARCHAR(255) NOT NULL,
                activity_id BIGINT NOT NULL,
                summary TEXT,
                start_year INTEGER,
                end_year INTEGER,
                active_ind SMALLINT DEFAULT 0 NOT NULL,
                output_text TEXT,
                resource_id BIGINT NOT NULL,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT strategic_initiatives_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.strategic_initiatives_id_seq OWNED BY kmdata.strategic_initiatives.id;

ALTER TABLE kmdata.strategic_initiatives ADD CONSTRAINT resources_strategic_initiatives_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.strategic_initiatives ADD CONSTRAINT institutions_strategic_initiatives_fk
FOREIGN KEY (institution_id)
REFERENCES kmdata.institutions (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.strategic_initiatives ADD CONSTRAINT users_strategic_initiatives_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;



ALTER TABLE kmdata.user_honors_awards ADD COLUMN created_at TIMESTAMP NOT NULL DEFAULT current_timestamp;
ALTER TABLE kmdata.user_honors_awards ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT current_timestamp;


-- add courses_taught

CREATE SEQUENCE kmdata.courses_taught_id_seq;

CREATE TABLE kmdata.courses_taught (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.courses_taught_id_seq'),
                user_id BIGINT NOT NULL,
                course_taught_type_id INTEGER NOT NULL,
                professional_type_id INTEGER,
                instructional_method_id INTEGER,
                instructional_method_other VARCHAR(255),
                title VARCHAR(255),
                number VARCHAR(255),
                length VARCHAR(255),
                institution_id INTEGER NOT NULL,
                department VARCHAR(255),
                credit_hour VARCHAR(50),
                year_offered INTEGER,
                period_offered_id VARCHAR,
                description TEXT,
                percent_taught INTEGER,
                role VARCHAR(3000),
                enrollment VARCHAR(255),
                formal_student_evaluation_ind SMALLINT,
                evaluation TEXT,
                output_text TEXT,
                formal_peer_evaluation_ind SMALLINT DEFAULT 0,
                resource_id BIGINT NOT NULL,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT courses_taught_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.courses_taught_id_seq OWNED BY kmdata.courses_taught.id;

ALTER TABLE kmdata.courses_taught ADD CONSTRAINT resources_course_taught_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.courses_taught ADD CONSTRAINT users_course_taught_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- alterations
ALTER TABLE kmdata.courses_taught ALTER COLUMN institution_id TYPE BIGINT;
ALTER TABLE kmdata.courses_taught ALTER COLUMN institution_id SET NOT NULL;

ALTER TABLE kmdata.courses_taught ADD CONSTRAINT institutions_courses_taught_fk
FOREIGN KEY (institution_id)
REFERENCES kmdata.institutions (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


-- add courses taught
CREATE SEQUENCE kmdata.courses_taught_other_id_seq;

CREATE TABLE kmdata.courses_taught_other (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.courses_taught_other_id_seq'),
                user_id BIGINT NOT NULL,
                course_taught_other_type_id INTEGER NOT NULL,
                title VARCHAR(255),
                number VARCHAR(255),
                length VARCHAR(255),
                institution_id BIGINT NOT NULL,
                department VARCHAR(255),
                credit_hour VARCHAR(50),
                start_year INTEGER,
                start_month INTEGER,
                start_day INTEGER,
                end_year INTEGER,
                end_month INTEGER,
                end_day INTEGER,
                description TEXT,
                percent_taught INTEGER,
                role VARCHAR(1500),
                enrollment VARCHAR(255),
                formal_student_evaluation SMALLINT,
                county VARCHAR(255),
                conference_title VARCHAR(255),
                evaluation TEXT,
                output_text TEXT,
                conference_location VARCHAR(255),
                one_day_event_ind SMALLINT,
                times_offered INTEGER,
                resource_id BIGINT NOT NULL,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT courses_taught_other_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.courses_taught_other_id_seq OWNED BY kmdata.courses_taught_other.id;

ALTER TABLE kmdata.courses_taught_other ADD CONSTRAINT resources_courses_taught_other_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.courses_taught_other ADD CONSTRAINT institutions_courses_taught_other_fk
FOREIGN KEY (institution_id)
REFERENCES kmdata.institutions (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.courses_taught_other ADD CONSTRAINT users_courses_taught_other_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- add narrative type

INSERT INTO narrative_types(narrative_desc) VALUES ('Advising Narrative');


-- add indexes to the researchinview schema
CREATE UNIQUE INDEX activity_import_log_riv_native_idx
 ON researchinview.activity_import_log
 ( integration_activity_id, integration_user_id, riv_activity_name );

CREATE UNIQUE INDEX activity_import_log_resource_idx
 ON researchinview.activity_import_log
 ( resource_id );

 
-- drop these for now
--kmdata.user_services constraints:
ALTER TABLE kmdata.user_services DROP CONSTRAINT service_role_modifiers_user_service_fk;
ALTER TABLE kmdata.user_services DROP CONSTRAINT service_roles_user_service_fk;
ALTER TABLE kmdata.user_services DROP CONSTRAINT service_units_user_service_fk;


ALTER TABLE kmdata.strategic_initiatives ALTER COLUMN role_name DROP NOT NULL;

-- ADD courses tables in kmdata

