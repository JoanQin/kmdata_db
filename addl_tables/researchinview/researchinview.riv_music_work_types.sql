-- Table: researchinview.riv_music_work_types

-- DROP TABLE researchinview.riv_music_work_types;

CREATE TABLE researchinview.riv_music_work_types
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_music_work_types_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_music_work_types
  OWNER TO kmdata;
