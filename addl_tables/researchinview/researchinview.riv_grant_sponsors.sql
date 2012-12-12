-- Table: researchinview.riv_grant_sponsors

-- DROP TABLE researchinview.riv_grant_sponsors;

CREATE TABLE researchinview.riv_grant_sponsors
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_grant_sponsors_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_grant_sponsors
  OWNER TO kmdata;
