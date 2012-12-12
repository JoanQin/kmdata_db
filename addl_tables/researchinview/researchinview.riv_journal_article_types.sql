-- Table: researchinview.riv_journal_article_types

-- DROP TABLE researchinview.riv_journal_article_types;

CREATE TABLE researchinview.riv_journal_article_types
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_journal_article_types_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_journal_article_types
  OWNER TO kmdata;
