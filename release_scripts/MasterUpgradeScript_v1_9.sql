-- upgrade script version 1.9

ALTER TABLE sid.OSU_SECTION ADD COLUMN enrl_tot NUMERIC(38);

ALTER TABLE sid.OSU_OFFERING ADD COLUMN units_acad_prog NUMERIC(5,2);
ALTER TABLE sid.OSU_OFFERING ADD COLUMN acad_career VARCHAR(4);

ALTER TABLE kmdata.offerings ADD COLUMN units_acad_prog NUMERIC(5,2);
ALTER TABLE kmdata.offerings ADD COLUMN acad_career VARCHAR(4);

ALTER TABLE kmdata.sections ADD COLUMN enrollment_total NUMERIC(38);

-- update kmdata.import_offerings_from_sid
-- update kmdata.import_sections_from_sid


