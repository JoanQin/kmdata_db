select 'GRANT EXECUTE ON FUNCTION '||routine_schema||'.'||routine_name||kmdata.get_routine_param_signature(specific_catalog, specific_schema, specific_name)||' TO kmd_riv_tr_export_user;'
from information_schema.routines
where routine_schema = 'researchinview'
and routine_name = ''
ORDER BY routine_schema, routine_name;

SELECT * FROM pg_proc WHERE proname = 'insert_biosketchnarrative' LIMIT 200;

SELECT * FROM information_schema.routines where routine_schema = 'researchinview' and routine_name = 'insert_conference' LIMIT 200;

"insert_html_book_58554"

--SELECT proargtypes, * FROM pg_proc LIMIT 200;


SELECT * FROM information_schema.parameters 
WHERE specific_catalog = 'kmdata_dev'
AND specific_schema = 'researchinview'
AND specific_name = 'get_month_57189'
AND parameter_mode = 'IN'
ORDER BY ordinal_position ASC
LIMIT 200;

SELECT kmdata.get_routine_param_signature('kmdata_dev', 'researchinview', 'insert_conference_55904');

["(character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, text, character varying, character varying, numeric, character varying, character varying, character varying, character varying, integer, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying)"]

select
    r.routine_name,
    p.parameter_name,
    max(case when p.ordinal_position = 1 then p.data_type else '' end) as p1,
    max(case when p.ordinal_position = 2 then p.data_type else '' end) as p2,
    max(case when p.ordinal_position = 3 then p.data_type else '' end) as p3,
    max(case when p.ordinal_position = 4 then p.data_type else '' end) as p4,
    max(case when p.ordinal_position = 5 then p.data_type else '' end) as p5,
    max(case when p.ordinal_position = 6 then p.data_type else '' end) as p6,
    max(case when p.ordinal_position = 7 then p.data_type else '' end) as p7,
    max(case when p.ordinal_position = 8 then p.data_type else '' end) as p8
from
    information_schema.routines r
    left join information_schema.parameters p
    on
        r.specific_catalog = p.specific_catalog
        and r.specific_schema = p.specific_schema
        and r.specific_name = p.specific_name
        and p.parameter_mode = 'IN'
where
    r.routine_schema = 'researchinview'
    --r.routine_type='FUNCTION'
group by
    r.routine_name,
    p.parameter_name
order by
    r.routine_name,
    p.parameter_name;