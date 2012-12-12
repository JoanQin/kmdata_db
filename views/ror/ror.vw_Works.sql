CREATE OR REPLACE VIEW ror.vw_Works AS
SELECT w.id, w.resource_id, title, w.user_id AS person_id, w.created_at, w.updated_at, w.parent_work_id, 
       work_type_id, journal_article_type_id, author_list, editor_list, 
       reviewer_list, article_title, journal_title, review_type_id, 
       edition, volume, issue, technical_report_number, submitted_to, 
       submission_date, series, sponsor, beginning_page, ending_page, 
       url, percent_authorship, author_date_citation, bibliography_citation, 
       research_report_citation, research_report_ind, impact_factor, 
       issn, publisher, publication_location, collection, site_last_viewed_date, 
       publication_media_type_id, status_id, abstract_type_id, peer_reviewed_ind, 
       presentation_role_id, presentation_location_descr, presentation_location_type_id, 
       audience_name, event_title, invited_talk, publication_title, 
       old_compiler, degree, acceptance_rate, role_id, artist, composer, 
       role_designator, title_in, format, program_length, medium, dimensions, 
       venue, forthcoming_id, collector, artwork_id, exhibit_title, 
       exhibition_type_id, juried_ind, curator, audience, juror, inventor, 
       invention_name, patent_number, manufacturer, format_id, director, 
       performer, network, distributor, station_call_number, duration, 
       media_collection, volume_number, participant, episode_title, 
       recital_performance_type_id, performance_company, writer, based_on, 
       organizer, publication_yearborked, ad_location, event_location, 
       other_info, people_served, hours, direct_cost, other_audience, 
       other_result, other_subject, publication_dmy_single_date_id, 
       submission_dmy_single_date_id, presentation_dmy_range_date_id, 
       presentation_dmy_single_date_id, performance_start_date, performance_end_date, 
       performance_dmy_range_date_id, exhibit_dmy_range_date_id, filed_date, 
       issued_date, filed_dmy_single_date_id, creative_work_year, issued_dmy_single_date_id, 
       last_update_dmy_single_date_id, creation_dmy_single_date_id, 
       broadcast_date, broadcast_dmy_single_date_id, disclosure_dmy_single_date_id, 
       outreach_dmy_range_date_id, city, state, country, book_title, 
       isbn, lccn, citation_count, 
       CASE ail.is_public WHEN 1 THEN TRUE ELSE FALSE END AS is_public
  FROM kmdata.works w
  INNER JOIN kmdata.resources res ON w.resource_id = res.id
  INNER JOIN kmdata.sources src ON res.source_id = src.id
  INNER JOIN researchinview.activity_import_log ail ON w.resource_id = ail.resource_id
 WHERE src.source_name != 'osupro'
   AND ail.is_active = 1;
