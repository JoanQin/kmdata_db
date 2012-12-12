-- Table: researchinview.riv_publication_freq

-- DROP TABLE researchinview.riv_publication_freq;

CREATE TABLE researchinview.riv_publication_freq
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_publication_freq_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_publication_freq
  OWNER TO kmdata;
