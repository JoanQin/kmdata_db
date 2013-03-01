CREATE OR REPLACE VIEW vw_communitypartners AS 
SELECT a.id, a.resource_id, a.user_id, a.title, a.organization, a.contact_within_organization, a.description_of_role, a.city,
          a.state, a.country, a.url, a.created_at, a.updated_at, al.is_public, al.is_active
  FROM kmdata.community_partner a
  left join researchinview.activity_import_log al on al.resource_id = a.resource_id;