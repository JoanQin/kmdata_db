CREATE OR REPLACE VIEW ror.vw_WorkAuthors AS
SELECT wa.id, wa.work_id, wa.user_id AS person_id
  FROM kmdata.work_authors wa;
