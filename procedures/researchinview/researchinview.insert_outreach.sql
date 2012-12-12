CREATE OR REPLACE FUNCTION researchinview.insert_outreach (
   p_IntegrationActivityId VARCHAR(2000),
   p_IntegrationUserId VARCHAR(2000),
   p_IsPublic INTEGER,
   p_ExtendedAttribute1 VARCHAR(4000),
   p_ExtendedAttribute2 VARCHAR(4000),
   p_ExtendedAttribute3 VARCHAR(4000),
   p_ExtendedAttribute4 VARCHAR(4000),
   p_ExtendedAttribute5 VARCHAR(4000),   
   p_AcademicCalendar VARCHAR(2000),
   p_AcademicCalendarOther VARCHAR(2000),
   p_Country VARCHAR(2000),
   p_Currency VARCHAR(2000),
   p_DescriptionOutcomes VARCHAR(4000),
   p_DirectCosts INTEGER,
   p_EndedOn VARCHAR(2000),
   p_Hours INTEGER,
   p_IncludedActivities VARCHAR(2000),
   p_Initiative VARCHAR(4000),
   p_InitiativeType VARCHAR(2000),
   p_NumberServed INTEGER,
   p_Ongoing VARCHAR(2000),
   p_OrganizationId VARCHAR(4000),
   p_PercentAuthorship INTEGER,
   p_StartedOn VARCHAR(2000),
   p_SuccessDefinition VARCHAR(4000),
   p_TargetAudience VARCHAR(4000),
   p_TimeFramesOffered VARCHAR(2000),
   p_TimeFramesOfferedOther VARCHAR(2000),
   p_TotalHours INTEGER
) RETURNS BIGINT AS $$
DECLARE
   v_ActivityID BIGINT;
   v_ResourceID BIGINT;
   v_OutreachID BIGINT;
   v_WorkDescrID BIGINT;
   v_OutreachsMatchCount BIGINT;
   v_UserID BIGINT;

BEGIN

   
   -- select the user ID
   --v_UserID := p_IntegrationUserId;
   SELECT user_id INTO v_UserID
     FROM kmdata.user_identifiers
    WHERE emplid = p_IntegrationUserId;

   -- NULL check
   IF v_UserID IS NULL THEN
      RETURN 0;
   END IF;
   
   -- insert activity information
   v_ActivityID := researchinview.insert_activity('Outreach', p_IntegrationActivityId, p_IntegrationUserId, p_IsPublic, p_ExtendedAttribute1,
	p_ExtendedAttribute2, p_ExtendedAttribute3, p_ExtendedAttribute4, p_ExtendedAttribute5);

   -- get resource ID
   SELECT resource_id INTO v_ResourceID
     FROM researchinview.activity_import_log
    WHERE id = v_ActivityID;

   IF v_ResourceID IS NULL THEN
      v_ResourceID := kmdata.add_new_resource('researchinview', 'outreach');
   END IF;

   -- update activity table in the researchinview schema
   UPDATE researchinview.activity_import_log
      SET resource_id = v_ResourceID
    WHERE id = v_ActivityID;


  
   -- update information specific to journal articles
      --doi (Digital Object Identifier), description of effort (below), !synced w/ researcherid, #citations, pmid, repository handle,
      --reviewed (pro data was 1), WoS item id

   -- check to see if there is a record in works with this resource id
   SELECT COUNT(*) INTO v_OutreachsMatchCount
     FROM kmdata.Outreach
    WHERE resource_id = v_ResourceID;

   IF v_OutreachsMatchCount = 0 THEN
   
      -- insert activity information
      v_OutreachID := nextval('kmdata.outreach_id_seq');
   
      INSERT INTO kmdata.outreach
         (id, resource_id, academic_calendar, academic_calendar_other, countries, currency, description, direct_cost, outreach_end_year, outreach_end_month,
         hours, included_activities, initiative, initiative_type, people_served, ongoing, organization_id, percent_effort, outreach_start_year, outreach_start_month,
         success, other_audience, timeframes_offered, timeframes_offered_other, total_hours, created_at, updated_at)
      VALUES
         (v_OutreachID, v_ResourceID, p_AcademicCalendar, p_AcademicCalendarOther, p_Country, p_Currency, p_DescriptionOutcomes, p_DirectCosts,
          researchinview.get_year(p_EndedOn), researchinview.get_month(p_EndedOn), p_Hours, p_IncludedActivities, p_Initiative, p_InitiativeType, 
          p_NumberServed, p_Ongoing, p_OrganizationId, p_PercentAuthorship, researchinview.get_year(p_StartedOn), researchinview.get_month(p_StartedOn),
          p_SuccessDefinition, p_TargetAudience, p_TimeframesOffered, p_TimeframesOfferedOther, p_TotalHours, current_timestamp, current_timestamp);

      -- add work author
      INSERT INTO kmdata.outreach_users
         (outreach_id, user_id)
      VALUES
         (v_OutreachID, v_UserID);
          
   ELSE
   
      -- get the work id
      SELECT id
        INTO v_OutreachID
        FROM kmdata.outreach
       WHERE resource_id = v_ResourceID;

      -- update the works table
      UPDATE kmdata.outreach
         SET 
             academic_calendar = p_AcademicCalendar,
             academic_calendar_other = p_AcademicCalendarOther,
             countries = p_Country,
             currency = p_Currency,
             description = p_DescriptionOutcomes,
             direct_cost = p_DirectCosts,
             outreach_end_year = researchinview.get_year(p_EndedOn),
             outreach_end_month = researchinview.get_month(p_EndedOn),
             hours = p_Hours,
             included_Activities = p_IncludedActivities,
             initiative = p_Initiative,
             initiative_type = p_InitiativeType,
             people_served = p_NumberServed,
             ongoing = p_Ongoing,
             organization_id = p_OrganizationId,
             percent_effort = p_PercentAuthorship,
             outreach_start_year = researchinview.get_year(p_StartedOn),
             outreach_start_month = researchinview.get_month(p_StartedOn),
             success = p_SuccessDefinition,
             other_audience = p_TargetAudience,
             timeframes_offered = p_TimeframesOffered,
             timeframes_offered_other = p_TimeframesOfferedOther,
             total_hours = p_TotalHours,
             updated_at = current_timestamp
       WHERE id = v_OutreachID;

     
      
   END IF;
   
   RETURN v_OutreachID;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
