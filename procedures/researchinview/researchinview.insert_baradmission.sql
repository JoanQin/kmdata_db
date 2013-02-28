
CREATE OR REPLACE FUNCTION researchinview.insert_baradmission (
   p_IntegrationActivityId VARCHAR(2000),
   p_IntegrationUserId VARCHAR(2000),
   p_IsPublic INTEGER,
   p_ExtendedAttribute1 VARCHAR(4000),
   p_ExtendedAttribute2 VARCHAR(4000),
   p_ExtendedAttribute3 VARCHAR(4000),
   p_ExtendedAttribute4 VARCHAR(4000),
   p_ExtendedAttribute5 VARCHAR(4000),
   p_Active VARCHAR(2000),
   p_AdmittedOn VARCHAR(2000),
   p_Country VARCHAR(2000),
   p_StateProvince VARCHAR(2000),
   p_StateProvinceOther VARCHAR(2000)
) RETURNS BIGINT AS $$
DECLARE
   v_ActivityID BIGINT;
   v_ResourceID BIGINT;
   v_BarID BIGINT;
   v_UserID BIGINT;
   v_BarAdmissionsMatchCount BIGINT;
   v_State VARCHAR(2000);
   v_BarAdmissionDateID bigint;
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
   v_ActivityID := researchinview.insert_activity('BarAdmission', p_IntegrationActivityId, p_IntegrationUserId, p_IsPublic, p_ExtendedAttribute1,
	p_ExtendedAttribute2, p_ExtendedAttribute3, p_ExtendedAttribute4, p_ExtendedAttribute5);

   -- get resource ID
   SELECT resource_id INTO v_ResourceID
     FROM researchinview.activity_import_log
    WHERE id = v_ActivityID;

   IF v_ResourceID IS NULL THEN
      v_ResourceID := kmdata.add_new_resource('researchinview', 'bar_admission');
   END IF;

   -- update activity table in the researchinview schema
   UPDATE researchinview.activity_import_log
      SET resource_id = v_ResourceID
    WHERE id = v_ActivityID;

   v_State := p_StateProvince;
   IF v_State IS NULL OR v_State = '' THEN
      v_State := p_StateProvinceOther;
   END IF;
   

   -- check to see if there is a record in grant_data with this resource id
   SELECT COUNT(*) INTO v_BarAdmissionsMatchCount
     FROM kmdata.bar_admission
    WHERE resource_id = v_ResourceID;

   IF v_BarAdmissionsMatchCount = 0 THEN
   
      -- insert activity information
      v_BarID := nextval('kmdata.bar_admission_id_seq');
   
      INSERT INTO kmdata.bar_admission
         (id, resource_id, user_id, active, admitted_on_dmy_single_date_id, country, state, created_at, updated_at)
      VALUES
         (v_BarID, v_ResourceID, v_UserID, p_Active, kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_AdmittedOn), researchinview.get_year(p_AdmittedOn)),
         p_Country, v_State, current_timestamp, current_timestamp);
   
   ELSE
   
      -- get the work id
      SELECT id, admitted_on_dmy_single_date_id INTO v_BarID, v_BarAdmissionDateID
        FROM kmdata.bar_admission
       WHERE resource_id = v_ResourceID;

      -- update the works table
      UPDATE kmdata.bar_admission
         SET active = p_Active,
	     admitted_on_dmy_single_date_id = kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_AdmittedOn), researchinview.get_year(p_AdmittedOn)),
	     country = p_Country,
	     state = v_State,
	     updated_at = current_timestamp
       WHERE id = v_BarID; 
       
       IF v_BarAdmissionDateID IS NULL THEN
       		v_BarAdmissionDateID := kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_AdmittedOn), researchinview.get_year(p_AdmittedOn));
       		
       		UPDATE kmdata.bar_admission
       			set admitted_on_dmy_single_date_id = v_BarAdmissionDateID
       		where id = v_BarID;
       	END IF;
       	
       	UPDATE kmdata.dmy_single_dates
       		set "day" = null,
       		    "month" = researchinview.get_month(p_AdmittedOn), 
       		    "year" = researchinview.get_year(p_AdmittedOn)
        where id = v_BarAdmissionDateID;
       
       
   END IF;
   
   
   
   RETURN v_BarID;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
