-- upgrade script version 1.9

ALTER TABLE sid.OSU_SECTION ADD COLUMN enrl_tot NUMERIC(38);

ALTER TABLE sid.OSU_OFFERING ADD COLUMN units_acad_prog NUMERIC(5,2);
ALTER TABLE sid.OSU_OFFERING ADD COLUMN acad_career VARCHAR(4);

ALTER TABLE kmdata.offerings ADD COLUMN units_acad_prog NUMERIC(5,2);
ALTER TABLE kmdata.offerings ADD COLUMN acad_career VARCHAR(4);

ALTER TABLE kmdata.sections ADD COLUMN enrollment_total NUMERIC(38);

-- update kmdata.import_offerings_from_sid
-- update kmdata.import_sections_from_sid


-- the following 3 completed by JW 2/15/13
ALTER TABLE kmdata.groups ADD COLUMN slug VARCHAR(100);
ALTER TABLE kmdata.groups ADD COLUMN active BOOLEAN DEFAULT TRUE NOT NULL;
ALTER TABLE kmdata.groups ADD COLUMN deleted_at TIMESTAMP;

--UPDATE kmdata.groups SET slug = 'system-'||lower(replace(name,' ','-'));
-- initialize the HR slugs for faculty and staff
UPDATE kmdata.groups SET slug = kmdata.get_slug('system-hr-fs-'||name) WHERE inst_group_code IS NOT NULL;

ALTER TABLE kmdata.groups ALTER COLUMN slug SET NOT NULL;

CREATE UNIQUE INDEX groups_slug_idx
 ON kmdata.groups
 ( slug );

 
-- course changes: many in separate file

/*
COL
DGC
LMA
MCH
MNS
MRN
NWK
WST
*/
UPDATE kmdata.campuses SET ps_location_name = 'CS-DGC' WHERE campus_name = 'Wright/Pat Grad Center';
UPDATE kmdata.campuses SET ps_location_name = 'CS-MCH' WHERE campus_name = 'Mt. Carmel Nurse Program';
-- add the 3-letter campus code to the campus table
ALTER TABLE kmdata.campuses ADD COLUMN campus_code VARCHAR(5);
UPDATE kmdata.campuses SET campus_code = 'COL' WHERE ps_location_name = 'CS-COLMBUS';
UPDATE kmdata.campuses SET campus_code = 'DGC' WHERE ps_location_name = 'CS-DGC';
UPDATE kmdata.campuses SET campus_code = 'LMA' WHERE ps_location_name = 'CS-LIMA';
UPDATE kmdata.campuses SET campus_code = 'MCH' WHERE ps_location_name = 'CS-MCH';
UPDATE kmdata.campuses SET campus_code = 'MNS' WHERE ps_location_name = 'CS-MANSFLD';
UPDATE kmdata.campuses SET campus_code = 'MRN' WHERE ps_location_name = 'CS-MARION';
UPDATE kmdata.campuses SET campus_code = 'NWK' WHERE ps_location_name = 'CS-NEWARK';
UPDATE kmdata.campuses SET campus_code = 'WST' WHERE ps_location_name = 'CS-WOOSTER';


CREATE TABLE sid.ps_class_mtg_pat (
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
                facility_bldg_cd VARCHAR(10),
                facility_room VARCHAR(10),
                CONSTRAINT ps_class_mtg_pat_pk PRIMARY KEY (crse_id, crse_offer_nbr, strm, session_code, class_section, class_mtg_nbr)
);


CREATE TABLE sid.ps_class_instr (
                crse_id VARCHAR(6) NOT NULL,
                crse_offer_nbr NUMERIC NOT NULL,
                strm VARCHAR(4) NOT NULL,
                session_code VARCHAR(3) NOT NULL,
                class_section VARCHAR(4) NOT NULL,
                class_mtg_nbr NUMERIC NOT NULL,
                instr_assign_seq NUMERIC NOT NULL,
                src_sys_id VARCHAR(5),
                emplid VARCHAR(11),
                instr_role VARCHAR(4),
                grade_rstr_access VARCHAR(1),
                contact_minutes NUMERIC(38),
                sched_print_instr VARCHAR(1),
                instr_load_factor NUMERIC(10,4),
                empl_rcd NUMERIC(38),
                assign_type VARCHAR(3),
                week_workload_hrs NUMERIC(5,2),
                assignment_pct NUMERIC(5,2),
                auto_calc_wrkld VARCHAR(1),
                load_error VARCHAR(1),
                data_origin VARCHAR(1),
                created_ew_dttm TIMESTAMP,
                lastupd_ew_dttm TIMESTAMP,
                batch_sid NUMERIC(10),
                CONSTRAINT ps_class_instr_pk PRIMARY KEY (crse_id, crse_offer_nbr, strm, session_code, class_section, class_mtg_nbr, instr_assign_seq)
);

-- New views for Report User
GRANT SELECT ON kmd_dev_riv_user.vw_event TO kmd_report_user;
GRANT SELECT ON kmd_dev_riv_user.vw_program TO kmd_report_user;



-- SCHEMA CHANGES FOR KMDATA CORE COURSES

-- kmdata.courses
ALTER TABLE kmdata.courses ADD COLUMN ps_course_id VARCHAR(6) NOT NULL;
ALTER TABLE kmdata.courses DROP COLUMN course_number;
--ALTER TABLE kmdata.courses ADD COLUMN course_name_abbrev VARCHAR(30);
ALTER TABLE kmdata.courses ADD COLUMN repeatable VARCHAR(1);
ALTER TABLE kmdata.courses ADD COLUMN grading_basis VARCHAR(3);
ALTER TABLE kmdata.courses ADD COLUMN units_acad_prog NUMERIC(5,2);
ALTER TABLE kmdata.courses DROP COLUMN subject_id;

-- kmdata.offerings
ALTER TABLE kmdata.offerings ADD COLUMN ps_course_offer_number BIGINT NOT NULL;
ALTER TABLE kmdata.offerings DROP COLUMN term_session_id;
ALTER TABLE kmdata.offerings DROP COLUMN units_acad_prog;
ALTER TABLE kmdata.offerings ADD COLUMN campus_id BIGINT NOT NULL;
ALTER TABLE kmdata.offerings ADD COLUMN subject_id BIGINT NOT NULL;
ALTER TABLE kmdata.offerings ADD COLUMN course_number VARCHAR(10) NOT NULL;
-- new FK
ALTER TABLE kmdata.offerings ADD CONSTRAINT subjects_offerings_fk
FOREIGN KEY (subject_id)
REFERENCES kmdata.subjects (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
-- new FK
ALTER TABLE kmdata.offerings ADD CONSTRAINT campuses_offerings_fk
FOREIGN KEY (campus_id)
REFERENCES kmdata.campuses (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
-- new FK
ALTER TABLE kmdata.offerings ADD CONSTRAINT acad_departments_offerings_fk
FOREIGN KEY (acad_department_id)
REFERENCES kmdata.acad_departments (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- kmdata.sections
ALTER TABLE kmdata.sections ADD COLUMN term_session_id BIGINT NOT NULL;
ALTER TABLE kmdata.sections ADD COLUMN ps_class_section VARCHAR(4) NOT NULL;
-- new FK
ALTER TABLE kmdata.sections ADD CONSTRAINT term_sessions_sections_fk
FOREIGN KEY (term_session_id)
REFERENCES kmdata.term_sessions (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- kmdata.section_weekly_mtgs
ALTER TABLE kmdata.section_weekly_mtgs ADD COLUMN ps_class_mtg_number BIGINT NOT NULL;
ALTER TABLE kmdata.section_weekly_mtgs ADD COLUMN resource_id BIGINT NOT NULL;
-- new FK
ALTER TABLE kmdata.section_weekly_mtgs ADD CONSTRAINT resources_section_weekly_mtgs_fk
FOREIGN KEY (resource_id)
REFERENCES kmdata.resources (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- kmdata.enrollments
ALTER TABLE kmdata.enrollments DROP CONSTRAINT sections_enrollment_fk;
ALTER TABLE kmdata.enrollments DROP COLUMN section_id;
ALTER TABLE kmdata.enrollments ADD COLUMN section_weekly_mtg_id BIGINT NOT NULL;
ALTER TABLE kmdata.enrollments ADD COLUMN ps_instr_assign_seq BIGINT NOT NULL;
-- drop index
DROP INDEX enrollment_unique_set_idx;
-- new FK
ALTER TABLE kmdata.enrollments ADD CONSTRAINT section_weekly_mtgs_enrollments_fk
FOREIGN KEY (section_weekly_mtg_id)
REFERENCES kmdata.section_weekly_mtgs (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


-- new indexes

--courses_ps_course_id_idx
CREATE INDEX courses_ps_course_id_idx
 ON kmdata.courses
 ( ps_course_id );

--offerings_ps_course_offer_number_idx
CREATE INDEX offerings_ps_course_offer_number_idx
 ON kmdata.offerings
 ( ps_course_offer_number );

--sections_ps_class_section_idx
CREATE INDEX sections_ps_class_section_idx
 ON kmdata.sections
 ( ps_class_section );

--section_weekly_mtgs_ps_class_mtg_number_idx
CREATE INDEX section_weekly_mtgs_ps_class_mtg_number_idx
 ON kmdata.section_weekly_mtgs
 ( ps_class_mtg_number );

--enrollments_ps_instr_assign_seq_idx
CREATE INDEX enrollments_ps_instr_assign_seq_idx
 ON kmdata.enrollments
 ( ps_instr_assign_seq );

--term_sessions_session_code_idx
CREATE INDEX term_sessions_session_code_idx
 ON kmdata.term_sessions
 ( session_code );

--terms_term_code_idx
CREATE INDEX terms_term_code_idx
 ON kmdata.terms
 ( term_code );
 
-- missing foreign key constraint
ALTER TABLE kmdata.term_sessions ADD CONSTRAINT terms_term_sessions_fk
FOREIGN KEY (term_id)
REFERENCES kmdata.terms (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--term_sessions_term_id_idx
CREATE INDEX term_sessions_term_id_idx
 ON kmdata.term_sessions
 ( term_id );

--ps_class_tbl_strm_idx
CREATE INDEX ps_class_tbl_strm_idx
 ON sid.ps_class_tbl
 ( strm );

-- MODIFY TERMS TABLE
ALTER TABLE kmdata.terms ALTER COLUMN term_code TYPE VARCHAR(4);

--ps_class_instr_class_mtg_nbr_idx
CREATE INDEX ps_class_instr_class_mtg_nbr_idx
 ON sid.ps_class_instr
 ( class_mtg_nbr );

--section_weekly_mtgs_section_id_idx
CREATE INDEX section_weekly_mtgs_section_id_idx
 ON kmdata.section_weekly_mtgs
 ( section_id );


-- RAILS VIEWS CHANGE: REMOVE COLUMNS THAT ARE NULL
-- MAP SSR_COMPONENT IN CLASS_TBL TO SECTION_TYPE IN SECTIONS

ALTER TABLE kmdata.sections ADD COLUMN enrollment_capacity NUMERIC(38);
ALTER TABLE kmdata.sections ADD COLUMN waitlist_total NUMERIC(38);
ALTER TABLE kmdata.sections ADD COLUMN ssr_component VARCHAR(3);
ALTER TABLE kmdata.sections ADD COLUMN schedule_print VARCHAR(1);
ALTER TABLE kmdata.sections ADD COLUMN print_topic VARCHAR(1);
ALTER TABLE kmdata.sections ADD COLUMN instruction_mode VARCHAR(2);

ALTER TABLE kmdata.offerings ADD COLUMN schedule_print VARCHAR(1);
ALTER TABLE kmdata.offerings ADD COLUMN catalog_print VARCHAR(1);
ALTER TABLE kmdata.offerings ADD COLUMN sched_print_instr VARCHAR(1);

ALTER TABLE kmdata.enrollments ADD COLUMN sched_print_instr VARCHAR(1);


-- table changes round 2

-- colleges
--drop campus_id (FK? campus_colleges_fk)
ALTER TABLE kmdata.colleges DROP COLUMN campus_id;

-- offerings
--drop acad_department_id (FK? acad_departments_offerings_fk)
ALTER TABLE kmdata.offerings DROP COLUMN acad_department_id;
--add college_id
ALTER TABLE kmdata.offerings ADD COLUMN college_id BIGINT;
ALTER TABLE kmdata.offerings ADD CONSTRAINT colleges_offerings_fk
FOREIGN KEY (college_id)
REFERENCES kmdata.colleges (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
--add department_id
ALTER TABLE kmdata.offerings ADD COLUMN department_id BIGINT;
ALTER TABLE kmdata.offerings ADD CONSTRAINT departments_offerings_fk
FOREIGN KEY (department_id)
REFERENCES kmdata.departments (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- allow offerings to be active and inactive
ALTER TABLE kmdata.offerings ADD COLUMN active SMALLINT DEFAULT 1 NOT NULL;


/*
-- sections took 26 minutes
SELECT kmdata.log_etl_message('TRANSFORMATION', 'KMD2SIDMeetingPatternsProc', kmdata.import_section_weekly_mtgs_from_sid());

-- meeting patterns took 14 minutes
SELECT kmdata.log_etl_message('TRANSFORMATION', 'KMD2SIDMeetingPatternsProc', kmdata.import_section_weekly_mtgs_from_sid());

-- instructor enrollments took 17 minutes
SELECT kmdata.log_etl_message('TRANSFORMATION', 'KMD2SIDOsuUnitEnrollmentProc', kmdata.import_enrollments_from_ps());

select count(*) from kmdata.courses;             --  51979
select count(*) from kmdata.offerings;           -- 193845
select count(*) from kmdata.sections;            -- 110972
select count(*) from kmdata.section_weekly_mtgs; -- 154317
select count(*) from kmdata.enrollments;         -- 265415




-- 24 minutes (1403 seconds)
--SELECT kmdata.log_etl_message('TRANSFORMATION', 'KMD2SIDOsuOfferingProc', kmdata.import_offerings_from_sid());

-- 12 seconds
--SELECT kmdata.log_etl_message('TRANSFORMATION', 'KMD2SIDOsuSectionProc', kmdata.import_sections_from_sid());

-- 7 minutes (419 seconds)
--SELECT kmdata.log_etl_message('TRANSFORMATION', 'KMD2SIDMeetingPatternsProc', kmdata.import_section_weekly_mtgs_from_sid());

-- 8.5 minutes (511 seconds)
--SELECT kmdata.log_etl_message('TRANSFORMATION', 'KMD2SIDOsuUnitEnrollmentProc', kmdata.import_enrollments_from_ps());


select count(*) from kmdata.courses;             --  52018
select count(*) from kmdata.offerings;           --  78427
select count(*) from kmdata.sections;            --  43680
select count(*) from kmdata.section_weekly_mtgs; --  62908
select count(*) from kmdata.enrollments;         --  87067

*/


-- RECOVER ROR VIEWS
-- courses, offerings, sections, section_weekly_mtgs, enrollments, terms


  
------------------------------------------
-- Start Metadata generating documentation
------------------------------------------

DROP TABLE IF EXISTS ror.entity CASCADE ;

CREATE TABLE ror.entity
(
  entity character varying(32) NOT NULL, 
  base_view character varying(32), 
  CONSTRAINT entity_pk PRIMARY KEY (entity)
)
WITH (
  OIDS=FALSE
);

COMMENT ON COLUMN ror.entity.entity IS 'Unique identifier for an entity';
COMMENT ON COLUMN ror.entity.base_view IS 'Name of the base view representing this entity.';

----------------------------

DROP TABLE IF EXISTS ror.entity_field ;

CREATE TABLE ror.entity_field
(
  entity character varying(32) NOT NULL,
  entity_field character varying(32),
  view_field character varying(32),
  override_ordinal_position integer,
  override_is_nullable character varying(3),
  override_udt_name character varying,
  override_character_maximum_length integer,
  description text,
  classification character varying(10),
  sample text
)
WITH (
  OIDS=FALSE
);

COMMENT ON COLUMN ror.entity_field.entity IS 'Identifier for the entity';
COMMENT ON COLUMN ror.entity_field.entity_field IS 'Identifier for the field in the entity.  If this is NULL, it means that view_field is to be excluded.';
COMMENT ON COLUMN ror.entity_field.view_field IS 'Identifier for the field in the view.  If this is NULL, it means there is no corresponding field in the view.';
COMMENT ON COLUMN ror.entity_field.override_ordinal_position IS 'Override of view metadata. Note, to allow insertion, view ordinals will be multiplied by 100';
COMMENT ON COLUMN ror.entity_field.override_is_nullable IS 'Override of view metadata';
COMMENT ON COLUMN ror.entity_field.override_udt_name IS 'Override of view metadata';
COMMENT ON COLUMN ror.entity_field.override_character_maximum_length IS 'Override of view metadata';
COMMENT ON COLUMN ror.entity_field.description IS 'Description of the field';
COMMENT ON COLUMN ror.entity_field.classification IS 'Highest level of restrictedness, must be {puiblic, limited, restricted}';
COMMENT ON COLUMN ror.entity_field.sample IS 'Example of the type of data stored in this field';

---------------------------

INSERT INTO ror.entity (entity, base_view) VALUES
  -- Various
  ('campus', 'vw_campuses'),
  ('citation', 'vw_workcitations'),
  ('course', 'vw_courses'),
  ('degree_type', 'vw_degreetypes'),
  ('department', 'vw_departments'),
  ('language', 'vw_languages'),
  ('narrative_type', 'vw_narrativetypes'),
  ('strategic_initiative', 'vw_strategicinitiatives'),
  ('subject', 'vw_subjects'),
  ('term', 'vw_terms'),
  ('term_session', 'vw_termsessions'),
  
  -- Preferred stuff (from Pro? Shouldn't be here?)
  -- ('preferred_appointment', ''),
  -- ('preferred_keyword', ''),
  -- ('preferred_name', ''),
  
  -- Courses
  ('offering', 'vw_offerings'),
  ('section', 'vw_sections'),
  ('section_meeting', 'vw_sectionweeklymtgs'),
  
  -- Things that shouldn't be visible
  -- ('ability', ''),
  -- ('enrollment', ''), -- course related?
  -- ('enrollment_role', ''), -- course related?
  -- ('keyword_search_result', ''),
  -- ('kmdata_table', ''),
  -- ('misc_course', ''),
  -- ('resource', ''),
  -- ('strategic_initiative', ''),
  -- ('user', ''),
  -- ('work', ''),
  -- ('work_type', ''),
  
  -- Groups do not have a base table/view in rails so excluding for now
  -- ('group', ''),
  -- ('group_categorization', ''),
  -- ('group_category', ''),
  -- ('group_exclusion', ''),
  -- ('group_membership', ''),
  -- ('grop_nesting', ''),
  -- ('group_permission', ''),
  -- ('group_property', ''),
  -- ('group_property_value', ''),
  
  -- People and people related includes
  ('person', 'vw_people'),
  ('address', 'vw_personaddresses'),
  ('advisee', 'vw_advising'),
  ('appointment', 'vw_personappointments'),
  ('artwork', 'vw_artwork'),
  ('audio_visual_work', 'vw_audiovisual'),
  ('book', 'vw_book'),
  ('chapter', 'vw_bookchapter'),
  ('clinical_service', 'vw_clinicalservice'),
  ('clinical_trial', 'vw_clinicaltrials'),
  ('conference', 'vw_conference'),
  ('degree_certification', 'vw_degreecertification'),
  ('edited_book', 'vw_editedbook'),
  ('editorial_activity', 'vw_editorialactivity'),
  ('email', 'vw_personemails'),
  ('honor', 'vw_personhonorsawards'),
  ('identifier', 'vw_personidentifiers'),
  ('journal_article', 'vw_journal'),
  ('language_proficiency', 'vw_personlanguages'),
  ('music', 'vw_music'),
  ('other_creative_work', 'vw_othercreativework'),
  ('narrative', 'vw_narratives'),
  ('patent', 'vw_patent'),
  ('phone_number', 'vw_personphones'),
  ('position', 'vw_personpositions'),
  ('presentation', 'vw_presentation'),
  ('professional_activity', ''),
  ('professional_society_membership', ''),
  ('reference_work', 'vw_referencework'),
  ('software', 'vw_software'),
  ('technical_report', 'vw_technicalreport'),
  ('unpublished_work', 'vw_unpublished')
  ;

 
-- Let's describe existing view fields without overriding (both entity_field and view_field)
INSERT INTO ror.entity_field 
  (entity,         entity_field,      view_field,       classification, sample,       description) VALUES
  ('person',       'last_name',       'last_name',      'public',       'Booth',              'Last name of individual'),
  ('person',       'first_name',      'first_name',     'public',       'John',               'First name of individual'),
  ('person',       'middle_name',     'middle_name',    'public',       'Wilkes',             'Middle name of individual'),
  ('person',       'name_prefix',     'name_prefix',    'public',       'Mr',                 'Mr, Dr, etc'),
  ('person',       'name_suffix',     'name_suffix',    'public',       'Jr.',                'Something appended to a name'),
  ('person',       'display_name',    'display_name',   'public',       'John Wilkes Booth',  'A full name'),
  ('person',       'deceased_ind',    'deceased_ind',   'public',       '1',                  '1 if the person is deceased according to HR. If someone truly has passed, this is usually only correct if the person died while strongly affiliated.'),
  ('appointment',  'department_id',   'department_id',  'public',       '14060',              'Department identifier at Ohio State'),
  ('appointment',  'rcd_num',         'rcd_num',        'public',       '1',                  'The "record number" within HR.  This is the best known sort criteria but does not necessarily yield the order everyone wants.')
  ;  
-- Let's add an API only field (no view_field)
-- INSERT INTO ror.entity_field 
--  (entity,         entity_field,      classification,   sample,                   override_ordinal_position, override_is_nullable, override_udt_name, override_character_maximum_length, description) VALUES
--  ('person',       'display_name',       'public',         'John Wilkes Booth',      1,                         'YES',                'varchar',         150,                               'Concatenation of first, middle, and last names')
--  ;  
  
-- Let's remove fields that should be there (no entity_field)
INSERT INTO ror.entity_field (entity, view_field) VALUES
  ('person', 'resource_id'),
  ('address', 'resource_id'),
  ('advisee', 'resource_id'),
  ('appointment', 'resource_id'),
  ('book', 'resource_id'),
  ('chapter', 'resource_id')
  ;


-- Manually add ./views/ror/ror.vw_EntityField.sql
  
------------------------------------
-- End metadata generating doc
------------------------------------



