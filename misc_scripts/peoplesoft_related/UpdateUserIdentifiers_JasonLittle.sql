CREATE UNIQUE INDEX user_identifiers_user_id_idx
  ON user_identifiers
  USING btree
  (user_id);

CREATE TABLE peoplesoft.ps_names_old
(
  emplid character varying(11) NOT NULL,
  name_type character varying(3) NOT NULL,
  effdt timestamp without time zone NOT NULL,
  eff_status character varying(1) NOT NULL,
  country_nm_format character varying(3) NOT NULL,
  "name" character varying(50) NOT NULL,
  name_initials character varying(6) NOT NULL,
  name_prefix character varying(4) NOT NULL,
  name_suffix character varying(15) NOT NULL,
  name_royal_prefix character varying(15) NOT NULL,
  name_royal_suffix character varying(15) NOT NULL,
  name_title character varying(30) NOT NULL,
  last_name character varying(30) NOT NULL,
  first_name character varying(30) NOT NULL,
  middle_name character varying(30) NOT NULL,
  second_last_name character varying(30) NOT NULL,
  name_ac character varying(50) NOT NULL,
  pref_first_name character varying(30) NOT NULL,
  partner_last_name character varying(30) NOT NULL,
  partner_roy_prefix character varying(15) NOT NULL,
  last_name_pref_nld character varying(1) NOT NULL,
  name_display character varying(50) NOT NULL,
  name_formal character varying(60) NOT NULL,
  lastupddttm timestamp without time zone,
  lastupdoprid character varying(30) NOT NULL,
  campus_id character varying(16)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE peoplesoft.ps_names_old OWNER TO kmdata;

-- Index: peoplesoft.ps_names_old_campus_id_idx

-- DROP INDEX peoplesoft.ps_names_old_campus_id_idx;

CREATE INDEX ps_names_old_campus_id_idx
  ON peoplesoft.ps_names_old
  USING btree
  (campus_id);

-- Index: peoplesoft.ps_names_old_emplid_idx

-- DROP INDEX peoplesoft.ps_names_old_emplid_idx;

CREATE INDEX ps_names_old_emplid_idx
  ON peoplesoft.ps_names_old
  USING btree
  (emplid);


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

select count(*) from peoplesoft.ps_names; -- 1228397
select count(*) from peoplesoft.ps_names_old; -- 1227132
-- truncate peoplesoft.ps_names


select * from peoplesoft.ps_email_addresses where email_addr = 'little.129@osu.edu';
select * from kmdata.user_identifiers where emplid = '03129362';
select * from peoplesoft.ps_names where emplid = '03129362';

SELECT COUNT(*) FROM kmdata.users; -- pre: 1216730; post: 1224901
SELECT COUNT(*) FROM kmdata.user_identifiers; -- pre: 1216723; 1224894

SELECT kmdata.import_users_from_ps(); -- 1215519 updated and 7450 inserted on prod
