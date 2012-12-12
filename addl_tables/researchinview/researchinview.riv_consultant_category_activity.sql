-- Table: researchinview.riv_consultant_category_activity

-- DROP TABLE researchinview.riv_consultant_category_activity;

CREATE TABLE researchinview.riv_consultant_category_activity
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_consultant_category_activity_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_consultant_category_activity
  OWNER TO kmdata;
