-- Table: researchinview.riv_unpublish_submission_status

-- DROP TABLE researchinview.riv_unpublish_submission_status;

CREATE TABLE researchinview.riv_unpublish_submission_status
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_unpublish_submission_status_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_unpublish_submission_status
  OWNER TO kmdata;
