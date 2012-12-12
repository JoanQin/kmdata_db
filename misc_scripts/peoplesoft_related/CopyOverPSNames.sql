-- ~ 1 minute
INSERT INTO peoplesoft.ps_names_old
(emplid, name_type, effdt, eff_status, country_nm_format, "name",
name_initials, name_prefix, name_suffix, name_royal_prefix, name_royal_suffix,
name_title, last_name, first_name, middle_name, second_last_name, name_ac,
pref_first_name, partner_last_name, partner_roy_prefix, last_name_pref_nld,
name_display, name_formal, lastupddttm, lastupdoprid, campus_id)
SELECT
emplid, name_type, effdt, eff_status, country_nm_format, "name",
name_initials, name_prefix, name_suffix, name_royal_prefix, name_royal_suffix,
name_title, last_name, first_name, middle_name, second_last_name, name_ac,
pref_first_name, partner_last_name, partner_roy_prefix, last_name_pref_nld,
name_display, name_formal, lastupddttm, lastupdoprid, campus_id
FROM peoplesoft.ps_names;