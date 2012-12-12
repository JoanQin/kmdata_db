-- Table: researchinview.riv_internet_communication_medium

-- DROP TABLE researchinview.riv_internet_communication_medium;

CREATE TABLE researchinview.riv_internet_communication_medium
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_internet_communication_medium_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_internet_communication_medium
  OWNER TO kmdata;
