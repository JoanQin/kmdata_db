-- Table: researchinview.riv_music_roles

-- DROP TABLE researchinview.riv_music_roles;

CREATE TABLE researchinview.riv_music_roles
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_music_roles_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_music_roles
  OWNER TO kmdata;
