-- Table: researchinview.riv_grant_statuses

-- DROP TABLE researchinview.riv_grant_statuses;

CREATE TABLE researchinview.riv_grant_statuses
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_grant_statuses_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_grant_statuses
  OWNER TO kmdata;
