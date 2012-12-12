CREATE OR REPLACE VIEW ror.vw_JournalArticleTypes AS
SELECT id, name
  FROM researchinview.riv_journal_article_types;

GRANT SELECT ON ror.vw_JournalArticleTypes TO kmd_ror_app_user;

