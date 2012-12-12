-- Table: researchinview.riv_sync_with_researcherid

-- DROP TABLE researchinview.riv_sync_with_researcherid;

CREATE TABLE researchinview.riv_sync_with_researcherid
(
  id bigint NOT NULL,
  name character varying(1000),
  CONSTRAINT riv_sync_with_researcherid_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE researchinview.riv_sync_with_researcherid
  OWNER TO kmdata;
