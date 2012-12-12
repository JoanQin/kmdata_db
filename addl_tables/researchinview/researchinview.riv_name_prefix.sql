-- Table: researchinview.riv_name_prefix

-- DROP TABLE researchinview.riv_name_prefix;

CREATE TABLE researchinview.riv_name_prefix
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_name_prefix_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_name_prefix
  OWNER TO kmdata;
