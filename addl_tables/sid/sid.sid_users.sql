-- Table: sid.sid_users

-- DROP TABLE sid.sid_users;

CREATE TABLE sid.sid_users
(
  id bigint NOT NULL,
  baseroleid integer NOT NULL,
  usertypeid integer NOT NULL,
  statusid smallint NOT NULL,
  sourceid smallint NOT NULL,
  iid character varying(255) NOT NULL,
  username character varying(255) NOT NULL,
  firstname character varying(255) NOT NULL,
  lastname character varying(255) NOT NULL,
  affiliation character varying(255) NOT NULL,
  password character varying(255),
  multildap smallint NOT NULL,
  lockid smallint NOT NULL,
  owner character varying(255),
  emplid character varying(255) NOT NULL,
  createdate timestamp without time zone NOT NULL,
  modifydate timestamp without time zone,
  usertype character varying(255) NOT NULL,
  middlename character varying(255),
  nameprefix character varying(255),
  namesuffix character varying(255),
  displayname character varying(2000) NOT NULL,
  CONSTRAINT sid_users_pk PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE sid.sid_users
  OWNER TO kmdata;
