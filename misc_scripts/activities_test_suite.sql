SELECT a.*, b.*
FROM researchinview.activity_import_log a
INNER JOIN kmdata.degree_certifications b ON a.resource_id = b.resource_id
WHERE a.riv_activity_name = 'Licensure'
ORDER BY a.id
LIMIT 2000;

SELECT a.*, b.*
FROM researchinview.activity_import_log a
INNER JOIN kmdata.works b ON a.resource_id = b.resource_id
WHERE a.riv_activity_name = 'Unpublished'
ORDER BY a.id
LIMIT 2000;

select * from kmdata.dmy_single_dates where id = 511314;

SELECT a.*, b.*, c.*
FROM researchinview.activity_import_log a
INNER JOIN kmdata.narratives b ON a.resource_id = b.resource_id
INNER JOIN kmdata.narrative_types c ON b.narrative_type_id = c.id
WHERE a.riv_activity_name IN ('CurriculumDevelopmentNarrative')
ORDER BY a.id
LIMIT 2000;

SELECT * FROM kmdata.work_types;

SELECT a.*, b.*
FROM researchinview.activity_import_log a
INNER JOIN kmdata.user_positions b ON a.resource_id = b.resource_id
WHERE a.riv_activity_name = 'Position'
ORDER BY a.id
LIMIT 2000;

SELECT a.*, b.*
FROM researchinview.activity_import_log a
INNER JOIN kmdata.degree_certifications b ON a.resource_id = b.resource_id
WHERE a.riv_activity_name = 'Licensure'
ORDER BY a.id
LIMIT 2000;

SELECT a.*, b.*, c.*, d.*
FROM researchinview.activity_import_log a
INNER JOIN kmdata.user_languages b ON a.resource_id = b.resource_id
INNER JOIN kmdata.languages c ON b.language_id = c.id
LEFT JOIN kmdata.language_dialects d ON b.dialect_id = d.id
WHERE a.riv_activity_name = 'ForeignLanguage'
ORDER BY a.id
LIMIT 2000;

SELECT a.*, b.*
FROM researchinview.activity_import_log a
INNER JOIN kmdata.user_preferred_names b ON a.resource_id = b.resource_id
WHERE a.riv_activity_name = 'Personal'
ORDER BY a.id
LIMIT 2000;

SELECT a.*, b.*
FROM researchinview.activity_import_log a
INNER JOIN kmdata.grant_data b ON a.resource_id = b.resource_id
WHERE a.riv_activity_name = 'Grant'
ORDER BY a.id
LIMIT 2000;

SELECT a.*, b.*
FROM researchinview.activity_import_log a
INNER JOIN kmdata.editorial_activity b ON a.resource_id = b.resource_id
WHERE a.riv_activity_name = 'Editorship'
ORDER BY a.id
LIMIT 2000;

SELECT a.*, b.*
FROM researchinview.activity_import_log a
INNER JOIN kmdata.membership b ON a.resource_id = b.resource_id
WHERE a.riv_activity_name = 'Society'
ORDER BY a.id
LIMIT 2000;

SELECT a.*, b.*
FROM researchinview.activity_import_log a
INNER JOIN kmdata.professional_activity b ON a.resource_id = b.resource_id
WHERE a.riv_activity_name = 'Consultant'
ORDER BY a.id
LIMIT 2000;

SELECT a.*, b.*
FROM researchinview.activity_import_log a
INNER JOIN kmdata.clinical_service b ON a.resource_id = b.resource_id
WHERE a.riv_activity_name = 'ClinicalService'
ORDER BY a.id
LIMIT 2000;

SELECT a.*, b.*
FROM researchinview.activity_import_log a
INNER JOIN kmdata.clinical_trials b ON a.resource_id = b.resource_id
WHERE a.riv_activity_name = 'ClinicalTrial'
ORDER BY a.id
LIMIT 2000;

SELECT a.*, b.*
FROM researchinview.activity_import_log a
INNER JOIN kmdata.user_services b ON a.resource_id = b.resource_id
WHERE a.riv_activity_name = 'Committee'
ORDER BY a.id
LIMIT 2000;

SELECT COUNT(*) FROM kmdata.user_services;

SELECT ail.*, n.*
FROM kmdata.narratives n
INNER JOIN kmdata.user_service_narratives usn ON n.id = usn.narrative_id
INNER JOIN kmdata.user_services us ON usn.user_service_id = us.id
INNER JOIN researchinview.activity_import_log ail ON us.resource_id = ail.resource_id
WHERE ail.riv_activity_name = 'Committee'
ORDER BY n.id
LIMIT 2000;

SELECT a.*, b.*
FROM researchinview.activity_import_log a
INNER JOIN kmdata.advising b ON a.resource_id = b.resource_id
WHERE a.riv_activity_name = 'StudentAdvising'
ORDER BY a.id
LIMIT 2000;

SELECT a.*, b.*
FROM researchinview.activity_import_log a
INNER JOIN kmdata.strategic_initiatives b ON a.resource_id = b.resource_id
WHERE a.riv_activity_name = 'StrategicInitiative'
ORDER BY a.id
LIMIT 2000;

SELECT a.*, b.*
FROM researchinview.activity_import_log a
INNER JOIN kmdata.user_honors_awards b ON a.resource_id = b.resource_id
WHERE a.riv_activity_name = 'AwardAndHonor'
ORDER BY a.id
LIMIT 2000;

SELECT a.*, b.*
FROM researchinview.activity_import_log a
INNER JOIN kmdata.courses_taught b ON a.resource_id = b.resource_id
WHERE a.riv_activity_name = 'CourseUndergraduate'
ORDER BY a.id
LIMIT 2000;

SELECT COUNT(*) FROM kmdata.courses_taught;

SELECT a.*, b.*
FROM researchinview.activity_import_log a
INNER JOIN kmdata.courses_taught_other b ON a.resource_id = b.resource_id
WHERE a.riv_activity_name = 'CourseContinuingEd'
ORDER BY a.id
LIMIT 2000;

