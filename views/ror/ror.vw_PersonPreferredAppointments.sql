CREATE OR REPLACE VIEW ror.vw_PersonPreferredAppointments AS
SELECT id, user_id AS person_id, description, department_name, show_ind, create_date
  FROM kmdata.user_preferred_appointments;
