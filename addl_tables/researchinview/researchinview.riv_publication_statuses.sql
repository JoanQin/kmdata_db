-- Table: researchinview.riv_publication_statuses

-- DROP TABLE researchinview.riv_publication_statuses;

CREATE TABLE researchinview.riv_publication_statuses
(
  id bigint NOT NULL,
  name character varying(50),
  CONSTRAINT riv_publication_statuses_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_publication_statuses
  OWNER TO kmdata;
