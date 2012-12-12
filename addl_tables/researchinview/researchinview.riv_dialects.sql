-- Table: researchinview.riv_dialects

-- DROP TABLE researchinview.riv_dialects;

CREATE TABLE researchinview.riv_dialects
(
  id bigint NOT NULL,
  name character varying(2000),
  CONSTRAINT riv_dialects_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_dialects
  OWNER TO kmdata;
