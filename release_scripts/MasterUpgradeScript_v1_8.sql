-- KMData Upgrade Script 1.8

-- protocol_id was already there
-- regulatory_approval was already there
ALTER TABLE kmdata.clinical_trials ADD COLUMN vertebrate_animals_used VARCHAR(255);
ALTER TABLE kmdata.clinical_trials ADD COLUMN clinical_trials_identifier VARCHAR(255);
ALTER TABLE kmdata.clinical_trials ADD COLUMN human_subjects VARCHAR(255);
ALTER TABLE kmdata.clinical_trials ADD COLUMN ongoing VARCHAR(255);
ALTER TABLE kmdata.clinical_trials ADD COLUMN regulatory_approval_other VARCHAR(255);

-- department was already there
ALTER TABLE kmdata.clinical_service ADD COLUMN clinical_hours_per VARCHAR(255);
ALTER TABLE kmdata.clinical_service ADD COLUMN individuals_served INTEGER;
ALTER TABLE kmdata.clinical_service ADD COLUMN ongoing VARCHAR(255);
ALTER TABLE kmdata.clinical_service ADD COLUMN role VARCHAR(255);
ALTER TABLE kmdata.clinical_service ADD COLUMN role_other VARCHAR(255);
ALTER TABLE kmdata.clinical_service ADD COLUMN total_hours_teaching_clinic INTEGER;

-- active was already there
--ALTER TABLE kmdata.degree_certifications ADD COLUMN active VARCHAR(255);

-- all columns were new
ALTER TABLE kmdata.user_honors_awards ADD COLUMN currency VARCHAR(255);
ALTER TABLE kmdata.user_honors_awards ADD COLUMN eligibility_other VARCHAR(255);
ALTER TABLE kmdata.user_honors_awards ADD COLUMN reach_of_award VARCHAR(255);
ALTER TABLE kmdata.user_honors_awards ADD COLUMN selection_process_other VARCHAR(255);
ALTER TABLE kmdata.user_honors_awards ADD COLUMN type_of_award VARCHAR(255);
ALTER TABLE kmdata.user_honors_awards ADD COLUMN type_of_award_other VARCHAR(255);
ALTER TABLE kmdata.user_honors_awards ADD COLUMN url VARCHAR(255);

-- all columns were new
ALTER TABLE kmdata.works ADD COLUMN completed VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN ongoing VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN other_artist VARCHAR(255);
ALTER TABLE kmdata.works ADD COLUMN solo VARCHAR(255);

-- all columns were new
ALTER TABLE kmdata.advising ADD COLUMN description_of_effort VARCHAR(4000);
ALTER TABLE kmdata.advising ADD COLUMN role_other VARCHAR(255);
ALTER TABLE kmdata.advising ADD COLUMN type_of_group VARCHAR(255);
ALTER TABLE kmdata.advising ADD COLUMN type_of_group_other VARCHAR(255);
ALTER TABLE kmdata.advising ADD COLUMN url VARCHAR(255);


-- Joan's changes per 1/7/13
ALTER TABLE kmdata.user_honors_awards ALTER COLUMN eligibility_other TYPE VARCHAR(1000);
ALTER TABLE kmdata.user_honors_awards ALTER COLUMN selection_process_other TYPE VARCHAR(1000);
ALTER TABLE kmdata.user_honors_awards ALTER COLUMN type_of_award_other TYPE VARCHAR(1000);
ALTER TABLE kmdata.user_honors_awards ALTER COLUMN url TYPE VARCHAR(2000);

ALTER TABLE kmdata.works ADD COLUMN performance VARCHAR(255);

