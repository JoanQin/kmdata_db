CREATE OR REPLACE VIEW kmdata.bckfd_pro_user_names_vw AS 
 SELECT ui.emplid, u.first_name, u.middle_name, u.last_name, u.name_prefix, u.name_suffix, 
        u.display_name, ui.inst_username AS kerb_id, ui.inst_username AS ckm_username, NULL::character varying AS ckm_password, 
        NULL::character varying AS who_emplid, u.updated_at AS when_dtm, 0 AS guest_ind, 1 AS active_ind, NULL::timestamp without time zone AS last_login, 
        0 AS app_forward, u.uuid, u.deceased_ind
   FROM users u
   JOIN user_identifiers ui ON u.id = ui.user_id;