-- upgrade script version 1.9

ALTER TABLE sid.OSU_SECTION ADD COLUMN enrl_tot NUMERIC(38);

ALTER TABLE sid.OSU_OFFERING ADD COLUMN units_acad_prog NUMERIC(5,2);
ALTER TABLE sid.OSU_OFFERING ADD COLUMN acad_career VARCHAR(4);

ALTER TABLE kmdata.offerings ADD COLUMN units_acad_prog NUMERIC(5,2);
ALTER TABLE kmdata.offerings ADD COLUMN acad_career VARCHAR(4);

ALTER TABLE kmdata.sections ADD COLUMN enrollment_total NUMERIC(38);

-- update kmdata.import_offerings_from_sid
-- update kmdata.import_sections_from_sid


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

