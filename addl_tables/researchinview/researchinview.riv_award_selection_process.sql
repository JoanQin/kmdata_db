-- Table: researchinview.riv_award_selection_process

-- DROP TABLE researchinview.riv_award_selection_process;

CREATE TABLE researchinview.riv_award_selection_process
(
  id bigint NOT NULL,
  name character varying(50),
  CONSTRAINT riv_award_selection_process_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_award_selection_process
  OWNER TO kmdata;
