CREATE TABLE kmd_dev_riv_user.users_in_riv
(
  id bigserial NOT NULL,
  username character varying(100) NOT NULL,
  emplid character varying(11) NOT NULL,
  usertype character varying(255) NOT NULL,
  CONSTRAINT users_in_riv_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE kmd_dev_riv_user.users_in_riv
  OWNER TO kmd_dev_riv_user;
GRANT ALL ON TABLE researchinview.users_in_riv TO kmdata;
GRANT SELECT ON TABLE researchinview.users_in_riv TO kmd_riv_tr_import_user;
--GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE researchinview.users_in_riv TO kmd_dev_riv_user;

INSERT INTO kmd_dev_riv_user.users_in_riv (id, username, emplid, usertype)
SELECT id, username, emplid, usertype FROM researchinview.users_in_riv;