-- Table: researchinview.riv_professional_society_role_modifiers

-- DROP TABLE researchinview.riv_professional_society_role_modifiers;

CREATE TABLE researchinview.riv_professional_society_role_modifiers
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_professional_society_role_modifiers_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_professional_society_role_modifiers
  OWNER TO kmdata;
