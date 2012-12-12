-- Table: researchinview.riv_advisee_positions

-- DROP TABLE researchinview.riv_advisee_positions;

CREATE TABLE researchinview.riv_advisee_positions
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_advisee_positions_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_advisee_positions
  OWNER TO kmdata;
