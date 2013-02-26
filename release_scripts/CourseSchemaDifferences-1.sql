-- First run changes in the master upgrade script before running this supplmental script

-- OLD
CREATE TABLE courses
(
	id bigserial NOT NULL,
	course_name character varying(500) NOT NULL,
	course_number character varying(10) NOT NULL,
	description text,
	resource_id bigint NOT NULL,
	subject_id bigint NOT NULL,
	active smallint NOT NULL DEFAULT 1,
	course_name_abbrev character varying(30),
	CONSTRAINT courses_pk PRIMARY KEY (id ),
)

-- NEW
CREATE TABLE kmdata.courses (
	id BIGINT NOT NULL DEFAULT nextval('kmdata.courses_id_seq'),
	ps_course_id VARCHAR(6) NOT NULL, -- crse_id
	course_name VARCHAR(500) NOT NULL, -- course_title_long
	course_name_abbrev VARCHAR(30),
	active SMALLINT DEFAULT 1 NOT NULL,
	description TEXT, -- descrlong
	repeatable VARCHAR(1), -- crse_repeatable
	grading_basis VARCHAR(3), -- grading_basis
	units_acad_prog NUMERIC(5,2), -- units_acad_prog
	resource_id BIGINT NOT NULL,
	CONSTRAINT courses_pk PRIMARY KEY (id)
);

-- courses
ALTER TABLE kmdata.courses DROP COLUMN course_number;
ALTER TABLE kmdata.courses DROP COLUMN subject_id;
ALTER TABLE kmdata.courses ADD COLUMN ps_course_id VARCHAR(6) NOT NULL;
ALTER TABLE kmdata.courses ADD COLUMN repeatable VARCHAR(1);
ALTER TABLE kmdata.courses ADD COLUMN grading_basis VARCHAR(3);
ALTER TABLE kmdata.courses ADD COLUMN units_acad_prog NUMERIC(5,2);


-- OLD
CREATE TABLE offerings
(
	id bigserial NOT NULL,
	course_id bigint NOT NULL,
	resource_id bigint NOT NULL,
	offering_name character varying(500),
	term_session_id bigint NOT NULL,
	acad_department_id bigint NOT NULL,
	units_acad_prog numeric(5,2),
	acad_career character varying(4),
	CONSTRAINT offerings_pk PRIMARY KEY (id ),
)

-- NEW
CREATE TABLE kmdata.offerings (
	id BIGINT NOT NULL DEFAULT nextval('kmdata.offerings_id_seq'),
	course_id BIGINT NOT NULL,
	ps_course_offer_number BIGINT NOT NULL, -- crse_offer_nbr
	offering_name VARCHAR(500) NOT NULL,
	acad_department_id BIGINT NOT NULL,
	acad_career VARCHAR(4), -- acad_career
	campus_id BIGINT NOT NULL,
	subject_id BIGINT NOT NULL,
	course_number VARCHAR(10) NOT NULL,
	resource_id BIGINT NOT NULL,
	CONSTRAINT offerings_pk PRIMARY KEY (id)
);

-- offerings
ALTER TABLE kmdata.offerings DROP COLUMN term_session_id;
ALTER TABLE kmdata.offerings DROP COLUMN units_acad_prog;
ALTER TABLE ADD COLUMN ps_course_offer_number BIGINT NOT NULL;
ALTER TABLE ADD COLUMN campus_id BIGINT NOT NULL;
ALTER TABLE ADD COLUMN subject_id subject_id BIGINT NOT NULL;
ALTER TABLE ADD COLUMN course_number VARCHAR(10) NOT NULL;


-- OLD
CREATE TABLE sections
(
	id bigserial NOT NULL,
	offering_id bigint NOT NULL,
	resource_id bigint NOT NULL,
	section_name character varying(500),
	class_number character varying(50) NOT NULL,
	section_type character varying(10),
	parent_section_id bigint,
	enrollment_total numeric(38,0),
	CONSTRAINT sections_pk PRIMARY KEY (id ),
)

-- NEW
CREATE TABLE kmdata.sections (
	id BIGINT NOT NULL DEFAULT nextval('kmdata.sections_id_seq'),
	section_name VARCHAR(500),
	offering_id BIGINT NOT NULL,
	term_session_id BIGINT NOT NULL,
	ps_class_section VARCHAR(4) NOT NULL,
	class_number VARCHAR(50) NOT NULL,
	section_type VARCHAR(10),
	parent_section_id BIGINT,
	enrollment_total NUMERIC(38), -- enrl_tot
	resource_id BIGINT NOT NULL,
	CONSTRAINT sections_pk PRIMARY KEY (id)
);

-- sections
ALTER TABLE kmdata.sections ADD COLUMN term_session_id BIGINT NOT NULL;
ALTER TABLE kmdata.sections ADD COLUMN ps_class_section VARCHAR(4) NOT NULL;




CREATE TABLE sid.ps_crse_catalog (
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

CREATE TABLE sid.ps_crse_offer (
                crse_id VARCHAR(6) NOT NULL,
                effdt TIMESTAMP NOT NULL,
                crse_offer_nbr NUMERIC(38) NOT NULL,
                institution VARCHAR(5),
                acad_group VARCHAR(5),
                subject VARCHAR(8),
                catalog_nbr VARCHAR(10),
                course_approved VARCHAR(1),
                campus VARCHAR(5),
                schedule_print VARCHAR(1),
                catalog_print VARCHAR(1),
                sched_print_instr VARCHAR(1),
                acad_org VARCHAR(10),
                acad_career VARCHAR(4),
                split_owner VARCHAR(1),
                sched_term_roll VARCHAR(1),
                rqrmnt_group VARCHAR(6),
                cip_code VARCHAR(13),
                hegis_code VARCHAR(8),
                use_blind_grading VARCHAR(1),
                rcv_from_item_type VARCHAR(1),
                sel_group VARCHAR(10),
                schedule_course VARCHAR(1),
                dyn_class_data VARCHAR(10),
                CONSTRAINT ps_crse_offer_pk PRIMARY KEY (crse_id, effdt, crse_offer_nbr)
);

CREATE TABLE sid.ps_class_tbl (
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
