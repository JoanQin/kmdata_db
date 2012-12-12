CREATE OR REPLACE VIEW ror.vw_PublicationStatuses AS
SELECT id, name
  FROM researchinview.riv_publication_statuses;

GRANT SELECT ON ror.vw_PublicationStatuses TO kmd_ror_app_user;
