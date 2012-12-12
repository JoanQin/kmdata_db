CREATE OR REPLACE FUNCTION osupro.GetOrInsertItemID (
   intAcademicItemTypeID INTEGER,
   intOldIntID INTEGER,
   chvProfileEmplid VARCHAR(11),
   dtmCreateDate TIMESTAMP,
   dtmModifiedDate TIMESTAMP,
   chvWhoEmplid VARCHAR(11),
   intShowItemInd SMALLINT,
   intTieInd SMALLINT,
   intTieProgramId INTEGER,
   intSigInd SMALLINT,
   intSignatureProgramID INTEGER,
   intQualityInd SMALLINT,
   txtQualityText TEXT DEFAULT NULL,
   intRefworkID INTEGER DEFAULT NULL,
   chvEBSCODBShortName VARCHAR(50) DEFAULT NULL,
   chvEBSCODBUITagCode VARCHAR(2) DEFAULT NULL,
   chvEBSCODBUIValue VARCHAR(50) DEFAULT NULL,
   chvOhioLinkDatabase VARCHAR(255) DEFAULT NULL,
   chvOhioLinkPublicationID VARCHAR(255) DEFAULT NULL,
   intTRLocatorID INTEGER DEFAULT NULL
) RETURNS INTEGER AS $$
DECLARE
   intMatchCount INTEGER;
   intNewItemID INTEGER;
   intEBSCOMatchCount INTEGER;
   intEBSCOLocatorID INTEGER;
   intOhioLinkMatchCount INTEGER;
   intOhioLinkLocatorID INTEGER;
   intTRMatchCount INTEGER;
   intTRLocatorID INTEGER;
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
         (intNewItemID, intAcademicItemTypeID, intOldIntID, chvProfileEmplid, dtmCreateDate, dtmModifiedDate,
          chvWhoEmplid, intShowItemInd, intTieInd, intTieProgramId, intSigInd, intSignatureProgramID,
          intQualityInd, txtQualityText, intRefworkID);

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
         END IF;
      END IF;
      
      -- return the matching value
      --RETURN intNewItemID;
   END IF;

   RETURN intNewItemID;
END;
$$ LANGUAGE plpgsql;
