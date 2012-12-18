CREATE OR REPLACE FUNCTION researchinview.insert_unpublished (
   p_IntegrationActivityId VARCHAR(2000),
   p_IntegrationUserId VARCHAR(2000),
   p_IsPublic INTEGER,
   p_ExtendedAttribute1 VARCHAR(4000),
   p_ExtendedAttribute2 VARCHAR(4000),
   p_ExtendedAttribute3 VARCHAR(4000),
   p_ExtendedAttribute4 VARCHAR(4000),
   p_ExtendedAttribute5 VARCHAR(4000),
   p_Author VARCHAR(2000),
   p_PercentAuthorship INTEGER,
   p_ReviewType VARCHAR(2000),
   p_SubmissionStatus VARCHAR(2000),
   p_Submitted VARCHAR(2000),
   p_SubmittedOn VARCHAR(2000), -- MonthYear
   p_SubmittedTo VARCHAR(2000),
   p_Title VARCHAR(2000)
) RETURNS BIGINT AS $$
DECLARE
   v_ActivityID BIGINT;
   v_ResourceID BIGINT;
   v_WorkID BIGINT;
   v_WorkDescrID BIGINT;
   v_StartPage VARCHAR(200);
   v_EndPage VARCHAR(200);
   v_WorksMatchCount BIGINT;
   v_UserID BIGINT;
   v_ReviewType BIGINT;
   v_State VARCHAR(2000);
   v_SubmittedMonth INTEGER;
   v_SubmittedYear INTEGER;
   v_SubmissionDateID BIGINT;
   v_SubmittedTo VARCHAR(255);
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
   v_ActivityID := researchinview.insert_activity('Unpublished', p_IntegrationActivityId, p_IntegrationUserId, p_IsPublic, p_ExtendedAttribute1,
	p_ExtendedAttribute2, p_ExtendedAttribute3, p_ExtendedAttribute4, p_ExtendedAttribute5);

   -- get resource ID
   SELECT resource_id INTO v_ResourceID
     FROM researchinview.activity_import_log
    WHERE id = v_ActivityID;

   IF v_ResourceID IS NULL THEN
      v_ResourceID := add_new_resource('researchinview', 'works');
   END IF;

   v_SubmittedTo := left(p_SubmittedTo, 254);

   -- update activity table in the researchinview schema
   UPDATE researchinview.activity_import_log
      SET resource_id = v_ResourceID
    WHERE id = v_ActivityID;

   -- parse the date
   v_SubmittedMonth := trim(both ' ' from split_part(p_SubmittedOn, '/', 1));
   v_SubmittedYear := trim(both ' ' from split_part(p_SubmittedOn, '/', 2));
   
   -- update information specific to Unpublished
   --  Submitted, 
   IF p_ReviewType = '2' THEN
      v_ReviewType := 3;
   ELSE
      v_ReviewType := 2;
   END IF;

   --TODO: FIX DATE ISSUE LATER
   --right now dates will not update to prevent unnecessary inserts into the date management table (kmdata.dmy_single_dates)
   --status_id = p_SubmissionStatus
   
   -- check to see if there is a record in works with this resource id
   SELECT COUNT(*) INTO v_WorksMatchCount
     FROM kmdata.works
    WHERE resource_id = v_ResourceID;

   IF v_WorksMatchCount = 0 THEN
   
      -- insert activity information
      v_WorkID := nextval('kmdata.works_id_seq');
   
      INSERT INTO kmdata.works
         (id, resource_id, user_id, title, author_list, 
          percent_authorship, submission_dmy_single_date_id, 
          review_type_id, created_at, updated_at, work_type_id,
          submitted_to, extended_author_list, status_id)
      VALUES
         (v_WorkID, v_ResourceID, v_UserID, researchinview.strip_riv_tags(p_Title), p_Author, 
          p_PercentAuthorship, kmdata.add_dmy_single_date(NULL, v_SubmittedMonth, v_SubmittedYear), 
          v_ReviewType, current_timestamp, current_timestamp, 10, -- 10 is potential publications under review (ReferenceWork)
          v_SubmittedTo, CASE WHEN LENGTH(p_SubmittedTo) < 255 THEN NULL ELSE p_SubmittedTo END, CAST(p_SubmissionStatus AS INTEGER));

      -- add work author
      INSERT INTO kmdata.work_authors
         (work_id, user_id)
      VALUES
         (v_WorkID, v_UserID);
          
   ELSE
   
      -- get the work id
      SELECT id, submission_dmy_single_date_id
        INTO v_WorkID, v_SubmissionDateID
        FROM kmdata.works
       WHERE resource_id = v_ResourceID;

      -- update the works table
      UPDATE kmdata.works
         SET user_id = v_UserID,
             title = researchinview.strip_riv_tags(p_Title), 
             author_list = p_Author, 
             percent_authorship = p_PercentAuthorship, 
             --submission_dmy_single_date_id
             status_id = CAST(p_SubmissionStatus AS INTEGER),
             review_type_id = v_ReviewType,
             updated_at = current_timestamp,
             submitted_to = v_SubmittedTo,
             extended_author_list = CASE WHEN LENGTH(p_SubmittedTo) < 255 THEN NULL ELSE p_SubmittedTo END
       WHERE id = v_WorkID;

      
      --v_SubmissionDateID
      IF v_SubmissionDateID IS NULL THEN
         v_SubmissionDateID := kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_SubmittedOn), researchinview.get_year(p_SubmittedOn));
         
         UPDATE kmdata.works
            SET submission_dmy_single_date_id = v_SubmissionDateID
          WHERE id = v_WorkID;
      END IF;

      -- update presentation_dmy_single_date_id, 
      UPDATE kmdata.dmy_single_dates
         SET "day" = NULL,
             "month" = researchinview.get_month(p_SubmittedOn),
             "year" = researchinview.get_year(p_SubmittedOn)
       WHERE id = v_SubmissionDateID;
      

   END IF;
   
   RETURN v_WorkID;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
