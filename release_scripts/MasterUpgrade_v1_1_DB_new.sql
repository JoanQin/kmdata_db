
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

CREATE SEQUENCE kmdata.work_arch_types_id_seq;

CREATE TABLE kmdata.work_arch_types (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.work_arch_types_id_seq'),
                type_description VARCHAR(255) NOT NULL,
                CONSTRAINT work_arch_types_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.work_arch_types_id_seq OWNED BY kmdata.work_arch_types.id;

CREATE SEQUENCE kmdata.import_errors_id_seq;

CREATE TABLE kmdata.import_errors (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.import_errors_id_seq'),
                error_number VARCHAR(50),
                resource_id BIGINT,
                user_id BIGINT,
                message_varchar VARCHAR(4000),
                message_text TEXT,
                CONSTRAINT import_errors_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.import_errors_id_seq OWNED BY kmdata.import_errors.id;

CREATE SEQUENCE kmdata.creator_organizations_id_seq;

CREATE TABLE kmdata.creator_organizations (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.creator_organizations_id_seq'),
                vid INTEGER NOT NULL,
                nid INTEGER NOT NULL,
                earliestdate_value INTEGER,
                latestdate_value INTEGER,
                orgsource_value TEXT,
                org_history_value TEXT,
                CONSTRAINT creator_organizations_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.creator_organizations_id_seq OWNED BY kmdata.creator_organizations.id;

CREATE SEQUENCE kmdata.creator_individuals_id_seq;

CREATE TABLE kmdata.creator_individuals (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.creator_individuals_id_seq'),
                vid INTEGER NOT NULL,
                nid INTEGER NOT NULL,
                biographical_note_value TEXT,
                birthyear_value INTEGER,
                deathyear_value INTEGER,
                pseudonym_value TEXT,
                suffix_value TEXT,
                CONSTRAINT creator_individuals_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.creator_individuals_id_seq OWNED BY kmdata.creator_individuals.id;

CREATE SEQUENCE kmdata.work_credits_id_seq;

CREATE TABLE kmdata.work_credits (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.work_credits_id_seq'),
                vid INTEGER NOT NULL,
                nid INTEGER NOT NULL,
                workid_nid INTEGER,
                CONSTRAINT work_credits_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.work_credits_id_seq OWNED BY kmdata.work_credits.id;

CREATE SEQUENCE kmdata.locations_ksa_id_seq;

CREATE TABLE kmdata.locations_ksa (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.locations_ksa_id_seq'),
                vid INTEGER NOT NULL,
                nid INTEGER NOT NULL,
                latitude_value NUMERIC(10,6),
                longitude_value NUMERIC(10,6),
                parentlocation_nid INTEGER,
                CONSTRAINT locations_ksa_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.locations_ksa_id_seq OWNED BY kmdata.locations_ksa.id;

CREATE SEQUENCE kmdata.publication_type_refs_id_seq;

CREATE TABLE kmdata.publication_type_refs (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.publication_type_refs_id_seq'),
                publication_type_descr VARCHAR(255) NOT NULL,
                CONSTRAINT publication_type_refs_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.publication_type_refs_id_seq OWNED BY kmdata.publication_type_refs.id;

CREATE SEQUENCE kmdata.creative_work_type_refs_id_seq;

CREATE TABLE kmdata.creative_work_type_refs (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.creative_work_type_refs_id_seq'),
                creative_work_type_descr VARCHAR(255) NOT NULL,
                CONSTRAINT creative_work_type_refs_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.creative_work_type_refs_id_seq OWNED BY kmdata.creative_work_type_refs.id;

CREATE SEQUENCE kmdata.sources_id_seq;

CREATE TABLE kmdata.sources (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.sources_id_seq'),
                source_name VARCHAR(255) NOT NULL,
                CONSTRAINT sources_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.sources_id_seq OWNED BY kmdata.sources.id;

CREATE SEQUENCE kmdata.user_appointments_id_seq;

CREATE TABLE kmdata.user_appointments (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.user_appointments_id_seq'),
                CONSTRAINT user_appointments_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.user_appointments_id_seq OWNED BY kmdata.user_appointments.id;

CREATE SEQUENCE kmdata.user_phones_id_seq;

CREATE TABLE kmdata.user_phones (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.user_phones_id_seq'),
                CONSTRAINT user_phones_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.user_phones_id_seq OWNED BY kmdata.user_phones.id;

CREATE SEQUENCE kmdata.user_addresses_id_seq;

CREATE TABLE kmdata.user_addresses (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.user_addresses_id_seq'),
                CONSTRAINT user_addresses_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.user_addresses_id_seq OWNED BY kmdata.user_addresses.id;

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

CREATE SEQUENCE kmdata.works_old_id_seq;

CREATE TABLE kmdata.works_old (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.works_old_id_seq'),
                creator_id INTEGER NOT NULL,
                creator_as_role INTEGER NOT NULL,
                publish_date TIMESTAMP,
                title VARCHAR(2000) NOT NULL,
                CONSTRAINT works_old_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.works_old_id_seq OWNED BY kmdata.works_old.id;

CREATE SEQUENCE kmdata.units_id_seq;

CREATE TABLE kmdata.units (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.units_id_seq'),
                CONSTRAINT units_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.units_id_seq OWNED BY kmdata.units.id;

CREATE SEQUENCE kmdata.departments_id_seq;

CREATE TABLE kmdata.departments (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.departments_id_seq'),
                CONSTRAINT departments_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.departments_id_seq OWNED BY kmdata.departments.id;

CREATE SEQUENCE kmdata.locations_id_seq;

CREATE TABLE kmdata.locations (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.locations_id_seq'),
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


ALTER SEQUENCE kmdata.locations_id_seq OWNED BY kmdata.locations.id;

CREATE SEQUENCE kmdata.privileges_id_seq;

CREATE TABLE kmdata.privileges (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.privileges_id_seq'),
                CONSTRAINT privileges_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.privileges_id_seq OWNED BY kmdata.privileges.id;

CREATE SEQUENCE kmdata.groups_id_seq;

CREATE TABLE kmdata.groups (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.groups_id_seq'),
                CONSTRAINT groups_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.groups_id_seq OWNED BY kmdata.groups.id;

CREATE SEQUENCE kmdata.resources_id_seq;

CREATE TABLE kmdata.resources (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.resources_id_seq'),
                source_id BIGINT NOT NULL,
                kmdata_table_id BIGINT,
                CONSTRAINT resources_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.resources_id_seq OWNED BY kmdata.resources.id;

CREATE SEQUENCE kmdata.institutions_id_seq;

CREATE TABLE kmdata.institutions (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.institutions_id_seq'),
                pro_id BIGINT NOT NULL,
                college_university_code VARCHAR(255),
                name VARCHAR(500),
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

CREATE SEQUENCE kmdata.offerings_id_seq;

CREATE TABLE kmdata.offerings (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.offerings_id_seq'),
                term_id VARCHAR(4) NOT NULL,
                session_id VARCHAR(50) NOT NULL,
                component_id VARCHAR(50) NOT NULL,
                class_section VARCHAR(50) NOT NULL,
                associated_class_section VARCHAR(50) NOT NULL,
                class_number VARCHAR(50) NOT NULL,
                resource_id BIGINT NOT NULL,
                CONSTRAINT offerings_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.offerings_id_seq OWNED BY kmdata.offerings.id;

CREATE SEQUENCE kmdata.courses_id_seq;

CREATE TABLE kmdata.courses (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.courses_id_seq'),
                course_id VARCHAR(5) NOT NULL,
                course_offer_number INTEGER NOT NULL,
                catalog_number VARCHAR(255) NOT NULL,
                subject_id VARCHAR(255) NOT NULL,
                campus_id VARCHAR(50) NOT NULL,
                resource_id BIGINT NOT NULL,
                CONSTRAINT courses_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.courses_id_seq OWNED BY kmdata.courses.id;

CREATE SEQUENCE kmdata.users_id_seq;

CREATE TABLE kmdata.users (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.users_id_seq'),
                uuid VARCHAR(50) NOT NULL,
                open_id VARCHAR(50),
                last_name VARCHAR(50),
                first_name VARCHAR(50),
                middle_name VARCHAR(50),
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                resource_id BIGINT NOT NULL,
                CONSTRAINT users_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.users_id_seq OWNED BY kmdata.users.id;

CREATE TABLE kmdata.user_honors_awards (
                id BIGINT NOT NULL,
                user_id BIGINT NOT NULL,
                resource_id BIGINT NOT NULL,
                honor_type_id INTEGER NOT NULL,
                name VARCHAR(500),
                monetary_component_ind SMALLINT,
                monetary_amount INTEGER,
                fellow_ind SMALLINT DEFAULT 0 NOT NULL,
                internal_ind SMALLINT DEFAULT 1 NOT NULL,
                institution_id BIGINT,
                sponsor VARCHAR(500),
                subject VARCHAR(500),
                start_year VARCHAR,
                end_year INTEGER,
                CONSTRAINT user_honors_awards_pk PRIMARY KEY (id)
);


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
                CONSTRAINT user_services_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.user_services_id_seq OWNED BY kmdata.user_services.id;

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

CREATE SEQUENCE kmdata.user_preferred_names_id_seq;

CREATE TABLE kmdata.user_preferred_names (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.user_preferred_names_id_seq'),
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
                create_date TIMESTAMP NOT NULL,
                modified_date TIMESTAMP NOT NULL,
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
                CONSTRAINT user_preferred_names_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.user_preferred_names_id_seq OWNED BY kmdata.user_preferred_names.id;

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
                institution_id BIGINT NOT NULL,
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

CREATE SEQUENCE kmdata.user_identifiers_id_seq;

CREATE TABLE kmdata.user_identifiers (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.user_identifiers_id_seq'),
                user_id BIGINT NOT NULL,
                emplid VARCHAR(11),
                name_dot_number VARCHAR(50),
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT user_identifiers_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.user_identifiers_id_seq OWNED BY kmdata.user_identifiers.id;

CREATE INDEX user_identifiers_emplid_idx
 ON kmdata.user_identifiers
 ( emplid );

CREATE INDEX user_identifiers_name_dot_number_idx
 ON kmdata.user_identifiers
 ( name_dot_number );

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
                CONSTRAINT works_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.works_id_seq OWNED BY kmdata.works.id;

CREATE SEQUENCE kmdata.work_narratives_id_seq;

CREATE TABLE kmdata.work_narratives (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.work_narratives_id_seq'),
                work_id BIGINT NOT NULL,
                narrative_id BIGINT NOT NULL,
                CONSTRAINT work_narratives_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.work_narratives_id_seq OWNED BY kmdata.work_narratives.id;

CREATE SEQUENCE kmdata.work_authors_id_seq;

CREATE TABLE kmdata.work_authors (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.work_authors_id_seq'),
                work_id BIGINT NOT NULL,
                user_id BIGINT NOT NULL,
                CONSTRAINT work_authors_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.work_authors_id_seq OWNED BY kmdata.work_authors.id;

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

CREATE SEQUENCE kmdata.creative_works_id_seq;

CREATE TABLE kmdata.creative_works (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.creative_works_id_seq'),
                work_id BIGINT NOT NULL,
                creative_work_type_id BIGINT NOT NULL,
                artist VARCHAR(255),
                composer VARCHAR(255),
                event_title VARCHAR(500),
                role_designator VARCHAR(1500),
                title VARCHAR(500),
                title_in VARCHAR(255),
                format VARCHAR(255),
                program_length VARCHAR(255),
                medium VARCHAR(255),
                dimensions VARCHAR(255),
                series VARCHAR(255),
                city VARCHAR(255),
                state VARCHAR(255),
                country VARCHAR(255),
                sponsor VARCHAR(500),
                venue VARCHAR(500),
                url VARCHAR(500),
                forthcoming_id INTEGER,
                percent_authorship INTEGER,
                description TEXT,
                author_date_citation TEXT,
                bibliography_citation TEXT,
                edition VARCHAR(500),
                volume VARCHAR(255),
                publisher VARCHAR(255),
                collector VARCHAR(255),
                collection VARCHAR(255),
                artwork_id INTEGER,
                exhibit_title VARCHAR(255),
                exhibition_type_id INTEGER,
                juried_ind SMALLINT DEFAULT 0 NOT NULL,
                curator VARCHAR(255),
                audience VARCHAR(500),
                juror VARCHAR(255),
                piece_description VARCHAR(500),
                inventor VARCHAR(255),
                name VARCHAR(255),
                patent_number VARCHAR(255),
                manufacturer VARCHAR(255),
                format_id INTEGER,
                director VARCHAR(500),
                performer VARCHAR(500),
                network VARCHAR(255),
                distributor VARCHAR(255),
                station_call_number VARCHAR(255),
                author VARCHAR(500),
                duration VARCHAR(500),
                media_collection VARCHAR(255),
                publication_location VARCHAR(255),
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
                beginning_page VARCHAR(50),
                ending_page VARCHAR(50),
                event_location VARCHAR(255),
                publication_title VARCHAR(255),
                other_info VARCHAR(255),
                CONSTRAINT creative_works_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.creative_works_id_seq OWNED BY kmdata.creative_works.id;

CREATE SEQUENCE kmdata.creative_work_date_collections_id_seq;

CREATE TABLE kmdata.creative_work_date_collections (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.creative_work_date_collections_id_seq'),
                creative_work_id BIGINT NOT NULL,
                presentation_year INTEGER,
                presentation_month INTEGER,
                presentation_day INTEGER,
                presentation_end_year INTEGER,
                presentation_end_month INTEGER,
                presentation_end_day INTEGER,
                performance_start_date TIMESTAMP,
                performance_end_date TIMESTAMP,
                performance_start_year INTEGER,
                performance_start_month INTEGER,
                performance_start_day INTEGER,
                performance_end_year INTEGER,
                performance_end_month INTEGER,
                performance_end_day INTEGER,
                exhibit_start_year INTEGER,
                exhibit_start_month INTEGER,
                exhibit_start_day INTEGER,
                exhibit_end_year INTEGER,
                exhibit_end_month INTEGER,
                exhibit_end_day INTEGER,
                filed_date TIMESTAMP,
                issued_date TIMESTAMP,
                filed_year INTEGER,
                filed_month INTEGER,
                filed_day INTEGER,
                year SMALLINT,
                issued_year INTEGER,
                issued_month INTEGER,
                issued_day INTEGER,
                publication_year INTEGER,
                publication_month INTEGER,
                publication_day INTEGER,
                presentation_start_year INTEGER,
                presentation_start_month INTEGER,
                presentation_start_day INTEGER,
                last_update_year INTEGER,
                last_update_month INTEGER,
                last_update_day INTEGER,
                creation_year INTEGER,
                creation_month INTEGER,
                creation_day INTEGER,
                broadcast_date TIMESTAMP,
                broadcast_year INTEGER,
                broadcast_month INTEGER,
                broadcast_day INTEGER,
                disclosure_year INTEGER,
                disclosure_month INTEGER,
                disclosure_day INTEGER,
                CONSTRAINT creative_work_date_collections_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.creative_work_date_collections_id_seq OWNED BY kmdata.creative_work_date_collections.id;

CREATE SEQUENCE kmdata.work_arch_details_id_seq;

CREATE TABLE kmdata.work_arch_details (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.work_arch_details_id_seq'),
                work_id BIGINT NOT NULL,
                work_arch_type BIGINT NOT NULL,
                vid INTEGER NOT NULL,
                nid INTEGER NOT NULL,
                area_value INTEGER,
                area_dimensionunit_value INTEGER,
                diameter_value INTEGER,
                dimensionflags_value INTEGER,
                dimensionunit_value INTEGER,
                height_value INTEGER,
                location_nid INTEGER,
                measurementcomment_value TEXT,
                reference_value TEXT,
                releasestate_value TEXT,
                volume_value INTEGER,
                volume_dimensionunit_value INTEGER,
                width_value INTEGER,
                workflags_value INTEGER,
                workyear_value INTEGER,
                asset_data TEXT,
                url_value VARCHAR(2000),
                CONSTRAINT work_arch_details_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.work_arch_details_id_seq OWNED BY kmdata.work_arch_details.id;

CREATE INDEX work_arch_details_vid_nid_idx
 ON kmdata.work_arch_details
 ( vid, nid );

CREATE SEQUENCE kmdata.video_assets_id_seq;

CREATE TABLE kmdata.video_assets (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.video_assets_id_seq'),
                work_arch_detail_id BIGINT NOT NULL,
                vid INTEGER NOT NULL,
                nid INTEGER NOT NULL,
                video_url_value VARCHAR(255),
                CONSTRAINT video_assets_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.video_assets_id_seq OWNED BY kmdata.video_assets.id;

CREATE SEQUENCE kmdata.doc_assets_id_seq;

CREATE TABLE kmdata.doc_assets (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.doc_assets_id_seq'),
                work_arch_detail_id BIGINT NOT NULL,
                vid INTEGER NOT NULL,
                nid INTEGER NOT NULL,
                doc_data TEXT,
                CONSTRAINT doc_assets_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.doc_assets_id_seq OWNED BY kmdata.doc_assets.id;

CREATE SEQUENCE kmdata.work_3d_assets_id_seq;

CREATE TABLE kmdata.work_3d_assets (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.work_3d_assets_id_seq'),
                work_arch_detail_id BIGINT NOT NULL,
                vid INTEGER NOT NULL,
                nid INTEGER NOT NULL,
                work_3dfile_data TEXT,
                CONSTRAINT work_3d_assets_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.work_3d_assets_id_seq OWNED BY kmdata.work_3d_assets.id;

CREATE SEQUENCE kmdata.file_assets_id_seq;

CREATE TABLE kmdata.file_assets (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.file_assets_id_seq'),
                work_arch_detail_id BIGINT NOT NULL,
                vid INTEGER NOT NULL,
                nid INTEGER NOT NULL,
                file_data TEXT,
                CONSTRAINT file_assets_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.file_assets_id_seq OWNED BY kmdata.file_assets.id;

CREATE SEQUENCE kmdata.audio_assets_id_seq;

CREATE TABLE kmdata.audio_assets (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.audio_assets_id_seq'),
                work_arch_detail_id BIGINT NOT NULL,
                vid INTEGER NOT NULL,
                nid INTEGER NOT NULL,
                audio_data TEXT,
                CONSTRAINT audio_assets_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.audio_assets_id_seq OWNED BY kmdata.audio_assets.id;

CREATE SEQUENCE kmdata.media_assets_id_seq;

CREATE TABLE kmdata.media_assets (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.media_assets_id_seq'),
                work_arch_detail_id BIGINT NOT NULL,
                vid INTEGER NOT NULL,
                nid INTEGER NOT NULL,
                accessionnumber_value TEXT,
                originalmedianumber_value TEXT,
                overlayflags_value INTEGER,
                pathhint_value TEXT,
                CONSTRAINT media_assets_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.media_assets_id_seq OWNED BY kmdata.media_assets.id;

CREATE SEQUENCE kmdata.publications_id_seq;

CREATE TABLE kmdata.publications (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.publications_id_seq'),
                work_id BIGINT NOT NULL,
                publication_type_id BIGINT NOT NULL,
                journal_article_type_id INTEGER,
                publication_year INTEGER,
                publication_month INTEGER,
                publication_day INTEGER,
                author VARCHAR(2000),
                editor VARCHAR(2000),
                reviewer VARCHAR(2000),
                article_title VARCHAR(1000),
                journal_title VARCHAR(1000),
                review_type_id INTEGER,
                edition VARCHAR(500),
                volume VARCHAR(255),
                issue VARCHAR(255),
                technical_report_number VARCHAR(255),
                submitted_to VARCHAR(255),
                submission_date TIMESTAMP,
                city VARCHAR(255),
                state VARCHAR(255),
                country VARCHAR(255),
                series VARCHAR(500),
                sponsor VARCHAR(255),
                beginning_page VARCHAR(255),
                ending_page VARCHAR(255),
                url VARCHAR(500),
                percent_authorship INTEGER,
                description TEXT,
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
                submission_year INTEGER,
                submission_month INTEGER,
                submission_day INTEGER,
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
                presentation_start_year INTEGER,
                presentation_start_month INTEGER,
                presentation_start_day INTEGER,
                presentation_end_year INTEGER,
                presentation_end_month INTEGER,
                presentation_end_day INTEGER,
                role_id INTEGER,
                CONSTRAINT publications_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.publications_id_seq OWNED BY kmdata.publications.id;

CREATE INDEX publications_match_idx1
 ON kmdata.publications
 ( publication_type_id, publication_year, publication_month, publication_day, article_title, journal_title, city, state, country );

CREATE SEQUENCE kmdata.user_emails_id_seq;

CREATE TABLE kmdata.user_emails (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.user_emails_id_seq'),
                email VARCHAR(100),
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                user_id BIGINT NOT NULL,
                CONSTRAINT user_emails_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.user_emails_id_seq OWNED BY kmdata.user_emails.id;

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

CREATE SEQUENCE kmdata.publication_authors_id_seq;

CREATE TABLE kmdata.publication_authors (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.publication_authors_id_seq'),
                user_id BIGINT NOT NULL,
                publication_id BIGINT NOT NULL,
                CONSTRAINT publication_authors_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.publication_authors_id_seq OWNED BY kmdata.publication_authors.id;

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

ALTER TABLE kmdata.work_arch_details ADD CONSTRAINT work_arch_types_work_arch_details_fk
FOREIGN KEY (work_arch_type)
REFERENCES kmdata.work_arch_types (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.publications ADD CONSTRAINT publication_type_ref_publications_fk
FOREIGN KEY (publication_type_id)
REFERENCES kmdata.publication_type_refs (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.creative_works ADD CONSTRAINT creative_work_type_ref_creative_work_fk
FOREIGN KEY (creative_work_type_id)
REFERENCES kmdata.creative_work_type_refs (id)
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

ALTER TABLE kmdata.users ADD CONSTRAINT resources_persons_fk
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

ALTER TABLE kmdata.offerings ADD CONSTRAINT resources_classes_fk
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

ALTER TABLE kmdata.publication_authors ADD CONSTRAINT users_work_authors_fk
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

ALTER TABLE kmdata.publications ADD CONSTRAINT works_publications_fk
FOREIGN KEY (work_id)
REFERENCES kmdata.works (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.work_arch_details ADD CONSTRAINT works_work_arch_details_fk
FOREIGN KEY (work_id)
REFERENCES kmdata.works (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.creative_works ADD CONSTRAINT works_creative_work_fk
FOREIGN KEY (work_id)
REFERENCES kmdata.works (id)
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

ALTER TABLE kmdata.creative_work_date_collections ADD CONSTRAINT creative_work_creative_work_date_collection_fk
FOREIGN KEY (creative_work_id)
REFERENCES kmdata.creative_works (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.media_assets ADD CONSTRAINT work_arch_details_media_asset_fk
FOREIGN KEY (work_arch_detail_id)
REFERENCES kmdata.work_arch_details (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.audio_assets ADD CONSTRAINT work_arch_details_audio_asset_fk
FOREIGN KEY (work_arch_detail_id)
REFERENCES kmdata.work_arch_details (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.file_assets ADD CONSTRAINT work_arch_details_file_asset_fk
FOREIGN KEY (work_arch_detail_id)
REFERENCES kmdata.work_arch_details (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.work_3d_assets ADD CONSTRAINT work_arch_details_work_3d_asset_fk
FOREIGN KEY (work_arch_detail_id)
REFERENCES kmdata.work_arch_details (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.doc_assets ADD CONSTRAINT work_arch_details_doc_asset_fk
FOREIGN KEY (work_arch_detail_id)
REFERENCES kmdata.work_arch_details (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.video_assets ADD CONSTRAINT work_arch_details_video_asset_fk
FOREIGN KEY (work_arch_detail_id)
REFERENCES kmdata.work_arch_details (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.publication_authors ADD CONSTRAINT works_work_authors_fk
FOREIGN KEY (publication_id)
REFERENCES kmdata.publications (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;