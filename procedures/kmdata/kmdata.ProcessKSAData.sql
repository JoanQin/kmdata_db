CREATE OR REPLACE FUNCTION kmdata.ProcessKSAData (
) RETURNS BIGINT AS $$
DECLARE
   v_intNewItemID BIGINT;
   v_intSourceID BIGINT;
   v_intResourceID BIGINT;
   v_intUserID BIGINT;
   v_intUserCount INTEGER;
   v_intWorkID BIGINT;
   v_intWorkArchDetailID BIGINT;
   v_intWorkArchDetailsCount BIGINT;
   v_intLocationsKSACount BIGINT;
   v_intAssetTypesCount BIGINT;

   v_intMediaArchTypeID BIGINT;
   v_intAudioArchTypeID BIGINT;
   v_intFileArchTypeID BIGINT;
   v_int3DArchTypeID BIGINT;
   v_intDocArchTypeID BIGINT;
   v_intVideoArchTypeID BIGINT;

   worksCursor CURSOR FOR
      SELECT a.vid, a.nid, a.title, c.work_arch_type, c.asset_data, g.user_uid, g.userid_value, REPLACE(g.userid_value,'@osu.edu','') AS osu_username,
      a.uid, a.mail, a.area_value, a.area_dimensionunit_value, 
      a.diameter_value, a.dimensionflags_value,
      a.dimensionunit_value, a.height_value, a.location_nid, a.measurementcomment_value, a.reference_value, a.releasestate_value,
      a.volume_value, a.volume_dimensionunit_value, a.width_value, a.workflags_value, a.workyear_value, c.url_value
      FROM ksa.work a
      INNER JOIN ksa.child_work b ON a.nid = b.work_nid
      INNER JOIN (
         SELECT vid, nid, NULL AS asset_data, v_intMediaArchTypeID AS work_arch_type, NULL AS url_value
         FROM ksa.media_asset
         UNION
         SELECT vid, nid, audio_data AS asset_data, v_intAudioArchTypeID AS work_arch_type, NULL AS url_value
         FROM ksa.audio_asset
         UNION
         SELECT vid, nid, file_data AS asset_data, v_intFileArchTypeID AS work_arch_type, NULL AS url_value
         FROM ksa.file_asset
         UNION
         SELECT vid, nid, work_3dfile_data AS asset_data, v_int3DArchTypeID AS work_arch_type, NULL AS url_value
         FROM ksa.work_3d_asset
         UNION
         SELECT vid, nid, doc_data AS asset_data, v_intDocArchTypeID AS work_arch_type, NULL AS url_value
         FROM ksa.doc_asset
         UNION
         SELECT vid, nid, NULL AS asset_data, v_intVideoArchTypeID AS work_arch_type, video_url_value AS url_value
         FROM ksa.video_asset
      ) c ON b.nid = c.nid AND b.vid = c.vid
      INNER JOIN ksa.child_mediaasset d ON c.nid = d.mediaasset_nid
      INNER JOIN ksa.media_asset_credit e ON d.nid = e.nid
      INNER JOIN ksa.child_creatormedia f ON e.nid = f.nid AND e.vid = f.vid
      INNER JOIN ksa.creator_media_asset g ON f.creatormedia_nid = g.nid;
BEGIN
   -- select and return the existing id
   v_intNewItemID := 0;

   -- load in the arch types
   select id INTO v_intMediaArchTypeID from kmdata.work_arch_types where type_description = 'media';
   select id INTO v_intAudioArchTypeID from kmdata.work_arch_types where type_description = 'audio';
   select id INTO v_intFileArchTypeID from kmdata.work_arch_types where type_description = 'file';
   select id INTO v_int3DArchTypeID from kmdata.work_arch_types where type_description = '3d';
   select id INTO v_intDocArchTypeID from kmdata.work_arch_types where type_description = 'doc';
   select id INTO v_intVideoArchTypeID from kmdata.work_arch_types where type_description = 'video';

   -- get the peoplesoft source id
   SELECT id INTO v_intSourceID FROM kmdata.sources WHERE source_name = 'ksa';

   SELECT COUNT(*) INTO v_intLocationsKSACount FROM kmdata.locations_ksa;

   IF v_intLocationsKSACount < 1 THEN
      -- populate the locations_ksa table
      INSERT INTO kmdata.locations_ksa
         (vid, nid, latitude_value, longitude_value, parentlocation_nid)
      SELECT vid, nid, latitude_value, longitude_value, parentlocation_nid
         FROM ksa.location;
   END IF;

   SELECT COUNT(*) INTO v_intAssetTypesCount FROM kmdata.work_arch_types;

   IF v_intAssetTypesCount < 1 THEN
      INSERT INTO kmdata.work_arch_types (type_description) VALUES ('media');
      INSERT INTO kmdata.work_arch_types (type_description) VALUES ('audio');
      INSERT INTO kmdata.work_arch_types (type_description) VALUES ('file');
      INSERT INTO kmdata.work_arch_types (type_description) VALUES ('3d');
      INSERT INTO kmdata.work_arch_types (type_description) VALUES ('doc');
      INSERT INTO kmdata.work_arch_types (type_description) VALUES ('video');
   END IF;

   -- open main cursor to loop over the records
   FOR currWork IN worksCursor LOOP
      
      -- check if the count is zero or one
      SELECT COUNT(*) INTO v_intUserCount
      FROM kmdata.user_identifiers
      WHERE inst_username = currWork.osu_username;

      IF v_intUserCount = 1 THEN

         -- get v_intUserID
         SELECT user_id INTO v_intUserID
         FROM kmdata.user_identifiers
         WHERE inst_username = currWork.osu_username;
      
         -- check to see if there is a resource
         SELECT COUNT(*) INTO v_intWorkArchDetailsCount
         FROM kmdata.work_arch_details
         WHERE vid = currWork.vid AND nid = currWork.nid;
   
         IF v_intWorkArchDetailsCount < 1 THEN
            -- get the resource id
            v_intResourceID := nextval('kmdata.resources_id_seq');
   
            -- insert the resource
            INSERT INTO kmdata.resources (id, source_id) VALUES (v_intResourceID, v_intSourceID);
   
            -- get the work ID
            v_intWorkID := nextval('kmdata.works_id_seq');
      
            -- insert the work
            INSERT INTO kmdata.works
               (id, resource_id, title, user_id, created_at, updated_at)
            VALUES
               (v_intWorkID, v_intResourceID, currWork.title, v_intUserID, current_timestamp, current_timestamp);

            -- get the architecture details id
            v_intWorkArchDetailID := nextval('kmdata.work_arch_details_id_seq');

            -- insert the architecture details
            INSERT INTO kmdata.work_arch_details
               (
               id,
               work_id,
               vid,
               nid,
               area_value,
               area_dimensionunit_value,
               diameter_value,
               dimensionflags_value,
               dimensionunit_value,
               height_value,
               location_nid,
               measurementcomment_value,
               reference_value,
               releasestate_value,
               volume_value,
               volume_dimensionunit_value,
               width_value,
               workflags_value,
               workyear_value,
               work_arch_type,
               asset_data,
               url_value
               )
            VALUES
               (
               v_intWorkArchDetailID,
               v_intWorkID,
               currWork.vid, 
               currWork.nid, 
               currWork.area_value, 
               currWork.area_dimensionunit_value, 
               currWork.diameter_value, 
               currWork.dimensionflags_value,
               currWork.dimensionunit_value,
               currWork.height_value, 
               currWork.location_nid, 
               currWork.measurementcomment_value, 
               currWork.reference_value, 
               currWork.releasestate_value,
               currWork.volume_value, 
               currWork.volume_dimensionunit_value, 
               currWork.width_value, 
               currWork.workflags_value, 
               currWork.workyear_value,
               currWork.work_arch_type,
               currWork.asset_data,
               currWork.url_value
               );

         ELSIF v_intWorkArchDetailsCount = 1 THEN
         
            -- there is already a record in the system

            -- select work_arch_details id
            SELECT id, work_id INTO v_intWorkArchDetailID, v_intWorkID
            FROM kmdata.work_arch_details
            WHERE vid = currWork.vid AND nid = currWork.nid;

            -- update the works table
            UPDATE kmdata.works
            SET title = currWork.title,
                user_id = v_intUserID,
                updated_at = current_timestamp
            WHERE id = v_intWorkID;

            -- update the work_arch_details table
            UPDATE kmdata.work_arch_details
            SET area_value = currWork.area_value,
               area_dimensionunit_value = currWork.area_dimensionunit_value,
               diameter_value = currWork.diameter_value,
               dimensionflags_value = currWork.dimensionflags_value,
               dimensionunit_value = currWork.dimensionunit_value,
               height_value = currWork.height_value,
               location_nid = currWork.location_nid,
               measurementcomment_value = currWork.measurementcomment_value,
               reference_value = currWork.reference_value,
               releasestate_value = currWork.releasestate_value,
               volume_value = currWork.volume_value,
               volume_dimensionunit_value = currWork.volume_dimensionunit_value,
               width_value = currWork.width_value,
               workflags_value = currWork.workflags_value,
               workyear_value = currWork.workyear_value,
               work_arch_type = currWork.work_arch_type,
               asset_data = currWork.asset_data,
               url_value = currWork.url_value
            WHERE id = v_intWorkArchDetailID;

         ELSE

            -- multiple records exist for this node, error
            INSERT INTO kmdata.import_errors (message_varchar) 
            VALUES ('KSA Assets/Works SELECT error (non-single match): ' || 
                    CAST(v_intWorkArchDetailsCount AS CHAR) || ' work_arch_details records matched vid==[' || 
                    CAST(currWork.vid AS CHAR) || '], nid==[' || CAST(currWork.nid AS CHAR) || ']. Record skipped.'
            );
         END IF;
   
      ELSE

         -- the count was not a single record
         INSERT INTO kmdata.import_errors (message_varchar) 
         VALUES ('KSA Assets/Works INSERT error (non-single match): ' || 
                 CAST(v_intUserCount AS CHAR) || ' users matched NAME.# ' || currWork.osu_username || '. Record skipped.'
         );
         
      END IF;
      
   END LOOP;

   RETURN v_intNewItemID;
END;
$$ LANGUAGE plpgsql;
