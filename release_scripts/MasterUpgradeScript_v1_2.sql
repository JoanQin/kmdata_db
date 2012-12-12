 CREATE UNIQUE INDEX user_identifiers_user_id_idx
 ON kmdata.user_identifiers
 ( user_id );


CREATE INDEX ps_names_name_type_idx
 ON peoplesoft.ps_names
 ( name_type );

 
CREATE SEQUENCE kmdata.group_categories_id_seq;

CREATE TABLE kmdata.group_categories (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.group_categories_id_seq'),
                name VARCHAR(50) NOT NULL,
                CONSTRAINT group_categories_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.group_categories_id_seq OWNED BY kmdata.group_categories.id;

CREATE SEQUENCE kmdata.groups_id_seq;

CREATE TABLE kmdata.groups (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.groups_id_seq'),
                name VARCHAR(255) NOT NULL,
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
                CONSTRAINT groups_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.groups_id_seq OWNED BY kmdata.groups.id;

ALTER TABLE kmdata.groups ADD CONSTRAINT group_categories_groups_fk
FOREIGN KEY (group_category_id)
REFERENCES kmdata.group_categories (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

CREATE SEQUENCE kmdata.user_groups_id_seq;

CREATE TABLE kmdata.user_groups (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.user_groups_id_seq'),
                user_id BIGINT NOT NULL,
                group_id BIGINT NOT NULL,
                manual_ind SMALLINT DEFAULT 0 NOT NULL,
                CONSTRAINT user_groups_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.user_groups_id_seq OWNED BY kmdata.user_groups.id;

ALTER TABLE kmdata.user_groups ADD CONSTRAINT groups_user_groups_fk
FOREIGN KEY (group_id)
REFERENCES kmdata.groups (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_groups ADD CONSTRAINT users_user_groups_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

CREATE SEQUENCE kmdata.user_groups_nestings_id_seq;

CREATE TABLE kmdata.user_groups_nestings (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.user_groups_nestings_id_seq'),
                parent_id BIGINT,
                group_id BIGINT NOT NULL,
                CONSTRAINT user_groups_nestings_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.user_groups_nestings_id_seq OWNED BY kmdata.user_groups_nestings.id;

ALTER TABLE kmdata.user_groups_nestings ADD CONSTRAINT groups_user_groups_nestings_fk
FOREIGN KEY (parent_id)
REFERENCES kmdata.groups (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_groups_nestings ADD CONSTRAINT groups_user_groups_nestings_fk1
FOREIGN KEY (group_id)
REFERENCES kmdata.groups (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

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

ALTER TABLE kmdata.user_group_permissions ADD CONSTRAINT groups_user_group_permissions_fk
FOREIGN KEY (group_id)
REFERENCES kmdata.groups (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_group_permissions ADD CONSTRAINT users_user_group_permissions_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

CREATE SEQUENCE kmdata.user_individual_modify_permissions_id_seq;

CREATE TABLE kmdata.user_individual_modify_permissions (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.user_individual_modify_permissions_id_seq'),
                profile_user_id BIGINT NOT NULL,
                person_to_modify_user_id BIGINT NOT NULL,
                administrator_entered_ind SMALLINT DEFAULT 1 NOT NULL,
                CONSTRAINT user_individual_modify_permissions_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.user_individual_modify_permissions_id_seq OWNED BY kmdata.user_individual_modify_permissions.id;

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

--- ****************** up to here has been executed on dev **********************************

-- insert the group categories
INSERT INTO kmdata.group_categories
   (name)
   SELECT name FROM osupro.user_group_categories_ref;

SELECT COUNT(*) FROM osupro.user_group_categories_ref; -- 12; prod: 12
SELECT COUNT(*) FROM kmdata.group_categories; -- 12; prod: 12

-- insert groups
INSERT INTO kmdata.groups
   (name, group_category_id, department_ind, department_id, description, sql_ind, sql_text,
    member_count, participation_count, active_ind, auto_update_ind, active_date, deactivated_date)
   SELECT a.name, c.id, a.department_ind, a.department_id, a.description, a.sql_ind, a.sql_text,
      a.member_count, a.participation_count, a.active_ind, a.auto_update_ind, a.active_date, a.deactivated_date
   FROM osupro.user_groups_ref a
   INNER JOIN osupro.user_group_categories_ref b ON a.category_id = b.id
   INNER JOIN kmdata.group_categories c ON b.name = c.name;

SELECT COUNT(*) FROM osupro.user_groups_ref; -- 17095; prod: 17121
SELECT COUNT(*) FROM kmdata.groups; -- 17095; prod: 17121

INSERT INTO kmdata.user_groups
   (user_id, group_id, manual_ind)
   SELECT b.user_id, f.id, a.manual_ind
   FROM osupro.user_groups a
   INNER JOIN kmdata.user_identifiers b ON a.profile_emplid = b.emplid
   INNER JOIN osupro.user_groups_ref c ON a.group_id = c.id
   INNER JOIN osupro.user_group_categories_ref d ON c.category_id = d.id
   INNER JOIN kmdata.group_categories e ON d.name = e.name
   INNER JOIN kmdata.groups f ON c.name = f.name AND e.id = f.group_category_id
      AND (c.department_id = f.department_id OR (c.department_id IS NULL AND f.department_id IS NULL));

SELECT COUNT(*) FROM osupro.user_groups; -- 210804; prod: 213112
SELECT COUNT(*) FROM kmdata.user_groups; -- 3 min 45 secons, 1429409; redo: 11 seconds, 123016; redo 2: 17 seconds, 204996; prod: 2.7 min, 209267

INSERT INTO kmdata.user_groups_nestings
   (parent_id, group_id)
   SELECT e.id, i.id
   FROM osupro.user_groups_nesting a
   INNER JOIN osupro.user_groups_ref b ON a.parent_id = b.id
   INNER JOIN osupro.user_group_categories_ref c ON b.category_id = c.id
   INNER JOIN kmdata.group_categories d ON c.name = d.name
   INNER JOIN kmdata.groups e ON b.name = e.name AND d.id = e.group_category_id
      AND (b.department_id = e.department_id OR (b.department_id IS NULL AND e.department_id IS NULL))
   INNER JOIN osupro.user_groups_ref f ON a.group_id = f.id
   INNER JOIN osupro.user_group_categories_ref g ON f.category_id = g.id
   INNER JOIN kmdata.group_categories h ON g.name = h.name
   INNER JOIN kmdata.groups i ON f.name = i.name AND h.id = i.group_category_id
      AND (f.department_id = i.department_id OR (f.department_id IS NULL AND i.department_id IS NULL));

SELECT COUNT(*) FROM osupro.user_groups_nesting; -- 662; prod: 652
SELECT COUNT(*) FROM kmdata.user_groups_nestings; -- 660; prod: 652

INSERT INTO kmdata.user_group_permissions
   (user_id, group_id, read_ind, write_ind, create_date)
   SELECT b.user_id, f.id, a.read_ind, a.write_ind, a.create_date
   FROM osupro.user_group_permissions a
   INNER JOIN kmdata.user_identifiers b ON a.profile_emplid = b.emplid
   INNER JOIN osupro.user_groups_ref c ON a.group_id = c.id
   INNER JOIN osupro.user_group_categories_ref d ON c.category_id = d.id
   INNER JOIN kmdata.group_categories e ON d.name = e.name
   INNER JOIN kmdata.groups f ON c.name = f.name AND e.id = f.group_category_id
      AND (c.department_id = f.department_id OR (c.department_id IS NULL AND f.department_id IS NULL));

SELECT COUNT(*) FROM osupro.user_group_permissions; -- 749; prod: 781
SELECT COUNT(*) FROM kmdata.user_group_permissions; -- 749; prod: 781

INSERT INTO kmdata.user_individual_modify_permissions
   (profile_user_id, person_to_modify_user_id, administrator_entered_ind)
   SELECT b.user_id, c.user_id, a.administrator_entered_ind
   FROM osupro.user_individual_modify_permissions a
   INNER JOIN kmdata.user_identifiers b ON a.profile_emplid = b.emplid
   INNER JOIN kmdata.user_identifiers c ON a.person_to_modify_emplid = c.emplid;

SELECT COUNT(*) FROM osupro.user_individual_modify_permissions; -- 1369; prod: 1658
SELECT COUNT(*) FROM kmdata.user_individual_modify_permissions; -- 1369; prod: 1658

-- add the resource ID
ALTER TABLE kmdata.groups ADD COLUMN resource_id BIGINT;

-- populate the resource column
UPDATE kmdata.groups SET resource_id = kmdata.add_new_resource('osupro', 'groups') WHERE resource_id IS NULL;
-- 17095 rows affected; prod: 17121 rows affected

-- add the foreign key
ALTER TABLE kmdata.groups ADD CONSTRAINT resources_groups_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- update resource ID to not null
ALTER TABLE kmdata.groups ALTER COLUMN resource_id SET NOT NULL;

-- change group name from "name" to "group_name"
ALTER TABLE kmdata.groups RENAME COLUMN name TO group_name;

-- change group category name from "name" to "group_category_name"
ALTER TABLE kmdata.group_categories RENAME COLUMN name TO group_category_name;

-- add the columns to the user table
ALTER TABLE kmdata.users ADD COLUMN name_prefix VARCHAR(4);
ALTER TABLE kmdata.users ADD COLUMN name_suffix VARCHAR(15);
ALTER TABLE kmdata.users ADD COLUMN display_name VARCHAR(255);

-- rename two columns...NOTE: THE FOLLOWING TWO STATEMENTS HAVE ALREADY BEEN RUN ON PRODUCTION
--ALTER TABLE kmdata.honor_types RENAME COLUMN type TO type_name;
--ALTER TABLE kmdata.user_honors_awards RENAME COLUMN name TO honor_name;

-- these will have been run on production already
--ALTER TABLE kmdata.user_identifiers RENAME COLUMN name_dot_number TO inst_username;
--ALTER INDEX kmdata.user_identifiers_name_dot_number_idx RENAME TO user_identifiers_inst_username_idx;

-- add default values for groups table
ALTER TABLE kmdata.groups ALTER COLUMN member_count SET DEFAULT 0;
ALTER TABLE kmdata.groups ALTER COLUMN participation_count SET DEFAULT 0;
ALTER TABLE kmdata.groups ALTER COLUMN active_date SET DEFAULT current_timestamp;
ALTER TABLE kmdata.groups ALTER COLUMN resource_id SET DEFAULT kmdata.add_new_resource('kmdata', 'groups');

-- *** FIRST CHECKPOINT ***

CREATE OR REPLACE VIEW kmdata.bckfd_pro_user_names_vw AS
SELECT ui.emplid, u.first_name, u.middle_name, u.last_name, u.name_prefix, u.name_suffix,
   u.display_name, ui.inst_username AS kerb_id, ui.inst_username AS ckm_username, CAST(NULL AS VARCHAR) AS ckm_password,
   CAST(NULL AS VARCHAR) AS who_emplid, u.updated_at AS when_dtm, 0 AS guest_ind, 1 AS active_ind, CAST(NULL AS timestamp) AS last_login,
   0 AS app_forward, u.uuid
FROM kmdata.users u
INNER JOIN kmdata.user_identifiers ui ON u.id = ui.user_id;


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
                CONSTRAINT bckfd_pro_user_names_pk PRIMARY KEY (emplid)
);


-- add full text search index to works
-- THIS IS ALREADY DONE ON PRODUCTION
--CREATE INDEX works_article_title_text_idx
--  ON kmdata.works
--  USING gin
--  (to_tsvector('english', article_title));

ALTER TABLE peoplesoft.ps_names ADD CONSTRAINT ps_names_pk PRIMARY KEY (emplid, name_type, effdt);
ALTER TABLE peoplesoft.ps_names ALTER COLUMN campus_id TYPE VARCHAR(50);


-- Peoplesoft changing tables primary keys
CREATE TABLE peoplesoft.ps_class_instr (
                crse_id VARCHAR(6) NOT NULL,
                crse_offer_nbr NUMERIC NOT NULL,
                strm VARCHAR(4) NOT NULL,
                session_code VARCHAR(3) NOT NULL,
                class_section VARCHAR(4) NOT NULL,
                class_mtg_nbr NUMERIC NOT NULL,
                instr_assign_seq NUMERIC NOT NULL,
                emplid VARCHAR(11) NOT NULL,
                instr_role VARCHAR(4) NOT NULL,
                grade_rstr_access VARCHAR(1) NOT NULL,
                contact_minutes NUMERIC NOT NULL,
                sched_print_instr VARCHAR(1) NOT NULL,
                instr_load_factor NUMERIC(10,4) NOT NULL,
                empl_rcd NUMERIC NOT NULL,
                assign_type VARCHAR(3) NOT NULL,
                week_workload_hrs NUMERIC(5,2) NOT NULL,
                assignment_pct NUMERIC(5,2) NOT NULL,
                auto_calc_wrkld VARCHAR(1) NOT NULL,
                CONSTRAINT ps_class_instr_pk PRIMARY KEY (crse_id, crse_offer_nbr, strm, session_code, class_section, class_mtg_nbr, instr_assign_seq)
);

CREATE TABLE peoplesoft.ps_class_mtg_pat (
                crse_id VARCHAR(6) NOT NULL,
                crse_offer_nbr NUMERIC NOT NULL,
                strm VARCHAR(4) NOT NULL,
                session_code VARCHAR(3) NOT NULL,
                class_section VARCHAR(4) NOT NULL,
                class_mtg_nbr NUMERIC NOT NULL,
                facility_id VARCHAR(10) NOT NULL,
                meeting_time_start TIMESTAMP,
                meeting_time_end TIMESTAMP,
                mon VARCHAR(1) NOT NULL,
                tues VARCHAR(1) NOT NULL,
                wed VARCHAR(1) NOT NULL,
                thurs VARCHAR(1) NOT NULL,
                fri VARCHAR(1) NOT NULL,
                sat VARCHAR(1) NOT NULL,
                sun VARCHAR(1) NOT NULL,
                start_dt DATE NOT NULL,
                end_dt DATE NOT NULL,
                crs_topic_id NUMERIC NOT NULL,
                descr VARCHAR(30) NOT NULL,
                stnd_mtg_pat VARCHAR(4) NOT NULL,
                print_topic_on_xcr VARCHAR(1) NOT NULL,
                osr_cpool_classrm VARCHAR(3) NOT NULL,
                CONSTRAINT ps_class_mtg_pat_pk PRIMARY KEY (crse_id, crse_offer_nbr, strm, session_code, class_section, class_mtg_nbr)
);


CREATE TABLE peoplesoft.ps_class_tbl (
                crse_id VARCHAR(6) NOT NULL,
                crse_offer_nbr NUMERIC NOT NULL,
                strm VARCHAR(4) NOT NULL,
                session_code VARCHAR(3) NOT NULL,
                class_section VARCHAR(4) NOT NULL,
                institution VARCHAR(5) NOT NULL,
                acad_group VARCHAR(5) NOT NULL,
                subject VARCHAR(8) NOT NULL,
                catalog_nbr VARCHAR(10) NOT NULL,
                acad_career VARCHAR(4) NOT NULL,
                descr VARCHAR(30) NOT NULL,
                class_nbr NUMERIC NOT NULL,
                ssr_component VARCHAR(3) NOT NULL,
                enrl_stat VARCHAR(1) NOT NULL,
                class_stat VARCHAR(1) NOT NULL,
                class_type VARCHAR(1) NOT NULL,
                associated_class NUMERIC NOT NULL,
                waitlist_daemon VARCHAR(2) NOT NULL,
                auto_enrl_waitlist VARCHAR(1) NOT NULL,
                stdnt_spec_perm VARCHAR(1) NOT NULL,
                auto_enroll_sect_1 VARCHAR(4) NOT NULL,
                auto_enroll_sect_2 VARCHAR(4) NOT NULL,
                resection VARCHAR(4) NOT NULL,
                schedule_print VARCHAR(1) NOT NULL,
                consent VARCHAR(1) NOT NULL,
                enrl_cap NUMERIC NOT NULL,
                wait_cap NUMERIC NOT NULL,
                min_enrl NUMERIC NOT NULL,
                enrl_tot NUMERIC NOT NULL,
                wait_tot NUMERIC NOT NULL,
                crs_topic_id NUMERIC NOT NULL,
                print_topic VARCHAR(1) NOT NULL,
                acad_org VARCHAR(10) NOT NULL,
                next_stdnt_positin NUMERIC NOT NULL,
                emplid VARCHAR(11) NOT NULL,
                campus VARCHAR(5) NOT NULL,
                location VARCHAR(10) NOT NULL,
                campus_event_nbr VARCHAR(9) NOT NULL,
                instruction_mode VARCHAR(2) NOT NULL,
                equiv_crse_id VARCHAR(5) NOT NULL,
                ovrd_crse_equiv_id VARCHAR(1) NOT NULL,
                room_cap_request NUMERIC NOT NULL,
                start_dt DATE NOT NULL,
                end_dt DATE NOT NULL,
                cancel_dt DATE,
                prim_instr_sect VARCHAR(4) NOT NULL,
                combined_section VARCHAR(1) NOT NULL,
                holiday_schedule VARCHAR(6) NOT NULL,
                exam_seat_spacing NUMERIC NOT NULL,
                dyn_dt_include VARCHAR(1) NOT NULL,
                dyn_dt_calc_req VARCHAR(1) NOT NULL,
                attend_generate VARCHAR(1) NOT NULL,
                attend_sync_reqd VARCHAR(1) NOT NULL,
                fees_exist VARCHAR(1) NOT NULL,
                cncl_if_stud_enrld VARCHAR(1) NOT NULL,
                rcv_from_item_type VARCHAR(1) NOT NULL,
                CONSTRAINT ps_class_tbl_pk PRIMARY KEY (crse_id, crse_offer_nbr, strm, session_code, class_section)
);


CREATE TABLE peoplesoft.ps_crse_catalog (
                crse_id VARCHAR(6) NOT NULL,
                effdt TIMESTAMP NOT NULL,
                eff_status VARCHAR(1) NOT NULL,
                descr VARCHAR(30) NOT NULL,
                equiv_crse_id VARCHAR(5) NOT NULL,
                consent VARCHAR(1) NOT NULL,
                allow_mult_enroll VARCHAR(1) NOT NULL,
                units_minimum NUMERIC(5,2) NOT NULL,
                units_maximum NUMERIC(5,2) NOT NULL,
                units_acad_prog NUMERIC(5,2) NOT NULL,
                units_finaid_prog NUMERIC(5,2) NOT NULL,
                crse_repeatable VARCHAR(1) NOT NULL,
                units_repeat_limit NUMERIC(5,2) NOT NULL,
                crse_repeat_limit NUMERIC NOT NULL,
                grading_basis VARCHAR(3) NOT NULL,
                grade_roster_print VARCHAR(1) NOT NULL,
                ssr_component VARCHAR(3) NOT NULL,
                course_title_long VARCHAR(100) NOT NULL,
                lst_mult_trm_crs VARCHAR(1) NOT NULL,
                crse_contact_hrs NUMERIC(5,2) NOT NULL,
                rqmnt_designtn VARCHAR(4) NOT NULL,
                crse_count NUMERIC(4,2) NOT NULL,
                instructor_edit VARCHAR(2) NOT NULL,
                fees_exist VARCHAR(1) NOT NULL,
                component_primary VARCHAR(3) NOT NULL,
                enrl_un_ld_clc_type VARCHAR(1) NOT NULL,
                descrlong TEXT,
                CONSTRAINT ps_crse_catalog_pk PRIMARY KEY (crse_id, effdt)
);


-- create facility table that was missing
CREATE TABLE peoplesoft.ps_facility_tbl (
                setid VARCHAR(5) NOT NULL,
                facility_id VARCHAR(10) NOT NULL,
                effdt TIMESTAMP NOT NULL,
                effstatus VARCHAR(1) NOT NULL,
                bldg_cd VARCHAR(10) NOT NULL,
                room VARCHAR(10) NOT NULL,
                descr VARCHAR(30) NOT NULL,
                descrshort VARCHAR(10) NOT NULL,
                facility_type VARCHAR(4) NOT NULL,
                facility_group VARCHAR(1) NOT NULL,
                location VARCHAR(10) NOT NULL,
                room_capacity BIGINT NOT NULL,
                generl_assign VARCHAR(1) NOT NULL,
                acad_org VARCHAR(10) NOT NULL,
                facility_partition VARCHAR(2) NOT NULL,
                min_utlzn_pct INTEGER NOT NULL,
                facility_conflict VARCHAR(1) NOT NULL,
                ext_sa_facility_id VARCHAR(10) NOT NULL,
                osr_copy_facility VARCHAR(1) NOT NULL,
                time_in_min BIGINT NOT NULL,
                CONSTRAINT ps_facility_tbl_pk PRIMARY KEY (setid, facility_id, effdt)
);

--CREATE SEQUENCE kmdata.user_appointments_id_seq;

--ALTER TABLE kmdata.user_appointments ADD COLUMN id BIGINT NOT NULL DEFAULT nextval('kmdata.user_appointments_id_seq');
ALTER TABLE kmdata.user_appointments ADD COLUMN user_id BIGINT NOT NULL;
ALTER TABLE kmdata.user_appointments ADD COLUMN department_id VARCHAR(10) NOT NULL;
ALTER TABLE kmdata.user_appointments ADD COLUMN title_abbrv VARCHAR(10) NOT NULL;
ALTER TABLE kmdata.user_appointments ADD COLUMN title VARCHAR(30) NOT NULL;
ALTER TABLE kmdata.user_appointments ADD COLUMN working_title VARCHAR(30) NOT NULL;
ALTER TABLE kmdata.user_appointments ADD COLUMN title_grp_id_code CHAR(1) NOT NULL;
ALTER TABLE kmdata.user_appointments ADD COLUMN jobcode CHAR(4) NOT NULL;
ALTER TABLE kmdata.user_appointments ADD COLUMN business_unit VARCHAR(5) NOT NULL;
ALTER TABLE kmdata.user_appointments ADD COLUMN organization VARCHAR(10);
ALTER TABLE kmdata.user_appointments ADD COLUMN fund CHAR(6);
ALTER TABLE kmdata.user_appointments ADD COLUMN account CHAR(6);
ALTER TABLE kmdata.user_appointments ADD COLUMN "function" CHAR(5);
ALTER TABLE kmdata.user_appointments ADD COLUMN project VARCHAR(15);
ALTER TABLE kmdata.user_appointments ADD COLUMN program CHAR(5);
ALTER TABLE kmdata.user_appointments ADD COLUMN user_defined VARCHAR(6);
ALTER TABLE kmdata.user_appointments ADD COLUMN budget_year VARCHAR(4);
ALTER TABLE kmdata.user_appointments ADD COLUMN prim_appt_code CHAR(1);
ALTER TABLE kmdata.user_appointments ADD COLUMN appt_percent SMALLINT;
ALTER TABLE kmdata.user_appointments ADD COLUMN appt_seq_code CHAR NOT NULL;
ALTER TABLE kmdata.user_appointments ADD COLUMN summer1_service CHAR(1);
ALTER TABLE kmdata.user_appointments ADD COLUMN winter_service CHAR;
ALTER TABLE kmdata.user_appointments ADD COLUMN autumn_service CHAR(1);
ALTER TABLE kmdata.user_appointments ADD COLUMN spring_service CHAR(1);
ALTER TABLE kmdata.user_appointments ADD COLUMN summer2_service CHAR(1);
ALTER TABLE kmdata.user_appointments ADD COLUMN osu_leave_start_date TIMESTAMP;
ALTER TABLE kmdata.user_appointments ADD COLUMN appt_end_date TIMESTAMP;
ALTER TABLE kmdata.user_appointments ADD COLUMN appt_end_length CHAR(3);
ALTER TABLE kmdata.user_appointments ADD COLUMN dw_change_date TIMESTAMP NOT NULL;
ALTER TABLE kmdata.user_appointments ADD COLUMN dw_change_code CHAR(1) NOT NULL;
ALTER TABLE kmdata.user_appointments ADD COLUMN resource_id BIGINT NOT NULL;
ALTER TABLE kmdata.user_appointments ADD COLUMN created_at TIMESTAMP NOT NULL;
ALTER TABLE kmdata.user_appointments ADD COLUMN updated_at TIMESTAMP NOT NULL;

--ALTER SEQUENCE kmdata.user_appointments_id_seq OWNED BY kmdata.user_appointments.id;

ALTER TABLE kmdata.user_appointments ADD CONSTRAINT resources_user_appointments_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_appointments ADD CONSTRAINT users_user_appointments_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

CREATE TABLE peoplesoft.personal_data_addressinfo (
                emplid VARCHAR(11) NOT NULL,
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
                country_other VARCHAR(3) NOT NULL,
                address1_other VARCHAR(55) NOT NULL,
                address2_other VARCHAR(55) NOT NULL,
                address3_other VARCHAR(55) NOT NULL,
                address4_other VARCHAR(55) NOT NULL,
                city_other VARCHAR(30) NOT NULL,
                county_other VARCHAR(30) NOT NULL,
                state_other VARCHAR(6) NOT NULL,
                postal_other VARCHAR(12) NOT NULL,
                num1_other VARCHAR(6) NOT NULL,
                num3_other VARCHAR(6) NOT NULL,
                house_type_other VARCHAR(2) NOT NULL,
                addr_field1_other VARCHAR(2) NOT NULL,
                addr_field2_other VARCHAR(4) NOT NULL,
                addr_field3_other VARCHAR(4) NOT NULL,
                in_city_lmt_other VARCHAR(1) NOT NULL,
                geo_code_other VARCHAR(11) NOT NULL,
                country_code VARCHAR(3) NOT NULL,
                phone VARCHAR(24) NOT NULL,
                extension VARCHAR(6) NOT NULL,
                CONSTRAINT personal_data_addressinfo_pk PRIMARY KEY (emplid)
);


DROP TABLE kmdata.user_addresses;

CREATE SEQUENCE kmdata.address_types_id_seq;

CREATE TABLE kmdata.address_types (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.address_types_id_seq'),
                address_type_name VARCHAR(255) NOT NULL,
                CONSTRAINT address_types_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.address_types_id_seq OWNED BY kmdata.address_types.id;

CREATE SEQUENCE kmdata.user_addresses_id_seq;

CREATE TABLE kmdata.user_addresses (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.user_addresses_id_seq'),
                user_id BIGINT NOT NULL,
                address_type_id BIGINT NOT NULL,
                address1 VARCHAR(2000),
                address2 VARCHAR(2000),
                address3 VARCHAR(2000),
                address4 VARCHAR(2000),
                city VARCHAR(255),
                state VARCHAR(10),
                zip VARCHAR(255),
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                resource_id BIGINT NOT NULL,
                CONSTRAINT user_addresses_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.user_addresses_id_seq OWNED BY kmdata.user_addresses.id;

ALTER TABLE kmdata.user_addresses ADD CONSTRAINT address_types_user_addresses_fk
FOREIGN KEY (address_type_id)
REFERENCES kmdata.address_types (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_addresses ADD CONSTRAINT users_user_addresses_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_addresses ADD CONSTRAINT resources_user_addresses_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

CREATE SEQUENCE kmdata.phone_types_id_seq;

CREATE TABLE kmdata.phone_types (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.phone_types_id_seq'),
                phone_type_name VARCHAR(255) NOT NULL,
                CONSTRAINT phone_types_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.phone_types_id_seq OWNED BY kmdata.phone_types.id;


DROP TABLE kmdata.user_phones;


CREATE SEQUENCE kmdata.user_phones_id_seq;

CREATE TABLE kmdata.user_phones (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.user_phones_id_seq'),
                user_id BIGINT NOT NULL,
                phone_type_id BIGINT NOT NULL,
                phone VARCHAR(24) NOT NULL,
                created_at TIMESTAMP NOT NULL,
                updated_at TIMESTAMP NOT NULL,
                resource_id BIGINT NOT NULL,
                CONSTRAINT user_phones_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.user_phones_id_seq OWNED BY kmdata.user_phones.id;

ALTER TABLE kmdata.user_phones ADD CONSTRAINT phone_types_user_phones_fk
FOREIGN KEY (phone_type_id)
REFERENCES kmdata.phone_types (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_phones ADD CONSTRAINT resources_user_phones_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.user_phones ADD CONSTRAINT users_user_phones_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- copy over 2 new stored procedures
-- kmdata.get_or_add_address_type_id
-- kmdata.get_or_add_phone_type_id

-- insert address information for campus addresses
SELECT kmdata.get_or_add_address_type_id('campus');

INSERT INTO kmdata.user_addresses(
            user_id, address_type_id, address1, address2, address3, address4, 
            city, state, zip, created_at, updated_at, resource_id
	)
  SELECT ui.user_id, kmdata.get_or_add_address_type_id('campus'), address1_other, address2_other, address3_other, address4_other, 
       city_other, state_other, postal_other, current_timestamp, current_timestamp, kmdata.add_new_resource('peoplesoft', 'user_addresses')
  FROM peoplesoft.personal_data_addressinfo pda
  INNER JOIN kmdata.user_identifiers ui ON pda.emplid = ui.emplid;

SELECT COUNT(*) FROM kmdata.user_addresses; -- dev: 1227836 records (8 min 15 sec); prod: 1222824(8.3 minutes)
			
-- insert phone information for campus phones
SELECT kmdata.get_or_add_phone_type_id('campus');

INSERT INTO kmdata.user_phones(
            user_id, phone_type_id, phone, created_at, updated_at, resource_id)
  SELECT b.user_id, kmdata.get_or_add_phone_type_id('campus'), a.phone,
     current_timestamp, current_timestamp, kmdata.add_new_resource('peoplesoft', 'user_phones')
  FROM peoplesoft.personal_data_addressinfo a
  INNER JOIN kmdata.user_identifiers b ON a.emplid = b.emplid;

SELECT COUNT(*) FROM kmdata.user_phones; -- 1227836 (dev: about 9 minutes); prod: 1222824 (8 minutes)

--/***********************************************************************
-- LEFT OFF HERE WITH ADDRESS INFO COMPLETED, BEGIN APPOINTMENTS
-- ***********************************************************************/

CREATE TABLE peoplesoft.ps_user_appointments (
                emplid VARCHAR(11) NOT NULL,
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
                appt_seq_code CHAR(1),
                summer1_service CHAR(1),
                winter_service CHAR,
                autumn_service CHAR(1),
                spring_service CHAR(1),
                summer2_service CHAR(1),
                osu_leave_start_date TIMESTAMP,
                appt_end_date TIMESTAMP,
                appt_end_length CHAR(3),
                dw_change_date TIMESTAMP,
                dw_change_code CHAR(1)
);

ALTER TABLE kmdata.user_appointments ALTER COLUMN business_unit DROP NOT NULL;
ALTER TABLE kmdata.user_appointments ALTER COLUMN appt_seq_code DROP NOT NULL;
ALTER TABLE kmdata.user_appointments ALTER COLUMN dw_change_date DROP NOT NULL;
ALTER TABLE kmdata.user_appointments ALTER COLUMN dw_change_code DROP NOT NULL;


INSERT INTO kmdata.user_appointments(
            user_id, department_id, title_abbrv, title, working_title, title_grp_id_code, 
            jobcode, business_unit, organization, fund, account, "function", 
            project, program, user_defined, budget_year, prim_appt_code, 
            appt_percent, appt_seq_code, summer1_service, winter_service, 
            autumn_service, spring_service, summer2_service, osu_leave_start_date, 
            appt_end_date, appt_end_length, dw_change_date, dw_change_code, 
            resource_id, created_at, updated_at)
SELECT b.user_id, a.department_id, a.title_abbrv, a.title, a.working_title, a.title_grp_id_code, 
       a.jobcode, a.business_unit, a.organization, a.fund, a.account, a."function", 
       a.project, a.program, a.user_defined, a.budget_year, a.prim_appt_code, 
       a.appt_percent, a.appt_seq_code, a.summer1_service, a.winter_service, 
       a.autumn_service, a.spring_service, a.summer2_service, a.osu_leave_start_date, 
       a.appt_end_date, a.appt_end_length, a.dw_change_date, a.dw_change_code,
       kmdata.add_new_resource('peoplesoft', 'user_appointments'), current_timestamp, current_timestamp
  FROM peoplesoft.ps_user_appointments a
  INNER JOIN kmdata.user_identifiers b ON a.emplid = b.emplid;

SELECT COUNT(*) FROM peoplesoft.ps_user_appointments; -- prod: 74514
SELECT COUNT(*) FROM kmdata.user_appointments; -- dev: 73215 (1.5 minutes); prod: 73865 (44 seconds)

-- add fix user appointments proc (already on prod)
SELECT kmdata.fix_duplicate_user_appointments(); -- 14 minutes on dev; 17 minutes on production


ALTER TABLE kmdata.bckfd_pro_user_names ADD COLUMN uuid VARCHAR(50) NOT NULL;

-- *********** CHECKPOINT *******************

-- new indexes:
CREATE INDEX user_addresses_user_id_idx
 ON kmdata.user_addresses
 ( user_id );
CREATE INDEX user_appointments_user_id_idx
 ON kmdata.user_appointments
 ( user_id );
CREATE INDEX user_phones_user_id_idx
 ON kmdata.user_phones
 ( user_id );
CREATE INDEX user_preferred_names_user_id_idx
 ON kmdata.user_preferred_names
 ( user_id );
CREATE INDEX user_services_user_id_idx
 ON kmdata.user_services
 ( user_id );
CREATE INDEX user_honors_awards_user_id_idx
 ON kmdata.user_honors_awards
 ( user_id );
CREATE INDEX user_preferred_appointments_user_id_idx
 ON kmdata.user_preferred_appointments
 ( user_id );
CREATE INDEX user_preferred_keywords_user_id_idx
 ON kmdata.user_preferred_keywords
 ( user_id );

-- index set 2
CREATE INDEX work_authors_work_id_idx
 ON kmdata.work_authors
 ( work_id );
CREATE INDEX work_authors_user_id_idx
 ON kmdata.work_authors
 ( user_id );
CREATE INDEX user_narratives_user_id_idx
 ON kmdata.user_narratives
 ( user_id );
CREATE INDEX user_narratives_narrative_id_idx
 ON kmdata.user_narratives
 ( narrative_id );
CREATE INDEX work_narratives_work_id_idx
 ON kmdata.work_narratives
 ( work_id );
CREATE INDEX work_narratives_narrative_id_idx
 ON kmdata.work_narratives
 ( narrative_id );
CREATE INDEX work_locations_work_id_idx
 ON kmdata.work_locations
 ( work_id );
CREATE INDEX work_locations_location_id_idx
 ON kmdata.work_locations
 ( location_id );




ALTER TABLE kmdata.users ADD COLUMN deceased_ind SMALLINT DEFAULT 0 NOT NULL;

-- *** MOVE kmdata.users_vw in ***

--DELETE FROM kmdata.user_groups ugo
--WHERE ugo.id != (SELECT MIN(ugi.id) FROM kmdata.user_groups ugi WHERE ugi.user_id = ugo.user_id AND ugi.group_id = ugo.group_id);

DELETE FROM kmdata.user_groups ugo WHERE ugo.id NOT IN (
SELECT MIN(ugi.id)
FROM kmdata.user_groups ugi
GROUP BY ugi.user_id, ugi.group_id
); -- 2215 rows deleted dev; 1854 deleted prod

SELECT COUNT(*) FROM kmdata.user_groups; -- dev pre: 205006, dev post: 202791; PROD PRE: 209274, PROD POST: 207420
SELECT user_id, group_id, COUNT(*) FROM kmdata.user_groups GROUP BY user_id, group_id HAVING COUNT(*) > 1;

CREATE UNIQUE INDEX user_groups_altkey1_idx
 ON kmdata.user_groups
 ( user_id, group_id );



ALTER TABLE peoplesoft.ps_user_appointments ADD COLUMN sal_admin_plan VARCHAR(4);
ALTER TABLE peoplesoft.ps_user_appointments ADD COLUMN empl_rcd INTEGER NOT NULL;
ALTER TABLE peoplesoft.ps_user_appointments ADD CONSTRAINT ps_user_appointments_pk PRIMARY KEY (emplid, empl_rcd);
ALTER TABLE peoplesoft.ps_user_appointments ALTER COLUMN sal_admin_plan SET NOT NULL;

-- run ETL PeoplesoftUserAppointments

ALTER TABLE kmdata.user_appointments ADD COLUMN rcd_num INTEGER;
ALTER TABLE kmdata.user_appointments ADD COLUMN sal_admin_plan VARCHAR(4);

--UPDATE kmdata.user_appointments a
--   SET a.rcd_num = (SELECT b.empl_rcd 
--					FROM peoplesoft.ps_user_appointments b 
--					INNER JOIN kmdata.user_identifiers c ON b.emplid = c.emplid
--					WHERE c.user_id = a.user_id
--					AND b.department_id = a.department_id
--					AND b.jobcode = a.jobcode
--					AND b.title_grp_id_code = a.title_grp_id_code);
-- end

TRUNCATE TABLE kmdata.user_appointments;

CREATE UNIQUE INDEX user_appointments_altkey1_idx
 ON kmdata.user_appointments
 ( user_id, rcd_num );


ALTER TABLE peoplesoft.ps_user_appointments
  ADD CONSTRAINT ps_user_appointments_pk PRIMARY KEY(emplid, empl_rcd);
 
 INSERT INTO kmdata.user_appointments(
            user_id, rcd_num, department_id, title_abbrv, title, working_title, title_grp_id_code, 
            jobcode, business_unit, organization, fund, account, "function", 
            project, program, user_defined, budget_year, prim_appt_code, 
            appt_percent, appt_seq_code, summer1_service, winter_service, 
            autumn_service, spring_service, summer2_service, osu_leave_start_date, 
            appt_end_date, appt_end_length, dw_change_date, dw_change_code, 
            resource_id, created_at, updated_at, sal_admin_plan)
SELECT b.user_id, a.empl_rcd, a.department_id, a.title_abbrv, a.title, a.working_title, a.title_grp_id_code, 
       a.jobcode, a.business_unit, a.organization, a.fund, a.account, a."function", 
       a.project, a.program, a.user_defined, a.budget_year, a.prim_appt_code, 
       a.appt_percent, a.appt_seq_code, a.summer1_service, a.winter_service, 
       a.autumn_service, a.spring_service, a.summer2_service, a.osu_leave_start_date, 
       a.appt_end_date, a.appt_end_length, a.dw_change_date, a.dw_change_code,
       kmdata.add_new_resource('peoplesoft', 'user_appointments'), current_timestamp, current_timestamp, sal_admin_plan
  FROM peoplesoft.ps_user_appointments a
  INNER JOIN kmdata.user_identifiers b ON a.emplid = b.emplid;
-- dev: 29 seconds, 59350 records
-- prod: 114 seconds, 59487 records



SELECT COUNT(*) FROM kmdata.user_groups;
-- dev: 202798; prod: 207420

select count(*) from (
SELECT a.user_id, a.group_id
FROM kmdata.user_groups a
INNER JOIN kmdata.groups b ON a.group_id = b.id
INNER JOIN kmdata.group_categories c ON b.group_category_id = c.id
WHERE c.group_category_name = 'HR Departments Faculty and Staff'
) t;
-- dev: 37053; prod: 36980

-- delete all HR Faculty and Staff records
DELETE FROM kmdata.user_groups
WHERE (user_id, group_id) IN (
SELECT a.user_id, a.group_id
FROM kmdata.user_groups a
INNER JOIN kmdata.groups b ON a.group_id = b.id
INNER JOIN kmdata.group_categories c ON b.group_category_id = c.id
WHERE c.group_category_name = 'HR Departments Faculty and Staff'
);

SELECT COUNT(*) FROM kmdata.user_groups;
-- dev: 165745; prod: 170440

-- insert
INSERT INTO kmdata.user_groups
   (user_id, group_id, manual_ind)
SELECT DISTINCT b.user_id, c.id AS group_id, 0 AS manual_ind
FROM peoplesoft.ps_user_appointments a
INNER JOIN kmdata.user_identifiers b ON a.emplid = b.emplid
INNER JOIN kmdata.groups c ON a.department_id = c.department_id
INNER JOIN kmdata.group_categories d ON c.group_category_id = d.id
INNER JOIN peoplesoft.ps_dept_tbl e ON a.department_id = e.deptid
WHERE d.group_category_name = 'HR Departments Faculty and Staff' AND a.sal_admin_plan != 'STD';
-- prod: 38099 rows


-- add deceased_ind
ALTER TABLE peoplesoft.ps_names ADD COLUMN deceased_ind SMALLINT NOT NULL DEFAULT 0;

-- run the update
SELECT kmdata.import_users_from_ps();
"User import completed. 1227834 users updated and 3113 users inserted." (dev)

ALTER TABLE kmdata.users ADD COLUMN deceased_ind SMALLINT DEFAULT 0 NOT NULL;

ALTER TABLE kmdata.bckfd_pro_user_names ADD COLUMN deceased_ind SMALLINT DEFAULT 0 NOT NULL;

-- install kmdata.bckfd_pro_user_names_vw

-- MOVE TO PROD
CREATE SEQUENCE kmdata.group_excluded_users_id_seq;

CREATE TABLE kmdata.group_excluded_users (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.group_excluded_users_id_seq'),
                group_id BIGINT NOT NULL,
                user_id BIGINT NOT NULL,
                CONSTRAINT group_excluded_users_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.group_excluded_users_id_seq OWNED BY kmdata.group_excluded_users.id;

ALTER TABLE kmdata.group_excluded_users ADD CONSTRAINT groups_group_excluded_users_fk
FOREIGN KEY (group_id)
REFERENCES kmdata.groups (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.group_excluded_users ADD CONSTRAINT users_group_excluded_users_fk
FOREIGN KEY (user_id)
REFERENCES kmdata.users (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

