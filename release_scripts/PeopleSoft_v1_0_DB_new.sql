
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


CREATE TABLE peoplesoft.ps_email_addresses (
                emplid VARCHAR(11) NOT NULL,
                e_addr_type VARCHAR(4) NOT NULL,
                email_addr VARCHAR(70) NOT NULL,
                pref_email_flag VARCHAR(1) NOT NULL
);


CREATE INDEX ps_email_addresses_idx
 ON peoplesoft.ps_email_addresses
 ( emplid );

CREATE TABLE peoplesoft.courses_all (
                crse_id VARCHAR(6),
                course_description TEXT,
                cred_hrs NUMERIC(5,2),
                crse_ttl VARCHAR(30),
                crse_acad_coll_nam VARCHAR(30),
                crse_acad_dept_nam VARCHAR(30),
                crse_sect_cmps_nam VARCHAR(10),
                acad_career VARCHAR(4),
                crse_ug_cred_flg VARCHAR(1),
                crse_prof_cred_flg VARCHAR(1),
                crse_grad_cred_flg VARCHAR(1),
                crse_num VARCHAR(10),
                instr_emplid VARCHAR(11),
                reg_cal_yr_num VARCHAR(4),
                reg_qtr_cd VARCHAR(1),
                reg_qtr_desc VARCHAR(2),
                total_section_enrollment NUMERIC,
                reg_yrqtr_cd VARCHAR(5),
                crse_acad_coll_cd VARCHAR(5),
                eff_status VARCHAR(1),
                instr_role VARCHAR(4),
                course_id VARCHAR(6)
);


CREATE TABLE peoplesoft.ps_job (
                emplid VARCHAR(11) NOT NULL,
                maxdt TIMESTAMP NOT NULL,
                mindt TIMESTAMP NOT NULL,
                deptid VARCHAR(10) NOT NULL,
                jobcode VARCHAR(6) NOT NULL,
                empl_status VARCHAR(1) NOT NULL,
                full_part_time VARCHAR(1) NOT NULL,
                company VARCHAR(3) NOT NULL,
                current_ind SMALLINT NOT NULL
);


CREATE INDEX ps_job_composite1_idx
 ON peoplesoft.ps_job
 ( emplid, deptid, jobcode );

CREATE TABLE peoplesoft.ps_jobcode_tbl (
                setid VARCHAR(5) NOT NULL,
                jobcode VARCHAR(6) NOT NULL,
                effdt TIMESTAMP NOT NULL,
                eff_status VARCHAR(1) NOT NULL,
                descr VARCHAR(30) NOT NULL,
                descrshort VARCHAR(10) NOT NULL,
                job_function VARCHAR(3) NOT NULL
);


CREATE INDEX ps_jobcode_tbl_jobcode_idx
 ON peoplesoft.ps_jobcode_tbl
 ( jobcode );

CREATE TABLE peoplesoft.ps_dept_tbl (
                setid VARCHAR(5) NOT NULL,
                deptid VARCHAR(10) NOT NULL,
                effdt TIMESTAMP NOT NULL,
                descr VARCHAR(30) NOT NULL,
                company VARCHAR(3) NOT NULL,
                setid_location VARCHAR(5) NOT NULL,
                location VARCHAR(10) NOT NULL,
                manager_id VARCHAR(11) NOT NULL,
                budget_deptid VARCHAR(10) NOT NULL,
                eff_status VARCHAR(1) NOT NULL,
                descrshort VARCHAR(10) NOT NULL
);


CREATE INDEX ps_dept_tbl_deptid_idx
 ON peoplesoft.ps_dept_tbl
 ( deptid );

CREATE TABLE peoplesoft.ps_names (
                emplid VARCHAR(11) NOT NULL,
                name_type VARCHAR(3) NOT NULL,
                effdt TIMESTAMP NOT NULL,
                eff_status VARCHAR(1) NOT NULL,
                country_nm_format VARCHAR(3) NOT NULL,
                name VARCHAR(50) NOT NULL,
                name_initials VARCHAR(6) NOT NULL,
                name_prefix VARCHAR(4) NOT NULL,
                name_suffix VARCHAR(15) NOT NULL,
                name_royal_prefix VARCHAR(15) NOT NULL,
                name_royal_suffix VARCHAR(15) NOT NULL,
                name_title VARCHAR(30) NOT NULL,
                last_name VARCHAR(30) NOT NULL,
                first_name VARCHAR(30) NOT NULL,
                middle_name VARCHAR(30) NOT NULL,
                second_last_name VARCHAR(30) NOT NULL,
                name_ac VARCHAR(50) NOT NULL,
                pref_first_name VARCHAR(30) NOT NULL,
                partner_last_name VARCHAR(30) NOT NULL,
                partner_roy_prefix VARCHAR(15) NOT NULL,
                last_name_pref_nld VARCHAR(1) NOT NULL,
                name_display VARCHAR(50) NOT NULL,
                name_formal VARCHAR(60) NOT NULL,
                lastupddttm TIMESTAMP,
                lastupdoprid VARCHAR(30) NOT NULL,
                campus_id VARCHAR(16)
);


CREATE INDEX ps_names_emplid_idx
 ON peoplesoft.ps_names
 ( emplid );

CREATE INDEX ps_names_campus_id_idx
 ON peoplesoft.ps_names
 ( campus_id );

CREATE INDEX ps_names_name_type_idx
 ON peoplesoft.ps_names
 ( name_type );