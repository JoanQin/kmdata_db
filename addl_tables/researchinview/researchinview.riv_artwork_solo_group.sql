-- Table: researchinview.riv_artwork_solo_group

-- DROP TABLE researchinview.riv_artwork_solo_group;

CREATE TABLE researchinview.riv_artwork_solo_group
(
  id bigint NOT NULL,
  name character varying(50),
  CONSTRAINT riv_artwork_solo_group_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_artwork_solo_group
  OWNER TO kmdata;
