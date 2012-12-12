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

-- step 5
SELECT kmdata.import_institutions();

-- step 6
SELECT kmdata.import_degrees_and_certifications();

select count(*) from osupro.degree; -- 9718
select count(*) from osupro.certification; -- 1767

-- 11485
select count(*) from kmdata.degree_certifications;

-- STEP 7
INSERT INTO kmdata.roles (name)
   SELECT DISTINCT description
   FROM osupro.appointment_title_ref
   WHERE description LIKE '%Professor%' OR description LIKE '%Faculty%';

-- STEP 8
INSERT INTO kmdata.user_roles (user_id, role_id)
   SELECT DISTINCT d.user_id, c.id
   FROM osupro.user_appointments a
   INNER JOIN osupro.appointment_title_ref b ON a.job_code = b.jobcode
   INNER JOIN kmdata.roles c ON b.description = c.name
   INNER JOIN kmdata.user_identifiers d ON a.profile_emplid = d.emplid
   WHERE c.name LIKE '%Professor%' OR c.name LIKE '%Faculty%';

select count(*) from osupro.user_appointments;
SELECT * FROM kmdata.roles;

select distinct jobcode, description, abbreviation
from osupro.appointment_title_ref
WHERE description LIKE '%Professor%' OR description LIKE '%Faculty%'
order by jobcode asc;

