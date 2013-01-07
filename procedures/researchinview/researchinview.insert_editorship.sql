CREATE OR REPLACE FUNCTION researchinview.insert_editorship (
   p_IntegrationActivityId VARCHAR(2000),
   p_IntegrationUserId VARCHAR(2000),
   p_IsPublic INTEGER,
   p_ExtendedAttribute1 VARCHAR(4000),
   p_ExtendedAttribute2 VARCHAR(4000),
   p_ExtendedAttribute3 VARCHAR(4000),
   p_ExtendedAttribute4 VARCHAR(4000),
   p_ExtendedAttribute5 VARCHAR(4000),   
   p_ArticleTitle VARCHAR(4000),
   p_EditorshipDescriptor VARCHAR(2000),
   p_EndedOn VARCHAR(2000),
   p_IsEditor VARCHAR(2000),
   p_Issue VARCHAR(2000),
   p_Limited VARCHAR(2000),
   p_PublicationTitle VARCHAR(2000),
   p_PublicationType VARCHAR(2000),
   p_PublishedOn VARCHAR(2000),
   p_StartedOn VARCHAR(2000),
   p_TypeOfEditorship VARCHAR(2000),
   p_URL VARCHAR(4000),
   p_Volume VARCHAR(2000)
   ) RETURNS BIGINT AS $$
DECLARE
   v_ActivityID BIGINT;
   v_ResourceID BIGINT;
   v_EditorialActivityID BIGINT;
   v_UserID BIGINT;
   v_EditorialActMatchCount BIGINT;
   v_ReviewedInd BIGINT;
   v_EditorshipDescriptor INTEGER;
   v_IsEditor SMALLINT;
   v_PublicationType INTEGER;
   v_TypeOfEditorship INTEGER;
BEGIN
   -- select the user ID
   --v_UserID := p_IntegrationUserId;
   SELECT user_id INTO v_UserID
     FROM kmdata.user_identifiers
    WHERE emplid = p_IntegrationUserId;
   
   IF v_UserID IS NULL THEN
      RETURN 0;
   END IF;
   
   -- insert activity information
   v_ActivityID := researchinview.insert_activity('Editorship', p_IntegrationActivityId, p_IntegrationUserId, p_IsPublic, p_ExtendedAttribute1,
	p_ExtendedAttribute2, p_ExtendedAttribute3, p_ExtendedAttribute4, p_ExtendedAttribute5);

   -- get resource ID
   SELECT resource_id INTO v_ResourceID
     FROM researchinview.activity_import_log
    WHERE id = v_ActivityID;

   IF v_ResourceID IS NULL THEN
      v_ResourceID := add_new_resource('researchinview', 'editorial_activity');
   END IF;

   -- update activity table in the researchinview schema
   UPDATE researchinview.activity_import_log
      SET resource_id = v_ResourceID
    WHERE id = v_ActivityID;

   -- check to see if there is a record in works with this resource id
   SELECT COUNT(*) INTO v_EditorialActMatchCount
     FROM kmdata.editorial_activity
    WHERE resource_id = v_ResourceID;

   v_EditorshipDescriptor := CAST(p_EditorshipDescriptor AS INTEGER);
   v_IsEditor := CAST(p_IsEditor AS SMALLINT);
   v_PublicationType := CAST(p_PublicationType AS INTEGER);
   v_TypeOfEditorship := CAST(p_TypeOfEditorship AS INTEGER);

   -- NOT MAPPED YET: p_EndedOn, p_PublishedOn, p_StartedOn
   -- Skipped: p_Limited, 

   IF v_EditorialActMatchCount = 0 THEN
   
      -- insert activity information
      v_EditorialActivityID := nextval('kmdata.editorial_activity_id_seq');

      -- description of effort (below), ISSN, ISBN, LCCN, publication status, Reviewed

      INSERT INTO kmdata.editorial_activity
         (id, resource_id, user_id, article_title, modifier_id, currently_editor_ind, 
          publication_issue, publication_name, publication_type_id, editorship_type_id, publication_volume, url, 
          start_year, end_year, publication_date,
          created_at, updated_at)
      VALUES
         (v_EditorialActivityID, v_ResourceID, v_UserID, researchinview.strip_riv_tags(p_ArticleTitle), v_EditorshipDescriptor, v_IsEditor,
          p_Issue, researchinview.strip_riv_tags(p_PublicationTitle), v_PublicationType, v_TypeOfEditorship, p_Volume, p_URL, 
          researchinview.get_year(p_StartedOn), researchinview.get_year(p_EndedOn), 
          case when researchinview.get_year(p_PublishedOn) = 0 then cast(null as date) else 
          date (researchinview.get_year(p_PublishedOn) || '-' || researchinview.get_month(p_PublishedOn) || '-1') end,
          current_timestamp, current_timestamp);
   
   ELSE
   
      -- get the work id
      SELECT id INTO v_EditorialActivityID
        FROM kmdata.editorial_activity
       WHERE resource_id = v_ResourceID;

      -- update the works table
      UPDATE kmdata.editorial_activity
         SET user_id = v_UserID,
             article_title = researchinview.strip_riv_tags(p_ArticleTitle), 
             modifier_id = v_EditorshipDescriptor, 
             currently_editor_ind = v_IsEditor, 
             publication_issue = p_Issue, 
             publication_name = researchinview.strip_riv_tags(p_PublicationTitle), 
             publication_type_id = v_PublicationType, 
             editorship_type_id = v_TypeOfEditorship,
             publication_volume = p_Volume, 
             url = p_URL,
             start_year = researchinview.get_year(p_StartedOn),
             end_year = researchinview.get_year(p_EndedOn),
             publication_date = case when researchinview.get_year(p_PublishedOn) = 0 then cast( null as date) else 
             			date (researchinview.get_year(p_PublishedOn) || '-' || researchinview.get_month(p_PublishedOn) || '-1') end,
             updated_at = current_timestamp
       WHERE id = v_EditorialActivityID;

   END IF;
   
   RETURN v_EditorialActivityID;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
