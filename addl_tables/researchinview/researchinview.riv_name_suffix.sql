-- Table: researchinview.riv_name_suffix

-- DROP TABLE researchinview.riv_name_suffix;

CREATE TABLE researchinview.riv_name_suffix
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_name_suffix_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_name_suffix
  OWNER TO kmdata;
