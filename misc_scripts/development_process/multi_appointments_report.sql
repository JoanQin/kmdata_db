SELECT COUNT(DISTINCT user_id) FROM kmdata.user_appointments;

SELECT CASE WHEN apptstats.total_appointments > 1 THEN 'Multi' ELSE 'Single' END AS appt_classification,
	SUM(apptstats.total_people) AS total_people
FROM
(
	SELECT apptcount.total_appointments, COUNT(*) AS total_people
	FROM
	(
		SELECT COUNT(*) AS total_appointments, iua.user_id
		FROM kmdata.user_appointments iua
		GROUP BY iua.user_id
	) apptcount
	GROUP BY apptcount.total_appointments
) apptstats
GROUP BY CASE WHEN apptstats.total_appointments > 1 THEN 'Multi' ELSE 'Single' END;


SELECT COUNT(*) FROM kmdata.user_appointments WHERE title LIKE '%Professor%' OR title LIKE '%Faculty%';




SELECT COUNT(DISTINCT user_id) FROM kmdata.user_appointments WHERE title LIKE '%Professor%' OR title LIKE '%Faculty%';


SELECT CASE WHEN apptstats.total_appointments > 1 THEN 'Multi' ELSE 'Single' END AS appt_classification,
	SUM(apptstats.total_people) AS total_people
FROM
(
	SELECT apptcount.total_appointments, COUNT(*) AS total_people
	FROM
	(
		SELECT COUNT(*) AS total_appointments, iua.user_id
		FROM (
			SELECT DISTINCT user_id
			FROM kmdata.user_appointments 
			WHERE title LIKE '%Professor%' OR title LIKE '%Faculty%'
		) faculty
		INNER JOIN kmdata.user_appointments iua ON faculty.user_id = iua.user_id
		GROUP BY iua.user_id
	) apptcount
	GROUP BY apptcount.total_appointments
) apptstats
GROUP BY CASE WHEN apptstats.total_appointments > 1 THEN 'Multi' ELSE 'Single' END;






SELECT CASE WHEN apptstats.total_appointments > 1 THEN 'Multi' ELSE 'Single' END AS appt_classification,
	SUM(apptstats.total_people) AS total_people
FROM
(
	SELECT apptcount.total_appointments, COUNT(*) AS total_people
	FROM
	(
		SELECT COUNT(*) AS total_appointments, iua.user_id
		FROM kmdata.user_appointments iua
		WHERE iua.user_id NOT IN (
			SELECT DISTINCT user_id
			FROM kmdata.user_appointments 
			WHERE title LIKE '%Professor%' OR title LIKE '%Faculty%'
		)
		GROUP BY iua.user_id
	) apptcount
	GROUP BY apptcount.total_appointments
) apptstats
GROUP BY CASE WHEN apptstats.total_appointments > 1 THEN 'Multi' ELSE 'Single' END;




SELECT DISTINCT ua.title --ui.inst_username, u.first_name, u.last_name, ua.title, ua.department_id
FROM kmdata.user_appointments ua
INNER JOIN kmdata.user_identifiers ui ON ua.user_id = ui.user_id
INNER JOIN kmdata.users u ON ui.user_id = u.id
WHERE ua.user_id IN (
	SELECT iua.user_id
	FROM kmdata.user_appointments iua
	WHERE iua.user_id NOT IN (
		SELECT DISTINCT user_id
		FROM kmdata.user_appointments 
		WHERE title LIKE '%Professor%' OR title LIKE '%Faculty%'
	)
	GROUP BY iua.user_id
	HAVING COUNT(*) > 1
)
ORDER BY ua.title; --ui.inst_username, u.last_name, u.first_name, ua.title, ua.department_id;
