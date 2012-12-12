-- Table: researchinview.riv_figure_types

-- DROP TABLE researchinview.riv_figure_types;

CREATE TABLE researchinview.riv_figure_types
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_figure_types_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_figure_types
  OWNER TO kmdata;
