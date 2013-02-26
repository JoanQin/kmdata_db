CREATE OR REPLACE FUNCTION kmdata.get_slug (
   p_InputString VARCHAR(4000)
) RETURNS VARCHAR AS $$
DECLARE
   v_ReturnText VARCHAR(4000);
   v_StringLength INTEGER;
   v_PlainMatchCount BIGINT;
   v_NumberedMatchCount BIGINT;
   v_NumberedReturnText VARCHAR(4000);
BEGIN
   -- initialize lowercase
   v_ReturnText := lower(p_InputString);

   -- invalid chars
   v_ReturnText := regexp_replace(v_ReturnText, '[^a-z0-9\s-]', '', 'g');

   -- convert multiple spaces into one space
   v_ReturnText := ltrim(rtrim(regexp_replace(v_ReturnText, '\s+', ' ', 'g')));

   -- cut and trim
   IF length(v_ReturnText) <= 50 THEN
      v_StringLength := length(v_ReturnText);
   ELSE
      v_StringLength := 50;
   END IF;
   v_ReturnText := ltrim(rtrim(substr(v_ReturnText, 1, v_StringLength)));

   -- hyphens
   v_ReturnText := regexp_replace(v_ReturnText, '\s', '-', 'g');
   
   -- see if this slug is already in the table
   SELECT COUNT(*) INTO v_PlainMatchCount
   FROM kmdata.groups
   WHERE slug = v_ReturnText;
   
   IF v_PlainMatchCount > 0 THEN
      -- loop through numbers until there is a match, this method prevents the majority of collisions
      FOR idx IN 1..999 LOOP
         IF length(v_ReturnText) >= 47 THEN
            v_NumberedReturnText := substr(v_ReturnText, 1, 47) || CAST(idx AS VARCHAR);
         ELSE
            v_NumberedReturnText := v_ReturnText || CAST(idx AS VARCHAR);
         END IF;
         
         SELECT COUNT(*) INTO v_NumberedMatchCount
         FROM kmdata.groups
         WHERE slug = v_NumberedReturnText;
		 
         IF v_NumberedMatchCount = 0 THEN
            RETURN v_NumberedReturnText;
         END IF;
      END LOOP;
      
      -- if we got here then we failed to create a unique slug
      RETURN NULL;
   END IF;

   -- the slug was ok and did not have to get processed through the numeric tests
   RETURN v_ReturnText;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
GRANT EXECUTE ON FUNCTION kmdata.get_slug(character varying) TO kmd_ror_app_user;
