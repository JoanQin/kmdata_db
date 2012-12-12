CREATE OR REPLACE FUNCTION kmdata.get_users_with_keyterms (
   p_QueryString VARCHAR,
   refcursor
) RETURNS refcursor AS $$
DECLARE
   --v_curResult refcursor;
BEGIN
   -- open the result set
   OPEN $2 FOR
   SELECT SUM(iq.total_matches) AS total_matches, iq.inst_username
   FROM (
      SELECT COUNT(DISTINCT n.id) AS total_matches, ui.inst_username 
      FROM kmdata.narratives n 
      INNER JOIN kmdata.user_narratives un ON n.id = un.narrative_id
      INNER JOIN kmdata.user_identifiers ui ON un.user_id = ui.user_id
      INNER JOIN kmdata.resources res ON n.resource_id = res.id
      INNER JOIN kmdata.sources src ON res.source_id = src.id
      WHERE src.source_name != 'osupro'
      AND to_tsvector('english', n.narrative_text) @@ to_tsquery('english', p_QueryString)
      GROUP BY ui.inst_username
      UNION ALL
      SELECT COUNT(DISTINCT w.id) AS total_matches, ui2.inst_username
      FROM kmdata.works w
      INNER JOIN kmdata.work_authors wa ON w.id = wa.work_id
      INNER JOIN kmdata.user_identifiers ui2 ON wa.user_id = ui2.user_id
      INNER JOIN kmdata.resources res ON w.resource_id = res.id
      INNER JOIN kmdata.sources src ON res.source_id = src.id
      WHERE src.source_name != 'osupro'
      AND (
         to_tsvector('english', w.article_title) @@ to_tsquery('english', p_QueryString) OR
         to_tsvector('english', w.title) @@ to_tsquery('english', p_QueryString) OR
         to_tsvector('english', w.journal_title) @@ to_tsquery('english', p_QueryString) OR
         to_tsvector('english', w.event_title) @@ to_tsquery('english', p_QueryString) OR
         to_tsvector('english', w.publication_title) @@ to_tsquery('english', p_QueryString) OR
         to_tsvector('english', w.title_in) @@ to_tsquery('english', p_QueryString) OR
         to_tsvector('english', w.exhibit_title) @@ to_tsquery('english', p_QueryString) OR
         to_tsvector('english', w.episode_title) @@ to_tsquery('english', p_QueryString) OR
         to_tsvector('english', w.book_title) @@ to_tsquery('english', p_QueryString)
      )
      GROUP BY ui2.inst_username
   ) iq
   GROUP BY iq.inst_username
   ORDER BY 1 DESC, 2 ASC;

   -- return the result
   RETURN $2;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
