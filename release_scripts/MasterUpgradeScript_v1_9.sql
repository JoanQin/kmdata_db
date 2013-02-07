-- upgrade script version 1.9

ALTER TABLE sid.OSU_SECTION ADD COLUMN enrl_tot NUMERIC(38);

ALTER TABLE sid.OSU_OFFERING ADD COLUMN units_acad_prog NUMERIC(5,2);
ALTER TABLE sid.OSU_OFFERING ADD COLUMN acad_career VARCHAR(4);

ALTER TABLE kmdata.offerings ADD COLUMN units_acad_prog NUMERIC(5,2);
ALTER TABLE kmdata.offerings ADD COLUMN acad_career VARCHAR(4);

ALTER TABLE kmdata.sections ADD COLUMN enrollment_total NUMERIC(38);

-- update kmdata.import_offerings_from_sid
-- update kmdata.import_sections_from_sid


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



