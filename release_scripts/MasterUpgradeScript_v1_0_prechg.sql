-- insert new location types
INSERT INTO kmdata.location_types (name, created_at, updated_at) VALUES ('Country', current_timestamp, current_timestamp);
INSERT INTO kmdata.location_types (name, created_at, updated_at) VALUES ('State', current_timestamp, current_timestamp);
INSERT INTO kmdata.location_types (name, created_at, updated_at) VALUES ('County', current_timestamp, current_timestamp);
INSERT INTO kmdata.location_types (name, created_at, updated_at) VALUES ('School District', current_timestamp, current_timestamp);
INSERT INTO kmdata.location_types (name, created_at, updated_at) VALUES ('City', current_timestamp, current_timestamp);
INSERT INTO kmdata.location_types (name, created_at, updated_at) VALUES ('Subdivision', current_timestamp, current_timestamp);
INSERT INTO kmdata.location_types (name, created_at, updated_at) VALUES ('Street Address', current_timestamp, current_timestamp);
INSERT INTO kmdata.location_types (name, created_at, updated_at) VALUES ('Congressional District', current_timestamp, current_timestamp);
INSERT INTO kmdata.location_types (name, created_at, updated_at) VALUES ('Undefined', current_timestamp, current_timestamp);

-- add kmdata.kmdata_tables and constraints
CREATE SEQUENCE kmdata.kmdata_tables_id_seq;

CREATE TABLE kmdata.kmdata_tables (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.kmdata_tables_id_seq'),
                table_name VARCHAR(255) NOT NULL,
                CONSTRAINT kmdata_tables_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.kmdata_tables_id_seq OWNED BY kmdata.kmdata_tables.id;


-- modify kdmata.resources and add constraints
ALTER TABLE kmdata.resources ADD COLUMN kmdata_table_id BIGINT;

ALTER TABLE kmdata.resources ADD CONSTRAINT kmdata_tables_resources_fk
FOREIGN KEY (kmdata_table_id)
REFERENCES kmdata.kmdata_tables (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- add kmdata.work_types
CREATE SEQUENCE kmdata.work_types_id_seq;

CREATE TABLE kmdata.work_types (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.work_types_id_seq'),
                work_type_name VARCHAR(255) NOT NULL,
                CONSTRAINT work_types_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.work_types_id_seq OWNED BY kmdata.work_types.id;


-- add new fields to kmdata.works
ALTER TABLE kmdata.works ADD COLUMN parent_work_id BIGINT;
ALTER TABLE kmdata.works ADD COLUMN work_type_id BIGINT;
ALTER TABLE kmdata.works ADD COLUMN journal_article_type_id INTEGER;
ALTER TABLE kmdata.works ADD COLUMN author_list VARCHAR(2000);
ALTER TABLE kmdata.works ADD COLUMN editor_list VARCHAR(2000);
ALTER TABLE kmdata.works ADD COLUMN reviewer_list VARCHAR(2000);
ALTER TABLE kmdata.works ADD COLUMN article_title VARCHAR(1000);
ALTER TABLE kmdata.works ADD COLUMN journal_title VARCHAR(1000);
ALTER TABLE kmdata.works ADD COLUMN review_type_id INTEGER;
ALTER TABLE kmdata.works ADD COLUMN edition VARCHAR(500);
ALTER TABLE kmdata.works ADD COLUMN volume VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN issue VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN technical_report_number VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN submitted_to VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN submission_date TIMESTAMP;
ALTER TABLE kmdata.works ADD COLUMN series VARCHAR(500);
ALTER TABLE kmdata.works ADD COLUMN sponsor VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN beginning_page VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN ending_page VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN url VARCHAR(500);
ALTER TABLE kmdata.works ADD COLUMN percent_authorship INTEGER;
ALTER TABLE kmdata.works ADD COLUMN author_date_citation TEXT;
ALTER TABLE kmdata.works ADD COLUMN bibliography_citation TEXT;
ALTER TABLE kmdata.works ADD COLUMN research_report_citation TEXT;
ALTER TABLE kmdata.works ADD COLUMN research_report_ind SMALLINT DEFAULT 0 NOT NULL;
ALTER TABLE kmdata.works ADD COLUMN impact_factor NUMERIC;
ALTER TABLE kmdata.works ADD COLUMN issn VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN publisher VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN publication_location VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN collection VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN site_last_viewed_date TIMESTAMP;
ALTER TABLE kmdata.works ADD COLUMN publication_media_type_id INTEGER;
ALTER TABLE kmdata.works ADD COLUMN status_id INTEGER;
ALTER TABLE kmdata.works ADD COLUMN abstract_type_id INTEGER;
ALTER TABLE kmdata.works ADD COLUMN peer_reviewed_ind SMALLINT;
ALTER TABLE kmdata.works ADD COLUMN presentation_role_id INTEGER;
ALTER TABLE kmdata.works ADD COLUMN presentation_location_descr VARCHAR(500);
ALTER TABLE kmdata.works ADD COLUMN presentation_location_type_id INTEGER;
ALTER TABLE kmdata.works ADD COLUMN audience_name VARCHAR(500);
ALTER TABLE kmdata.works ADD COLUMN event_title VARCHAR(500);
ALTER TABLE kmdata.works ADD COLUMN invited_talk INTEGER;
ALTER TABLE kmdata.works ADD COLUMN publication_title VARCHAR(500);
ALTER TABLE kmdata.works ADD COLUMN old_compiler VARCHAR(500);
ALTER TABLE kmdata.works ADD COLUMN degree VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN acceptance_rate VARCHAR(50);
ALTER TABLE kmdata.works ADD COLUMN role_id INTEGER;
ALTER TABLE kmdata.works ADD COLUMN artist VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN composer VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN role_designator VARCHAR(1500);
ALTER TABLE kmdata.works ADD COLUMN title_in VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN format VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN program_length VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN medium VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN dimensions VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN venue VARCHAR(500);
ALTER TABLE kmdata.works ADD COLUMN forthcoming_id INTEGER;
ALTER TABLE kmdata.works ADD COLUMN collector VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN artwork_id INTEGER;
ALTER TABLE kmdata.works ADD COLUMN exhibit_title VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN exhibition_type_id INTEGER;
ALTER TABLE kmdata.works ADD COLUMN juried_ind SMALLINT DEFAULT 0 NOT NULL;
ALTER TABLE kmdata.works ADD COLUMN curator VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN audience VARCHAR(500);
ALTER TABLE kmdata.works ADD COLUMN juror VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN inventor VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN invention_name VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN patent_number VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN manufacturer VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN format_id INTEGER;
ALTER TABLE kmdata.works ADD COLUMN director VARCHAR(500);
ALTER TABLE kmdata.works ADD COLUMN performer VARCHAR(500);
ALTER TABLE kmdata.works ADD COLUMN network VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN distributor VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN station_call_number VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN duration VARCHAR(500);
ALTER TABLE kmdata.works ADD COLUMN media_collection VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN volume_number INTEGER;
ALTER TABLE kmdata.works ADD COLUMN participant VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN episode_title VARCHAR(500);
ALTER TABLE kmdata.works ADD COLUMN recital_performance_type_id INTEGER;
ALTER TABLE kmdata.works ADD COLUMN performance_company VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN writer VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN based_on VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN organizer VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN publication_yearborked VARCHAR(50);
ALTER TABLE kmdata.works ADD COLUMN ad_location VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN event_location VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN other_info VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN people_served INTEGER;
ALTER TABLE kmdata.works ADD COLUMN hours NUMERIC(9,2);
ALTER TABLE kmdata.works ADD COLUMN direct_cost NUMERIC(9,2);
ALTER TABLE kmdata.works ADD COLUMN other_audience VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN other_result VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN other_subject VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN publication_dmy_single_date_id BIGINT;
ALTER TABLE kmdata.works ADD COLUMN submission_dmy_single_date_id BIGINT;
ALTER TABLE kmdata.works ADD COLUMN presentation_dmy_range_date_id BIGINT;
ALTER TABLE kmdata.works ADD COLUMN presentation_dmy_single_date_id BIGINT;
ALTER TABLE kmdata.works ADD COLUMN performance_start_date TIMESTAMP;
ALTER TABLE kmdata.works ADD COLUMN performance_end_date TIMESTAMP;
ALTER TABLE kmdata.works ADD COLUMN performance_dmy_range_date_id BIGINT;
ALTER TABLE kmdata.works ADD COLUMN exhibit_dmy_range_date_id BIGINT;
ALTER TABLE kmdata.works ADD COLUMN filed_date TIMESTAMP;
ALTER TABLE kmdata.works ADD COLUMN issued_date TIMESTAMP;
ALTER TABLE kmdata.works ADD COLUMN filed_dmy_single_date_id BIGINT;
ALTER TABLE kmdata.works ADD COLUMN creative_work_year BIGINT;
ALTER TABLE kmdata.works ADD COLUMN issued_dmy_single_date_id BIGINT;
ALTER TABLE kmdata.works ADD COLUMN last_update_dmy_single_date_id BIGINT;
ALTER TABLE kmdata.works ADD COLUMN creation_dmy_single_date_id BIGINT;
ALTER TABLE kmdata.works ADD COLUMN broadcast_date TIMESTAMP;
ALTER TABLE kmdata.works ADD COLUMN broadcast_dmy_single_date_id BIGINT;
ALTER TABLE kmdata.works ADD COLUMN disclosure_dmy_single_date_id BIGINT;
ALTER TABLE kmdata.works ADD COLUMN outreach_dmy_range_date_id BIGINT;

-- add kmdata.work_locations
CREATE SEQUENCE kmdata.work_locations_id_seq;

CREATE TABLE kmdata.work_locations (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.work_locations_id_seq'),
                work_id BIGINT NOT NULL,
                location_id BIGINT NOT NULL,
                CONSTRAINT work_locations_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.work_locations_id_seq OWNED BY kmdata.work_locations.id;

ALTER TABLE kmdata.work_locations ADD CONSTRAINT locations_work_locations_fk
FOREIGN KEY (location_id)
REFERENCES kmdata.locations (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.work_locations ADD CONSTRAINT works_work_locations_fk
FOREIGN KEY (work_id)
REFERENCES kmdata.works (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


-- add kmdata.work_authors
CREATE SEQUENCE kmdata.work_authors_id_seq;

CREATE TABLE kmdata.work_authors (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.work_authors_id_seq'),
                work_id BIGINT NOT NULL,
                user_id BIGINT NOT NULL,
                CONSTRAINT work_authors_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.work_authors_id_seq OWNED BY kmdata.work_authors.id;

ALTER TABLE kmdata.work_authors ADD CONSTRAINT users_work_authors_fk1
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.work_authors ADD CONSTRAINT works_work_authors_fk1
FOREIGN KEY (work_id)
REFERENCES kmdata.works (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


-- add kmdata.user_narratives
CREATE SEQUENCE kmdata.user_narratives_id_seq;

CREATE TABLE kmdata.user_narratives (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.user_narratives_id_seq'),
                user_id BIGINT NOT NULL,
                narrative_id BIGINT NOT NULL,
                CONSTRAINT user_narratives_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.user_narratives_id_seq OWNED BY kmdata.user_narratives.id;

ALTER TABLE kmdata.user_narratives ADD CONSTRAINT narratives_user_narratives_fk
FOREIGN KEY (narrative_id)
REFERENCES kmdata.narratives (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_narratives ADD CONSTRAINT users_user_narratives_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


-- populate kmdata.user_narratives using legacy kmdata.narrative.user_id
INSERT INTO kmdata.user_narratives
	(user_id, narrative_id)
SELECT user_id, id
	FROM kmdata.narratives;

-- add kmdata.work_narratives
CREATE SEQUENCE kmdata.work_narratives_id_seq;

CREATE TABLE kmdata.work_narratives (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.work_narratives_id_seq'),
                work_id BIGINT NOT NULL,
                narrative_id BIGINT NOT NULL,
                CONSTRAINT work_narratives_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.work_narratives_id_seq OWNED BY kmdata.work_narratives.id;

ALTER TABLE kmdata.work_narratives ADD CONSTRAINT narratives_work_narratives_fk
FOREIGN KEY (narrative_id)
REFERENCES kmdata.narratives (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.work_narratives ADD CONSTRAINT works_work_narratives_fk
FOREIGN KEY (work_id)
REFERENCES kmdata.works (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


-- add fields to kmdata.locations
ALTER TABLE kmdata.locations ADD COLUMN geotype_id VARCHAR(255);
ALTER TABLE kmdata.locations ADD COLUMN name VARCHAR(1000);
ALTER TABLE kmdata.locations ADD COLUMN abbreviation VARCHAR(100);

-- kmdata.narrative_types will need to grow dynamically with load procedures

-- add kmdata.dmy_single_dates
CREATE SEQUENCE kmdata.dmy_single_dates_id_seq;

CREATE TABLE kmdata.dmy_single_dates (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.dmy_single_dates_id_seq'),
                day INTEGER,
                month INTEGER,
                year BIGINT NOT NULL,
                CONSTRAINT dmy_single_dates_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.dmy_single_dates_id_seq OWNED BY kmdata.dmy_single_dates.id;


-- add kmdata.dmy_range_dates
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


-- add resource ID to narratives
ALTER TABLE kmdata.narratives ADD COLUMN resource_id BIGINT;

-- backfill kmdata.resources for tables that had resource_id's (now all tables will have them).
-- Tables that were populated allowing for this step:  users, works, offerings, narratives, courses; NOT import_errors
INSERT INTO kmdata.kmdata_tables (table_name) VALUES ('users');
INSERT INTO kmdata.kmdata_tables (table_name) VALUES ('works');
INSERT INTO kmdata.kmdata_tables (table_name) VALUES ('offerings');
INSERT INTO kmdata.kmdata_tables (table_name) VALUES ('narratives');
INSERT INTO kmdata.kmdata_tables (table_name) VALUES ('courses');

UPDATE kmdata.resources SET kmdata_table_id = (SELECT id FROM kmdata.kmdata_tables WHERE table_name = 'users') WHERE id IN (SELECT resource_id FROM kmdata.users);
UPDATE kmdata.resources SET kmdata_table_id = (SELECT id FROM kmdata.kmdata_tables WHERE table_name = 'works') WHERE id IN (SELECT resource_id FROM kmdata.works);
UPDATE kmdata.resources SET kmdata_table_id = (SELECT id FROM kmdata.kmdata_tables WHERE table_name = 'offerings') WHERE id IN (SELECT resource_id FROM kmdata.offerings);
UPDATE kmdata.resources SET kmdata_table_id = (SELECT id FROM kmdata.kmdata_tables WHERE table_name = 'narratives') WHERE id IN (SELECT resource_id FROM kmdata.narratives);
UPDATE kmdata.resources SET kmdata_table_id = (SELECT id FROM kmdata.kmdata_tables WHERE table_name = 'courses') WHERE id IN (SELECT resource_id FROM kmdata.courses);

-- check for nulls that we may have not covered from the resource table updates
SELECT t.table_name, COUNT(*) AS Total FROM kmdata.resources r LEFT JOIN kmdata.kmdata_tables t ON r.kmdata_table_id = t.id GROUP BY t.table_name;

-- add remaining constraints, mostly on kmdata.works to other tables
ALTER TABLE kmdata.works ADD CONSTRAINT work_types_works_fk
FOREIGN KEY (work_type_id)
REFERENCES kmdata.work_types (id)
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

-- WE MAY NEED TO DELETE 1 FK CONSTRAINT ON KMDATA.WORKS due to legacy user_id, if we abandon that

-- create date procedures to pass in the 3 field or 6 fields for dates and return the id to be inserted. will be called inline.
CREATE OR REPLACE FUNCTION kmdata.add_dmy_single_date (
   p_Day INTEGER,
   p_Month INTEGER,
   p_Year BIGINT
) RETURNS BIGINT AS $$
DECLARE
   v_DateID BIGINT := 0;
BEGIN
   -- select the  next sequence value
   v_DateID := nextval('kmdata.dmy_single_dates_id_seq');

   -- insert the single date
   INSERT INTO kmdata.dmy_single_dates
      (id, day, month, year)
   VALUES
      (v_DateID, p_Day, p_Month, p_Year);

   -- return the sequence value
   RETURN v_DateID;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION kmdata.add_dmy_range_date (
   p_StartDay INTEGER,
   p_StartMonth INTEGER,
   p_StartYear BIGINT,
   p_EndDay INTEGER,
   p_EndMonth INTEGER,
   p_EndYear BIGINT
) RETURNS BIGINT AS $$
DECLARE
   v_DateID BIGINT := 0;
BEGIN
   -- select the  next sequence value
   v_DateID := nextval('kmdata.dmy_range_dates_id_seq');

   -- insert the single date
   INSERT INTO kmdata.dmy_range_dates
      (id, start_day, start_month, start_year, end_day, end_month, end_year)
   VALUES
      (v_DateID, p_StartDay, p_StartMonth, p_StartYear, p_EndDay, p_EndMonth, p_EndYear);

   -- return the sequence value
   RETURN v_DateID;
END;
$$ LANGUAGE plpgsql;


-- create a locations procedure that will check and return or create a new location and return the location back to the works procedure or other calling code
--CREATE OR REPLACE FUNCTION kmdata.get_or_add_location_id IN SEPARATE FILE
--CREATE OR REPLACE FUNCTION kmdata.get_or_add_kmdata_table_id
--CREATE OR REPLACE FUNCTION kmdata.get_or_add_source_id

-- call PL/pgSQL script to populate kmdata.works with Outreach data from osupro, with inserts into locations
SELECT kmdata.processoutreachphase1(); -- 53295 ms
SELECT kmdata.fix_duplicate_location_names();

-- fill kmdata.work_authors using legacy kmdata.publication_authors
INSERT INTO kmdata.work_authors (work_id, user_id)
   SELECT p.work_id, pa.user_id
   FROM kmdata.publications p
   INNER JOIN kmdata.publication_authors pa ON p.id = pa.publication_id;

-- geo information tables
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


CREATE SEQUENCE kmdata.county_congressional_districts_id_seq;

CREATE TABLE kmdata.county_congressional_districts (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.county_congressional_districts_id_seq'),
                state_geotype_id VARCHAR(255),
                county_geotype_id VARCHAR(255),
                congressional_district_2010_geotype_id VARCHAR(255),
                CONSTRAINT county_congressional_districts_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.county_congressional_districts_id_seq OWNED BY kmdata.county_congressional_districts.id;


-- RUN KETTLE JOBS FOR CENSUS LOCATION INFORMATION!!!

-- update the ohio count
SELECT kmdata.fix_ohio_counties();




-- load states and places
CREATE SEQUENCE kmdata.states_id_seq;

CREATE TABLE kmdata.states (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.states_id_seq'),
                geoid VARCHAR(255),
                state VARCHAR(8000),
                abbreviation VARCHAR(50),
                CONSTRAINT states_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.states_id_seq OWNED BY kmdata.states.id;
ALTER TABLE kmdata.states OWNER TO kmd_app_user;

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
ALTER TABLE kmdata.places OWNER TO kmd_app_user;


CREATE INDEX states_geoid_idx
 ON kmdata.states
 ( geoid );


-- create tables/indexes/constraints for:
-- institutions, degree_certifications, degree_certification_narratives, degree_classes, degree_types, cip_codes, certifying_bodies

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
ALTER TABLE kmdata.institutions OWNER TO kmd_app_user;

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
ALTER TABLE kmdata.degree_certifications OWNER TO kmd_app_user;

CREATE SEQUENCE kmdata.degree_certification_narratives_id_seq;

CREATE TABLE kmdata.degree_certification_narratives (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.degree_certification_narratives_id_seq'),
                degree_certification_id BIGINT NOT NULL,
                narrative_id BIGINT NOT NULL,
                CONSTRAINT degree_certification_narratives_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.degree_certification_narratives_id_seq OWNED BY kmdata.degree_certification_narratives.id;
ALTER TABLE kmdata.degree_certification_narratives OWNER TO kmd_app_user;

CREATE SEQUENCE kmdata.degree_classes_id_seq;

CREATE TABLE kmdata.degree_classes (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.degree_classes_id_seq'),
                classification VARCHAR(50) NOT NULL,
                CONSTRAINT degree_classes_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.degree_classes_id_seq OWNED BY kmdata.degree_classes.id;
ALTER TABLE kmdata.degree_classes OWNER TO kmd_app_user;

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
ALTER TABLE kmdata.degree_types OWNER TO kmd_app_user;

CREATE SEQUENCE kmdata.cip_codes_id_seq;

CREATE TABLE kmdata.cip_codes (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.cip_codes_id_seq'),
                code VARCHAR(3),
                definition VARCHAR(255),
                CONSTRAINT cip_codes_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.cip_codes_id_seq OWNED BY kmdata.cip_codes.id;
ALTER TABLE kmdata.cip_codes OWNER TO kmd_app_user;

CREATE SEQUENCE kmdata.certifying_bodies_id_seq;

CREATE TABLE kmdata.certifying_bodies (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.certifying_bodies_id_seq'),
                certifying_body VARCHAR(255) NOT NULL,
                CONSTRAINT certifying_bodies_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.certifying_bodies_id_seq OWNED BY kmdata.certifying_bodies.id;
ALTER TABLE kmdata.certifying_bodies OWNER TO kmd_app_user;

ALTER TABLE kmdata.institutions ADD CONSTRAINT locations_institutions_fk
FOREIGN KEY (location_id)
REFERENCES kmdata.locations (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.institutions ADD CONSTRAINT resources_institutions_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

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

ALTER TABLE kmdata.degree_certifications ADD CONSTRAINT degree_types_degree_certifications_fk
FOREIGN KEY (degree_type_id)
REFERENCES kmdata.degree_types (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.degree_certifications ADD CONSTRAINT resources_degree_certifications_fk
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

ALTER TABLE kmdata.degree_certifications ADD CONSTRAINT users_degree_certifications_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.degree_certification_narratives ADD CONSTRAINT narratives_degree_certification_narratives_fk
FOREIGN KEY (narrative_id)
REFERENCES kmdata.narratives (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.degree_certification_narratives ADD CONSTRAINT degree_certifications_degree_certification_narratives_fk
FOREIGN KEY (degree_certification_id)
REFERENCES kmdata.degree_certifications (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.degree_types ADD CONSTRAINT degree_classes_degree_types_fk
FOREIGN KEY (degree_class_id)
REFERENCES kmdata.degree_classes (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;



-- import states
SELECT kmdata.import_states();

-- import places - ~15 minutes
SELECT kmdata.import_places();


-- populate degrees/certifications ref tables
-- step 1
INSERT INTO kmdata.degree_classes (classification)
   SELECT classification FROM osupro.degree_class_ref;

-- step 2
INSERT INTO kmdata.degree_types (description_abbreviation, transcript_abbreviation, degree_description, degree_class_id)
   SELECT a.description_abbreviation, a.transcript_abbreviation, a.degree_description, c.id
   FROM osupro.degree_type_ref a
   LEFT JOIN osupro.degree_class_ref b ON a.class_id = b.id
   LEFT JOIN kmdata.degree_classes c ON b.classification = c.classification;

-- step 3
INSERT INTO kmdata.cip_codes (code, definition)
   SELECT code, definition FROM osupro.cip_code_ref;

-- step 4
INSERT INTO kmdata.certifying_bodies (certifying_body)
   SELECT certifying_body FROM osupro.certification_certifying_body_ref;

-- create struct for roles

ALTER TABLE kmdata.roles ADD COLUMN name VARCHAR(255) NOT NULL;

CREATE SEQUENCE kmdata.user_roles_id_seq;

CREATE TABLE kmdata.user_roles (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.user_roles_id_seq'),
                user_id BIGINT NOT NULL,
                role_id BIGINT,
                CONSTRAINT user_roles_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.user_roles_id_seq OWNED BY kmdata.user_roles.id;

ALTER TABLE kmdata.user_roles ADD CONSTRAINT roles_user_roles_fk
FOREIGN KEY (role_id)
REFERENCES kmdata.roles (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_roles ADD CONSTRAINT users_user_roles_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


-- process institutions
SELECT kmdata.import_institutions();
SELECT kmdata.import_degrees_and_certifications();
   
-- BACKFILL USER_ROLES, ROLES FOR ASSISTANT PROFESSOR OR PROFESSOR

-- RUN ETL FOR APPOINTMENTS AND USER_APPOINTMENTS IF NECESSARY

INSERT INTO kmdata.roles (name)
   SELECT DISTINCT description
   FROM osupro.appointment_title_ref
   WHERE description LIKE '%Professor%' OR description LIKE '%Faculty%';

INSERT INTO kmdata.user_roles (user_id, role_id)
   SELECT DISTINCT d.user_id, c.id
   FROM osupro.user_appointments a
   INNER JOIN osupro.appointment_title_ref b ON a.job_code = b.jobcode
   INNER JOIN kmdata.roles c ON b.description = c.name
   INNER JOIN kmdata.user_identifiers d ON a.profile_emplid = d.emplid
   WHERE c.name LIKE '%Professor%' OR c.name LIKE '%Faculty%';


-- OPTIONAL: backfill kmdata.publications using new date functions hitting the dmy tables
--DELAY

-- backfill Pro narratives with missing information
--** TITLES AND SUCH ***

-- update narratives and drop kmdata.narrative.user_id
ALTER TABLE kmdata.narratives DROP COLUMN user_id; --CASCADE
ALTER TABLE kmdata.narratives ALTER COLUMN resource_id SET NOT NULL;

