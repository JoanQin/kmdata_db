
CREATE TABLE researchinview.riv_institutions (
                id BIGINT NOT NULL,
                name NVARCHAR(4000) NOT NULL,
                CONSTRAINT riv_institutions_pk PRIMARY KEY (id)
);


CREATE SEQUENCE researchinview.activity_import_log_id_seq;

CREATE TABLE researchinview.activity_import_log (
                id BIGINT NOT NULL DEFAULT nextval('researchinview.activity_import_log_id_seq'),
                integration_activity_id VARCHAR(2000) NOT NULL,
                integration_user_id VARCHAR(2000) NOT NULL,
                riv_activity_name VARCHAR(100) NOT NULL,
                change_type VARCHAR(20) NOT NULL,
                update_date TIMESTAMP NOT NULL,
                is_public SMALLINT NOT NULL,
                extended_attribute_1 VARCHAR(4000),
                extended_attribute_2 VARCHAR(4000),
                extended_attribute_3 VARCHAR(4000),
                extended_attribute_4 VARCHAR(4000),
                extended_attribute_5 VARCHAR(4000),
                resource_id BIGINT,
                CONSTRAINT activity_import_log_pk PRIMARY KEY (id)
);


ALTER SEQUENCE researchinview.activity_import_log_id_seq OWNED BY researchinview.activity_import_log.id;