-- Table: researchinview.riv_name_gender

-- DROP TABLE researchinview.riv_name_gender;

CREATE TABLE researchinview.riv_name_gender
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_name_gender_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_name_gender
  OWNER TO kmdata;
