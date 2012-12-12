/*
Vedu,

This is what Doug would like displayed on his pages.

"The categories that should appear on the biosketch are:

Preferred Personal Information
Approach and Goals to Teaching Narrative
Service Section 6) Administrative Service a) Unit Committees, and b) College or University Committees.
Research Section 1) Published Works
Teaching Section 8) Awards for Teaching"

Let me know if you can tailor the feed for his needs.


Dan VonderBrink
Web Developer / Designer
Marketing & Communications
The Ohio State University Medical Center
660 Ackerman Road
ph: 614-366-8550
*/

CREATE INDEX location_county_ref_upper_county_idx ON osupro.location_county_ref (upper(county));

-- New upgrade script to move from script version 1.0 to 1.1

-- DATABASE STRUCTURE

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

ALTER TABLE kmdata.user_preferred_names ADD CONSTRAINT users_user_preferred_names_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

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

ALTER TABLE kmdata.user_preferred_appointments ADD CONSTRAINT users_user_preferred_appointments_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

CREATE SEQUENCE kmdata.user_preferred_keywords_id_seq;

CREATE TABLE kmdata.user_preferred_keywords (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.user_preferred_keywords_id_seq'),
                user_id BIGINT NOT NULL,
                expertise_keywords INTEGER,
                partners_keywords INTEGER,
                contact_ind SMALLINT DEFAULT 0,
                create_date TIMESTAMP NOT NULL,
                CONSTRAINT user_preferred_keywords_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.user_preferred_keywords_id_seq OWNED BY kmdata.user_preferred_keywords.id;

ALTER TABLE kmdata.user_preferred_keywords ADD CONSTRAINT users_user_preferred_keywords_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- ADMINISTRATRIVE SERVICE STRUCTURE

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

CREATE SEQUENCE kmdata.service_units_id_seq;

CREATE TABLE kmdata.service_units (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.service_units_id_seq'),
                unit VARCHAR(50) NOT NULL,
                CONSTRAINT service_units_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.service_units_id_seq OWNED BY kmdata.service_units.id;

CREATE SEQUENCE kmdata.service_roles_id_seq;

CREATE TABLE kmdata.service_roles (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.service_roles_id_seq'),
                role VARCHAR(255) NOT NULL,
                CONSTRAINT service_roles_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.service_roles_id_seq OWNED BY kmdata.service_roles.id;

CREATE SEQUENCE kmdata.service_role_modifiers_id_seq;

CREATE TABLE kmdata.service_role_modifiers (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.service_role_modifiers_id_seq'),
                modifier VARCHAR(255) NOT NULL,
                CONSTRAINT service_role_modifiers_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.service_role_modifiers_id_seq OWNED BY kmdata.service_role_modifiers.id;

-- HONORS AND AWARDS (AWARDS FOR TEACHING)
CREATE SEQUENCE kmdata.user_honors_awards_id_seq;

CREATE TABLE kmdata.user_honors_awards (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.user_honors_awards_id_seq'),
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
                selected VARCHAR(500),
                competitiveness VARCHAR(500),
                output_text TEXT,
                CONSTRAINT user_honors_awards_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.user_honors_awards_id_seq OWNED BY kmdata.user_honors_awards.id;


CREATE SEQUENCE kmdata.honor_types_id_seq;

CREATE TABLE kmdata.honor_types (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.honor_types_id_seq'),
                type VARCHAR(255) NOT NULL,
                CONSTRAINT honor_types_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.honor_types_id_seq OWNED BY kmdata.honor_types.id;


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

ALTER TABLE kmdata.user_services ADD CONSTRAINT resources_user_service_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_services ADD CONSTRAINT institutions_user_service_fk
FOREIGN KEY (institution_id)
REFERENCES kmdata.institutions (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_services ADD CONSTRAINT users_user_service_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_honors_awards ADD CONSTRAINT honor_types_user_honors_awards_fk
FOREIGN KEY (honor_type_id)
REFERENCES kmdata.honor_types (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_honors_awards ADD CONSTRAINT resources_user_honors_awards_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_honors_awards ADD CONSTRAINT users_user_honors_awards_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_honors_awards ADD CONSTRAINT institutions_user_honors_awards_fk
FOREIGN KEY (institution_id)
REFERENCES kmdata.institutions (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;



-- DATA LOADS

-- load preferred name
INSERT INTO kmdata.user_preferred_names
   (user_id, prefix, first_name, middle_name, last_name, suffix, preferred_publishing_name,
    email, fax, phone, address, address_2, city, state, zip, country, create_date, modified_date,
    subscribe, url, cip_area, cip_focus, prefix_show_ind, first_name_show_ind, middle_name_show_ind,
    last_name_show_ind, suffix_show_ind, email_show_ind, url_show_ind, phone_show_ind, fax_show_ind,
    address_1_show_ind, address_2_show_ind, city_show_ind, state_show_ind, zip_show_ind, country_show_ind)
SELECT b.user_id, a.prefix, a.first_name, a.middle_name, a.last_name, a.suffix, a.preferred_publishing_name,
    a.email, a.fax, a.phone, a.address, a.address_2, a.city, a.state, a.zip, a.country, a.create_date, a.modified_date,
    a.subscribe, a.url, a.cip_area, a.cip_focus, a.prefix_show_ind, a.first_name_show_ind, a.middle_name_show_ind,
    a.last_name_show_ind, a.suffix_show_ind, a.email_show_ind, a.url_show_ind, a.phone_show_ind, a.fax_show_ind,
    a.address_1_show_ind, a.address_2_show_ind, a.city_show_ind, a.state_show_ind, a.zip_show_ind, a.country_show_ind
FROM osupro.user_preferred_name a
INNER JOIN kmdata.user_identifiers b ON a.profile_emplid = b.emplid;

-- RUN USER PREFERRED APPOINTMENT KETTLE TRANSFORMATION
ALTER TABLE osupro.user_preferred_appointment ADD COLUMN department_id VARCHAR(50);

-- load preferred appointment
INSERT INTO kmdata.user_preferred_appointments
   (user_id, description, department_name, show_ind, create_date)
   SELECT b.user_id, a.description, a.department_name, a.show_ind, a.create_date
   FROM osupro.user_preferred_appointment a
   INNER JOIN kmdata.user_identifiers b ON a.profile_emplid = b.emplid;

-- load keyterms_ref
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

INSERT INTO kmdata.keyterms
   (faes_ind, emphasis_id, key_word, active_ind, order_no)
   SELECT faes_ind, emphasis_id, key_word, active_ind, order_no
   FROM osupro.keyterms_ref;

-- create user preferred keywords
   
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

ALTER TABLE kmdata.user_preferred_keywords ADD CONSTRAINT users_user_preferred_keywords_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


   
-- load preferred keywords
INSERT INTO kmdata.user_preferred_keywords
   (user_id, expertise_keyterm_id, partners_keyterm_id, contact_ind, create_date)
   SELECT b.user_id, MIN(d.id), MIN(f.id), a.contact_ind, a.create_date
   FROM osupro.user_preferred_keywords a
   INNER JOIN kmdata.user_identifiers b ON a.profile_emplid = b.emplid
   LEFT JOIN osupro.keyterms_ref c ON a.expertise_keywords = c.key_word_id
   LEFT JOIN kmdata.keyterms d ON c.key_word = d.key_word
   LEFT JOIN osupro.keyterms_ref e ON a.partners_keywords = e.key_word_id
   LEFT JOIN kmdata.keyterms f ON e.key_word = f.key_word
   GROUP BY b.user_id, a.contact_ind, a.create_date;


-- create kmdata.import_teaching_approach

SELECT kmdata.import_teaching_approach();

select count(*) from osupro.teaching_approach; -- 1322

SELECT id FROM kmdata.narrative_types WHERE narrative_desc = 'Approach & Goals to Teaching'; -- 29 is id

select count(*) from kmdata.narratives where narrative_type_id = 29; -- 0 is pre; 1318 is after; 14 was dev id


-- create services tables
CREATE SEQUENCE kmdata.user_service_narratives_id_seq;

CREATE TABLE kmdata.user_service_narratives (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.user_service_narratives_id_seq'),
                user_service_id BIGINT NOT NULL,
                narrative_id BIGINT NOT NULL,
                CONSTRAINT user_service_narratives_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.user_service_narratives_id_seq OWNED BY kmdata.user_service_narratives.id;

ALTER TABLE kmdata.user_service_narratives ADD CONSTRAINT narratives_user_service_narratives_fk
FOREIGN KEY (narrative_id)
REFERENCES kmdata.narratives (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_service_narratives ADD CONSTRAINT user_services_user_service_narratives_fk
FOREIGN KEY (user_service_id)
REFERENCES kmdata.user_services (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;



-- insert services

-- 10
INSERT INTO kmdata.service_units (unit)
   SELECT unit FROM osupro.administrative_service_unit_ref;

-- 28
INSERT INTO kmdata.service_roles (role)
   SELECT role FROM osupro.administrative_service_role_ref;

-- 24
INSERT INTO kmdata.service_role_modifiers (modifier)
   SELECT modifier FROM osupro.administrative_service_role_modifier_ref;

select count(*) from osupro.administrative_service; -- 12437; 22308 on prod
select count(*) from kmdata.user_services; -- 12351; 22183 on prod

SELECT kmdata.import_user_services(); -- 42 seconds; 34 on prod


-- update published works into works table
ALTER TABLE kmdata.works ADD COLUMN city VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN state VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN country VARCHAR(255);
ALTER TABLE kmdata.narratives ALTER COLUMN user_id DROP NOT NULL;
ALTER TABLE kmdata.dmy_single_dates ALTER COLUMN year DROP NOT NULL;

SELECT * FROM kmdata.work_types; -- pre: 1 (Outreach); post: 11

INSERT INTO kmdata.work_types (work_type_name)
   SELECT publication_type_descr FROM kmdata.publication_type_refs;

-- run the update
SELECT COUNT(*) FROM kmdata.works; -- pre: 160382; post: 160382;  PROD pre: 220066; post: 
SELECT COUNT(*) FROM kmdata.work_narratives WHERE work_id IN (SELECT work_id from kmdata.publications); -- pre: 0; post: 165588; PROD pre: 0; post: 

SELECT kmdata.transfer_publications(); -- 700 seconds/12 min; 1182 seconds/20 min


-- awards for teaching (honors and awards)

-- 6
INSERT INTO kmdata.honor_types (type)
   SELECT type FROM osupro.honor_type_ref;

SELECT COUNT(*) FROM osupro.honor_type_ref; -- 6
SELECT COUNT(*) FROM kmdata.honor_types; -- 6

-- create narratives table
CREATE SEQUENCE kmdata.user_honors_awards_narratives_id_seq;

CREATE TABLE kmdata.user_honors_awards_narratives (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.user_honors_awards_narratives_id_seq'),
                user_honors_awards_id BIGINT NOT NULL,
                narrative_id BIGINT NOT NULL,
                CONSTRAINT user_honors_awards_narratives_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.user_honors_awards_narratives_id_seq OWNED BY kmdata.user_honors_awards_narratives.id;

ALTER TABLE kmdata.user_honors_awards_narratives ADD CONSTRAINT narratives_user_honors_awards_narratives_fk
FOREIGN KEY (narrative_id)
REFERENCES kmdata.narratives (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_honors_awards_narratives ADD CONSTRAINT user_honors_awards_user_honors_awards_narratives_fk
FOREIGN KEY (user_honors_awards_id)
REFERENCES kmdata.user_honors_awards (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


-- process the teaching awards
SELECT COUNT(*) FROM osupro.honor; -- 21737; PROD 24849
SELECT COUNT(*) FROM kmdata.user_honors_awards; -- 21713; PROD 

SELECT kmdata.import_honors_and_awards(); -- 69 seconds; PROD 89 seconds


