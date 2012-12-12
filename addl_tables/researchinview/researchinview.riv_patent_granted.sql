-- Table: researchinview.riv_patent_granted

-- DROP TABLE researchinview.riv_patent_granted;

CREATE TABLE researchinview.riv_patent_granted
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_patent_granted_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_patent_granted
  OWNER TO kmdata;
