-- Table: researchinview.riv_institutions

-- DROP TABLE researchinview.riv_institutions;

CREATE TABLE researchinview.riv_institutions
(
  id bigint NOT NULL,
  name character varying(4000) NOT NULL,
  CONSTRAINT riv_institutions_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_institutions
  OWNER TO kmdata;
