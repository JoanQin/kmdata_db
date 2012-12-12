      SELECT a.vid, a.nid, a.title, c.work_arch_type, c.asset_data, --d.user_uid, d.userid_value,
      a.uid, a.mail, a.area_value, a.area_dimensionunit_value, 
      a.diameter_value, a.dimensionflags_value,
      a.dimensionunit_value, a.height_value, a.location_nid, a.measurementcomment_value, a.reference_value, a.releasestate_value,
      a.volume_value, a.volume_dimensionunit_value, a.width_value, a.workflags_value, a.workyear_value
      FROM ksa.work a
      INNER JOIN ksa.child_work b ON a.nid = b.work_nid
      INNER JOIN (
         SELECT vid, nid, NULL AS asset_data, (select id from kmdata.work_arch_types where type_description = 'media') AS work_arch_type
         FROM ksa.media_asset
         UNION
         SELECT vid, nid, audio_data AS asset_data, (select id from kmdata.work_arch_types where type_description = 'audio') AS work_arch_type
         FROM ksa.audio_asset
         UNION
         SELECT vid, nid, file_data AS asset_data, (select id from kmdata.work_arch_types where type_description = 'file') AS work_arch_type
         FROM ksa.file_asset
         UNION
         SELECT vid, nid, work_3dfile_data AS asset_data, (select id from kmdata.work_arch_types where type_description = '3d') AS work_arch_type
         FROM ksa.work_3d_asset
         UNION
         SELECT vid, nid, doc_data AS asset_data, (select id from kmdata.work_arch_types where type_description = 'doc') AS work_arch_type
         FROM ksa.doc_asset
         UNION
         SELECT vid, nid, NULL AS asset_data, (select id from kmdata.work_arch_types where type_description = 'video') AS work_arch_type
         FROM ksa.video_asset
      ) c ON b.nid = c.nid AND b.vid = c.vid
      INNER JOIN ksa.work_credit d ON a.nid = d.workid_nid
      INNER JOIN ksa.child_creatorid e ON d.nid = e.nid AND d.vid = e.vid -- e.creatorid_nid
      INNER JOIN ksa.creator_individual f ON e.creatorid_nid = f.nid
      INNER JOIN ksa.users g ON f.nid = g.nid
      --INNER JOIN ksa.child_mediaasset d ON c.nid = d.nid
      --INNER JOIN ksa.child_creatormedia d ON b.nid = d.nid
      --INNER JOIN ksa.media_asset_credit d ON b.nid = d.nid
      --INNER JOIN ksa.creator_media_asset d ON b.nid = d.nid AND b.vid = d.vid
      
      --LEFT JOIN ksa.creator_media_asset d ON b.nid = d.nid --AND b.vid = d.vid 
      --LEFT JOIN ksa.
      WHERE c.work_arch_type = (select id from kmdata.work_arch_types where type_description = 'media')
      LIMIT 400;
