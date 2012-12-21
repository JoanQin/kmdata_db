CREATE OR REPLACE FUNCTION researchinview.insert_presentation (
   p_IntegrationActivityId VARCHAR(2000),
   p_IntegrationUserId VARCHAR(2000),
   p_IsPublic INTEGER,
   p_ExtendedAttribute1 VARCHAR(4000),
   p_ExtendedAttribute2 VARCHAR(4000),
   p_ExtendedAttribute3 VARCHAR(4000),
   p_ExtendedAttribute4 VARCHAR(4000),
   p_ExtendedAttribute5 VARCHAR(4000),
   p_Audience INTEGER,
   p_City VARCHAR(2000),
   p_ConferenceLocation VARCHAR(4000),
   p_ConferenceName VARCHAR(2000),
   p_ConferenceStartedOn VARCHAR(2000), -- MonthYear
   p_Country VARCHAR(2000),
   p_DescriptionOfEffort TEXT,
   p_InvitedSpeaker VARCHAR(2000),
   p_PercentAuthorship INTEGER,
   p_ReachOfConference VARCHAR(4000),
   p_ReviewType VARCHAR(2000),
   p_Role VARCHAR(2000),
   p_SessionName VARCHAR(2000),
   p_SpeakerName VARCHAR(2000),
   p_StateProvince VARCHAR(2000),
   p_StateProvinceOther VARCHAR(2000),
   p_Title VARCHAR(2000),
   p_URL VARCHAR(4000)
) RETURNS BIGINT AS $$
DECLARE
   v_ActivityID BIGINT;
   v_ResourceID BIGINT;
   v_WorkID BIGINT;
   v_WorkDescrID BIGINT;
   v_JournalArticleTypeID BIGINT;
   v_WorksMatchCount BIGINT;
   v_UserID BIGINT;
   v_State VARCHAR(2000);
   v_PublicationDateID BIGINT;
BEGIN
   -- maps to Papers in Proceedings
   
   -- select the user ID
   --v_UserID := p_IntegrationUserId;
   SELECT user_id INTO v_UserID
     FROM kmdata.user_identifiers
    WHERE emplid = p_IntegrationUserId;
   
   IF v_UserID IS NULL THEN
      RETURN 0;
   END IF;
   
   -- insert activity information
   v_ActivityID := researchinview.insert_activity('Presentation', p_IntegrationActivityId, p_IntegrationUserId, p_IsPublic, p_ExtendedAttribute1,
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

   -- get publication type
   -- get publication document type

   -- parse the date
   --p_ConferenceStartedOn (presentation_dmy_single_date_id)

   v_State := p_StateProvince;
   IF v_State IS NULL OR v_State = '' THEN
      v_State := p_StateProvinceOther;
   END IF;

   --TODO: look up audience name from drop down values (p_Audience is an ID in RiV)
   
   -- update information specific to presentation
      --p_ReachOfConference, p_InvitedSpeaker, p_Role, p_SessionName, p_SpeakerName

   -- check to see if there is a record in works with this resource id
   SELECT COUNT(*) INTO v_WorksMatchCount
     FROM kmdata.works
    WHERE resource_id = v_ResourceID;

   IF v_WorksMatchCount = 0 THEN
   
      -- insert activity information
      v_WorkID := nextval('kmdata.works_id_seq');
   
      INSERT INTO kmdata.works
         (id, resource_id, user_id, title, event_title, 
          percent_authorship, audience_name, invited_talk, review_type_id,
          presentation_dmy_single_date_id, 
           presentation_role_id, reach_of_conference, session_name, speaker_name,
           url, created_at, updated_at, work_type_id,
          city, state, country, presentation_location_descr)
      VALUES
         (v_WorkID, v_ResourceID, v_UserID, researchinview.strip_riv_tags(p_Title), researchinview.strip_riv_tags(p_ConferenceName), 
          p_PercentAuthorship, p_Audience, CAST(p_InvitedSpeaker AS INTEGER), CAST(p_ReviewType AS INTEGER),
          kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_ConferenceStartedOn), researchinview.get_year(p_ConferenceStartedOn)), 
           CAST(p_Role AS INTEGER), p_ReachOfConference, p_SessionName, p_SpeakerName,
           p_URL, current_timestamp, current_timestamp, 11,  -- 11 is presentation (Unpublished Scholarly Presentation)
          p_City, v_State, p_Country, p_ConferenceLocation);

      -- add work author
      INSERT INTO kmdata.work_authors
         (work_id, user_id)
      VALUES
         (v_WorkID, v_UserID);
          
      -- add work description
      v_WorkDescrID := kmdata.add_new_narrative('researchinview', 'Work Description', researchinview.strip_riv_tags(p_DescriptionOfEffort), p_IsPublic);
   
      INSERT INTO kmdata.work_narratives
         (work_id, narrative_id)
      VALUES
         (v_WorkID, v_WorkDescrID);
   
   ELSE
   
      -- get the work id
      SELECT id, presentation_dmy_single_date_id
        INTO v_WorkID, v_PublicationDateID
        FROM kmdata.works
       WHERE resource_id = v_ResourceID;

      -- update the works table
      UPDATE kmdata.works
         SET user_id = v_UserID,
             title = researchinview.strip_riv_tags(p_Title), 
             event_title = researchinview.strip_riv_tags(p_ConferenceName),
             percent_authorship = p_PercentAuthorship, 
             reach_of_conference = p_ReachOfConference,
             session_name = p_SessionName,
             speaker_name = p_SpeakerName,
             audience_name = p_Audience,
             invited_talk = CAST(p_InvitedSpeaker AS INTEGER),
             review_type_id = CAST(p_ReviewType AS INTEGER),
             url = p_URL, 
             presentation_role_id = CAST(p_Role AS INTEGER),
             updated_at = current_timestamp,
             city = p_City,
             state = v_State,
             country = p_Country,
             presentation_location_descr = p_ConferenceLocation
       WHERE id = v_WorkID;

      -- get the narrative ID for description of effort
      SELECT b.id INTO v_WorkDescrID
        FROM kmdata.work_narratives a
        INNER JOIN kmdata.narratives b ON a.narrative_id = b.id
        INNER JOIN kmdata.narrative_types c ON b.narrative_type_id = c.id
       WHERE c.narrative_desc = 'Work Description'
         AND a.work_id = v_WorkID
       LIMIT 1;

      -- update the text and private indicator
      UPDATE kmdata.narratives
         SET narrative_text = researchinview.strip_riv_tags(p_DescriptionOfEffort),
             private_ind = p_IsPublic
       WHERE id = v_WorkDescrID;
      
      --v_PublicationDateID
      IF v_PublicationDateID IS NULL THEN
         v_PublicationDateID := kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_ConferenceStartedOn), researchinview.get_year(p_ConferenceStartedOn));
         
         UPDATE kmdata.works
            SET presentation_dmy_single_date_id = v_PublicationDateID
          WHERE id = v_WorkID;
      END IF;

      -- update presentation_dmy_single_date_id, 
      UPDATE kmdata.dmy_single_dates
         SET "day" = NULL,
             "month" = researchinview.get_month(p_ConferenceStartedOn),
             "year" = researchinview.get_year(p_ConferenceStartedOn)
       WHERE id = v_PublicationDateID;

   END IF;
   
   RETURN v_WorkID;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
