-- Table: researchinview.riv_instruction_methods

-- DROP TABLE researchinview.riv_instruction_methods;

CREATE TABLE researchinview.riv_instruction_methods
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_instruction_methods_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_instruction_methods
  OWNER TO kmdata;
