   v_CreationDateID BIGINT;
   v_ExhibitDateID BIGINT;

   (
          creation_dmy_single_date_id, 
          exhibit_dmy_range_date_id,
	)

          kmdata.add_dmy_single_date(NULL, researchinview.get_month(p_CompletedOn), researchinview.get_year(p_CompletedOn)),
          kmdata.add_dmy_range_date(NULL, researchinview.get_month(p_StartedOn), researchinview.get_year(p_StartedOn),
                                    NULL, researchinview.get_month(p_EndedOn), researchinview.get_year(p_EndedOn)),

									
      SELECT id, creation_dmy_single_date_id, exhibit_dmy_range_date_id 
        INTO v_WorkID, v_CreationDateID, v_ExhibitDateID
        FROM kmdata.works
       WHERE resource_id = v_ResourceID;

	  -- update creation_dmy_single_date_id, 
      UPDATE kmdata.dmy_single_dates
         SET "day" = NULL,
             "month" = researchinview.get_month(p_CompletedOn),
             "year" = researchinview.get_year(p_CompletedOn)
       WHERE id = v_CreationDateID;
      
      -- update exhibit_dmy_range_date_id,
      UPDATE kmdata.dmy_range_dates
         SET start_day = NULL,
             start_month = researchinview.get_month(p_StartedOn),
             start_year = researchinview.get_year(p_StartedOn),
             end_day = NULL,
             end_month = researchinview.get_month(p_EndedOn),
             end_year = researchinview.get_year(p_EndedOn)
       WHERE id = v_ExhibitDateID;
