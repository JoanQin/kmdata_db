-- Move script for KMData Extension Reporting
-- Items listed by JQ, moved by JW

-- Here are tables we need to move:

--Kmd_dev_riv_user.event
CREATE TABLE kmd_dev_riv_user.event
(
  id bigserial NOT NULL,
  created_at timestamp without time zone NOT NULL,
  updated_at timestamp without time zone NOT NULL,
  integrationactivityid character varying(255),
  integrationuserid character varying(255),
  ispublic boolean,
  extendedattribute1 character varying(2000),
  extendedattribute2 character varying(2000),
  extendedattribute3 character varying(2000),
  extendedattribute4 character varying(2000),
  extendedattribute5 character varying(2000),
  deleted_ind boolean NOT NULL DEFAULT false,
  audienceregion character varying(255),
  contacthours integer,
  county character varying(255),
  deliverymethod character varying(255),
  displayondossierreport character varying(255),
  eventaudiencegroups character varying(2000),
  eventdate character varying(255),
  eventdescription character varying(2000),
  eventexternalpartners character varying(2000),
  eventindicators character varying(2000),
  eventname character varying(2000),
  isformalstudentevaluation character varying(255),
  numberofmailcontacts integer,
  numberofmaterials integer,
  numberofmediaappearances integer,
  numberofphonecontacts integer,
  numberofvolunteers integer,
  organizerrole character varying(255),
  percenttaught integer,
  programintegrationactivityid character varying(255),
  state character varying(255),
  volunteerhours integer,
  CONSTRAINT event_pky PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE kmd_dev_riv_user.event
  OWNER TO kmd_dev_riv_user;

--Kmd_dev_riv_user.event_audience_group
CREATE TABLE kmd_dev_riv_user.event_audience_group
(
  id bigserial NOT NULL,
  created_at timestamp without time zone NOT NULL DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT now(),
  integrationactivityid character varying(255),
  audienceracialgroupid integer,
  numberoffemales integer,
  numberofmales integer,
  CONSTRAINT event_audience_group_pky PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE kmd_dev_riv_user.event_audience_group
  OWNER TO kmd_dev_riv_user;

--Kmd_dev_riv_user.event_external_partner
CREATE TABLE kmd_dev_riv_user.event_external_partner
(
  id bigserial NOT NULL,
  created_at timestamp without time zone NOT NULL DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT now(),
  integrationactivityid character varying(255),
  collaboratordesc character varying(4000),
  collaboratorname character varying(1000),
  collaboratorpercent integer,
  sortorder integer,
  CONSTRAINT event_external_partner_pky PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE kmd_dev_riv_user.event_external_partner
  OWNER TO kmd_dev_riv_user;

--Kmd_dev_riv_user.event_indicator
CREATE TABLE kmd_dev_riv_user.event_indicator
(
  id bigserial NOT NULL,
  created_at timestamp without time zone NOT NULL DEFAULT now(),
  updated_at timestamp without time zone NOT NULL DEFAULT now(),
  integrationactivityid character varying(255),
  displayorder integer,
  indicatorid integer,
  indicatorscore integer,
  isrequired boolean,
  CONSTRAINT event_indicator_pky PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE kmd_dev_riv_user.event_indicator
  OWNER TO kmd_dev_riv_user;

--Kmd_dev_riv_user.program
CREATE TABLE kmd_dev_riv_user.program
(
  created_at timestamp without time zone NOT NULL,
  updated_at timestamp without time zone NOT NULL,
  activityoutputdescription character varying(2000),
  collaborationdescription character varying(2000),
  daysplanned integer,
  daysspent integer,
  grantintegrationactivityids character varying(255),
  impactarea character varying(255),
  iscostrecoverystar character varying(255),
  isfunded character varying(255),
  ispointofpride character varying(255),
  issuearea character varying(255),
  keywords character varying(255),
  longtermimpactdescription character varying(2000),
  longtermoutcome character varying(255),
  midtermimpactdescription character varying(2000),
  midtermoutcome character varying(255),
  participationoutputdescription character varying(2000),
  partnership character varying(255),
  partnershipother character varying(2000),
  planofaction character varying(255),
  planyear integer,
  programarea character varying(255),
  programcreatedyear integer,
  programname character varying(2000),
  programobjectivedescription character varying(2000),
  shorttermimpactdescription character varying(2000),
  shorttermoutcome character varying(255),
  situationdescription character varying(2000),
  statewideteam character varying(255),
  targetaudiencedescription character varying(2000),
  teammemberintegrationuserids character varying(2000),
  integrationactivityid character varying(255),
  integrationuserid character varying(255),
  ispublic boolean,
  extenedattribute1 character varying(2000),
  extenedattribute2 character varying(2000),
  extenedattribute3 character varying(2000),
  extenedattribute4 character varying(2000),
  extenedattribute5 character varying(2000),
  deleted_ind boolean NOT NULL DEFAULT false,
  id bigserial NOT NULL,
  CONSTRAINT id PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE kmd_dev_riv_user.program
  OWNER TO kmd_dev_riv_user;


-- Here are the functions we need to move:

--Kmd_dev_riv_user.geteventorganizerrole
CREATE OR REPLACE FUNCTION kmd_dev_riv_user.geteventorganizerrole(p_organizerrole character varying)
  RETURNS character varying AS
$BODY$
declare 
	v_organizerrole varchar(2000);
	i record;
begin
	for i in select name from researchinview.riv_event_organizer_role
			where value in (select cast(regexp_split_to_table(p_organizerrole, ',') as integer) ) 
		loop
			v_organizerrole = concat(v_organizerrole, i.name, ', ');
		end loop;
	if length(v_organizerrole) > 1 then
		v_organizerrole = left(v_organizerrole, length(v_organizerrole)-2);
	end if;
	return v_organizerrole;

end;
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;
ALTER FUNCTION kmd_dev_riv_user.geteventorganizerrole(character varying)
  OWNER TO kmd_dev_riv_user;

--Kmd_dev_riv_user.getlongtermoutcome
CREATE OR REPLACE FUNCTION kmd_dev_riv_user.getlongtermoutcome(p_longtermoutcome character varying)
  RETURNS character varying AS
$BODY$
declare 
	v_longtermoutcomeName varchar(2000);
	i record;
begin
	for i in select name from researchinview.riv_program_long_term_eval 
			where value in (select cast(regexp_split_to_table(p_longtermoutcome, ',') as integer) )  
		loop
			v_longtermoutcomeName = concat(v_longtermoutcomeName, i.name, ', ');
		end loop;
	if length(v_longtermoutcomeName) > 1 then
		v_longtermoutcomeName = left(v_longtermoutcomeName, length(v_longtermoutcomeName)-2);
	end if;
	return v_longtermoutcomeName;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;
ALTER FUNCTION kmd_dev_riv_user.getlongtermoutcome(character varying)
  OWNER TO kmd_dev_riv_user;

--Kmd_dev_riv_user.getmidtermoutcome
CREATE OR REPLACE FUNCTION kmd_dev_riv_user.getmidtermoutcome(p_midtermoutcome character varying)
  RETURNS character varying AS
$BODY$
declare 
	v_midtermoutcomeName varchar(2000);
	i record;
begin
	for i in select name from researchinview.riv_program_medium_term_eval 
			where value in (select cast(regexp_split_to_table(p_midtermoutcome, ',') as integer) )  
		loop
			v_midtermoutcomeName = concat(v_midtermoutcomeName, i.name, ', ');
		end loop;
	if length(v_midtermoutcomeName) > 1 then
		v_midtermoutcomeName = left(v_midtermoutcomeName, length(v_midtermoutcomeName)-2);
	end if;
	return v_midtermoutcomeName;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;
ALTER FUNCTION kmd_dev_riv_user.getmidtermoutcome(character varying)
  OWNER TO kmd_dev_riv_user;

--Kmd_dev_riv_user.getpartnershipname
CREATE OR REPLACE FUNCTION kmd_dev_riv_user.getpartnershipname(p_partnership character varying)
  RETURNS character varying AS
$BODY$
declare 
	v_partnershipName varchar(2000);
	i record;
begin
	for i in select name from researchinview.riv_program_partnership 
			where value in (select cast(regexp_split_to_table(p_partnership, ',') as integer) ) 
		loop
			v_partnershipName = concat(v_partnershipName, i.name, ', ');
		end loop;
	if length(v_partnershipName) > 1 then
		v_partnershipName = left(v_partnershipName, length(v_partnershipName)-2);
	end if;
	return v_partnershipName;

end;
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;
ALTER FUNCTION kmd_dev_riv_user.getpartnershipname(character varying)
  OWNER TO kmd_dev_riv_user;

--Kmd_dev_riv_user.getprogramkeyword
CREATE OR REPLACE FUNCTION kmd_dev_riv_user.getprogramkeyword(p_keyword character varying)
  RETURNS character varying AS
$BODY$
declare 
	v_keywordName varchar(2000);
	i record;
begin
	for i in select name from researchinview.riv_program_keyword 
			where value in (select cast(regexp_split_to_table(p_keyword, ',') as integer) ) 
		loop
			v_keywordName = concat(v_keywordName, i.name, ', ');
		end loop;
	if length(v_keywordName) > 1 then
		v_keywordName = left(v_keywordName, length(v_keywordName)-2);
	end if;
	return v_keywordName;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;
ALTER FUNCTION kmd_dev_riv_user.getprogramkeyword(character varying)
  OWNER TO kmd_dev_riv_user;

--Kmd_dev_riv_user.getprogramteammember
CREATE OR REPLACE FUNCTION kmd_dev_riv_user.getprogramteammember(p_teammember character varying)
  RETURNS character varying AS
$BODY$
declare 
	v_teammemberName varchar(2000);
	i record;
begin
	for i in select inst_username from kmdata.user_identifiers 
			where emplid in (select regexp_split_to_table(p_teammember, ',')  ) 
		loop
			v_teammemberName = concat(v_teammemberName, i.inst_username, ', ');
		end loop;
	if length(v_teammemberName) > 1 then
		v_teammemberName = left(v_teammemberName, length(v_teammemberName)-2);
	end if;
	return v_teammemberName;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;
ALTER FUNCTION kmd_dev_riv_user.getprogramteammember(character varying)
  OWNER TO kmd_dev_riv_user;

--Kmd_dev_riv_user.getshorttermoutcome
CREATE OR REPLACE FUNCTION kmd_dev_riv_user.getshorttermoutcome(p_shorttermoutcome character varying)
  RETURNS character varying AS
$BODY$
declare 
	v_shorttermoutcomeName varchar(2000);
	i record;
begin
	for i in select name from researchinview.riv_program_short_term_eval 
			where value in (select cast(regexp_split_to_table(p_shorttermoutcome, ',') as integer) )  
		loop
			v_shorttermoutcomeName = concat(v_shorttermoutcomeName, i.name, ', ');
		end loop;
	if length(v_shorttermoutcomeName) > 1 then
		v_shorttermoutcomeName = left(v_shorttermoutcomeName, length(v_shorttermoutcomeName)-2);
	end if;
	return v_shorttermoutcomeName;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;
ALTER FUNCTION kmd_dev_riv_user.getshorttermoutcome(character varying)
  OWNER TO kmd_dev_riv_user;

--Kmd_dev_riv_user.insert_event
CREATE OR REPLACE FUNCTION kmd_dev_riv_user.insert_event(p_integrationactivityid character varying, p_integrationuserid character varying, p_ispublic integer, p_extendedattribute1 character varying, p_extendedattribute2 character varying, p_extendedattribute3 character varying, p_extendedattribute4 character varying, p_extendedattribute5 character varying, p_audienceregion character varying, p_contacthours integer, p_county character varying, p_deliverymethod character varying, p_displayondossierreport character varying, p_eventaudiencegroups character varying, p_eventdate character varying, p_eventdescription character varying, p_eventexternalpartners character varying, p_eventindicators character varying, p_eventname character varying, p_isformalstudentevaluation character varying, p_numberofmailcontacts integer, p_numberofmaterials integer, p_numberofmediaappearances integer, p_numberofphonecontacts integer, p_numberofvolunteers integer, p_organizerrole character varying, p_percenttaught integer, p_programintegrationactivityid character varying, p_state character varying, p_volunteerhours integer)
  RETURNS bigint AS
$BODY$
declare 
	v_eventID bigint;
	v_eventMatchCount bigint;
begin

select count(*) into v_eventMatchCount
from kmd_dev_riv_user.event
where integrationActivityId = p_integrationActivityId;

if v_eventMatchCount = 0 then
	v_eventID := nextval('kmd_dev_riv_user.event_id_seq');
	insert into kmd_dev_riv_user.event
	(id, created_at, updated_at, integrationactivityid, integrationuserid, ispublic, extendedattribute1, extendedattribute2,
	extendedattribute3, extendedattribute4, extendedattribute5, audienceregion, contacthours, county,
	deliverymethod, displayondossierreport, eventaudiencegroups, eventdate, eventdescription, eventexternalpartners,
	eventindicators, eventname, isformalstudentevaluation, numberofmailcontacts, numberofmaterials, numberofmediaappearances,
	numberofphonecontacts, numberofvolunteers, organizerrole, percenttaught, programintegrationactivityid, state, volunteerhours)
	values
	(v_eventID, current_timestamp, current_timestamp, p_integrationactivityid, p_integrationuserid, cast(p_ispublic as boolean), p_extendedAttribute1,
	p_extendedAttribute2, p_extendedAttribute3, p_extendedAttribute4, p_extendedAttribute5, p_audienceRegion, p_contactHours,
	p_county, p_deliveryMethod, p_displayOnDossierReport, p_eventAudienceGroups, p_eventDate, p_eventDescription, 
	p_eventExternalPartners, p_eventIndicators, p_eventName, p_isFormalStudentEvaluation, p_numberOfMailContacts, p_numberOfMaterials, 
	p_numberOfMediaAppearances, p_numberOfPhoneContacts, p_numberOfVolunteers, p_organizerRole, p_percentTaught, 
	p_programIntegrationActivityId, p_state, p_volunteerHours);
else 
	select id into v_eventID
	from kmd_dev_riv_user.event
	where integrationActivityId = p_integrationActivityId;

	update kmd_dev_riv_user.event
		set updated_at = current_timestamp, 
		    integrationactivityid = p_integrationactivityid, 
		    integrationuserid = p_integrationuserid, 
		    ispublic = cast(p_ispublic as boolean), 
		    extendedattribute1 = p_extendedAttribute1, 
		    extendedattribute2 = p_extendedAttribute2,
	            extendedattribute3 = p_extendedAttribute3, 
	            extendedattribute4 = p_extendedAttribute4, 
	            extendedattribute5 = p_extendedAttribute5, 
	            audienceregion = p_audienceRegion, 
	            contacthours = p_contactHours, 
	            county = p_county,
	            deliverymethod = p_deliveryMethod, 
	            displayondossierreport = p_displayOnDossierReport, 
	            eventaudiencegroups = p_eventAudienceGroups, 
	            eventdate = p_eventDate, 
	            eventdescription = p_eventDescription, 
	            eventexternalpartners = p_eventExternalPartners,
	            eventindicators = p_eventIndicators, 
	            eventname = p_eventName, 
	            isformalstudentevaluation = p_isFormalStudentEvaluation, 
	            numberofmailcontacts = p_numberOfMailContacts, 
	            numberofmaterials = p_numberOfMaterials, 
	            numberofmediaappearances = p_numberOfMediaAppearances,
	            numberofphonecontacts = p_numberOfPhoneContacts, 
	            numberofvolunteers = p_numberOfVolunteers, 
	            organizerrole = p_organizerRole, 
	            percenttaught = p_percentTaught, 
	            programintegrationactivityid = p_programIntegrationActivityId, 
	            state = p_state, 
	            volunteerhours = p_volunteerHours
	where id = v_eventID;
end if;
return v_eventID;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;
ALTER FUNCTION kmd_dev_riv_user.insert_event(character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, integer, integer, integer, integer, character varying, integer, character varying, character varying, integer)
  OWNER TO kmd_dev_riv_user;

--Kmd_dev_riv_user.insert_program
CREATE OR REPLACE FUNCTION kmd_dev_riv_user.insert_program(p_integrationactivityid character varying, p_integrationuserid character varying, p_ispublic integer, p_extendedattribute1 character varying, p_extendedattribute2 character varying, p_extendedattribute3 character varying, p_extendedattribute4 character varying, p_extendedattribute5 character varying, p_activityoutputdescription character varying, p_collaborationdescription character varying, p_daysplanned integer, p_daysspent integer, p_grantintegrationactivityids character varying, p_impactarea character varying, p_iscostrecoverystar character varying, p_isfunded character varying, p_ispointofpride character varying, p_issuearea character varying, p_keywords character varying, p_longtermimpactdescription character varying, p_longtermoutcome character varying, p_midtermimpactdescription character varying, p_midtermoutcome character varying, p_participationoutputdescription character varying, p_partnership character varying, p_partnershipother character varying, p_planofaction character varying, p_planyear integer, p_programarea character varying, p_programcreatedyear integer, p_programname character varying, p_programobjectivedescription character varying, p_shorttermimpactdescription character varying, p_shorttermoutcome character varying, p_situationdescription character varying, p_statewideteam character varying, p_targetaudiencedescription character varying, p_teammemberintegrationuserids character varying)
  RETURNS bigint AS
$BODY$
declare 
	v_programID bigint;
	v_programMatchCount bigint;
begin

select count(*) into v_programMatchCount
from kmd_dev_riv_user.program
where integrationActivityId = p_integrationActivityId;

if v_programMatchCount = 0 then
	v_programID := nextval('kmd_dev_riv_user.program_id_seq');
	insert into kmd_dev_riv_user.program
	(id, created_at, updated_at, activityOutputDescription, collaborationDescription, daysPlanned, daysSpent, grantIntegrationactivityIds, impactArea,
	isCostRecoveryStar, isFunded, isPointOfPride, issueArea, keywords, longTermImpactDescription, longTermOutcome, midTermImpactDescription, midTermOutcome,
	participationOutputDescription, partnership, partnershipOther, planOfAction, planYear, programArea, programCreatedYear, programName,
	programObjectiveDescription, shortTermImpactDescription, shortTermOutcome, situationDescription, statewideTeam, targetAudienceDescription,
	teamMemberIntegrationUserIds, integrationActivityId, integrationUserId, isPublic, extenedAttribute1, extenedAttribute2, extenedAttribute3,
	extenedAttribute4, extenedAttribute5)
	values
	(v_programID, current_timestamp, current_timestamp, p_activityOutputDescription, p_collaborationDescription, p_daysPlanned, p_daysSpent, 
	p_grantIntegrationActivityIds, p_impactArea, p_isCostRecoveryStar, p_isFunded, p_isPointOfPride, p_issueArea, p_keywords, p_longTermImpactDescription, p_longTermOutcome,
	p_midTermImpactDescription, p_midTermOutcome, p_participationOutputDescription, p_partnership, p_partnershipOther, p_planOfAction, p_planYear, 
	p_programArea, p_programCreatedYear, p_programName, p_programObjectiveDescription, p_shortTermImpactDescription, p_shortTermOutcome, 
	p_situationDescription, p_statewideTeam, p_targetAudienceDescription, p_teamMemberIntegrationUserIds, p_integrationActivityId,
	p_integrationUserId, cast(p_isPublic as boolean), p_extendedAttribute1, p_extendedAttribute2, p_extendedAttribute3, p_extendedAttribute4, p_extendedAttribute5);

else
	select id into v_programID
	from kmd_dev_riv_user.program
	where integrationActivityId = p_integrationActivityId;
	
	update kmd_dev_riv_user.program
		set updated_at = current_timestamp , 
		    activityOutputDescription = p_activityOutputDescription, 
		    collaborationDescription = p_collaborationDescription, 
		    daysPlanned = p_daysPlanned, 
		    daysSpent = p_daysSpent, 
		    grantIntegrationactivityIds = p_grantIntegrationActivityIds, 
		    impactArea = p_impactArea,
		    isCostRecoveryStar = p_isCostRecoveryStar, 
		    isFunded = p_isFunded, 
		    isPointOfPride = p_isPointOfPride, 
		    issueArea = p_issueArea, 
		    keywords = p_keywords, 
		    longTermImpactDescription = p_longTermImpactDescription, 
		    longTermOutcome = p_longTermOutcome, 
		    midTermImpactDescription = p_midTermImpactDescription, 
		    midTermOutcome = p_midTermOutcome,
		    participationOutputDescription = p_participationOutputDescription, 
		    partnership = p_partnership, 
		    partnershipOther = p_partnershipOther, 
		    planOfAction = p_planOfAction, 
		    planYear = p_planYear, 
		    programArea = p_programArea, 
		    programCreatedYear = p_programCreatedYear, 
		    programName = p_programName,
	            programObjectiveDescription = p_programObjectiveDescription, 
	            shortTermImpactDescription = p_shortTermImpactDescription, 
	            shortTermOutcome = p_shortTermOutcome, 
	            situationDescription = p_situationDescription, 
	            statewideTeam = p_statewideTeam, 
	            targetAudienceDescription = p_targetAudienceDescription,
	            teamMemberIntegrationUserIds = p_teamMemberIntegrationUserIds, 
	            integrationActivityId = p_integrationActivityId, 
	            integrationUserId = p_integrationUserId, 
	            isPublic = cast(p_isPublic as boolean), 
	            extenedAttribute1 = p_extendedAttribute1, 
	            extenedAttribute2 = p_extendedAttribute2, 
	            extenedAttribute3 = p_extendedAttribute3,
	            extenedAttribute4 = p_extendedAttribute4,  
	            extenedAttribute5 = p_extendedAttribute5
	where id = v_programID;
end if;
return v_programID;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;
ALTER FUNCTION kmd_dev_riv_user.insert_program(character varying, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying)
  OWNER TO kmd_dev_riv_user;



-- Here are the views we need to move:

--Kmd_dev_riv_user.vw_event
CREATE OR REPLACE VIEW kmd_dev_riv_user.vw_event AS 
 SELECT a.eventname, a.audienceregion, b.name AS event_audience, a.county, c.name AS event_county, a.deliverymethod, d.name AS event_delivery_method, a.programintegrationactivityid, e.programname, a.organizerrole, kmd_dev_riv_user.geteventorganizerrole(a.organizerrole) AS event_organizer_role, a.contacthours, a.eventdate, a.eventdescription, a.numberofmailcontacts, a.numberofmaterials, a.numberofmediaappearances, a.numberofphonecontacts, a.numberofvolunteers, a.percenttaught, a.state, a.volunteerhours, a.id, a.created_at, a.updated_at, a.integrationactivityid, a.integrationuserid, a.ispublic, a.extendedattribute1, a.extendedattribute2, a.extendedattribute3, a.extendedattribute4, a.extendedattribute5, a.deleted_ind, a.displayondossierreport, a.isformalstudentevaluation
   FROM kmd_dev_riv_user.event a
   LEFT JOIN researchinview.riv_event_audience b ON a.audienceregion::integer = b.value
   LEFT JOIN researchinview.riv_ohio_state_county c ON a.county::integer = c.value
   LEFT JOIN researchinview.riv_event_delivery_method d ON a.deliverymethod::integer = d.value
   LEFT JOIN kmd_dev_riv_user.program e ON a.programintegrationactivityid::text = e.integrationactivityid::text;

ALTER TABLE kmd_dev_riv_user.vw_event
  OWNER TO kmd_dev_riv_user;
GRANT ALL ON TABLE kmd_dev_riv_user.vw_event TO kmd_dev_riv_user;
GRANT SELECT ON TABLE kmd_dev_riv_user.vw_event TO kmd_report_user;

--Kmd_dev_riv_user.vw_program
CREATE OR REPLACE VIEW kmd_dev_riv_user.vw_program AS 
 SELECT a.activityoutputdescription, a.collaborationdescription, a.daysplanned, a.daysspent, a.grantintegrationactivityids, a.impactarea, b.name AS impactareaname, a.isfunded, a.issuearea, c.name AS issueareaname, a.keywords, kmd_dev_riv_user.getprogramkeyword(a.keywords) AS keywordname, a.longtermimpactdescription, a.longtermoutcome, kmd_dev_riv_user.getlongtermoutcome(a.longtermoutcome) AS longtermoutcomename, a.midtermimpactdescription, a.midtermoutcome, kmd_dev_riv_user.getmidtermoutcome(a.midtermoutcome) AS midtermoutcomename, a.participationoutputdescription, a.partnership, kmd_dev_riv_user.getpartnershipname(a.partnership) AS partnershipname, a.partnershipother, a.planofaction, f.name AS planofactionname, a.planyear, a.programarea, j.name AS areaname, a.programcreatedyear, a.programname, a.programobjectivedescription, a.shorttermimpactdescription, a.shorttermoutcome, kmd_dev_riv_user.getshorttermoutcome(a.shorttermoutcome) AS shortermoutcomename, a.situationdescription, a.statewideteam, h.name AS teamname, a.targetaudiencedescription, a.teammemberintegrationuserids, kmd_dev_riv_user.getprogramteammember(a.teammemberintegrationuserids) AS teammembers, a.integrationuserid, a.deleted_ind
   FROM kmd_dev_riv_user.program a
   LEFT JOIN researchinview.riv_program_impact_area b ON a.impactarea::integer = b.value
   LEFT JOIN researchinview.riv_program_issue_area c ON a.issuearea::integer = c.value
   LEFT JOIN researchinview.riv_program_planofaction f ON a.planofaction::integer = f.value
   LEFT JOIN researchinview.riv_program_area j ON a.programarea::integer = j.value
   LEFT JOIN researchinview.riv_program_team h ON a.statewideteam::integer = h.value;

ALTER TABLE kmd_dev_riv_user.vw_program
  OWNER TO kmd_dev_riv_user;
GRANT ALL ON TABLE kmd_dev_riv_user.vw_program TO kmd_dev_riv_user;
GRANT SELECT ON TABLE kmd_dev_riv_user.vw_program TO kmd_report_user;

