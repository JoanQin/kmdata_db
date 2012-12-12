CREATE OR REPLACE FUNCTION researchinview.insert_institution (
   p_RIVInstitutionID INTEGER
) RETURNS BIGINT AS $$
DECLARE
   v_InstitutionName VARCHAR(2000);
   v_LCaseInstitutionName VARCHAR(2000);
   v_MatchCount1 INTEGER;
   v_MatchCount2 INTEGER;
   v_ReturnID BIGINT;
   v_ResourceID BIGINT;
BEGIN
   v_ReturnID := 0;

   IF p_RIVInstitutionID IS NULL OR p_RIVInstitutionID = 0 THEN
      RETURN NULL;
   END IF;

   -- select the institution name
   SELECT upper("name"), "name" INTO v_InstitutionName, v_LCaseInstitutionName
     FROM researchinview.riv_institutions
    WHERE id = p_RIVInstitutionID;

   IF v_InstitutionName IS NULL OR 
      v_LCaseInstitutionName IS NULL OR 
      TRIM(v_InstitutionName) = '' OR
      TRIM(v_LCaseInstitutionName) = '' THEN
      
      RETURN NULL;
      
   END IF;

   -- see if this exists in the KMData table
   SELECT COUNT(*) INTO v_MatchCount1
     FROM kmdata.institutions
    WHERE upper("name") = v_InstitutionName;

   IF v_MatchCount1 > 0 THEN
   
      v_MatchCount2 = 1;
      
      SELECT id INTO v_ReturnID
        FROM kmdata.institutions
       WHERE upper("name") = v_InstitutionName;
       
   ELSE
   
      SELECT COUNT(*) INTO v_MatchCount2
        FROM kmdata.institutions
       WHERE 'THE ' || REPLACE(upper("name"), ', THE', '') = v_InstitutionName;

      IF v_MatchCount2 > 0 THEN

         SELECT id INTO v_ReturnID
           FROM kmdata.institutions
          WHERE 'THE ' || REPLACE(upper("name"), ', THE', '') = v_InstitutionName;

      END IF;
      
   END IF;

   IF v_MatchCount2 = 0 THEN
   
      -- insert the institution
      v_ReturnID := nextval('kmdata.institutions_id_seq');
      v_ResourceID := add_new_resource('kmdata', 'institutions');

      INSERT INTO kmdata.institutions
         (id, name, resource_id)
      VALUES
         (v_ReturnID, v_LCaseInstitutionName, v_ResourceID);
       
   END IF;
   
   RETURN v_ReturnID;
END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;
