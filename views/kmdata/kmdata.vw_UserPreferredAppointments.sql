CREATE OR REPLACE VIEW kmdata.vw_UserPreferredAppointments AS
SELECT id, user_id, description, department_name, show_ind, create_date
  FROM kmdata.user_preferred_appointments;
