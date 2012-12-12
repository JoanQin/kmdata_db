CREATE OR REPLACE FUNCTION researchinview.insert_internet (
   p_IntegrationActivityId VARCHAR(2000),
   p_IntegrationUserId VARCHAR(2000),
   p_IsPublic INTEGER,
   p_ExtendedAttribute1 VARCHAR(4000),
   p_ExtendedAttribute2 VARCHAR(4000),
   p_ExtendedAttribute3 VARCHAR(4000),
   p_ExtendedAttribute4 VARCHAR(4000),
   p_ExtendedAttribute5 VARCHAR(4000),     
   p_Author VARCHAR(4000),
   p_FrequencyOfPublication VARCHAR(2000),
   p_FrequencyOfPublicationOther VARCHAR(2000),
   p_Medium VARCHAR(4000),
   p_PercentAuthorship INTEGER,
   p_PostedOn VARCHAR(2000),
   p_Title VARCHAR(4000),
   p_TitleOfWeblog VARCHAR(4000),
   p_URL VARCHAR(4000)
   ) RETURNS BIGINT AS $$
DECLARE
   v_ActivityID BIGINT;
   v_ResourceID BIGINT;
   v_WorkID BIGINT;
   v_WorkDescrID BIGINT;
   v_UserID BIGINT;
   v_WorksMatchCount BIGINT;
   v_WorkTypeID BIGINT;

BEGIN
   -- select the user ID
   --v_UserID := p_IntegrationUserId;
   SELECT user_id INTO v_UserID
     FROM kmdata.user_identifiers
    WHERE emplid = p_IntegrationUserId;
   
   IF v_UserID IS NULL THEN
      RETURN 0;
   END IF;

   -- maps to Figure
   v_WorkTypeID := kmdata.get_or_add_work_type_id('Internet');
   
   -- insert activity information
   v_ActivityID := researchinview.insert_activity('Internet', p_IntegrationActivityId, p_IntegrationUserId, p_IsPublic, p_ExtendedAttribute1,
	p_ExtendedAttribute2, p_ExtendedAttribute3, p_ExtendedAttribute4, p_ExtendedAttribute5);

   -- get resource ID
   SELECT resource_id INTO v_ResourceID
     FROM researchinview.activity_import_log
    WHERE id = v_ActivityID;

   IF v_ResourceID IS NULL THEN
      v_ResourceID := add_new_resource('researchinview', 'works');
   END IF;


   -- update activity table in the researchinview schema
   UPDATE researchinview.activity_import_log
      SET resource_id = v_ResourceID
    WHERE id = v_ActivityID;

   -- check to see if there is a record in works with this resource id
   SELECT COUNT(*) INTO v_WorksMatchCount
     FROM kmdata.works
    WHERE resource_id = v_ResourceID;


   IF v_WorksMatchCount = 0 THEN
   
      -- insert activity information
      v_WorkID := nextval('kmdata.works_id_seq');

      -- description of effort (below), publication status, Reviewed

      INSERT INTO kmdata.works
         (id, resource_id, user_id, author_list, frequency_of_publication, frequency_of_publication_other, medium,  percent_authorship,
          posted_on_dmy_single_date_id, title, title_of_weblog, url, work_type_id,
          created_at, updated_at)
      VALUES
         (v_WorkID, v_ResourceID, v_UserID, p_Author, p_FrequencyOfPublication, p_FrequencyOfPublicationOther, p_Medium, p_PercentAuthorship, 
          kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_PostedOn), researchinview.get_year(p_PostedOn)), 
	  researchinview.strip_riv_tags(p_Title), researchinview.strip_riv_tags(p_TitleOfWeblog), p_URL,  v_WorkTypeID, 
          current_timestamp, current_timestamp);
   
      -- add work author
      INSERT INTO kmdata.work_authors
         (work_id, user_id)
      VALUES
         (v_WorkID, v_UserID);
   
   ELSE
   
      -- get the work id
      SELECT id
        INTO v_WorkID
        FROM kmdata.works
       WHERE resource_id = v_ResourceID;

      -- update the works table
      UPDATE kmdata.works
         SET user_id = v_UserID,
             author_list = p_Author,
             frequency_of_publication = p_FrequencyOfPublication,
             frequency_of_publication_other = p_FrequencyOfPublicationOther,
             medium = p_Medium,
             percent_authorship = p_PercentAuthorship,
             posted_on_dmy_single_date_id = kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_PostedOn), researchinview.get_year(p_PostedOn)), 
             title = researchinview.strip_riv_tags(p_Title),
             title_of_weblog = researchinview.strip_riv_tags(p_TitleOfWeblog),
             url = p_URL,
             updated_at = current_timestamp
       WHERE id = v_WorkID;
      
   END IF;
   
   RETURN v_WorkID;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
