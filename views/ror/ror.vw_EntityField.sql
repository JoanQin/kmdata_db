-- Add a view to make it easier to find fields corresponding to an entity
CREATE OR REPLACE VIEW ror.vw_entityfield AS 
  SELECT
    e.entity,
    CASE
      WHEN ef.entity_field IS NULL THEN c.column_name
      ELSE ef.entity_field
      END AS field,
    ef.description,
    ef.classification,
    CASE 
      WHEN ef.override_ordinal_position IS NULL THEN 100 * c.ordinal_position
      ELSE ef.override_ordinal_position
      END AS ordinal_position,
    CASE 
      WHEN ef.override_is_nullable IS NULL THEN c.is_nullable
      ELSE ef.override_is_nullable
      END AS is_nullable,
    CASE 
      WHEN ef.override_udt_name IS NULL THEN c.udt_name
      ELSE ef.override_udt_name
      END AS data_type,
    CASE 
      WHEN ef.override_character_maximum_length IS NULL THEN c.character_maximum_length
      ELSE ef.override_character_maximum_length
      END AS maximum_length
  FROM 
    ror.entity e
    LEFT JOIN information_schema.columns c ON
      c.table_schema = 'ror' 
      AND c.table_name = e.base_view
    LEFT JOIN ror.entity_field ef ON
      ef.entity = e.entity
      AND ef.view_field = c.column_name
      AND (
        ef.entity_field IS NOT NULL 
        OR ef.view_field IS NULL)
UNION
  SELECT 
    e.entity,
    ef.entity_field AS field,
    ef.description,
    ef.classification,
    ef.override_ordinal_position as ordinal_position,
    ef.override_is_nullable as is_nullable,
    ef.override_udt_name as data_type,
    ef.override_character_maximum_length as maximum_length
  FROM
    ror.entity e
    JOIN ror.entity_field ef ON
      ef.entity = e.entity
  WHERE
    ef.view_field IS NULL



