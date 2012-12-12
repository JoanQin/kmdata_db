CREATE OR REPLACE VIEW kmdata.vw_UserPositions AS
SELECT up.id, up.user_id, up.business_name, up.city, up.country, up.current_ind, up.description, 
       up.division, 
       up.started_dmy_single_date_id, sd1.day AS started_day, sd1.month AS started_month, sd1.year AS started_year,
       up.ended_dmy_single_date_id, sd2.day AS ended_day, sd2.month AS ended_month, sd2.year AS ended_year,
       up.higher_ed_college, up.institution_id, up.higher_ed_department, up.higher_ed_position_title, 
       up.higher_ed_school, up.institute, up.unit, up.percent_time, up.position_title, 
       up.position_type, up.state, up.subject_area, up.resource_id, up.created_at, 
       up.updated_at
  FROM kmdata.user_positions up
  LEFT JOIN kmdata.dmy_single_dates sd1 ON up.started_dmy_single_date_id = sd1.id
  LEFT JOIN kmdata.dmy_single_dates sd2 ON up.ended_dmy_single_date_id = sd2.id;
