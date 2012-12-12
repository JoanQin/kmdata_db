-- Table: researchinview.riv_position_title

-- DROP TABLE researchinview.riv_position_title;

CREATE TABLE researchinview.riv_position_title
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_position_title_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_position_title
  OWNER TO kmdata;
