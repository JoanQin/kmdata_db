-- Table: researchinview.riv_states

-- DROP TABLE researchinview.riv_states;

CREATE TABLE researchinview.riv_states
(
  id bigserial NOT NULL,
  name character varying(100),
  value character varying(50),
  CONSTRAINT riv_states_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_states
  OWNER TO kmdata;
