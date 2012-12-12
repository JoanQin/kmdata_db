-- Table: researchinview.riv_software_type_of_work

-- DROP TABLE researchinview.riv_software_type_of_work;

CREATE TABLE researchinview.riv_software_type_of_work
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_type_of_work_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_software_type_of_work
  OWNER TO kmdata;
