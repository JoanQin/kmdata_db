-- Table: researchinview.riv_foreign_languages

-- DROP TABLE researchinview.riv_foreign_languages;

CREATE TABLE researchinview.riv_foreign_languages
(
  id bigint NOT NULL,
  name character varying(2000),
  CONSTRAINT riv_foreign_languages_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_foreign_languages
  OWNER TO kmdata;
