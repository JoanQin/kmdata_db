-- THIS FILE STARTS AFTER EXCLUDED USERS HAS BEEN MOVED TO PRODUCTION

ALTER TABLE kmdata.narratives ALTER COLUMN user_id SET DEFAULT NULL;

ALTER TABLE kmdata.narratives DROP COLUMN user_id;

ALTER TABLE kmdata.import_errors ADD COLUMN message_when TIMESTAMP NOT NULL DEFAULT NOW();
 

--make pro inst ID on kmdata.institutions nullable
ALTER TABLE kmdata.institutions ALTER COLUMN pro_id DROP NOT NULL;

--make a function-based index on capitalizing institution name
CREATE INDEX institutions_name_to_upper_idx
  ON institutions
  USING btree
  (upper("name"));

  
-- add book title to the works table
ALTER TABLE kmdata.works ADD COLUMN book_title VARCHAR(1000);

-- add ISBN and LCCN
ALTER TABLE kmdata.works ADD COLUMN isbn VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN lccn VARCHAR(255);


-- DROP OLD TABLES
DROP TABLE kmdata.courses;
DROP TABLE kmdata.offerings;

DROP TABLE kmdata.publication_authors;
DROP TABLE kmdata.publications;
DROP TABLE kmdata.publication_type_refs;
DROP TABLE kmdata.works_old;

DROP TABLE kmdata.locations_ksa;
DROP TABLE kmdata.work_credits;
DROP TABLE kmdata.creator_individuals;
DROP TABLE kmdata.creator_organizations;

DROP TABLE kmdata.media_assets;
DROP TABLE kmdata.audio_assets;
DROP TABLE kmdata.file_assets;
DROP TABLE kmdata.work_3d_assets;
DROP TABLE kmdata.doc_assets;
DROP TABLE kmdata.video_assets;
DROP TABLE kmdata.work_arch_details;
DROP TABLE kmdata.work_arch_types;

DROP TABLE kmdata.creative_work_date_collections;
DROP TABLE kmdata.creative_works;
DROP TABLE kmdata.creative_work_type_refs;

-- side note: Before dropping tables, there were 86 tables and 84 sequences in kmdata_prod.kmdata. Now there are 65 tables and 63 sequences.

-- ADD IDM ID TO user_identifiers

-- ADD kmdata.user_positions
CREATE SEQUENCE kmdata.user_positions_user_id_seq;

CREATE TABLE kmdata.user_positions (
                id BIGINT NOT NULL,
                user_id BIGINT NOT NULL DEFAULT nextval('kmdata.user_positions_user_id_seq'),
                business_name VARCHAR(500),
                city VARCHAR(255),
                country VARCHAR(255),
                current_ind SMALLINT DEFAULT 0 NOT NULL,
                description TEXT,
                division VARCHAR(500),
                started_dmy_single_date_id BIGINT,
                ended_dmy_single_date_id BIGINT,
                higher_ed_college VARCHAR(500),
                institution_id BIGINT,
                higher_ed_department VARCHAR(500),
                higher_ed_position_title VARCHAR(300),
                higher_ed_school VARCHAR(300),
                institute VARCHAR(500),
                unit VARCHAR(500),
                percent_time INTEGER DEFAULT 100 NOT NULL,
                position_title VARCHAR(300),
                position_type VARCHAR(255),
                state VARCHAR(255),
                subject_area VARCHAR(255),
                resource_id BIGINT NOT NULL,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT user_positions_pk PRIMARY KEY (id)
);
COMMENT ON COLUMN kmdata.user_positions.institute IS 'new RIV attribute';
COMMENT ON COLUMN kmdata.user_positions.position_type IS 'Maps to research in view position type. <No Data> : (Faculty, 1), (Administration, 2), (Fellowship, 3), (Clerkship, 4), (Internship, 5), (Residency, 6), (Graduate Student, 7), (Rsearcher, 8), (Other, 9)
';

ALTER SEQUENCE kmdata.user_positions_user_id_seq OWNED BY kmdata.user_positions.user_id;

ALTER TABLE kmdata.user_positions ADD CONSTRAINT resources_user_positions_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_positions ADD CONSTRAINT institutions_user_positions_fk
FOREIGN KEY (institution_id)
REFERENCES kmdata.institutions (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_positions ADD CONSTRAINT users_user_positions_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- add degrees and certifications
ALTER TABLE kmdata.degree_certifications ADD COLUMN created_at TIMESTAMP DEFAULT current_timestamp;
ALTER TABLE kmdata.degree_certifications ADD COLUMN updated_at TIMESTAMP DEFAULT current_timestamp;


-- add grants
CREATE SEQUENCE kmdata.grant_data_id_seq;

CREATE TABLE kmdata.grant_data (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.grant_data_id_seq'),
                grant_type_id INTEGER NOT NULL,
                status_id INTEGER NOT NULL,
                title VARCHAR(1000),
                role_id INTEGER NOT NULL,
                originating_contract VARCHAR(255),
                principal_inverstigator VARCHAR(255),
                co_investigator VARCHAR(255),
                source VARCHAR(500),
                agency VARCHAR(255),
                priority_score VARCHAR(255),
                amount_funded INTEGER,
                direct_cost INTEGER,
                goal TEXT,
                description TEXT,
                other_contributors TEXT,
                percent_effort INTEGER,
                identifier VARCHAR(255),
                grant_number VARCHAR(255),
                award_number VARCHAR(255),
                explanation_of_role VARCHAR(2000),
                start_date TIMESTAMP,
                end_date TIMESTAMP,
                start_year INTEGER,
                start_month INTEGER,
                start_day INTEGER,
                end_year INTEGER,
                end_month INTEGER,
                end_day INTEGER,
                grant_identifier VARCHAR(255),
                output_text TEXT,
                submitted_year INTEGER,
                submitted_month INTEGER,
                submitted_day INTEGER,
                denied_year INTEGER,
                denied_month INTEGER,
                denied_day INTEGER,
                resource_id BIGINT NOT NULL,
                CONSTRAINT grant_data_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.grant_data_id_seq OWNED BY kmdata.grant_data.id;

ALTER TABLE kmdata.grant_data ADD CONSTRAINT resources_grant_data_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- add to licensure
ALTER TABLE kmdata.degree_certifications ADD COLUMN city VARCHAR(255);
ALTER TABLE kmdata.degree_certifications ADD COLUMN state VARCHAR(255);
ALTER TABLE kmdata.degree_certifications ADD COLUMN country VARCHAR(255);

-- add RIV foreign languages

CREATE TABLE researchinview.riv_foreign_languages (
                id BIGINT NOT NULL,
                name VARCHAR(2000),
                CONSTRAINT riv_foreign_languages_pk PRIMARY KEY (id)
);


CREATE TABLE researchinview.riv_lookups (
                lookup_id INTEGER NOT NULL,
                lookup_name VARCHAR(255) NOT NULL,
                lookup_value INTEGER NOT NULL,
                CONSTRAINT riv_lookups_pk PRIMARY KEY (lookup_id, lookup_name)
);



CREATE TABLE researchinview.riv_lookup_xml (
                lookup_Id INTEGER NOT NULL,
                lookup_name VARCHAR(255) NOT NULL,
                xml_content TEXT NOT NULL,
                CONSTRAINT riv_lookup_xml_pk PRIMARY KEY (lookup_Id)
);



CREATE SEQUENCE researchinview.excluded_pro_users_id_seq;

CREATE TABLE researchinview.excluded_pro_users (
                id BIGINT NOT NULL DEFAULT nextval('researchinview.excluded_pro_users_id_seq'),
                emplid VARCHAR(11) NOT NULL,
                CONSTRAINT excluded_pro_users_pk PRIMARY KEY (id)
);


ALTER SEQUENCE researchinview.excluded_pro_users_id_seq OWNED BY researchinview.excluded_pro_users.id;


CREATE INDEX excluded_pro_users_emplid_idx
 ON researchinview.excluded_pro_users
 ( emplid );

 

CREATE TABLE researchinview.riv_dialects (
                id BIGINT NOT NULL,
                name VARCHAR(2000),
                CONSTRAINT riv_dialects_pk PRIMARY KEY (id)
);


-- KMDATA LANGUAGE TABLES
 
CREATE TABLE kmdata.languages (
                id BIGINT NOT NULL,
                name VARCHAR(255) NOT NULL,
                CONSTRAINT languages_pk PRIMARY KEY (id)
);

CREATE TABLE kmdata.language_dialects (
                id BIGINT NOT NULL,
                name VARCHAR(255) NOT NULL,
                CONSTRAINT language_dialects_pk PRIMARY KEY (id)
);

CREATE TABLE kmdata.language_proficiencies (
                id BIGINT NOT NULL,
                name VARCHAR(255) NOT NULL,
                CONSTRAINT language_proficiencies_pk PRIMARY KEY (id)
);


CREATE SEQUENCE kmdata.user_languages_id_seq;

CREATE TABLE kmdata.user_languages (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.user_languages_id_seq'),
                language_id BIGINT NOT NULL,
                dialect_id BIGINT NOT NULL,
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

ALTER TABLE kmdata.user_languages ADD CONSTRAINT resources_user_languages_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_languages ADD CONSTRAINT users_user_languages_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


-- update user languages
ALTER TABLE kmdata.user_languages ALTER COLUMN dialect_id DROP NOT NULL;


-- update kmdata.user_preferred_names
ALTER TABLE kmdata.user_preferred_names ADD COLUMN resource_id BIGINT NOT NULL;
ALTER TABLE kmdata.user_preferred_names ADD COLUMN created_at TIMESTAMP NOT NULL;
ALTER TABLE kmdata.user_preferred_names ADD COLUMN updated_at TIMESTAMP NOT NULL;

ALTER TABLE kmdata.user_preferred_names ADD CONSTRAINT resources_user_preferred_names_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_preferred_names DROP COLUMN create_date;
ALTER TABLE kmdata.user_preferred_names DROP COLUMN modified_date;


-- grants additions
CREATE SEQUENCE kmdata.user_grants_id_seq;

CREATE TABLE kmdata.user_grants (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.user_grants_id_seq'),
                user_id BIGINT NOT NULL,
                grant_data_id BIGINT NOT NULL,
                CONSTRAINT user_grants_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.user_grants_id_seq OWNED BY kmdata.user_grants.id;

ALTER TABLE kmdata.user_grants ADD CONSTRAINT grant_data_user_grants_fk
FOREIGN KEY (grant_data_id)
REFERENCES kmdata.grant_data (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_grants ADD CONSTRAINT users_user_grants_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


-- change principal investigator from principal_inverstigator to principal_investigator
ALTER TABLE kmdata.grant_data RENAME COLUMN principal_inverstigator TO principal_investigator;

ALTER TABLE kmdata.grant_data ADD COLUMN created_at TIMESTAMP NOT NULL DEFAULT current_timestamp;
ALTER TABLE kmdata.grant_data ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT current_timestamp;


ALTER TABLE kmdata.grant_data ALTER COLUMN role_id DROP NOT NULL;
ALTER TABLE kmdata.grant_data ALTER COLUMN status_id DROP NOT NULL;
ALTER TABLE kmdata.grant_data ALTER COLUMN grant_type_id DROP NOT NULL;


-- membership and editorial activity
CREATE SEQUENCE kmdata.membership_id_seq;

CREATE TABLE kmdata.membership (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.membership_id_seq'),
                user_id BIGINT NOT NULL,
                organization_name VARCHAR(500),
                organization_city VARCHAR(255),
                organization_state VARCHAR(255),
                organization_country VARCHAR(255),
                group_name VARCHAR(500),
                membership_role_id INTEGER NOT NULL,
                membership_role_modifier_id INTEGER NOT NULL,
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

ALTER TABLE kmdata.membership ADD CONSTRAINT resources_membership_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.membership ADD CONSTRAINT users_membership_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

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
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                CONSTRAINT editorial_activity_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.editorial_activity_id_seq OWNED BY kmdata.editorial_activity.id;

ALTER TABLE kmdata.editorial_activity ADD CONSTRAINT resources_editorial_activity_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.editorial_activity ADD CONSTRAINT users_editorial_activity_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;



--   https://buckeyepass.osu.edu/RSASWE/WXUserRequestToken.do

