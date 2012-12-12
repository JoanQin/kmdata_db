--update kmdata.institutions set "name" = 'UNKNOWN' where "name" is null;
--select count(*) from kmdata.institutions where "name" = 'UNKNOWN';
ALTER TABLE kmdata.institutions ALTER COLUMN name SET NOT NULL;

ALTER TABLE kmdata.user_identifiers ADD COLUMN idm_id VARCHAR(255);




CREATE SEQUENCE researchinview.temp_riv_users_degrees_id_seq;

CREATE TABLE researchinview.temp_riv_users_degrees (
                id BIGINT NOT NULL DEFAULT nextval('researchinview.temp_riv_users_degrees_id_seq'),
                emplid VARCHAR(255) NOT NULL,
                degree_type_id BIGINT,
                area_of_study VARCHAR(255),
                riv_institution_id BIGINT,
                CONSTRAINT temp_riv_users_degrees_pk PRIMARY KEY (id)
);


ALTER SEQUENCE researchinview.temp_riv_users_degrees_id_seq OWNED BY researchinview.temp_riv_users_degrees.id;


-- update views, Books insert proc AND Books view
-- editor_list

ALTER TABLE kmdata.works ADD COLUMN sub_work_type_id BIGINT;

ALTER TABLE kmdata.works ADD COLUMN book_author VARCHAR(255);

ALTER TABLE kmdata.clinical_trials ADD COLUMN approved_on TIMESTAMP;
ALTER TABLE kmdata.clinical_trials ADD COLUMN condition_studied VARCHAR(255);
ALTER TABLE kmdata.clinical_trials ADD COLUMN intervention_analyzed VARCHAR(255);
ALTER TABLE kmdata.clinical_trials ADD COLUMN percent_effort INTEGER;
ALTER TABLE kmdata.clinical_trials ADD COLUMN regulatory_approval VARCHAR(255);
ALTER TABLE kmdata.clinical_trials ADD COLUMN role_other VARCHAR(255);
ALTER TABLE kmdata.clinical_trials ADD COLUMN site_name VARCHAR(1000);

ALTER TABLE kmdata.grant_data ADD COLUMN agency_other VARCHAR(255);
ALTER TABLE kmdata.grant_data ADD COLUMN agency_other_city VARCHAR(255);
ALTER TABLE kmdata.grant_data ADD COLUMN agency_other_country VARCHAR(255);
ALTER TABLE kmdata.grant_data ADD COLUMN agency_other_state_province VARCHAR(255);
ALTER TABLE kmdata.grant_data ADD COLUMN currency VARCHAR(255);
ALTER TABLE kmdata.grant_data ADD COLUMN fellowship VARCHAR(255);
ALTER TABLE kmdata.grant_data ADD COLUMN funding_agency_type VARCHAR(255);

ALTER TABLE kmdata.grant_data ALTER COLUMN agency_other TYPE VARCHAR(1000);
ALTER TABLE kmdata.grant_data ALTER COLUMN agency_other_city TYPE VARCHAR(1000);
ALTER TABLE kmdata.grant_data ALTER COLUMN agency_other_country TYPE VARCHAR(1000);
ALTER TABLE kmdata.grant_data ALTER COLUMN agency_other_state_province TYPE VARCHAR(1000);
ALTER TABLE kmdata.grant_data ALTER COLUMN currency TYPE VARCHAR(1000);
ALTER TABLE kmdata.grant_data ALTER COLUMN fellowship TYPE VARCHAR(1000);
ALTER TABLE kmdata.grant_data ALTER COLUMN funding_agency_type TYPE VARCHAR(1000);



ALTER TABLE kmdata.grant_data ALTER COLUMN originating_contract TYPE VARCHAR(1000);
ALTER TABLE kmdata.grant_data ALTER COLUMN principal_investigator TYPE VARCHAR(1000);
ALTER TABLE kmdata.grant_data ALTER COLUMN co_investigator TYPE VARCHAR(1000);
ALTER TABLE kmdata.grant_data ALTER COLUMN agency TYPE VARCHAR(1000);
ALTER TABLE kmdata.grant_data ALTER COLUMN priority_score TYPE VARCHAR(1000);
ALTER TABLE kmdata.grant_data ALTER COLUMN identifier TYPE VARCHAR(1000);
ALTER TABLE kmdata.grant_data ALTER COLUMN grant_number TYPE VARCHAR(1000);
ALTER TABLE kmdata.grant_data ALTER COLUMN award_number TYPE VARCHAR(1000);
ALTER TABLE kmdata.grant_data ALTER COLUMN grant_identifier TYPE VARCHAR(1000);

ALTER TABLE kmdata.works ADD COLUMN sub_work_type_other VARCHAR(1000);


CREATE TABLE kmdata.journal_article_types (
                id INTEGER NOT NULL,
                name VARCHAR(255) NOT NULL,
                CONSTRAINT journal_article_types_pk PRIMARY KEY (id)
);

-- 1 == peer reviewed; 2 == editor reviewed
INSERT INTO kmdata.journal_article_types (id, name) VALUES (1, 'Peer-Reviewed');
INSERT INTO kmdata.journal_article_types (id, name) VALUES (2, 'Editor-Reviewed');
INSERT INTO kmdata.journal_article_types (id, name) VALUES (3, 'Other');

ALTER TABLE kmdata.works ADD CONSTRAINT journal_article_types_works_fk
FOREIGN KEY (journal_article_type_id)
REFERENCES kmdata.journal_article_types (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;



ALTER TABLE kmdata.grant_data ADD COLUMN funding_amount_breakdown INTEGER;
ALTER TABLE kmdata.grant_data ADD COLUMN duration INTEGER;



ALTER TABLE kmdata.works ADD COLUMN publication_type_id BIGINT;


ALTER TABLE kmdata.grant_data ADD COLUMN funding_agency_type_other VARCHAR(1000);

ALTER TABLE peoplesoft.ps_names ALTER COLUMN COUNTRY_NM_FORMAT DROP NOT NULL;
ALTER TABLE peoplesoft.ps_names ALTER COLUMN NAME_INITIALS DROP NOT NULL;
ALTER TABLE peoplesoft.ps_names ALTER COLUMN NAME_ROYAL_PREFIX DROP NOT NULL;
ALTER TABLE peoplesoft.ps_names ALTER COLUMN NAME_ROYAL_SUFFIX DROP NOT NULL;
ALTER TABLE peoplesoft.ps_names ALTER COLUMN SECOND_LAST_NAME DROP NOT NULL;
ALTER TABLE peoplesoft.ps_names ALTER COLUMN PARTNER_LAST_NAME DROP NOT NULL;
ALTER TABLE peoplesoft.ps_names ALTER COLUMN PARTNER_ROY_PREFIX DROP NOT NULL;
ALTER TABLE peoplesoft.ps_names ALTER COLUMN LAST_NAME_PREF_NLD DROP NOT NULL;
ALTER TABLE peoplesoft.ps_names ALTER COLUMN LASTUPDDTTM DROP NOT NULL;

ALTER TABLE peoplesoft.ps_user_appointments ALTER COLUMN title_grp_id_code DROP NOT NULL;
ALTER TABLE peoplesoft.ps_user_appointments ALTER COLUMN sal_admin_plan DROP NOT NULL;

ALTER TABLE kmdata.user_appointments ALTER COLUMN title_grp_id_code DROP NOT NULL;
ALTER TABLE kmdata.user_appointments ALTER COLUMN sal_admin_plan DROP NOT NULL;


ALTER TABLE kmdata.user_addresses ADD COLUMN country VARCHAR(255);


ALTER TABLE kmdata.works ADD COLUMN citation_count BIGINT;


ALTER TABLE peoplesoft.ps_names ADD COLUMN idm_id VARCHAR(255);

ALTER TABLE kmdata.user_appointments ADD COLUMN appt_start_date TIMESTAMP;
ALTER TABLE peoplesoft.ps_user_appointments ADD COLUMN appt_start_date TIMESTAMP;


ALTER TABLE peoplesoft.personal_data_addressinfo ALTER COLUMN num1 DROP NOT NULL;
ALTER TABLE peoplesoft.personal_data_addressinfo ALTER COLUMN num2 DROP NOT NULL;
ALTER TABLE peoplesoft.personal_data_addressinfo ALTER COLUMN house_type DROP NOT NULL;
ALTER TABLE peoplesoft.personal_data_addressinfo ALTER COLUMN in_city_limit DROP NOT NULL;
ALTER TABLE peoplesoft.personal_data_addressinfo ALTER COLUMN num1_other DROP NOT NULL;
ALTER TABLE peoplesoft.personal_data_addressinfo ALTER COLUMN num3_other DROP NOT NULL;
ALTER TABLE peoplesoft.personal_data_addressinfo ALTER COLUMN house_type_other DROP NOT NULL;
ALTER TABLE peoplesoft.personal_data_addressinfo ALTER COLUMN in_city_lmt_other DROP NOT NULL;
ALTER TABLE peoplesoft.personal_data_addressinfo ALTER COLUMN country_code DROP NOT NULL;
ALTER TABLE peoplesoft.personal_data_addressinfo ALTER COLUMN phone DROP NOT NULL;
ALTER TABLE peoplesoft.personal_data_addressinfo ALTER COLUMN extension DROP NOT NULL;


CREATE SEQUENCE kmdata.email_types_id_seq;

CREATE TABLE kmdata.email_types (
                id BIGINT NOT NULL DEFAULT nextval('kmdata.email_types_id_seq'),
                email_type_name VARCHAR(255) NOT NULL,
                CONSTRAINT email_types_pk PRIMARY KEY (id)
);


ALTER SEQUENCE kmdata.email_types_id_seq OWNED BY kmdata.email_types.id;

ALTER TABLE kmdata.user_emails ADD COLUMN email_type_id BIGINT NOT NULL;

ALTER TABLE kmdata.user_emails ADD CONSTRAINT email_types_user_emails_fk
FOREIGN KEY (email_type_id)
REFERENCES kmdata.email_types (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


ALTER TABLE kmdata.user_emails ADD COLUMN resource_id BIGINT NOT NULL;

-- DROP IT!!!
--not really DROP TABLE kmdata.user_emails;


CREATE SEQUENCE kmdata.user_emails_id_seq;

ALTER TABLE kmdata.user_emails ALTER COLUMN id SET DEFAULT nextval('kmdata.user_emails_id_seq');

ALTER SEQUENCE kmdata.user_emails_id_seq OWNED BY kmdata.user_emails.id;


ALTER TABLE kmdata.user_emails ADD COLUMN resource_id BIGINT NOT NULL;

ALTER TABLE kmdata.user_emails ADD CONSTRAINT resources_user_emails_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--************************************************
--ADD INDEXES!!!!
--************************************************

CREATE INDEX user_addresses_alt_key_idx
 ON kmdata.user_addresses
 ( user_id, address_type_id );

 CREATE INDEX user_emails_alt_key_idx
 ON kmdata.user_emails
 ( user_id, email_type_id );

 

--************************************************
-- fix the views!!!
--************************************************



CREATE TABLE peoplesoft.ps_acad_group_tbl (
                institution VARCHAR(5) NOT NULL,
                acad_group VARCHAR(5) NOT NULL,
                effdt DATE NOT NULL,
                eff_status VARCHAR(1) NOT NULL,
                descr VARCHAR(30) NOT NULL,
                descrshort VARCHAR(10) NOT NULL,
                stdnt_spec_perm VARCHAR(1) NOT NULL,
                auto_enrl_waitlist VARCHAR(1) NOT NULL,
                CONSTRAINT ps_acad_group_tbl_pk PRIMARY KEY (institution, acad_group, effdt)
);


CREATE TABLE peoplesoft.ps_campus_tbl (
                campus VARCHAR(5) NOT NULL,
                descr VARCHAR(30) NOT NULL,
                descrshort VARCHAR(10),
                institution VARCHAR(5) NOT NULL,
                effdt TIMESTAMP NOT NULL,
                src_sys_id VARCHAR(5),
                eff_status VARCHAR(1),
                location VARCHAR(10),
                facility_conflict VARCHAR(1)
);




-- new courses schema tables
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

ALTER TABLE kmdata.campuses ADD CONSTRAINT locations_campus_fk
FOREIGN KEY (location_id)
REFERENCES kmdata.locations (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.campuses ADD CONSTRAINT resources_campus_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.campuses ADD CONSTRAINT institutions_campuses_fk
FOREIGN KEY (institution_id)
REFERENCES kmdata.institutions (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

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

ALTER TABLE kmdata.colleges ADD CONSTRAINT resources_colleges_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE kmdata.colleges ADD CONSTRAINT campus_colleges_fk
FOREIGN KEY (campus_id)
REFERENCES kmdata.campuses (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;



ALTER TABLE peoplesoft.ps_dept_tbl ALTER COLUMN company DROP NOT NULL;
ALTER TABLE peoplesoft.ps_dept_tbl ALTER COLUMN setid_location DROP NOT NULL;
ALTER TABLE peoplesoft.ps_dept_tbl ALTER COLUMN location DROP NOT NULL;
ALTER TABLE peoplesoft.ps_dept_tbl ALTER COLUMN manager_id DROP NOT NULL;
ALTER TABLE peoplesoft.ps_dept_tbl ALTER COLUMN budget_deptid DROP NOT NULL;



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

