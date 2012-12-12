CREATE OR REPLACE VIEW ror.vw_Unpublished AS 
 SELECT w.id, w.user_id AS person_id, w.title, w.author_list, w.percent_authorship, 
        w.submission_dmy_single_date_id, sd1.day AS submission_day, sd1.month AS submission_month, sd1.year AS submission_year,
        w.status_id, w.review_type_id, w.created_at, w.updated_at, w.submitted_to, 
        CASE ail.is_public WHEN 1 THEN TRUE ELSE FALSE END AS is_public,
        COALESCE(w.extended_author_list, w.author_list) AS extended_author_list
   FROM kmdata.works w
   LEFT JOIN kmdata.dmy_single_dates sd1 ON w.submission_dmy_single_date_id = sd1.id
   INNER JOIN kmdata.resources res ON w.resource_id = res.id
   INNER JOIN kmdata.sources src ON res.source_id = src.id
   INNER JOIN researchinview.activity_import_log ail ON w.resource_id = ail.resource_id
 WHERE w.work_type_id = 10
   AND src.source_name != 'osupro'
   AND ail.is_active = 1;
-- w.resource_id, w.work_type_id, 