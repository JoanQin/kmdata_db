CREATE OR REPLACE FUNCTION kmdata.get_work_citation (
   p_RIVActivityName VARCHAR(100),
   p_WorkID BIGINT
) RETURNS VARCHAR AS $$
DECLARE
   v_Citation VARCHAR(4000);
   v_Title1 VARCHAR(2000);
   v_Title2 VARCHAR(2000);
   v_Title3 VARCHAR(2000);
   v_Title4 VARCHAR(2000);
   v_AuthorList VARCHAR(2000);
   v_EditorList VARCHAR(2000);
   v_Artist VARCHAR(255);
   v_City VARCHAR(255);
   v_State VARCHAR(255);
   v_Country VARCHAR(255);
   v_PerformanceCompany VARCHAR(255);
   v_Venue VARCHAR(500);
   v_Sponsor VARCHAR(255);
   v_Format VARCHAR(255);
   v_Inventor VARCHAR(255);
   v_Manufacturer VARCHAR(255);
   v_LocationDescr VARCHAR(500);
   v_Year1 BIGINT;
   v_Year2 BIGINT;
   v_Year3 BIGINT;
   v_Year4 BIGINT;
   v_Year5 BIGINT;
   v_Year6 BIGINT;
   v_Year7 BIGINT;
   v_Year8 BIGINT;
   v_Month1 INTEGER;
   v_Month2 INTEGER;
   v_Month3 INTEGER;
   v_Month4 INTEGER;
   v_Month5 INTEGER;
   v_Month6 INTEGER;
   v_Month7 INTEGER;
   v_Month8 INTEGER;
   v_Day1 INTEGER;
   v_Day2 INTEGER;
   v_Day3 INTEGER;
   v_Day4 INTEGER;
   v_Day5 INTEGER;
   v_Day6 INTEGER;
   v_Day7 INTEGER;
   v_Day8 INTEGER;
   v_Edition VARCHAR(500);
   v_Volume VARCHAR(255);
   v_Publisher VARCHAR(255);
   v_Issue VARCHAR(255);
   v_BeginningPage VARCHAR(255);
   v_EndingPage VARCHAR(255);
   v_PrintString1 VARCHAR(255);
   v_PrintString2 VARCHAR(255);
   v_PrintString3 VARCHAR(255);
   v_PrintString4 VARCHAR(255);
   v_PrintString5 VARCHAR(255);
   v_PrintString6 VARCHAR(255);
   v_PrintString7 VARCHAR(255);
BEGIN
   -- get the citation type
   IF p_RIVActivityName = 'Artwork' THEN
   
      SELECT a.title, a.exhibit_title, a.artist, a.city, a.state, a.country, 
             a.creation_day, a.creation_month, a.creation_year,
             a.exhibit_start_day, a.exhibit_start_month, a.exhibit_start_year, a.exhibit_end_day, a.exhibit_end_month, a.exhibit_end_year
        INTO v_Title1, v_Title2, v_Artist, v_City, v_State, v_Country,
             v_Day1, v_Month1, v_Year1,
             v_Day2, v_Month2, v_Year2, v_Day3, v_Month3, v_Year3
        FROM ror.vw_Artwork a
       WHERE a.id = p_WorkID
       LIMIT 1;
       
      v_Citation := kmdata.cit_nvl(kmdata.cit_nvl(v_Artist, '. ', '') || COALESCE(v_Title1, ''), '. ', '') || kmdata.cit_nvl(v_Title2, ', ', '') || 
                       kmdata.cit_nvl(v_City, ', ', '') || kmdata.cit_nvl(v_State, ', ', '') || kmdata.cit_nvl(v_Country, ', ', '') ||
                       kmdata.cit_nvl(kmdata.cit_nvl(kmdata.get_month_name(v_Month1), ' ', '') || kmdata.cit_nvl(v_Year1::text, '.', ''), '', '');
      
   ELSIF p_RIVActivityName = 'Audiovisual' THEN
   
      SELECT a.title, a.artist, a.city, a.state, a.country, 
             a.broadcast_day, a.broadcast_month, a.broadcast_year,
             a.presentation_day, a.presentation_month, a.presentation_year
        INTO v_Title1, v_Artist, v_City, v_State, v_Country,
             v_Day1, v_Month1, v_Year1,
             v_Day2, v_Month2, v_Year2
        FROM ror.vw_Audiovisual a
       WHERE a.id = p_WorkID
       LIMIT 1;
       
      v_Citation := kmdata.cit_nvl(kmdata.cit_nvl(v_Artist, '. ', '') || COALESCE(v_Title1, ''), '. ', '') || 
                       kmdata.cit_nvl(v_City, ', ', '') || kmdata.cit_nvl(v_State, ', ', '') || kmdata.cit_nvl(v_Country, ', ', '') ||
                       kmdata.cit_nvl(kmdata.cit_nvl(kmdata.get_month_name(v_Month1), ' ', '') || kmdata.cit_nvl(v_Year1::text, '.', ''), '', '');
      
   ELSIF p_RIVActivityName = 'Book' THEN

      SELECT a.title, a.author_list, a.city, a.state, a.country, 
             a.edition, a.publisher, a.volume, 
             a.publication_day, a.publication_month, a.publication_year
        INTO v_Title1, v_AuthorList, v_City, v_State, v_Country,
             v_Edition, v_Publisher, v_Volume, 
             v_Day1, v_Month1, v_Year1
        FROM ror.vw_Book a
       WHERE a.id = p_WorkID
       LIMIT 1;

      IF (TRIM(v_City) != '' AND v_City IS NOT NULL) AND (TRIM(v_State) = '' OR v_State IS NULL) AND (TRIM(v_Country) = '' OR v_Country IS NULL) THEN
         v_PrintString1 := ': ';
      ELSE
         v_PrintString1 := ', ';
      END IF;

      IF (TRIM(v_State) != '' AND v_State IS NOT NULL) AND (TRIM(v_Country) = '' OR v_Country IS NULL) THEN
         v_PrintString2 := ': ';
      ELSE
         v_PrintString2 := ', ';
      END IF;
      
      v_Citation := kmdata.cit_nvl(kmdata.cit_nvl(v_AuthorList, '. ', '') || COALESCE(v_Title1, ''), '. ', '') || 
                       kmdata.cit_nvl(v_City, v_PrintString1, '') || kmdata.cit_nvl(v_State, v_PrintString2, '') || kmdata.cit_nvl(v_Country, ': ', '') ||
                       kmdata.cit_nvl(v_Publisher, ', ', '') ||
                       kmdata.cit_nvl(kmdata.cit_nvl(kmdata.get_month_name(v_Month1), ' ', '') || kmdata.cit_nvl(v_Year1::text, '.', ''), '', '');
      
   ELSIF p_RIVActivityName = 'BookChapter' THEN

      SELECT a.title, a.title_in, a.author_list, a.edition, a.publisher, a.volume, a.editor_list,
             a.city, a.state, a.country, a.beginning_page, a.ending_page,
             a.publication_day, a.publication_month, a.publication_year
        INTO v_Title1, v_Title2, v_AuthorList, v_Edition, v_Publisher, v_Volume, v_EditorList, 
             v_City, v_State, v_Country, v_BeginningPage, v_EndingPage, 
             v_Day1, v_Month1, v_Year1
        FROM ror.vw_BookChapter a
       WHERE a.id = p_WorkID
       LIMIT 1;
      
      IF (TRIM(v_City) != '' AND v_City IS NOT NULL) AND (TRIM(v_State) = '' OR v_State IS NULL) AND (TRIM(v_Country) = '' OR v_Country IS NULL) THEN
         v_PrintString1 := ': ';
      ELSE
         v_PrintString1 := ', ';
      END IF;

      IF (TRIM(v_State) != '' AND v_State IS NOT NULL) AND (TRIM(v_Country) = '' OR v_Country IS NULL) THEN
         v_PrintString2 := ': ';
      ELSE
         v_PrintString2 := ', ';
      END IF;

      IF v_Title1 IS NULL OR TRIM(v_Title1) = '' THEN
         v_PrintString3 := '';
         v_PrintString4 := '';
      ELSE
         v_PrintString3 := '"';
         v_PrintString4 := '." ';
      END IF;

      IF v_Title2 IS NULL OR TRIM(v_Title2) = '' THEN
         v_PrintString5 := '';
      ELSE
         v_PrintString5 := 'In ';
      END IF;

      IF v_Volume IS NULL OR TRIM(v_Volume) = '' THEN
         v_PrintString6 := '';
      ELSE
         v_PrintString6 := 'Vol. ';
      END IF;

      IF v_EditorList IS NULL OR TRIM(v_EditorList) = '' THEN
         v_PrintString7 := '';
      ELSE
         v_PrintString7 := 'Edited by ';
      END IF;
      
      v_Citation := kmdata.cit_nvl(v_AuthorList, '. ', '') || v_PrintString3 || v_Title1 || v_PrintString4 ||
                       v_PrintString5 || kmdata.cit_nvl(v_Title2, '. ', '') ||
                       kmdata.cit_nvl(v_Edition, ' ed. ', '') || 
                       v_PrintString6 || kmdata.cit_nvl(v_Volume, '. ', '') ||
                       v_PrintString7 || kmdata.cit_nvl(v_EditorList, '. ', '') ||
                       COALESCE(v_BeginningPage, '') || '-' || COALESCE(v_EndingPage, '') || '. ' ||
                       kmdata.cit_nvl(v_City, v_PrintString1, '') || kmdata.cit_nvl(v_State, v_PrintString2, '') || kmdata.cit_nvl(v_Country, ': ', '') ||
                       kmdata.cit_nvl(v_Publisher, ', ', '') ||
                       kmdata.cit_nvl(kmdata.cit_nvl(kmdata.get_month_name(v_Month1), ' ', '') || kmdata.cit_nvl(v_Year1::text, '.', ''), '', '');
                       
   ELSIF p_RIVActivityName = 'Conference' THEN

      SELECT a.author_list, a.title, a.journal_title, a.book_title, a.event_title, 
             a.publication_day, a.publication_month, a.publication_year,
             a.volume, a.issue, a.beginning_page, a.ending_page
        INTO v_AuthorList, v_Title1, v_Title2, v_Title3, v_Title4,
             v_Day1, v_Month1, v_Year1,
             v_Volume, v_Issue, v_BeginningPage, v_EndingPage
        FROM ror.vw_Conference a
       WHERE a.id = p_WorkID
       LIMIT 1;

      IF v_Title1 IS NULL OR TRIM(v_Title1) = '' THEN
         v_PrintString3 := '';
         v_PrintString4 := '';
      ELSE
         v_PrintString3 := '"';
         v_PrintString4 := '." ';
      END IF;

      IF v_Title2 IS NULL OR TRIM(v_Title2) = '' THEN
         v_PrintString5 := '';
      ELSE
         v_PrintString5 := 'In ';
      END IF;

      IF v_Month1 IS NULL AND v_Year1 IS NULL THEN
         v_PrintString2 := '';
      ELSE
         v_PrintString2 := '(';
      END IF;

      v_Citation := kmdata.cit_nvl(v_AuthorList, '. ', '') || v_PrintString3 || v_Title1 || v_PrintString4 ||
                       v_PrintString5 || kmdata.cit_nvl(COALESCE(v_Title2, v_Title3, v_Title4), '. ', '') ||
                       v_PrintString2 || kmdata.cit_nvl(kmdata.cit_nvl(kmdata.get_month_name(v_Month1), ' ', '') || kmdata.cit_nvl(v_Year1::text, '', ''), '). ', '') ||
                       kmdata.cit_nvl(v_BeginningPage, '-', '') || COALESCE(v_EndingPage, '') || '. ';
      
   ELSIF p_RIVActivityName = 'EditedBook' THEN

      SELECT a.title, a.author_list, a.edition, a.publisher, a.volume, a.editor_list,
             a.city, a.state, a.country, 
             a.publication_day, a.publication_month, a.publication_year
        INTO v_Title1, v_AuthorList, v_Edition, v_Publisher, v_Volume, v_EditorList,
             v_City, v_State, v_Country,
             v_Day1, v_Month1, v_Year1
        FROM ror.vw_EditedBook a
       WHERE a.id = p_WorkID
       LIMIT 1;
      
      IF (TRIM(v_City) != '' AND v_City IS NOT NULL) AND (TRIM(v_State) = '' OR v_State IS NULL) AND (TRIM(v_Country) = '' OR v_Country IS NULL) THEN
         v_PrintString1 := ': ';
      ELSE
         v_PrintString1 := ', ';
      END IF;

      IF (TRIM(v_State) != '' AND v_State IS NOT NULL) AND (TRIM(v_Country) = '' OR v_Country IS NULL) THEN
         v_PrintString2 := ': ';
      ELSE
         v_PrintString2 := ', ';
      END IF;

      IF v_Title1 IS NULL OR TRIM(v_Title1) = '' THEN
         v_PrintString3 := '';
         v_PrintString4 := '';
      ELSE
         v_PrintString3 := '"';
         v_PrintString4 := '." ';
      END IF;

      IF v_Volume IS NULL OR TRIM(v_Volume) = '' THEN
         v_PrintString6 := '';
      ELSE
         v_PrintString6 := 'Vol. ';
      END IF;

      IF v_EditorList IS NULL OR TRIM(v_EditorList) = '' THEN
         v_PrintString7 := '';
      ELSE
         v_PrintString7 := 'Edited by ';
      END IF;
      
      v_Citation := kmdata.cit_nvl(v_AuthorList, '. ', '') || v_PrintString3 || v_Title1 || v_PrintString4 ||
                       kmdata.cit_nvl(v_Edition, ' ed. ', '') || 
                       v_PrintString6 || kmdata.cit_nvl(v_Volume, '. ', '') ||
                       v_PrintString7 || kmdata.cit_nvl(v_EditorList, '. ', '') ||
                       kmdata.cit_nvl(v_City, v_PrintString1, '') || kmdata.cit_nvl(v_State, v_PrintString2, '') || kmdata.cit_nvl(v_Country, ': ', '') ||
                       kmdata.cit_nvl(v_Publisher, ', ', '') ||
                       kmdata.cit_nvl(kmdata.cit_nvl(kmdata.get_month_name(v_Month1), ' ', '') || kmdata.cit_nvl(v_Year1::text, '.', ''), '', '');
      
   ELSIF p_RIVActivityName = 'Journal' THEN
      
      SELECT a.article_title, a.journal_title, a.author_list, a.issue, a.volume, 
             a.beginning_page, a.ending_page,
             a.publication_day, a.publication_month, a.publication_year
        INTO v_Title1, v_Title2, v_AuthorList, v_Issue, v_Volume,  
             v_BeginningPage, v_EndingPage, 
             v_Day1, v_Month1, v_Year1
        FROM ror.vw_Journal a
       WHERE a.id = p_WorkID
       LIMIT 1;
      
      IF v_Title1 IS NULL OR TRIM(v_Title1) = '' THEN
         v_PrintString3 := '';
         v_PrintString4 := '';
      ELSE
         v_PrintString3 := '"';
         v_PrintString4 := '." ';
      END IF;

      IF v_Volume IS NULL OR TRIM(v_Volume) = '' THEN
         v_PrintString6 := '';
      ELSE
         v_PrintString6 := 'Vol. ';
      END IF;

      IF v_Issue IS NULL OR TRIM(v_Issue) = '' THEN
         v_PrintString1 := '';
      ELSE
         v_PrintString1 := 'no. ';
      END IF;

      IF v_Month1 IS NULL AND v_Year1 IS NULL THEN
         v_PrintString2 := '';
      ELSE
         v_PrintString2 := '(';
      END IF;

      v_Citation := kmdata.cit_nvl(v_AuthorList, '. ', '') || v_PrintString3 || COALESCE(v_Title1, '') || v_PrintString4 ||
                       kmdata.cit_nvl(v_Title2, '. ', '') ||
                       v_PrintString6 || kmdata.cit_nvl(v_Volume, ', ', '') ||
                       v_PrintString1 || kmdata.cit_nvl(v_Issue, '. ', '') ||
                       v_PrintString2 || kmdata.cit_nvl(kmdata.cit_nvl(kmdata.get_month_name(v_Month1), ' ', '') || kmdata.cit_nvl(v_Year1::text, '.', ''), '): ', '') ||
                       COALESCE(v_BeginningPage, '') || '-' || COALESCE(v_EndingPage, '') || '.';
      
   ELSIF p_RIVActivityName = 'Music' THEN
      
      SELECT a.title, a.title_in, a.artist, a.city, a.state, a.country, 
             a.presentation_day, a.presentation_month, a.presentation_year,
             a.performance_company, a.venue
        INTO v_Title1, v_Title2, v_Artist, v_City, v_State, v_Country,
             v_Day1, v_Month1, v_Year1,
             v_PerformanceCompany, v_Venue
        FROM ror.vw_Music a
       WHERE a.id = p_WorkID
       LIMIT 1;
       
      IF (v_State IS NOT NULL AND TRIM(v_State) != '') OR (v_Country IS NOT NULL OR TRIM(v_Country) != '') THEN
         v_PrintString1 := ', ';
      ELSE
         v_PrintString1 := '';
      END IF;

      IF v_Country IS NOT NULL OR TRIM(v_Country) != '' THEN
         v_PrintString2 := ', ';
      ELSE
         v_PrintString2 := '';
      END IF;
      
      IF (v_City IS NOT NULL AND TRIM(v_City) != '') OR (v_State IS NOT NULL AND TRIM(v_State) != '') OR (v_Country IS NOT NULL OR TRIM(v_Country) != '') THEN
         v_PrintString3 := ' ';
      ELSE
         v_PrintString3 := '';
      END IF;

      IF v_Month1 IS NOT NULL OR v_Year1 IS NOT NULL THEN
         v_PrintString4 := '(';
         v_PrintString5 := ').';
      ELSE
         v_PrintString4 := '';
         v_PrintString5 := '';
      END IF;
      
      v_Citation := kmdata.cit_nvl(v_Title2, '. ', '') || kmdata.cit_nvl(v_Artist, ', ', '') || kmdata.cit_nvl(v_Title1, ', ', '') ||
                       kmdata.cit_nvl(v_Venue, ', ', '') ||
                       kmdata.cit_nvl(v_City, v_PrintString1, '') || kmdata.cit_nvl(v_State, v_PrintString2, '') || kmdata.cit_nvl(v_Country, '', '') || v_PrintString3 ||
                       v_PrintString4 || kmdata.cit_nvl(kmdata.cit_nvl(kmdata.get_month_name(v_Month1), ' ', '') || kmdata.cit_nvl(v_Year1::text, '', ''), '', '') || v_PrintString5;
      
   ELSIF p_RIVActivityName = 'OtherCreativeWork' THEN

      -- do not currently have type of work text from RIV
      SELECT a.title, a.author_list, a.sponsor, a.format, 
             a.creation_day, a.creation_month, a.creation_year
        INTO v_Title1, v_AuthorList, v_Sponsor, v_Format, 
             v_Day1, v_Month1, v_Year1
        FROM ror.vw_OtherCreativeWork a
       WHERE a.id = p_WorkID
       LIMIT 1;
       
      IF v_Title1 IS NULL OR TRIM(v_Title1) = '' THEN
         v_PrintString1 := '';
         v_PrintString2 := '';
      ELSE
         v_PrintString1 := '"';
         v_PrintString2 := '." ';
      END IF;
      
      v_Citation := kmdata.cit_nvl(v_AuthorList, '. ', '') || 
                       kmdata.cit_nvl(kmdata.cit_nvl(kmdata.get_month_name(v_Month1), ' ', '') || kmdata.cit_nvl(v_Year1::text, '.', ''), '', '') ||
                       v_PrintString1 || COALESCE(v_Title1, '') || v_PrintString2 || 
                       kmdata.cit_nvl(v_Format, '.', '');
      
   ELSIF p_RIVActivityName = 'Patent' THEN
   
      SELECT a.title, a.inventor, a.manufacturer, a.sponsor, 
             date_part('month', a.filed_date) AS filed_month, date_part('year', a.filed_date) AS filed_year
        INTO v_Title1, v_Inventor, v_Manufacturer, v_Sponsor,
             v_Month1, v_Year1
        FROM ror.vw_Patent a
       WHERE a.id = p_WorkID
       LIMIT 1;
       
      IF v_Title1 IS NULL OR TRIM(v_Title1) = '' THEN
         v_PrintString1 := '';
         v_PrintString2 := '';
      ELSE
         v_PrintString1 := '"';
         v_PrintString2 := '." ';
      END IF;

      IF v_Sponsor IS NULL OR TRIM(v_Sponsor) = '' THEN
         v_PrintString3 := '';
      ELSE
         v_PrintString3 := ', ';
      END IF;

      IF v_Month1 IS NULL AND v_Year1 IS NULL THEN
         v_PrintString4 := '';
      ELSE
         v_PrintString4 := 'Filed ';
      END IF;
      
      v_Citation := kmdata.cit_nvl(v_Inventor, '. ', '') || 
                       v_PrintString1 || COALESCE(v_Title1, '') || v_PrintString2 || 
                       kmdata.cit_nvl(v_Manufacturer, v_PrintString3, '') ||
                       kmdata.cit_nvl(v_Sponsor, '. ', '') ||
                       v_PrintString4 || kmdata.cit_nvl(kmdata.cit_nvl(kmdata.get_month_name(v_Month1), ' ', '') || kmdata.cit_nvl(v_Year1::text, '.', ''), '', '');
      
   ELSIF p_RIVActivityName = 'Presentation' THEN
      
      SELECT a.title, a.event_title, a.presentation_location_descr, 
             a.city, a.state, a.country, 
             a.presentation_day, a.presentation_month, a.presentation_year
        INTO v_Title1, v_Title2, v_LocationDescr,
             v_City, v_State, v_Country,
             v_Day1, v_Month1, v_Year1
        FROM ror.vw_Presentation a
       WHERE a.id = p_WorkID
       LIMIT 1;
      
      IF v_Title1 IS NULL OR TRIM(v_Title1) = '' THEN
         v_PrintString3 := '';
         v_PrintString4 := '';
      ELSE
         v_PrintString3 := '"';
         v_PrintString4 := '." ';
      END IF;

      IF v_Title2 IS NULL OR TRIM(v_Title2) = '' THEN
         v_PrintString6 := '';
      ELSE
         v_PrintString6 := 'Presented at ';
      END IF;

      IF (v_State IS NULL OR TRIM(v_State) = '') AND (v_Country IS NULL OR TRIM(v_Country) = '') THEN
         v_PrintString1 := '';
      ELSE
         v_PrintString1 := ', ';
      END IF;

      IF v_Country IS NULL OR TRIM(v_Country) = '' THEN
         v_PrintString2 := '';
      ELSE
         v_PrintString2 := ', ';
      END IF;

      IF v_Month1 IS NULL AND v_Year1 IS NULL THEN
         v_PrintString5 := '';
      ELSE
         v_PrintString5 := '(';
      END IF;
      
      v_Citation := v_PrintString3 || COALESCE(v_Title1, '') || v_PrintString4 ||
                       v_PrintString6 || kmdata.cit_nvl(v_Title2, ', ', '') ||
                       kmdata.cit_nvl(v_City, v_PrintString1, '') || kmdata.cit_nvl(v_State, v_PrintString2, '') || kmdata.cit_nvl(v_Country, '', '') || '. ' ||
                       v_PrintString5 || kmdata.cit_nvl(kmdata.cit_nvl(kmdata.get_month_name(v_Month1), ' ', '') || kmdata.cit_nvl(v_Year1::text, '', ''), ')', '');
      
   ELSIF p_RIVActivityName = 'ReferenceWork' THEN
      
      SELECT a.title, a.author_list, a.volume, 
             a.beginning_page, a.ending_page,
             a.publication_day, a.publication_month, a.publication_year,
             a.city, a.state, a.country
        INTO v_Title1, v_AuthorList, v_Volume,
             v_BeginningPage, v_EndingPage, 
             v_Day1, v_Month1, v_Year1,
             v_City, v_State, v_Country
        FROM ror.vw_ReferenceWork a
       WHERE a.id = p_WorkID
       LIMIT 1;
      
      IF v_Title1 IS NULL OR TRIM(v_Title1) = '' THEN
         v_PrintString3 := '';
         v_PrintString4 := '';
      ELSE
         v_PrintString3 := '"';
         v_PrintString4 := '." ';
      END IF;

      IF v_Volume IS NULL OR TRIM(v_Volume) = '' THEN
         v_PrintString6 := '';
      ELSE
         v_PrintString6 := 'Vol. ';
      END IF;

      IF v_Month1 IS NULL AND v_Year1 IS NULL THEN
         v_PrintString2 := '';
      ELSE
         v_PrintString2 := '(';
      END IF;

      IF (v_State IS NULL OR TRIM(v_State) = '') AND (v_Country IS NULL OR TRIM(v_Country) = '') THEN
         v_PrintString1 := '';
      ELSE
         v_PrintString1 := ', ';
      END IF;

      IF v_Country IS NULL OR TRIM(v_Country) = '' THEN
         v_PrintString5 := '';
      ELSE
         v_PrintString5 := ', ';
      END IF;
      
      v_Citation := kmdata.cit_nvl(v_AuthorList, '. ', '') || v_PrintString3 || COALESCE(v_Title1, '') || v_PrintString4 ||
                       v_PrintString6 || kmdata.cit_nvl(v_Volume, ', ', '') ||
                       kmdata.cit_nvl(v_City, v_PrintString1, '') || kmdata.cit_nvl(v_State, v_PrintString5, '') || kmdata.cit_nvl(v_Country, '', '') || '. ' ||
                       v_PrintString2 || kmdata.cit_nvl(kmdata.cit_nvl(kmdata.get_month_name(v_Month1), ' ', '') || kmdata.cit_nvl(v_Year1::text, '.', ''), '): ', '') ||
                       COALESCE(v_BeginningPage, '') || '-' || COALESCE(v_EndingPage, '') || '.';
      
   ELSIF p_RIVActivityName = 'Software' THEN
      
      SELECT a.title, a.author_list, 
             a.edition, a.publisher, a.sponsor, 
             a.publication_day, a.publication_month, a.publication_year
        INTO v_Title1, v_AuthorList, 
             v_Edition, v_Publisher, v_Sponsor, 
             v_Day1, v_Month1, v_Year1
        FROM ror.vw_Software a
       WHERE a.id = p_WorkID
       LIMIT 1;

      IF (TRIM(v_City) != '' AND v_City IS NOT NULL) AND (TRIM(v_State) = '' OR v_State IS NULL) AND (TRIM(v_Country) = '' OR v_Country IS NULL) THEN
         v_PrintString1 := ': ';
      ELSE
         v_PrintString1 := ', ';
      END IF;

      IF (TRIM(v_State) != '' AND v_State IS NOT NULL) AND (TRIM(v_Country) = '' OR v_Country IS NULL) THEN
         v_PrintString2 := ': ';
      ELSE
         v_PrintString2 := ', ';
      END IF;
      
      IF v_Title1 IS NULL OR TRIM(v_Title1) = '' THEN
         v_PrintString3 := '';
         v_PrintString4 := '';
      ELSE
         v_PrintString3 := '"';
         v_PrintString4 := '." ';
      END IF;
      
      IF v_Month1 IS NULL AND v_Year1 IS NULL THEN
         v_PrintString5 := '';
      ELSE
         v_PrintString5 := '. ';
      END IF;
      
      v_Citation := kmdata.cit_nvl(v_AuthorList, '. ', '') || 
                       v_PrintString3 || COALESCE(v_Title1, '') || v_PrintString4 || 
                       kmdata.cit_nvl(v_Edition, '. ', '') ||
                       kmdata.cit_nvl(v_Publisher, '. ', '') ||
                       kmdata.cit_nvl(v_Sponsor, '. ', '') ||
                       kmdata.cit_nvl(kmdata.cit_nvl(kmdata.get_month_name(v_Month1), ' ', '') || kmdata.cit_nvl(v_Year1::text, '', ''), v_PrintString5, '');
      
   ELSIF p_RIVActivityName = 'TechnicalReport' THEN
      
      SELECT a.title, a.author_list, a.edition, a.volume, a.issue, a.editor_list,
             a.city, a.state, a.country,
             a.publisher, --a.isbn, NULL AS report_number,
             a.publication_day, a.publication_month, a.publication_year
        INTO v_Title1, v_AuthorList, v_Edition, v_Volume, v_Issue, v_EditorList,
             v_City, v_State, v_Country,
             v_Publisher,
             v_Day1, v_Month1, v_Year1
        FROM ror.vw_TechnicalReport a
       WHERE a.id = p_WorkID
       LIMIT 1;
      
      IF v_Volume IS NULL OR TRIM(v_Volume) = '' THEN
         v_PrintString6 := '';
      ELSE
         v_PrintString6 := 'Vol. ';
      END IF;

      IF v_Issue IS NULL OR TRIM(v_Issue) = '' THEN
         v_PrintString1 := '';
      ELSE
         v_PrintString1 := 'no. ';
      END IF;
      
      IF v_EditorList IS NULL OR TRIM(v_EditorList) = '' THEN
         v_PrintString7 := '';
      ELSE
         v_PrintString7 := 'Edited by ';
      END IF;
      
      IF v_Month1 IS NULL AND v_Year1 IS NULL THEN
         v_PrintString2 := '';
      ELSE
         v_PrintString2 := '(';
      END IF;

      IF (v_State IS NULL OR TRIM(v_State) = '') AND (v_Country IS NULL OR TRIM(v_Country) = '') THEN
         v_PrintString3 := '';
      ELSE
         v_PrintString3 := ', ';
      END IF;

      IF v_Country IS NULL OR TRIM(v_Country) = '' THEN
         v_PrintString5 := '';
      ELSE
         v_PrintString5 := ', ';
      END IF;
      
      v_Citation := kmdata.cit_nvl(v_AuthorList, '. ', '') || kmdata.cit_nvl(v_Title1, '. ', '') ||
                       kmdata.cit_nvl(v_Edition, ' ed. ', '') || 
                       v_PrintString6 || kmdata.cit_nvl(v_Volume, ', ', '') ||
                       v_PrintString1 || kmdata.cit_nvl(v_Issue, '. ', '') ||
                       v_PrintString7 || kmdata.cit_nvl(v_EditorList, '. ', '') ||
                       kmdata.cit_nvl(v_City, v_PrintString3, '') || kmdata.cit_nvl(v_State, v_PrintString5, '') || kmdata.cit_nvl(v_Country, '', '') || ': ' ||
                       kmdata.cit_nvl(v_Publisher, '. ', '') ||
                       v_PrintString2 || kmdata.cit_nvl(kmdata.cit_nvl(kmdata.get_month_name(v_Month1), ' ', '') || kmdata.cit_nvl(v_Year1::text, '', ''), '). ', '');
      
   ELSIF p_RIVActivityName = 'Unpublished' THEN
      
      SELECT a.author_list, a.title, 
             a.submission_day, a.submission_month, a.submission_year
        INTO v_AuthorList, v_Title1, 
             v_Day1, v_Month1, v_Year1
        FROM ror.vw_Unpublished a
       WHERE a.id = p_WorkID
       LIMIT 1;
       
      IF v_Title1 IS NULL OR TRIM(v_Title1) = '' THEN
         v_PrintString3 := '';
         v_PrintString4 := '';
      ELSE
         v_PrintString3 := '"';
         v_PrintString4 := '." ';
      END IF;

      v_Citation := kmdata.cit_nvl(v_AuthorList, '. ', '') ||
                       --v_PrintString3 || COALESCE(v_Title1) || v_PrintString4 ||
                       kmdata.cit_nvl(v_Title1, '. ', '') || --COALESCE(v_Title2, v_Title3, v_Title4)
                       kmdata.cit_nvl(kmdata.cit_nvl(kmdata.get_month_name(v_Month1), ' ', '') || kmdata.cit_nvl(v_Year1::text, '.', ''), '', '');
      
   ELSE
      
      v_Citation := 'Citation unavailable.';
      
   END IF;
   
   RETURN v_Citation;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
