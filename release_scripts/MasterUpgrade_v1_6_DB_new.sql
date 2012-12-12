
CREATE SEQUENCE kmdata.group_categories_new_id_seq;

CREATE TABLE kmdata.group_categories (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.group_categories_new_id_seq'),
                name VARCHAR(255) NOT NULL,
                system_only BOOLEAN,
                CONSTRAINT group_categories_new_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.group_categories_new_id_seq OWNED BY kmdata.group_categories.id;

CREATE SEQUENCE kmdata.group_properties_id_seq;

CREATE TABLE kmdata.group_properties (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.group_properties_id_seq'),
                name VARCHAR(255) NOT NULL,
                description TEXT,
                datatype VARCHAR(30) NOT NULL,
                CONSTRAINT group_properties_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.group_properties_id_seq OWNED BY kmdata.group_properties.id;

CREATE SEQUENCE kmdata.groups_new_id_seq;

CREATE TABLE kmdata.groups (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.groups_new_id_seq'),
                name VARCHAR(255) NOT NULL,
                description TEXT,
                is_public BOOLEAN,
                CONSTRAINT groups_new_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.groups_new_id_seq OWNED BY kmdata.groups.id;

CREATE SEQUENCE kmdata.group_nestings_id_seq;

CREATE TABLE kmdata.group_nestings (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.group_nestings_id_seq'),
                parent_group_id BIGINT NOT NULL,
                child_group_id BIGINT NOT NULL,
                CONSTRAINT group_nestings_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.group_nestings_id_seq OWNED BY kmdata.group_nestings.id;

CREATE SEQUENCE kmdata.group_categorizations_id_seq;

CREATE TABLE kmdata.group_categorizations (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.group_categorizations_id_seq'),
                group_id BIGINT NOT NULL,
                group_category_id BIGINT NOT NULL,
                CONSTRAINT group_categorizations_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.group_categorizations_id_seq OWNED BY kmdata.group_categorizations.id;

CREATE SEQUENCE kmdata.group_permissions_id_seq;

CREATE TABLE kmdata.group_permissions (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.group_permissions_id_seq'),
                group_id BIGINT NOT NULL,
                permission_set INTEGER,
                managing_group_id BIGINT NOT NULL,
                CONSTRAINT group_permissions_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.group_permissions_id_seq OWNED BY kmdata.group_permissions.id;

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

CREATE SEQUENCE kmdata.etl_log_id_seq;

CREATE TABLE kmdata.etl_log (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.etl_log_id_seq'),
                source_type VARCHAR(30) NOT NULL,
                source_name VARCHAR(30) NOT NULL,
                message_time TIMESTAMP NOT NULL,
                message_text VARCHAR(2000) NOT NULL,
                CONSTRAINT etl_log_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.etl_log_id_seq OWNED BY kmdata.etl_log.id;

CREATE SEQUENCE kmdata.email_types_id_seq;

CREATE TABLE kmdata.email_types (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.email_types_id_seq'),
                email_type_name VARCHAR(255) NOT NULL,
                CONSTRAINT email_types_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.email_types_id_seq OWNED BY kmdata.email_types.id;

CREATE TABLE kmdata.journal_article_types (
                id INTEGER NOT NULL,
                name VARCHAR(255) NOT NULL,
                CONSTRAINT journal_article_types_pk PRIMARY KEY (id)
);


CREATE TABLE kmdata.language_proficiencies (
                id BIGINT NOT NULL,
                name VARCHAR(255) NOT NULL,
                CONSTRAINT language_proficiencies_pk PRIMARY KEY (id)
);


CREATE TABLE kmdata.language_dialects (
                id BIGINT NOT NULL,
                name VARCHAR(255) NOT NULL,
                CONSTRAINT language_dialects_pk PRIMARY KEY (id)
);


CREATE TABLE kmdata.languages (
                id BIGINT NOT NULL,
                name VARCHAR(255) NOT NULL,
                CONSTRAINT languages_pk PRIMARY KEY (id)
);


CREATE SEQUENCE kmdata.day_of_wk_cds_id_seq;

CREATE TABLE kmdata.day_of_wk_cds (
                id INTEGER NOT NULL DEFAULT nextval('kmdata.day_of_wk_cds_id_seq'),
                week_letter_code VARCHAR(1) NOT NULL,
                day_abbrev VARCHAR(4) NOT NULL,
                day_long VARCHAR(50) NOT NULL,
                CONSTRAINT day_of_wk_cds_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.day_of_wk_cds_id_seq OWNED BY kmdata.day_of_wk_cds.id;

CREATE SEQUENCE kmdata.terms_id_seq;

CREATE TABLE kmdata.terms (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.terms_id_seq'),
                term_code VARCHAR(10) NOT NULL,
                description VARCHAR(255),
                CONSTRAINT terms_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.terms_id_seq OWNED BY kmdata.terms.id;

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

CREATE SEQUENCE kmdata.address_types_id_seq;

CREATE TABLE kmdata.address_types (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.address_types_id_seq'),
                address_type_name VARCHAR(255) NOT NULL,
                CONSTRAINT address_types_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.address_types_id_seq OWNED BY kmdata.address_types.id;

CREATE SEQUENCE kmdata.phone_types_id_seq;

CREATE TABLE kmdata.phone_types (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.phone_types_id_seq'),
                phone_type_name VARCHAR(255) NOT NULL,
                CONSTRAINT phone_types_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.phone_types_id_seq OWNED BY kmdata.phone_types.id;

CREATE TABLE kmdata.bckfd_pro_user_names (
                emplid VARCHAR(11) NOT NULL,
                first_name VARCHAR(50),
                middle_name VARCHAR(50),
                last_name VARCHAR(50),
                prefix VARCHAR(50),
                suffix VARCHAR(50),
                display_name VARCHAR(150),
                kerb_id VARCHAR(75),
                ckm_username VARCHAR(75),
                ckm_password VARCHAR(50),
                who_emplid VARCHAR(11),
                when_dtm TIMESTAMP NOT NULL,
                guest_ind SMALLINT NOT NULL,
                active_ind SMALLINT NOT NULL,
                last_login TIMESTAMP,
                app_forward INTEGER,
                uuid VARCHAR(50) NOT NULL,
                deceased_ind SMALLINT DEFAULT 0 NOT NULL,
                CONSTRAINT bckfd_pro_user_names_pk PRIMARY KEY (emplid)
);


CREATE SEQUENCE kmdata.group_categories_legacy_id_seq;

CREATE TABLE kmdata.group_categories_legacy (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.group_categories_legacy_id_seq'),
                group_category_name VARCHAR(50) NOT NULL,
                CONSTRAINT group_categories_legacy_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.group_categories_legacy_id_seq OWNED BY kmdata.group_categories_legacy.id;

CREATE SEQUENCE kmdata.keyterms_id_seq;

CREATE TABLE kmdata.keyterms (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.keyterms_id_seq'),
                faes_ind SMALLINT NOT NULL,
                emphasis_id INTEGER,
                key_word VARCHAR(500),
                active_ind SMALLINT DEFAULT 1 NOT NULL,
                order_no INTEGER NOT NULL,
                CONSTRAINT keyterms_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.keyterms_id_seq OWNED BY kmdata.keyterms.id;

CREATE SEQUENCE kmdata.honor_types_id_seq;

CREATE TABLE kmdata.honor_types (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.honor_types_id_seq'),
                type_name VARCHAR(255) NOT NULL,
                CONSTRAINT honor_types_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.honor_types_id_seq OWNED BY kmdata.honor_types.id;

CREATE SEQUENCE kmdata.service_units_id_seq;

CREATE TABLE kmdata.service_units (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.service_units_id_seq'),
                unit VARCHAR(50) NOT NULL,
                CONSTRAINT service_units_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.service_units_id_seq OWNED BY kmdata.service_units.id;

CREATE SEQUENCE kmdata.service_role_modifiers_id_seq;

CREATE TABLE kmdata.service_role_modifiers (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.service_role_modifiers_id_seq'),
                modifier VARCHAR(255) NOT NULL,
                CONSTRAINT service_role_modifiers_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.service_role_modifiers_id_seq OWNED BY kmdata.service_role_modifiers.id;

CREATE SEQUENCE kmdata.service_roles_id_seq;

CREATE TABLE kmdata.service_roles (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.service_roles_id_seq'),
                role VARCHAR(255) NOT NULL,
                CONSTRAINT service_roles_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.service_roles_id_seq OWNED BY kmdata.service_roles.id;

CREATE SEQUENCE kmdata.cip_codes_id_seq;

CREATE TABLE kmdata.cip_codes (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.cip_codes_id_seq'),
                code VARCHAR(3),
                definition VARCHAR(255),
                CONSTRAINT cip_codes_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.cip_codes_id_seq OWNED BY kmdata.cip_codes.id;

CREATE SEQUENCE kmdata.certifying_bodies_id_seq;

CREATE TABLE kmdata.certifying_bodies (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.certifying_bodies_id_seq'),
                certifying_body VARCHAR(255) NOT NULL,
                CONSTRAINT certifying_bodies_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.certifying_bodies_id_seq OWNED BY kmdata.certifying_bodies.id;

CREATE SEQUENCE kmdata.degree_classes_id_seq;

CREATE TABLE kmdata.degree_classes (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.degree_classes_id_seq'),
                classification VARCHAR(50) NOT NULL,
                CONSTRAINT degree_classes_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.degree_classes_id_seq OWNED BY kmdata.degree_classes.id;

CREATE SEQUENCE kmdata.degree_types_id_seq;

CREATE TABLE kmdata.degree_types (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.degree_types_id_seq'),
                description_abbreviation VARCHAR(50),
                transcript_abbreviation VARCHAR(200),
                degree_description VARCHAR(200),
                degree_class_id BIGINT,
                riv_id BIGINT,
                CONSTRAINT degree_types_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.degree_types_id_seq OWNED BY kmdata.degree_types.id;

CREATE SEQUENCE kmdata.states_id_seq;

CREATE TABLE kmdata.states (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.states_id_seq'),
                geoid VARCHAR(255),
                state VARCHAR(8000),
                abbreviation VARCHAR(50),
                CONSTRAINT states_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.states_id_seq OWNED BY kmdata.states.id;

CREATE INDEX states_geoid_idx
 ON kmdata.states
 ( geoid );

CREATE SEQUENCE kmdata.places_id_seq;

CREATE TABLE kmdata.places (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.places_id_seq'),
                stusps VARCHAR(2),
                state_geoid VARCHAR(255),
                geoid VARCHAR(255),
                name VARCHAR(8000),
                intptlat NUMERIC(10,6),
                intptlong NUMERIC(10,6),
                CONSTRAINT places_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.places_id_seq OWNED BY kmdata.places.id;

CREATE SEQUENCE kmdata.county_congressional_districts_id_seq;

CREATE TABLE kmdata.county_congressional_districts (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.county_congressional_districts_id_seq'),
                state_geotype_id VARCHAR(255),
                county_geotype_id VARCHAR(255),
                congressional_district_2010_geotype_id VARCHAR(255),
                CONSTRAINT county_congressional_districts_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.county_congressional_districts_id_seq OWNED BY kmdata.county_congressional_districts.id;

CREATE SEQUENCE kmdata.counties_id_seq;

CREATE TABLE kmdata.counties (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.counties_id_seq'),
                STUSPS VARCHAR(2),
                STATE_GEOID VARCHAR(255),
                GEOID VARCHAR(255),
                NAME VARCHAR(33),
                INTPTLAT NUMERIC(10,6),
                INTPTLONG NUMERIC(10,6),
                CONSTRAINT counties_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.counties_id_seq OWNED BY kmdata.counties.id;

CREATE SEQUENCE kmdata.congressional_districts_id_seq;

CREATE TABLE kmdata.congressional_districts (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.congressional_districts_id_seq'),
                STUSPS VARCHAR(2),
                STATE_GEOID VARCHAR(255),
                GEOID VARCHAR(255),
                INTPTLAT NUMERIC(10,6),
                INTPTLONG NUMERIC(10,6),
                CONSTRAINT congressional_districts_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.congressional_districts_id_seq OWNED BY kmdata.congressional_districts.id;

CREATE SEQUENCE kmdata.work_types_id_seq;

CREATE TABLE kmdata.work_types (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.work_types_id_seq'),
                work_type_name VARCHAR(255) NOT NULL,
                CONSTRAINT work_types_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.work_types_id_seq OWNED BY kmdata.work_types.id;

CREATE SEQUENCE kmdata.kmdata_tables_id_seq;

CREATE TABLE kmdata.kmdata_tables (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.kmdata_tables_id_seq'),
                table_name VARCHAR(255) NOT NULL,
                app_view_name VARCHAR(255),
                CONSTRAINT kmdata_tables_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.kmdata_tables_id_seq OWNED BY kmdata.kmdata_tables.id;

CREATE SEQUENCE kmdata.dmy_range_dates_id_seq;

CREATE TABLE kmdata.dmy_range_dates (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.dmy_range_dates_id_seq'),
                start_day INTEGER,
                start_month INTEGER,
                start_year BIGINT,
                end_day INTEGER,
                end_month INTEGER,
                end_year BIGINT,
                CONSTRAINT dmy_range_dates_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.dmy_range_dates_id_seq OWNED BY kmdata.dmy_range_dates.id;

CREATE SEQUENCE kmdata.dmy_single_dates_id_seq;

CREATE TABLE kmdata.dmy_single_dates (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.dmy_single_dates_id_seq'),
                day INTEGER,
                month INTEGER,
                year BIGINT,
                CONSTRAINT dmy_single_dates_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.dmy_single_dates_id_seq OWNED BY kmdata.dmy_single_dates.id;

CREATE SEQUENCE kmdata.narrative_types_id_seq;

CREATE TABLE kmdata.narrative_types (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.narrative_types_id_seq'),
                narrative_desc VARCHAR(255) NOT NULL,
                CONSTRAINT narrative_types_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.narrative_types_id_seq OWNED BY kmdata.narrative_types.id;

CREATE SEQUENCE kmdata.import_errors_id_seq;

CREATE TABLE kmdata.import_errors (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.import_errors_id_seq'),
                error_number VARCHAR(50),
                resource_id BIGINT,
                user_id BIGINT,
                message_varchar VARCHAR(4000),
                message_text TEXT,
                message_when TIMESTAMP NOT NULL,
                CONSTRAINT import_errors_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.import_errors_id_seq OWNED BY kmdata.import_errors.id;

CREATE SEQUENCE kmdata.sources_id_seq;

CREATE TABLE kmdata.sources (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.sources_id_seq'),
                source_name VARCHAR(255) NOT NULL,
                CONSTRAINT sources_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.sources_id_seq OWNED BY kmdata.sources.id;

CREATE SEQUENCE kmdata.class_instructors_id_seq;

CREATE TABLE kmdata.class_instructors (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.class_instructors_id_seq'),
                course_offer_resource_id INTEGER NOT NULL,
                order_index INTEGER NOT NULL,
                person_resource_id INTEGER NOT NULL,
                CONSTRAINT class_instructors_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.class_instructors_id_seq OWNED BY kmdata.class_instructors.id;

CREATE SEQUENCE kmdata.location_types_id_seq;

CREATE TABLE kmdata.location_types (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.location_types_id_seq'),
                name VARCHAR(255) NOT NULL,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT location_types_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.location_types_id_seq OWNED BY kmdata.location_types.id;

CREATE SEQUENCE kmdata.roles_id_seq;

CREATE TABLE kmdata.roles (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.roles_id_seq'),
                name VARCHAR(255) NOT NULL,
                CONSTRAINT roles_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.roles_id_seq OWNED BY kmdata.roles.id;

CREATE SEQUENCE kmdata.units_id_seq;

CREATE TABLE kmdata.units (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.units_id_seq'),
                CONSTRAINT units_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.units_id_seq OWNED BY kmdata.units.id;

CREATE TABLE kmdata.locations (
                id BIGINT NOT NULL,
                location_type_id BIGINT NOT NULL,
                geotype_id VARCHAR(255),
                name VARCHAR(1000),
                abbreviation VARCHAR(100),
                latitude NUMERIC(10,6),
                longitude NUMERIC(10,6),
                address VARCHAR(2000),
                address2 VARCHAR(2000),
                city VARCHAR(255),
                state VARCHAR(10),
                zip VARCHAR(255),
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT locations_pk PRIMARY KEY (id)
);


CREATE SEQUENCE kmdata.privileges_id_seq;

CREATE TABLE kmdata.privileges (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.privileges_id_seq'),
                CONSTRAINT privileges_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.privileges_id_seq OWNED BY kmdata.privileges.id;

CREATE SEQUENCE kmdata.resources_id_seq;

CREATE TABLE kmdata.resources (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.resources_id_seq'),
                source_id BIGINT NOT NULL,
                kmdata_table_id BIGINT,
                CONSTRAINT resources_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.resources_id_seq OWNED BY kmdata.resources.id;

CREATE SEQUENCE kmdata.group_exclusions_id_seq;

CREATE TABLE kmdata.group_exclusions (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.group_exclusions_id_seq'),
                group_id BIGINT NOT NULL,
                resource_id BIGINT NOT NULL,
                CONSTRAINT group_exclusions_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.group_exclusions_id_seq OWNED BY kmdata.group_exclusions.id;

CREATE SEQUENCE kmdata.group_memberships_id_seq;

CREATE TABLE kmdata.group_memberships (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.group_memberships_id_seq'),
                resource_id BIGINT NOT NULL,
                group_id BIGINT NOT NULL,
                CONSTRAINT group_memberships_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.group_memberships_id_seq OWNED BY kmdata.group_memberships.id;

CREATE SEQUENCE kmdata.grant_data_id_seq;

CREATE TABLE kmdata.grant_data (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.grant_data_id_seq'),
                grant_type_id INTEGER,
                status_id INTEGER,
                title VARCHAR(1000),
                role_id INTEGER,
                originating_contract VARCHAR(1000),
                principal_investigator VARCHAR(1000),
                co_investigator VARCHAR(1000),
                source VARCHAR(500),
                agency VARCHAR(1000),
                priority_score VARCHAR(1000),
                amount_funded INTEGER,
                direct_cost INTEGER,
                goal TEXT,
                description TEXT,
                other_contributors TEXT,
                percent_effort INTEGER,
                identifier VARCHAR(1000),
                grant_number VARCHAR(1000),
                award_number VARCHAR(1000),
                explanation_of_role VARCHAR(2000),
                start_date TIMESTAMP,
                end_date TIMESTAMP,
                start_year INTEGER,
                start_month INTEGER,
                start_day INTEGER,
                end_year INTEGER,
                end_month INTEGER,
                end_day INTEGER,
                grant_identifier VARCHAR(1000),
                output_text TEXT,
                submitted_year INTEGER,
                submitted_month INTEGER,
                submitted_day INTEGER,
                denied_year INTEGER,
                denied_month INTEGER,
                denied_day INTEGER,
                resource_id BIGINT NOT NULL,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                agency_other VARCHAR(1000),
                agency_other_city VARCHAR(1000),
                agency_other_country VARCHAR(1000),
                agency_other_state_province VARCHAR(1000),
                currency VARCHAR(1000),
                fellowship VARCHAR(1000),
                funding_agency_type VARCHAR(1000),
                funding_amount_breakdown INTEGER,
                duration INTEGER,
                funding_agency_type_other VARCHAR(1000),
                CONSTRAINT grant_data_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.grant_data_id_seq OWNED BY kmdata.grant_data.id;

CREATE SEQUENCE kmdata.departments_id_seq;

CREATE TABLE kmdata.departments (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.departments_id_seq'),
                deptid VARCHAR(10) NOT NULL,
                dept_name VARCHAR(30) NOT NULL,
                manager_emplid VARCHAR(11),
                budget_deptid VARCHAR(10),
                location VARCHAR(10),
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                resource_id BIGINT NOT NULL,
                CONSTRAINT departments_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.departments_id_seq OWNED BY kmdata.departments.id;

CREATE TABLE kmdata.groups_legacy (
                id BIGINT NOT NULL,
                group_name VARCHAR(255) NOT NULL,
                group_category_id BIGINT,
                department_ind SMALLINT DEFAULT 0 NOT NULL,
                department_id VARCHAR(50),
                description TEXT,
                sql_ind SMALLINT DEFAULT 0 NOT NULL,
                sql_text TEXT,
                member_count INTEGER NOT NULL,
                participation_count INTEGER NOT NULL,
                active_ind SMALLINT DEFAULT 0 NOT NULL,
                auto_update_ind SMALLINT DEFAULT 1 NOT NULL,
                active_date TIMESTAMP NOT NULL,
                deactivated_date TIMESTAMP,
                resource_id BIGINT,
                CONSTRAINT groups_legacy_pk PRIMARY KEY (id)
);


CREATE SEQUENCE kmdata.user_groups_nestings_id_seq;

CREATE TABLE kmdata.user_groups_nestings (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.user_groups_nestings_id_seq'),
                parent_id BIGINT,
                group_id BIGINT NOT NULL,
                CONSTRAINT user_groups_nestings_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.user_groups_nestings_id_seq OWNED BY kmdata.user_groups_nestings.id;

CREATE SEQUENCE kmdata.institutions_id_seq;

CREATE TABLE kmdata.institutions (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.institutions_id_seq'),
                pro_id BIGINT,
                college_university_code VARCHAR(255),
                name VARCHAR(500) NOT NULL,
                comment VARCHAR(255),
                state_code VARCHAR(255),
                location_id BIGINT,
                college_sequence_number VARCHAR(255),
                city_code VARCHAR(250),
                edited_ind SMALLINT,
                url VARCHAR(255),
                resource_id BIGINT NOT NULL,
                CONSTRAINT institutions_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.institutions_id_seq OWNED BY kmdata.institutions.id;

CREATE SEQUENCE kmdata.campuses_id_seq;

CREATE TABLE kmdata.campuses (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.campuses_id_seq'),
                campus_name VARCHAR(250) NOT NULL,
                institution_id BIGINT NOT NULL,
                location_id BIGINT NOT NULL,
                resource_id BIGINT NOT NULL,
                CONSTRAINT campuses_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.campuses_id_seq OWNED BY kmdata.campuses.id;

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

CREATE SEQUENCE kmdata.colleges_id_seq;

CREATE TABLE kmdata.colleges (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.colleges_id_seq'),
                college_name VARCHAR(250) NOT NULL,
                campus_id BIGINT NOT NULL,
                abbreviation VARCHAR(50),
                resource_id BIGINT NOT NULL,
                CONSTRAINT colleges_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.colleges_id_seq OWNED BY kmdata.colleges.id;

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

CREATE SEQUENCE kmdata.narratives_id_seq;

CREATE TABLE kmdata.narratives (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.narratives_id_seq'),
                narrative_type_id BIGINT NOT NULL,
                narrative_text TEXT,
                private_ind SMALLINT DEFAULT 0 NOT NULL,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP,
                resource_id BIGINT NOT NULL,
                user_id BIGINT,
                CONSTRAINT narratives_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.narratives_id_seq OWNED BY kmdata.narratives.id;

CREATE SEQUENCE kmdata.users_id_seq;

CREATE TABLE kmdata.users (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.users_id_seq'),
                uuid VARCHAR(50) NOT NULL,
                open_id VARCHAR(50),
                last_name VARCHAR(50),
                first_name VARCHAR(50),
                middle_name VARCHAR(50),
                name_prefix VARCHAR(4),
                name_suffix VARCHAR(15),
                display_name VARCHAR(255),
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                resource_id BIGINT NOT NULL,
                deceased_ind SMALLINT DEFAULT 0 NOT NULL,
                CONSTRAINT users_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.users_id_seq OWNED BY kmdata.users.id;

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
                institution_id BIGINT NOT NULL,
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

CREATE SEQUENCE kmdata.strategic_initiatives_id_seq;

CREATE TABLE kmdata.strategic_initiatives (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.strategic_initiatives_id_seq'),
                user_id BIGINT NOT NULL,
                institution_id BIGINT NOT NULL,
                role_name VARCHAR(255),
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

CREATE SEQUENCE kmdata.advising_id_seq;

CREATE TABLE kmdata.advising (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.advising_id_seq'),
                user_id BIGINT NOT NULL,
                institution_id BIGINT NOT NULL,
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
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT advising_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.advising_id_seq OWNED BY kmdata.advising.id;

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
                approved_on TIMESTAMP,
                condition_studied VARCHAR(255),
                intervention_analyzed VARCHAR(255),
                percent_effort INTEGER,
                regulatory_approval VARCHAR(255),
                role_other VARCHAR(255),
                site_name VARCHAR(1000),
                CONSTRAINT clinical_trials_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.clinical_trials_id_seq OWNED BY kmdata.clinical_trials.id;

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
                url VARCHAR(500),
                CONSTRAINT clinical_service_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.clinical_service_id_seq OWNED BY kmdata.clinical_service.id;

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

CREATE SEQUENCE kmdata.membership_id_seq;

CREATE TABLE kmdata.membership (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.membership_id_seq'),
                user_id BIGINT NOT NULL,
                organization_name VARCHAR(500),
                organization_city VARCHAR(255),
                organization_state VARCHAR(255),
                organization_country VARCHAR(255),
                group_name VARCHAR(500),
                membership_role_id INTEGER,
                membership_role_modifier_id INTEGER,
                start_year INTEGER,
                start_month INTEGER,
                start_day INTEGER,
                end_year INTEGER,
                end_month INTEGER,
                end_day INTEGER,
                active_ind SMALLINT DEFAULT 0 NOT NULL,
                organization_website VARCHAR(500),
                duration_known_ind SMALLINT,
                notes TEXT,
                output_text TEXT,
                resource_id BIGINT NOT NULL,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT membership_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.membership_id_seq OWNED BY kmdata.membership.id;

CREATE SEQUENCE kmdata.editorial_activity_id_seq;

CREATE TABLE kmdata.editorial_activity (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.editorial_activity_id_seq'),
                user_id BIGINT NOT NULL,
                editorship_type_id INTEGER NOT NULL,
                modifier_id INTEGER,
                publication_type_id INTEGER,
                publication_name VARCHAR(500),
                publication_issue VARCHAR(255),
                article_title VARCHAR(255),
                start_year INTEGER,
                end_year INTEGER,
                currently_editor_ind SMALLINT,
                publication_volume VARCHAR(255),
                publication_date TIMESTAMP,
                output_text TEXT,
                research_report_ind SMALLINT DEFAULT 0 NOT NULL,
                titled_num INTEGER,
                resource_id BIGINT NOT NULL,
                url VARCHAR(500),
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT editorial_activity_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.editorial_activity_id_seq OWNED BY kmdata.editorial_activity.id;

CREATE SEQUENCE kmdata.user_grants_id_seq;

CREATE TABLE kmdata.user_grants (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.user_grants_id_seq'),
                user_id BIGINT NOT NULL,
                grant_data_id BIGINT NOT NULL,
                CONSTRAINT user_grants_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.user_grants_id_seq OWNED BY kmdata.user_grants.id;

CREATE SEQUENCE kmdata.user_languages_id_seq;

CREATE TABLE kmdata.user_languages (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.user_languages_id_seq'),
                language_id BIGINT NOT NULL,
                dialect_id BIGINT,
                user_id BIGINT NOT NULL,
                reading_proficiency BIGINT NOT NULL,
                speaking_proficiency BIGINT NOT NULL,
                writing_proficiency BIGINT NOT NULL,
                resource_id BIGINT NOT NULL,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT user_languages_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.user_languages_id_seq OWNED BY kmdata.user_languages.id;

CREATE SEQUENCE kmdata.user_positions_user_id_seq;

CREATE TABLE kmdata.user_positions (
                id BIGINT NOT NULL,
                user_id BIGINT NOT NULL DEFAULT nextval('kmdata.user_positions_user_id_seq'),
                business_name VARCHAR(500),
                city VARCHAR(255),
                state VARCHAR(255),
                country VARCHAR(255),
                current_ind SMALLINT DEFAULT 0 NOT NULL,
                description TEXT,
                division VARCHAR(500),
                started_dmy_single_date_id BIGINT,
                ended_dmy_single_date_id BIGINT,
                institution_id BIGINT,
                higher_ed_college VARCHAR(500),
                higher_ed_department VARCHAR(500),
                higher_ed_position_title VARCHAR(300),
                higher_ed_school VARCHAR(300),
                institute VARCHAR(500),
                unit VARCHAR(500),
                percent_time INTEGER DEFAULT 100 NOT NULL,
                position_title VARCHAR(300),
                position_type VARCHAR(255),
                subject_area VARCHAR(255),
                resource_id BIGINT NOT NULL,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT user_positions_pk PRIMARY KEY (id)
);
COMMENT ON COLUMN kmdata.user_positions.institute IS 'new RIV attribute';
COMMENT ON COLUMN kmdata.user_positions.position_type IS 'Maps to research in view position type. No Data : (Faculty, 1), (Administration, 2), (Fellowship, 3), (Clerkship, 4), (Internship, 5), (Residency, 6), (Graduate Student, 7), (Rsearcher, 8), (Other, 9)';


ALTER SEQUENCE kmdata.user_positions_user_id_seq OWNED BY kmdata.user_positions.user_id;

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

CREATE SEQUENCE kmdata.group_excluded_users_id_seq;

CREATE TABLE kmdata.group_excluded_users (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.group_excluded_users_id_seq'),
                group_id BIGINT NOT NULL,
                user_id BIGINT NOT NULL,
                CONSTRAINT group_excluded_users_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.group_excluded_users_id_seq OWNED BY kmdata.group_excluded_users.id;

CREATE SEQUENCE kmdata.user_phones_id_seq;

CREATE TABLE kmdata.user_phones (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.user_phones_id_seq'),
                user_id BIGINT NOT NULL,
                phone_type_id BIGINT NOT NULL,
                country_code VARCHAR(3) NOT NULL,
                phone VARCHAR(24) NOT NULL,
                extension VARCHAR(6) NOT NULL,
                pref_phone_flag VARCHAR(1) NOT NULL,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                resource_id BIGINT NOT NULL,
                CONSTRAINT user_phones_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.user_phones_id_seq OWNED BY kmdata.user_phones.id;

CREATE INDEX user_phones_user_id_idx
 ON kmdata.user_phones
 ( user_id );

CREATE SEQUENCE kmdata.user_appointments_id_seq;

CREATE TABLE kmdata.user_appointments (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.user_appointments_id_seq'),
                user_id BIGINT NOT NULL,
                rcd_num INTEGER NOT NULL,
                department_id VARCHAR(10) NOT NULL,
                title_abbrv VARCHAR(10) NOT NULL,
                title VARCHAR(30) NOT NULL,
                working_title VARCHAR(30) NOT NULL,
                title_grp_id_code CHAR(1) NOT NULL,
                jobcode CHAR(4) NOT NULL,
                business_unit VARCHAR(5),
                organization VARCHAR(10),
                fund CHAR(6),
                account CHAR(6),
                function CHAR(5),
                project VARCHAR(15),
                program CHAR(5),
                user_defined VARCHAR(6),
                budget_year VARCHAR(4),
                prim_appt_code CHAR(1),
                appt_percent SMALLINT,
                appt_seq_code CHAR,
                summer1_service CHAR(1),
                winter_service CHAR,
                autumn_service CHAR(1),
                spring_service CHAR(1),
                summer2_service CHAR(1),
                osu_leave_start_date TIMESTAMP,
                appt_start_date TIMESTAMP,
                appt_end_date TIMESTAMP,
                appt_end_length CHAR(3),
                dw_change_date TIMESTAMP,
                dw_change_code CHAR(1),
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                resource_id BIGINT NOT NULL,
                sal_admin_plan VARCHAR(4),
                CONSTRAINT user_appointments_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.user_appointments_id_seq OWNED BY kmdata.user_appointments.id;

CREATE INDEX user_appointments_user_id_idx
 ON kmdata.user_appointments
 ( user_id );

CREATE UNIQUE INDEX user_appointments_altkey1_idx
 ON kmdata.user_appointments
 ( user_id, rcd_num );

CREATE TABLE kmdata.user_addresses (
                id BIGINT NOT NULL,
                user_id BIGINT NOT NULL,
                address_type_id BIGINT NOT NULL,
                address1 VARCHAR(2000),
                address2 VARCHAR(2000),
                address3 VARCHAR(2000),
                address4 VARCHAR(2000),
                city VARCHAR(255),
                state VARCHAR(10),
                zip VARCHAR(255),
                country VARCHAR(255),
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                resource_id BIGINT NOT NULL,
                CONSTRAINT user_addresses_pk PRIMARY KEY (id)
);


CREATE INDEX user_addresses_user_id_idx
 ON kmdata.user_addresses
 ( user_id );

CREATE INDEX user_addresses_alt_key_idx
 ON kmdata.user_addresses
 ( user_id, address_type_id );

CREATE SEQUENCE kmdata.user_individual_modify_permissions_id_seq;

CREATE TABLE kmdata.user_individual_modify_permissions (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.user_individual_modify_permissions_id_seq'),
                profile_user_id BIGINT NOT NULL,
                person_to_modify_user_id BIGINT NOT NULL,
                administrator_entered_ind SMALLINT DEFAULT 1 NOT NULL,
                CONSTRAINT user_individual_modify_permissions_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.user_individual_modify_permissions_id_seq OWNED BY kmdata.user_individual_modify_permissions.id;

CREATE SEQUENCE kmdata.user_group_permissions_id_seq;

CREATE TABLE kmdata.user_group_permissions (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.user_group_permissions_id_seq'),
                user_id BIGINT NOT NULL,
                group_id BIGINT NOT NULL,
                read_ind SMALLINT DEFAULT 0 NOT NULL,
                write_ind SMALLINT DEFAULT 0 NOT NULL,
                create_date TIMESTAMP NOT NULL,
                CONSTRAINT user_group_permissions_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.user_group_permissions_id_seq OWNED BY kmdata.user_group_permissions.id;

CREATE SEQUENCE kmdata.user_groups_id_seq;

CREATE TABLE kmdata.user_groups (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.user_groups_id_seq'),
                user_id BIGINT NOT NULL,
                group_id BIGINT NOT NULL,
                manual_ind SMALLINT DEFAULT 0 NOT NULL,
                CONSTRAINT user_groups_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.user_groups_id_seq OWNED BY kmdata.user_groups.id;

CREATE UNIQUE INDEX user_groups_altkey1_idx
 ON kmdata.user_groups
 ( user_id, group_id );

CREATE TABLE kmdata.user_honors_awards (
                id BIGINT NOT NULL,
                user_id BIGINT NOT NULL,
                resource_id BIGINT NOT NULL,
                honor_type_id INTEGER NOT NULL,
                honor_name VARCHAR(500),
                monetary_component_ind SMALLINT,
                monetary_amount INTEGER,
                fellow_ind SMALLINT DEFAULT 0 NOT NULL,
                internal_ind SMALLINT DEFAULT 1 NOT NULL,
                institution_id BIGINT,
                sponsor VARCHAR(500),
                subject VARCHAR(500),
                start_year VARCHAR,
                end_year INTEGER,
                selected VARCHAR(500),
                competitiveness VARCHAR(500),
                output_text TEXT,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT user_honors_awards_pk PRIMARY KEY (id)
);


CREATE INDEX user_honors_awards_user_id_idx
 ON kmdata.user_honors_awards
 ( user_id );

CREATE SEQUENCE kmdata.user_honors_awards_narratives_id_seq;

CREATE TABLE kmdata.user_honors_awards_narratives (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.user_honors_awards_narratives_id_seq'),
                user_honors_awards_id BIGINT NOT NULL,
                narrative_id BIGINT NOT NULL,
                CONSTRAINT user_honors_awards_narratives_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.user_honors_awards_narratives_id_seq OWNED BY kmdata.user_honors_awards_narratives.id;

CREATE SEQUENCE kmdata.user_services_id_seq;

CREATE TABLE kmdata.user_services (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.user_services_id_seq'),
                user_id BIGINT NOT NULL,
                resource_id BIGINT NOT NULL,
                institution_id BIGINT NOT NULL,
                service_unit_id BIGINT,
                group_name VARCHAR(255),
                subcommittee_name VARCHAR(255),
                workgroup_name VARCHAR(255),
                service_role_id BIGINT,
                service_role_modifier_id BIGINT,
                start_year INTEGER,
                active_ind SMALLINT DEFAULT 0 NOT NULL,
                end_year INTEGER,
                student_affairs_ind SMALLINT,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT user_services_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.user_services_id_seq OWNED BY kmdata.user_services.id;

CREATE INDEX user_services_user_id_idx
 ON kmdata.user_services
 ( user_id );

CREATE SEQUENCE kmdata.user_service_narratives_id_seq;

CREATE TABLE kmdata.user_service_narratives (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.user_service_narratives_id_seq'),
                user_service_id BIGINT NOT NULL,
                narrative_id BIGINT NOT NULL,
                CONSTRAINT user_service_narratives_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.user_service_narratives_id_seq OWNED BY kmdata.user_service_narratives.id;

CREATE SEQUENCE kmdata.user_preferred_keywords_id_seq;

CREATE TABLE kmdata.user_preferred_keywords (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.user_preferred_keywords_id_seq'),
                user_id BIGINT NOT NULL,
                expertise_keyterm_id BIGINT,
                partners_keyterm_id BIGINT,
                contact_ind SMALLINT DEFAULT 0,
                create_date TIMESTAMP NOT NULL,
                CONSTRAINT user_preferred_keywords_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.user_preferred_keywords_id_seq OWNED BY kmdata.user_preferred_keywords.id;

CREATE INDEX user_preferred_keywords_user_id_idx
 ON kmdata.user_preferred_keywords
 ( user_id );

CREATE SEQUENCE kmdata.user_preferred_appointments_id_seq;

CREATE TABLE kmdata.user_preferred_appointments (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.user_preferred_appointments_id_seq'),
                user_id BIGINT NOT NULL,
                description VARCHAR(50),
                department_name VARCHAR(100),
                show_ind SMALLINT DEFAULT 1 NOT NULL,
                create_date TIMESTAMP NOT NULL,
                CONSTRAINT user_preferred_appointments_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.user_preferred_appointments_id_seq OWNED BY kmdata.user_preferred_appointments.id;

CREATE INDEX user_preferred_appointments_user_id_idx
 ON kmdata.user_preferred_appointments
 ( user_id );

CREATE TABLE kmdata.user_preferred_names (
                id BIGINT NOT NULL,
                user_id BIGINT NOT NULL,
                prefix VARCHAR(50),
                first_name VARCHAR(50),
                middle_name VARCHAR(50),
                last_name VARCHAR(50),
                suffix VARCHAR(50),
                preferred_publishing_name VARCHAR(255),
                email VARCHAR(50),
                fax VARCHAR(50),
                phone VARCHAR(50),
                address VARCHAR(255),
                address_2 VARCHAR(255),
                city VARCHAR(255),
                state VARCHAR(255),
                zip VARCHAR(255),
                country VARCHAR(255),
                subscribe INTEGER,
                url VARCHAR(500),
                cip_area VARCHAR(255),
                cip_focus VARCHAR(255),
                prefix_show_ind SMALLINT DEFAULT 1,
                first_name_show_ind SMALLINT DEFAULT 1,
                middle_name_show_ind SMALLINT DEFAULT 1,
                last_name_show_ind SMALLINT DEFAULT 1,
                suffix_show_ind SMALLINT DEFAULT 1,
                email_show_ind SMALLINT DEFAULT 1,
                url_show_ind SMALLINT DEFAULT 1,
                phone_show_ind SMALLINT DEFAULT 1,
                fax_show_ind SMALLINT DEFAULT 1,
                address_1_show_ind SMALLINT DEFAULT 1,
                address_2_show_ind SMALLINT DEFAULT 1,
                city_show_ind SMALLINT DEFAULT 1,
                state_show_ind SMALLINT DEFAULT 1,
                zip_show_ind SMALLINT DEFAULT 1,
                country_show_ind SMALLINT DEFAULT 1,
                resource_id BIGINT NOT NULL,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT user_preferred_names_pk PRIMARY KEY (id)
);


CREATE INDEX user_preferred_names_user_id_idx
 ON kmdata.user_preferred_names
 ( user_id );

CREATE SEQUENCE kmdata.user_roles_id_seq;

CREATE TABLE kmdata.user_roles (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.user_roles_id_seq'),
                user_id BIGINT NOT NULL,
                role_id BIGINT,
                CONSTRAINT user_roles_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.user_roles_id_seq OWNED BY kmdata.user_roles.id;

CREATE SEQUENCE kmdata.degree_certifications_id_seq;

CREATE TABLE kmdata.degree_certifications (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.degree_certifications_id_seq'),
                user_id BIGINT NOT NULL,
                institution_id BIGINT,
                degree_type_id BIGINT,
                resource_id BIGINT NOT NULL,
                title VARCHAR(255),
                start_year INTEGER,
                start_month INTEGER,
                end_year INTEGER,
                end_month INTEGER,
                cip_code_id INTEGER,
                area_of_study VARCHAR(255),
                terminal_ind SMALLINT,
                certifying_body_id BIGINT,
                subspecialty VARCHAR(255),
                license_number VARCHAR(255),
                npi VARCHAR(10),
                upin VARCHAR(6),
                medicaid VARCHAR(8),
                abbreviation VARCHAR(255),
                city VARCHAR(255),
                state VARCHAR(255),
                country VARCHAR(255),
                created_at TIMESTAMP,
                updated_at TIMESTAMP,
                CONSTRAINT degree_certifications_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.degree_certifications_id_seq OWNED BY kmdata.degree_certifications.id;

CREATE SEQUENCE kmdata.degree_certification_narratives_id_seq;

CREATE TABLE kmdata.degree_certification_narratives (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.degree_certification_narratives_id_seq'),
                degree_certification_id BIGINT NOT NULL,
                narrative_id BIGINT NOT NULL,
                CONSTRAINT degree_certification_narratives_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.degree_certification_narratives_id_seq OWNED BY kmdata.degree_certification_narratives.id;

CREATE SEQUENCE kmdata.user_narratives_id_seq;

CREATE TABLE kmdata.user_narratives (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.user_narratives_id_seq'),
                user_id BIGINT NOT NULL,
                narrative_id BIGINT NOT NULL,
                CONSTRAINT user_narratives_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.user_narratives_id_seq OWNED BY kmdata.user_narratives.id;

CREATE INDEX user_narratives_user_id_idx
 ON kmdata.user_narratives
 ( user_id );

CREATE INDEX user_narratives_narrative_id_idx
 ON kmdata.user_narratives
 ( narrative_id );

CREATE SEQUENCE kmdata.user_identifiers_id_seq;

CREATE TABLE kmdata.user_identifiers (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.user_identifiers_id_seq'),
                user_id BIGINT NOT NULL,
                emplid VARCHAR(11),
                inst_username VARCHAR(50),
                idm_id VARCHAR(255),
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT user_identifiers_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.user_identifiers_id_seq OWNED BY kmdata.user_identifiers.id;

CREATE INDEX user_identifiers_emplid_idx
 ON kmdata.user_identifiers
 ( emplid );

CREATE INDEX user_identifiers_inst_username_idx
 ON kmdata.user_identifiers
 ( inst_username );

CREATE UNIQUE INDEX user_identifiers_user_id_idx
 ON kmdata.user_identifiers
 ( user_id );

CREATE SEQUENCE kmdata.works_id_seq;

CREATE TABLE kmdata.works (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.works_id_seq'),
                parent_work_id BIGINT,
                resource_id BIGINT NOT NULL,
                work_type_id BIGINT,
                title VARCHAR(2000),
                user_id BIGINT NOT NULL,
                journal_article_type_id INTEGER,
                author_list VARCHAR(2000),
                editor_list VARCHAR(2000),
                reviewer_list VARCHAR(2000),
                article_title VARCHAR(1000),
                journal_title VARCHAR(1000),
                review_type_id INTEGER,
                edition VARCHAR(500),
                volume VARCHAR(255),
                issue VARCHAR(255),
                technical_report_number VARCHAR(255),
                submitted_to VARCHAR(255),
                submission_date TIMESTAMP,
                series VARCHAR(500),
                sponsor VARCHAR(255),
                beginning_page VARCHAR(255),
                ending_page VARCHAR(255),
                url VARCHAR(500),
                percent_authorship INTEGER,
                author_date_citation TEXT,
                bibliography_citation TEXT,
                research_report_citation TEXT,
                research_report_ind SMALLINT DEFAULT 0 NOT NULL,
                impact_factor NUMERIC,
                issn VARCHAR(255),
                publisher VARCHAR(255),
                publication_location VARCHAR(255),
                collection VARCHAR(255),
                site_last_viewed_date TIMESTAMP,
                publication_media_type_id INTEGER,
                status_id INTEGER,
                abstract_type_id INTEGER,
                peer_reviewed_ind SMALLINT,
                presentation_role_id INTEGER,
                presentation_location_descr VARCHAR(500),
                presentation_location_type_id INTEGER,
                audience_name VARCHAR(500),
                event_title VARCHAR(500),
                invited_talk INTEGER,
                publication_title VARCHAR(500),
                old_compiler VARCHAR(500),
                degree VARCHAR(255),
                acceptance_rate VARCHAR(50),
                role_id INTEGER,
                artist VARCHAR(255),
                composer VARCHAR(255),
                role_designator VARCHAR(1500),
                title_in VARCHAR(255),
                format VARCHAR(255),
                program_length VARCHAR(255),
                medium VARCHAR(255),
                dimensions VARCHAR(255),
                venue VARCHAR(500),
                forthcoming_id INTEGER,
                collector VARCHAR(255),
                artwork_id INTEGER,
                exhibit_title VARCHAR(255),
                exhibition_type_id INTEGER,
                juried_ind SMALLINT DEFAULT 0 NOT NULL,
                curator VARCHAR(255),
                audience VARCHAR(500),
                juror VARCHAR(255),
                inventor VARCHAR(255),
                invention_name VARCHAR(255),
                patent_number VARCHAR(255),
                manufacturer VARCHAR(255),
                format_id INTEGER,
                director VARCHAR(500),
                performer VARCHAR(500),
                network VARCHAR(255),
                distributor VARCHAR(255),
                station_call_number VARCHAR(255),
                duration VARCHAR(500),
                media_collection VARCHAR(255),
                volume_number INTEGER,
                participant VARCHAR(255),
                episode_title VARCHAR(500),
                recital_performance_type_id INTEGER,
                performance_company VARCHAR(255),
                writer VARCHAR(255),
                based_on VARCHAR(255),
                organizer VARCHAR(255),
                publication_yearborked VARCHAR(50),
                ad_location VARCHAR(255),
                event_location VARCHAR(255),
                other_info VARCHAR(255),
                people_served INTEGER,
                hours NUMERIC(9,2),
                direct_cost NUMERIC(9,2),
                other_audience VARCHAR(255),
                other_result VARCHAR(255),
                other_subject VARCHAR(255),
                publication_dmy_single_date_id BIGINT,
                submission_dmy_single_date_id BIGINT,
                presentation_dmy_range_date_id BIGINT,
                presentation_dmy_single_date_id BIGINT,
                performance_start_date TIMESTAMP,
                performance_end_date TIMESTAMP,
                performance_dmy_range_date_id BIGINT,
                exhibit_dmy_range_date_id BIGINT,
                filed_date TIMESTAMP,
                issued_date TIMESTAMP,
                filed_dmy_single_date_id BIGINT,
                creative_work_year BIGINT,
                issued_dmy_single_date_id BIGINT,
                last_update_dmy_single_date_id BIGINT,
                creation_dmy_single_date_id BIGINT,
                broadcast_date TIMESTAMP,
                broadcast_dmy_single_date_id BIGINT,
                disclosure_dmy_single_date_id BIGINT,
                outreach_dmy_range_date_id BIGINT,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                city VARCHAR(255),
                state VARCHAR(255),
                country VARCHAR(255),
                area VARCHAR(255),
                area_dimension_unit VARCHAR(255),
                diameter VARCHAR(255),
                dimension_flags VARCHAR(255),
                dimension_unit VARCHAR(255),
                height VARCHAR(255),
                volume_val VARCHAR(255),
                volume_dimension_unit VARCHAR(255),
                width VARCHAR(255),
                work_flags VARCHAR(255),
                overlay_flags VARCHAR(255),
                book_title VARCHAR(1000),
                isbn VARCHAR(255),
                lccn VARCHAR(255),
                sub_work_type_id BIGINT,
                book_author VARCHAR(255),
                sub_work_type_other VARCHAR(1000),
                journal_article_types_id INTEGER NOT NULL,
                publication_type_id BIGINT,
                citation_count BIGINT,
                CONSTRAINT works_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.works_id_seq OWNED BY kmdata.works.id;

CREATE SEQUENCE kmdata.textbooks_id_seq;

CREATE TABLE kmdata.textbooks (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.textbooks_id_seq'),
                work_id BIGINT,
                resource_id BIGINT NOT NULL,
                CONSTRAINT textbooks_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.textbooks_id_seq OWNED BY kmdata.textbooks.id;

CREATE SEQUENCE kmdata.section_textbooks_id_seq;

CREATE TABLE kmdata.section_textbooks (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.section_textbooks_id_seq'),
                section_id BIGINT NOT NULL,
                textbook_id BIGINT NOT NULL,
                CONSTRAINT section_textbooks_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.section_textbooks_id_seq OWNED BY kmdata.section_textbooks.id;

CREATE SEQUENCE kmdata.work_narratives_id_seq;

CREATE TABLE kmdata.work_narratives (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.work_narratives_id_seq'),
                work_id BIGINT NOT NULL,
                narrative_id BIGINT NOT NULL,
                CONSTRAINT work_narratives_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.work_narratives_id_seq OWNED BY kmdata.work_narratives.id;

CREATE INDEX work_narratives_work_id_idx
 ON kmdata.work_narratives
 ( work_id );

CREATE INDEX work_narratives_narrative_id_idx
 ON kmdata.work_narratives
 ( narrative_id );

CREATE SEQUENCE kmdata.work_authors_id_seq;

CREATE TABLE kmdata.work_authors (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.work_authors_id_seq'),
                work_id BIGINT NOT NULL,
                user_id BIGINT NOT NULL,
                CONSTRAINT work_authors_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.work_authors_id_seq OWNED BY kmdata.work_authors.id;

CREATE INDEX work_authors_work_id_idx
 ON kmdata.work_authors
 ( work_id );

CREATE INDEX work_authors_user_id_idx
 ON kmdata.work_authors
 ( user_id );

CREATE TABLE kmdata.outreach (
                id BIGINT NOT NULL,
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


CREATE SEQUENCE kmdata.work_locations_id_seq;

CREATE TABLE kmdata.work_locations (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.work_locations_id_seq'),
                work_id BIGINT NOT NULL,
                location_id BIGINT NOT NULL,
                CONSTRAINT work_locations_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.work_locations_id_seq OWNED BY kmdata.work_locations.id;

CREATE INDEX work_locations_work_id_idx
 ON kmdata.work_locations
 ( work_id );

CREATE INDEX work_locations_location_id_idx
 ON kmdata.work_locations
 ( location_id );

CREATE SEQUENCE kmdata.user_emails_id_seq;

CREATE TABLE kmdata.user_emails (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.user_emails_id_seq'),
                user_id BIGINT NOT NULL,
                email_type_id BIGINT NOT NULL,
                email VARCHAR(100),
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                resource_id BIGINT NOT NULL,
                CONSTRAINT user_emails_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.user_emails_id_seq OWNED BY kmdata.user_emails.id;

CREATE INDEX user_emails_alt_key_idx
 ON kmdata.user_emails
 ( user_id, email_type_id );

CREATE SEQUENCE kmdata.user_tracks_id_seq;

CREATE TABLE kmdata.user_tracks (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.user_tracks_id_seq'),
                user_id BIGINT NOT NULL,
                login_dt TIMESTAMP,
                logout_dt TIMESTAMP,
                login_mode VARCHAR(255),
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT user_tracks_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.user_tracks_id_seq OWNED BY kmdata.user_tracks.id;

CREATE SEQUENCE kmdata.user_logins_id_seq;

CREATE TABLE kmdata.user_logins (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.user_logins_id_seq'),
                user_id BIGINT NOT NULL,
                username VARCHAR(16) NOT NULL,
                encrypted_password VARCHAR(255) NOT NULL,
                salt VARCHAR(255) NOT NULL,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT user_logins_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.user_logins_id_seq OWNED BY kmdata.user_logins.id;

ALTER TABLE kmdata.group_categorizations ADD CONSTRAINT group_categories_group_categorizations_fk
FOREIGN KEY (group_category_id)
REFERENCES kmdata.group_categories (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

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

ALTER TABLE kmdata.group_memberships ADD CONSTRAINT groups_group_memberships_fk
FOREIGN KEY (group_id)
REFERENCES kmdata.groups (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.group_exclusions ADD CONSTRAINT groups_group_exclusions_fk
FOREIGN KEY (group_id)
REFERENCES kmdata.groups (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.group_categorizations ADD CONSTRAINT groups_group_categorizations_fk
FOREIGN KEY (group_id)
REFERENCES kmdata.groups (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

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

ALTER TABLE kmdata.user_emails ADD CONSTRAINT email_types_user_emails_fk
FOREIGN KEY (email_type_id)
REFERENCES kmdata.email_types (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.works ADD CONSTRAINT journal_article_types_works_fk
FOREIGN KEY (journal_article_type_id)
REFERENCES kmdata.journal_article_types (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_languages ADD CONSTRAINT language_proficiencies_user_languages_fk
FOREIGN KEY (reading_proficiency)
REFERENCES kmdata.language_proficiencies (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_languages ADD CONSTRAINT language_proficiencies_user_languages_fk1
FOREIGN KEY (speaking_proficiency)
REFERENCES kmdata.language_proficiencies (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_languages ADD CONSTRAINT language_proficiencies_user_languages_fk2
FOREIGN KEY (writing_proficiency)
REFERENCES kmdata.language_proficiencies (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_languages ADD CONSTRAINT language_dialects_user_languages_fk
FOREIGN KEY (dialect_id)
REFERENCES kmdata.language_dialects (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_languages ADD CONSTRAINT languages_user_languages_fk
FOREIGN KEY (language_id)
REFERENCES kmdata.languages (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.section_weekly_mtgs ADD CONSTRAINT day_of_wk_cds_section_weekly_mtgs_fk
FOREIGN KEY (day_of_wk_cd_id)
REFERENCES kmdata.day_of_wk_cds (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.sections ADD CONSTRAINT terms_sections_fk
FOREIGN KEY (term_id)
REFERENCES kmdata.terms (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

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

ALTER TABLE kmdata.user_addresses ADD CONSTRAINT address_types_user_addresses_fk
FOREIGN KEY (address_type_id)
REFERENCES kmdata.address_types (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_phones ADD CONSTRAINT phone_types_user_phones_fk
FOREIGN KEY (phone_type_id)
REFERENCES kmdata.phone_types (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.groups_legacy ADD CONSTRAINT group_categories_groups_fk
FOREIGN KEY (group_category_id)
REFERENCES kmdata.group_categories_legacy (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_preferred_keywords ADD CONSTRAINT keyterms_user_preferred_keywords_fk
FOREIGN KEY (expertise_keyterm_id)
REFERENCES kmdata.keyterms (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_preferred_keywords ADD CONSTRAINT keyterms_user_preferred_keywords_fk1
FOREIGN KEY (partners_keyterm_id)
REFERENCES kmdata.keyterms (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

/*
Warning: Column types mismatch in the following column mapping(s):
        id: BIGINT -- honor_type_id: INTEGER
*/
ALTER TABLE kmdata.user_honors_awards ADD CONSTRAINT honor_types_user_honors_awards_fk
FOREIGN KEY (honor_type_id)
REFERENCES kmdata.honor_types (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_services ADD CONSTRAINT service_units_user_service_fk
FOREIGN KEY (service_unit_id)
REFERENCES kmdata.service_units (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_services ADD CONSTRAINT service_role_modifiers_user_service_fk
FOREIGN KEY (service_role_modifier_id)
REFERENCES kmdata.service_role_modifiers (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_services ADD CONSTRAINT service_roles_user_service_fk
FOREIGN KEY (service_role_id)
REFERENCES kmdata.service_roles (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

/*
Warning: Column types mismatch in the following column mapping(s):
        id: BIGINT -- cip_code_id: INTEGER
*/
ALTER TABLE kmdata.degree_certifications ADD CONSTRAINT cip_codes_degree_certifications_fk
FOREIGN KEY (cip_code_id)
REFERENCES kmdata.cip_codes (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.degree_certifications ADD CONSTRAINT certifying_bodies_degree_certifications_fk
FOREIGN KEY (certifying_body_id)
REFERENCES kmdata.certifying_bodies (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.degree_types ADD CONSTRAINT degree_classes_degree_types_fk
FOREIGN KEY (degree_class_id)
REFERENCES kmdata.degree_classes (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.degree_certifications ADD CONSTRAINT degree_types_degree_certifications_fk
FOREIGN KEY (degree_type_id)
REFERENCES kmdata.degree_types (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.works ADD CONSTRAINT work_types_works_fk
FOREIGN KEY (work_type_id)
REFERENCES kmdata.work_types (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.resources ADD CONSTRAINT kmdata_tables_resources_fk
FOREIGN KEY (kmdata_table_id)
REFERENCES kmdata.kmdata_tables (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.works ADD CONSTRAINT dmy_range_dates_works_fk1
FOREIGN KEY (presentation_dmy_range_date_id)
REFERENCES kmdata.dmy_range_dates (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.works ADD CONSTRAINT dmy_range_dates_works_fk
FOREIGN KEY (performance_dmy_range_date_id)
REFERENCES kmdata.dmy_range_dates (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.works ADD CONSTRAINT dmy_range_dates_works_fk2
FOREIGN KEY (exhibit_dmy_range_date_id)
REFERENCES kmdata.dmy_range_dates (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.works ADD CONSTRAINT dmy_range_dates_works_fk3
FOREIGN KEY (outreach_dmy_range_date_id)
REFERENCES kmdata.dmy_range_dates (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.works ADD CONSTRAINT dmy_single_dates_works_fk
FOREIGN KEY (publication_dmy_single_date_id)
REFERENCES kmdata.dmy_single_dates (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.works ADD CONSTRAINT dmy_single_dates_works_fk1
FOREIGN KEY (submission_dmy_single_date_id)
REFERENCES kmdata.dmy_single_dates (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.works ADD CONSTRAINT dmy_single_dates_works_fk2
FOREIGN KEY (presentation_dmy_single_date_id)
REFERENCES kmdata.dmy_single_dates (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.works ADD CONSTRAINT dmy_single_dates_works_fk3
FOREIGN KEY (filed_dmy_single_date_id)
REFERENCES kmdata.dmy_single_dates (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.works ADD CONSTRAINT dmy_single_dates_works_fk4
FOREIGN KEY (issued_dmy_single_date_id)
REFERENCES kmdata.dmy_single_dates (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.works ADD CONSTRAINT dmy_single_dates_works_fk5
FOREIGN KEY (last_update_dmy_single_date_id)
REFERENCES kmdata.dmy_single_dates (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.works ADD CONSTRAINT dmy_single_dates_works_fk6
FOREIGN KEY (creation_dmy_single_date_id)
REFERENCES kmdata.dmy_single_dates (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.works ADD CONSTRAINT dmy_single_dates_works_fk7
FOREIGN KEY (broadcast_dmy_single_date_id)
REFERENCES kmdata.dmy_single_dates (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.works ADD CONSTRAINT dmy_single_dates_works_fk8
FOREIGN KEY (disclosure_dmy_single_date_id)
REFERENCES kmdata.dmy_single_dates (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.narratives ADD CONSTRAINT narrative_types_narratives_fk
FOREIGN KEY (narrative_type_id)
REFERENCES kmdata.narrative_types (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.resources ADD CONSTRAINT sources_resources_fk
FOREIGN KEY (source_id)
REFERENCES kmdata.sources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.locations ADD CONSTRAINT location_types_locations_fk
FOREIGN KEY (location_type_id)
REFERENCES kmdata.location_types (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_roles ADD CONSTRAINT roles_user_roles_fk
FOREIGN KEY (role_id)
REFERENCES kmdata.roles (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.work_locations ADD CONSTRAINT locations_work_locations_fk
FOREIGN KEY (location_id)
REFERENCES kmdata.locations (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.institutions ADD CONSTRAINT locations_institutions_fk
FOREIGN KEY (location_id)
REFERENCES kmdata.locations (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.campuses ADD CONSTRAINT locations_campus_fk
FOREIGN KEY (location_id)
REFERENCES kmdata.locations (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.buildings ADD CONSTRAINT locations_buildings_fk
FOREIGN KEY (location_id)
REFERENCES kmdata.locations (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.users ADD CONSTRAINT resources_persons_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.works ADD CONSTRAINT resources_works_fk1
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.narratives ADD CONSTRAINT resources_narratives_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.institutions ADD CONSTRAINT resources_institutions_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.degree_certifications ADD CONSTRAINT resources_degree_certifications_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_services ADD CONSTRAINT resources_user_service_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_honors_awards ADD CONSTRAINT resources_user_honors_awards_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.groups_legacy ADD CONSTRAINT resources_groups_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_appointments ADD CONSTRAINT resources_user_appointments_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_phones ADD CONSTRAINT resources_user_phones_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_addresses ADD CONSTRAINT resources_user_addresses_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.departments ADD CONSTRAINT resources_departments_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.campuses ADD CONSTRAINT resources_campus_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.colleges ADD CONSTRAINT resources_colleges_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.acad_departments ADD CONSTRAINT resources_departments_fk1
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.courses ADD CONSTRAINT resources_courses_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.offerings ADD CONSTRAINT resources_offerings_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.sections ADD CONSTRAINT resources_sections_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.enrollments ADD CONSTRAINT resources_enrollment_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.textbooks ADD CONSTRAINT resources_textbooks_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.course_syllabi ADD CONSTRAINT resources_course_syllabus_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.buildings ADD CONSTRAINT resources_buildings_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_positions ADD CONSTRAINT resources_user_positions_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.grant_data ADD CONSTRAINT resources_grant_data_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_languages ADD CONSTRAINT resources_user_languages_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_preferred_names ADD CONSTRAINT resources_user_preferred_names_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.editorial_activity ADD CONSTRAINT resources_editorial_activity_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.membership ADD CONSTRAINT resources_membership_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.professional_activity ADD CONSTRAINT resources_professional_activity_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.clinical_service ADD CONSTRAINT resources_clinical_service_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.clinical_trials ADD CONSTRAINT resources_clinical_trial_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.advising ADD CONSTRAINT resources_advising_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.strategic_initiatives ADD CONSTRAINT resources_strategic_initiatives_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.courses_taught ADD CONSTRAINT resources_course_taught_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.courses_taught_other ADD CONSTRAINT resources_courses_taught_other_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_emails ADD CONSTRAINT resources_user_emails_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.group_memberships ADD CONSTRAINT resources_group_memberships_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.group_exclusions ADD CONSTRAINT resources_group_exclusions_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_grants ADD CONSTRAINT grant_data_user_grants_fk
FOREIGN KEY (grant_data_id)
REFERENCES kmdata.grant_data (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_groups ADD CONSTRAINT groups_user_groups_fk
FOREIGN KEY (group_id)
REFERENCES kmdata.groups_legacy (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_groups_nestings ADD CONSTRAINT groups_user_groups_nesting_fk
FOREIGN KEY (parent_id)
REFERENCES kmdata.groups_legacy (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_groups_nestings ADD CONSTRAINT groups_user_groups_nesting_fk1
FOREIGN KEY (group_id)
REFERENCES kmdata.groups_legacy (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_group_permissions ADD CONSTRAINT groups_user_group_permissions_fk
FOREIGN KEY (group_id)
REFERENCES kmdata.groups_legacy (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.group_excluded_users ADD CONSTRAINT groups_group_excluded_users_fk
FOREIGN KEY (group_id)
REFERENCES kmdata.groups_legacy (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.degree_certifications ADD CONSTRAINT institution_degree_certifications_fk
FOREIGN KEY (institution_id)
REFERENCES kmdata.institutions (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_services ADD CONSTRAINT institutions_user_service_fk
FOREIGN KEY (institution_id)
REFERENCES kmdata.institutions (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_honors_awards ADD CONSTRAINT institutions_user_honors_awards_fk
FOREIGN KEY (institution_id)
REFERENCES kmdata.institutions (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.campuses ADD CONSTRAINT institutions_campuses_fk
FOREIGN KEY (institution_id)
REFERENCES kmdata.institutions (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_positions ADD CONSTRAINT institutions_user_positions_fk
FOREIGN KEY (institution_id)
REFERENCES kmdata.institutions (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.advising ADD CONSTRAINT institutions_advising_fk
FOREIGN KEY (institution_id)
REFERENCES kmdata.institutions (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.strategic_initiatives ADD CONSTRAINT institutions_strategic_initiatives_fk
FOREIGN KEY (institution_id)
REFERENCES kmdata.institutions (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.courses_taught ADD CONSTRAINT institutions_courses_taught_fk
FOREIGN KEY (institution_id)
REFERENCES kmdata.institutions (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.courses_taught_other ADD CONSTRAINT institutions_courses_taught_other_fk
FOREIGN KEY (institution_id)
REFERENCES kmdata.institutions (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.colleges ADD CONSTRAINT campus_colleges_fk
FOREIGN KEY (campus_id)
REFERENCES kmdata.campuses (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.buildings ADD CONSTRAINT campuses_buildings_fk
FOREIGN KEY (campus_id)
REFERENCES kmdata.campuses (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.section_weekly_mtgs ADD CONSTRAINT buildings_section_weekly_mtgs_fk
FOREIGN KEY (building_id)
REFERENCES kmdata.buildings (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.acad_departments ADD CONSTRAINT colleges_departments_fk
FOREIGN KEY (college_id)
REFERENCES kmdata.colleges (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.courses ADD CONSTRAINT departments_courses_fk
FOREIGN KEY (acad_department_id)
REFERENCES kmdata.acad_departments (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.offerings ADD CONSTRAINT courses_offerings_fk
FOREIGN KEY (course_id)
REFERENCES kmdata.courses (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.course_syllabi ADD CONSTRAINT courses_course_syllabus_fk
FOREIGN KEY (course_id)
REFERENCES kmdata.courses (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.sections ADD CONSTRAINT offerings_sections_fk
FOREIGN KEY (offering_id)
REFERENCES kmdata.offerings (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.enrollments ADD CONSTRAINT sections_enrollment_fk
FOREIGN KEY (section_id)
REFERENCES kmdata.sections (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.section_textbooks ADD CONSTRAINT sections_section_textbooks_fk
FOREIGN KEY (section_id)
REFERENCES kmdata.sections (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.section_weekly_mtgs ADD CONSTRAINT sections_section_weekly_mtgs_fk
FOREIGN KEY (section_id)
REFERENCES kmdata.sections (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.work_narratives ADD CONSTRAINT narratives_work_narratives_fk
FOREIGN KEY (narrative_id)
REFERENCES kmdata.narratives (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_narratives ADD CONSTRAINT narratives_user_narratives_fk
FOREIGN KEY (narrative_id)
REFERENCES kmdata.narratives (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.degree_certification_narratives ADD CONSTRAINT narratives_degree_certification_narratives_fk
FOREIGN KEY (narrative_id)
REFERENCES kmdata.narratives (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_service_narratives ADD CONSTRAINT narratives_user_service_narratives_fk
FOREIGN KEY (narrative_id)
REFERENCES kmdata.narratives (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_honors_awards_narratives ADD CONSTRAINT narratives_user_honors_awards_narratives_fk
FOREIGN KEY (narrative_id)
REFERENCES kmdata.narratives (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_logins ADD CONSTRAINT users_user_logins_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_tracks ADD CONSTRAINT users_user_tracks_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_emails ADD CONSTRAINT users_user_emails_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.works ADD CONSTRAINT users_works_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_identifiers ADD CONSTRAINT users_user_identifiers_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.work_authors ADD CONSTRAINT users_work_authors_fk1
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_narratives ADD CONSTRAINT users_user_narratives_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.degree_certifications ADD CONSTRAINT users_degree_certifications_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_roles ADD CONSTRAINT users_user_roles_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_preferred_names ADD CONSTRAINT users_user_preferred_name_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_preferred_appointments ADD CONSTRAINT users_user_preferred_appointment_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_preferred_keywords ADD CONSTRAINT users_user_preferred_keywords_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_services ADD CONSTRAINT users_user_service_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_honors_awards ADD CONSTRAINT users_user_honors_awards_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_groups ADD CONSTRAINT users_user_groups_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_group_permissions ADD CONSTRAINT users_user_group_permissions_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_individual_modify_permissions ADD CONSTRAINT users_user_individual_modify_permissions_fk
FOREIGN KEY (profile_user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_individual_modify_permissions ADD CONSTRAINT users_user_individual_modify_permissions_fk1
FOREIGN KEY (person_to_modify_user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_addresses ADD CONSTRAINT users_user_addresses_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_appointments ADD CONSTRAINT users_user_appointments_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_phones ADD CONSTRAINT users_user_phones_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.group_excluded_users ADD CONSTRAINT users_group_excluded_users_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.enrollments ADD CONSTRAINT users_enrollment_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_positions ADD CONSTRAINT users_user_positions_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_languages ADD CONSTRAINT users_user_languages_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_grants ADD CONSTRAINT users_user_grants_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.editorial_activity ADD CONSTRAINT users_editorial_activity_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.membership ADD CONSTRAINT users_membership_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.professional_activity ADD CONSTRAINT users_professional_activity_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.clinical_service ADD CONSTRAINT users_clinical_service_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.clinical_trials ADD CONSTRAINT users_clinical_trial_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.advising ADD CONSTRAINT users_advising_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.strategic_initiatives ADD CONSTRAINT users_strategic_initiatives_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.courses_taught ADD CONSTRAINT users_course_taught_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.courses_taught_other ADD CONSTRAINT users_courses_taught_other_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_honors_awards_narratives ADD CONSTRAINT user_honors_awards_user_honors_awards_narratives_fk
FOREIGN KEY (user_honors_awards_id)
REFERENCES kmdata.user_honors_awards (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_service_narratives ADD CONSTRAINT user_services_user_service_narratives_fk
FOREIGN KEY (user_service_id)
REFERENCES kmdata.user_services (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.degree_certification_narratives ADD CONSTRAINT degree_certifications_degree_certification_narratives_fk
FOREIGN KEY (degree_certification_id)
REFERENCES kmdata.degree_certifications (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.work_locations ADD CONSTRAINT works_work_locations_fk
FOREIGN KEY (work_id)
REFERENCES kmdata.works (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.outreach ADD CONSTRAINT works_outreach_fk
FOREIGN KEY (work_id)
REFERENCES kmdata.works (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.work_authors ADD CONSTRAINT works_work_authors_fk1
FOREIGN KEY (work_id)
REFERENCES kmdata.works (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.work_narratives ADD CONSTRAINT works_work_narratives_fk
FOREIGN KEY (work_id)
REFERENCES kmdata.works (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.textbooks ADD CONSTRAINT works_textbooks_fk
FOREIGN KEY (work_id)
REFERENCES kmdata.works (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.section_textbooks ADD CONSTRAINT textbooks_section_textbooks_fk
FOREIGN KEY (textbook_id)
REFERENCES kmdata.textbooks (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;