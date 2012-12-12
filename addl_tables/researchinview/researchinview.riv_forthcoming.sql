-- Table: researchinview.riv_forthcoming

-- DROP TABLE researchinview.riv_forthcoming;

CREATE TABLE researchinview.riv_forthcoming
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_yes_no_unknown_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_forthcoming
  OWNER TO kmdata;
