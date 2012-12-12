CREATE OR REPLACE FUNCTION osupro.GetOrInsertItemID (
   intAcademicItemTypeID BIGINT,
   intOldIntID BIGINT,
   chvProfileEmplid VARCHAR(11),
   dtmCreateDate VARCHAR,
   dtmModifiedDate VARCHAR,
   chvWhoEmplid VARCHAR(11),
   intShowItemInd VARCHAR,
   intTieInd VARCHAR,
   intTieProgramId BIGINT,
   intSigInd VARCHAR,
   intSignatureProgramID BIGINT,
   intQualityInd VARCHAR,
   txtQualityText TEXT DEFAULT NULL,
   intRefworkID BIGINT DEFAULT NULL,
   chvEBSCODBShortName VARCHAR(50) DEFAULT NULL,
   chvEBSCODBUITagCode VARCHAR(2) DEFAULT NULL,
   chvEBSCODBUIValue VARCHAR(50) DEFAULT NULL,
   chvOhioLinkDatabase VARCHAR(255) DEFAULT NULL,
   chvOhioLinkPublicationID VARCHAR(255) DEFAULT NULL,
   intTRLocatorID BIGINT DEFAULT NULL
) RETURNS BIGINT AS $$
DECLARE
   intMatchCount INTEGER;
   intNewItemID INTEGER;
   intEBSCOMatchCount INTEGER;
   intEBSCOLocatorID INTEGER;
   intEBSCORefMatchCount INTEGER;
   intOhioLinkMatchCount INTEGER;
   intOhioLinkLocatorID INTEGER;
   intOhioLinkRefMatchCount INTEGER;
   intTRMatchCount INTEGER;
   intTRLocatorID INTEGER;
   intTRRefMatchCount INTEGER;
BEGIN
   -- check to see the count in academic items
   SELECT COUNT(*) INTO intMatchCount
   FROM osupro.academic_item
   WHERE academic_item_type_id = intAcademicItemTypeID
   AND old_int_id = intOldIntID;

   -- if the record exists then select the item ID
   IF intMatchCount > 0 THEN
      -- select and return the existing id
      SELECT item_id INTO intNewItemID
      FROM osupro.academic_item
      WHERE academic_item_type_id = intAcademicItemTypeID
      AND old_int_id = intOldIntID;

      -- may want to update the record here as we are persisting this table
      -- update common fields like last modified dates, etc
      UPDATE osupro.academic_item
      SET create_date = TO_DATE(dtmCreateDate,'YYYY-MM-DD'), 
         modified_date = TO_DATE(dtmModifiedDate,'YYYY-MM-DD'),
         who_emplid = chvWhoEmplid, 
         show_item_ind = CASE intShowItemInd WHEN 'Y' THEN 1 WHEN 'N' THEN 0 ELSE NULL END, 
         tie_ind = CASE intTieInd WHEN 'Y' THEN 1 WHEN 'N' THEN 0 ELSE NULL END, 
         tie_program_id = intTieProgramId, 
         sig_ind = CASE intSigInd WHEN 'Y' THEN 1 WHEN 'N' THEN 0 ELSE NULL END, 
         signature_program_id = intSignatureProgramID, 
         quality_ind = CASE intQualityInd WHEN 'Y' THEN 1 WHEN 'N' THEN 0 ELSE NULL END, 
         quality_text = txtQualityText, 
         refwork_id = intRefworkID
      WHERE item_id = intNewItemID;

      -- return the matching value
      --RETURN intNewItemID;
   ELSE
      -- insert and return a new id
      intNewItemID := nextval('osupro.academic_item_item_id_seq');

      -- insert the complete academic item record
      INSERT INTO osupro.academic_item
         (item_id, academic_item_type_id, old_int_id, profile_emplid, create_date, modified_date,
          who_emplid, show_item_ind, tie_ind, tie_program_id, sig_ind, signature_program_id, 
          quality_ind, quality_text, refwork_id)
      VALUES
         (intNewItemID, intAcademicItemTypeID, intOldIntID, chvProfileEmplid, TO_DATE(dtmCreateDate,'YYYY-MM-DD'), TO_DATE(dtmModifiedDate,'YYYY-MM-DD'),
          chvWhoEmplid, 
          CASE intShowItemInd WHEN 'Y' THEN 1 WHEN 'N' THEN 0 ELSE NULL END, 
          CASE intTieInd WHEN 'Y' THEN 1 WHEN 'N' THEN 0 ELSE NULL END, 
          intTieProgramId, 
          CASE intSigInd WHEN 'Y' THEN 1 WHEN 'N' THEN 0 ELSE NULL END, 
          intSignatureProgramID,
          CASE intQualityInd WHEN 'Y' THEN 1 WHEN 'N' THEN 0 ELSE NULL END, 
          txtQualityText, intRefworkID);

      -- insert EBSCO Locator if applicable
      IF chvEBSCODBShortName IS NOT NULL AND chvEBSCODBUITagCode IS NOT NULL AND chvEBSCODBUIValue IS NOT NULL THEN
         -- check the count. Note that items in the Postgres system are linked and we can actually track instances of the same article across users and buckets.
         SELECT COUNT(*) INTO intEBSCOMatchCount
         FROM osupro.ebsco_locator
         WHERE ebsco_db_short_name = chvEBSCODBShortName
         AND ebsco_ui_tag_code = chvEBSCODBUITagCode
         AND ebsco_ui_value = chvEBSCODBUIValue;

         -- if the record doesn't exist then insert it
         IF intEBSCOMatchCount < 1 THEN
            -- insert and return a new id
            intEBSCOLocatorID := nextval('osupro.ebsco_locator_ebsco_locator_id_seq');

            INSERT INTO osupro.ebsco_locator
               (ebsco_locator_id, ebsco_db_short_name, ebsco_ui_tag_code, ebsco_ui_value)
            VALUES
               (intEBSCOLocatorID, chvEBSCODBShortName, chvEBSCODBUITagCode, chvEBSCODBUIValue);

            INSERT INTO osupro.academic_item_ebsco_locator_ref
               (item_id, ebsco_locator_id)
            VALUES
               (intNewItemID, intEBSCOLocatorID);
         ELSE
            -- select the EBSCO locator
            SELECT ebsco_locator_id INTO intEBSCOLocatorID
            FROM osupro.ebsco_locator
            WHERE ebsco_db_short_name = chvEBSCODBShortName
            AND ebsco_ui_tag_code = chvEBSCODBUITagCode
            AND ebsco_ui_value = chvEBSCODBUIValue;

            -- see if the current record has a reference match to join to the locator
            SELECT COUNT(*) INTO intEBSCORefMatchCount
            FROM osupro.academic_item_ebsco_locator_ref
            WHERE item_id = intNewItemID
            AND ebsco_locator_id = intEBSCOLocatorID;

            IF intEBSCORefMatchCount < 1 THEN
               -- insert the locator reference match
               INSERT INTO osupro.academic_item_ebsco_locator_ref
                  (item_id, ebsco_locator_id)
               VALUES
                  (intNewItemID, intEBSCOLocatorID);
            END IF;
         END IF;
      END IF;

      -- insert OhioLINK Locator if applicable
      IF chvOhioLinkDatabase IS NOT NULL AND chvOhioLinkPublicationID IS NOT NULL THEN
         -- check the count
         SELECT COUNT(*) INTO intOhioLinkMatchCount
         FROM osupro.ohio_link_locator
         WHERE ohio_link_database = chvOhioLinkDatabase
         AND ohio_link_publication_id = chvOhioLinkPublicationID;

         -- if the record doesn't exist then insert it
         IF intOhioLinkMatchCount < 1 THEN
            -- insert and return a new id
            intOhioLinkLocatorID := nextval('osupro.ohio_link_locator_ohio_link_locator_id_seq');

            INSERT INTO osupro.ohio_link_locator
               (ohio_link_locator_id, ohio_link_database, ohio_link_publication_id)
            VALUES
               (intOhioLinkLocatorID, chvOhioLinkDatabase, chvOhioLinkPublicationID);

            INSERT INTO osupro.academic_item_ohio_link_locator_ref
               (item_id, ohio_link_locator_id)
            VALUES
               (intNewItemID, intOhioLinkLocatorID);
         ELSE
            -- select the OhioLINK locator
            SELECT ohio_link_locator_id INTO intOhioLinkLocatorID
            FROM osupro.ohio_link_locator
            WHERE ohio_link_database = chvOhioLinkDatabase
            AND ohio_link_publication_id = chvOhioLinkPublicationID;
            
            -- see if the current record has a reference match to join to the locator
            SELECT COUNT(*) INTO intOhioLinkRefMatchCount
            FROM osupro.academic_item_ohio_link_locator_ref
            WHERE item_id = intNewItemID
            AND ohio_link_locator_id = intOhioLinkLocatorID;

            IF intOhioLinkLocatorID < 1 THEN
               -- insert the locator reference match
               INSERT INTO osupro.academic_item_ohio_link_locator_ref
                  (item_id, ohio_link_locator_id)
               VALUES
                  (intNewItemID, intOhioLinkLocatorID);
            END IF;
         END IF;
      END IF;

      -- insert TR locator if applicable
      IF intTRLocatorID IS NOT NULL THEN
         -- check the count
         SELECT COUNT(*) INTO intTRMatchCount
         FROM osupro.tr_locator
         WHERE tr_locator_id = intTRLocatorID;

         -- if the record doesn't exist then insert it
         IF intTRMatchCount < 1 THEN
            -- insert and return a new id
            intTRLocatorID := nextval('osupro.tr_locator_tr_locator_id_seq');

            INSERT INTO osupro.tr_locator
               (tr_locator_id)
            VALUES
               (intTRLocatorID);

            INSERT INTO osupro.academic_item_tr_locator_ref
               (item_id, tr_locator_id)
            VALUES
               (intNewItemID, intTRLocatorID);
         ELSE
            -- select the TR locator
            --SELECT tr_locator_id INTO intTRLocatorID
            --FROM osupro.tr_locator
            --WHERE 
            NULL;
         END IF;
      END IF;
      
      -- return the matching value
      --RETURN intNewItemID;
   END IF;

   RETURN intNewItemID;
END;
$$ LANGUAGE plpgsql;
