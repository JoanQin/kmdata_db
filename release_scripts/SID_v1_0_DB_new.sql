
CREATE TABLE sid.PS_SUBJECT_TBL (
                institution VARCHAR(5),
                subject VARCHAR(25),
                effdt TIMESTAMP,
                src_sys_id VARCHAR(5),
                eff_status VARCHAR(1),
                descr VARCHAR(30),
                descrshort VARCHAR(10),
                acad_org VARCHAR(10),
                split_owner VARCHAR(1),
                ext_subject_area VARCHAR(4),
                cip_code VARCHAR(13),
                hegis_code VARCHAR(8),
                descrformal VARCHAR(50),
                use_blind_grading VARCHAR(1),
                study_field VARCHAR(10),
                load_error VARCHAR(1),
                data_origin VARCHAR(1),
                created_ew_dttm TIMESTAMP,
                lastupd_ew_dttm TIMESTAMP,
                batch_sid NUMERIC(10)
);


CREATE TABLE sid.matvw_unit_association (
                unit_association_type_id INTEGER NOT NULL,
                unit_association_type_name VARCHAR(255) NOT NULL,
                parent_type_name VARCHAR(50) NOT NULL,
                parentunitid BIGINT NOT NULL,
                child_type_name VARCHAR(50) NOT NULL,
                childunitid BIGINT NOT NULL
);


CREATE INDEX matvw_unit_association_typename_idx
 ON sid.matvw_unit_association
 ( unit_association_type_name );

CREATE INDEX matvw_unit_association_parentunitid_idx
 ON sid.matvw_unit_association
 ( parentunitid );

CREATE INDEX matvw_unit_association_childunitid_idx
 ON sid.matvw_unit_association
 ( childunitid );

CREATE TABLE sid.OSU_COLLEGE (
                id BIGINT NOT NULL,
                dean VARCHAR(50) NOT NULL,
                mainOffice VARCHAR(50) NOT NULL,
                abbreviation VARCHAR(50) NOT NULL,
                CONSTRAINT osu_college_pk PRIMARY KEY (id)
);


CREATE TABLE sid.OSU_UNIT_TYPE (
                id INTEGER NOT NULL,
                name VARCHAR(50) NOT NULL,
                description VARCHAR(255) NOT NULL,
                createDate TIMESTAMP NOT NULL,
                CONSTRAINT osu_unit_type_pk PRIMARY KEY (id)
);


CREATE TABLE sid.OSU_UNIT_ASSOCIATION_TYPE (
                parentUnitTypeId INTEGER NOT NULL,
                childUnitTypeId INTEGER NOT NULL,
                id INTEGER NOT NULL,
                description VARCHAR(255) NOT NULL,
                createDate TIMESTAMP NOT NULL,
                modifyDate TIMESTAMP,
                CONSTRAINT osu_unit_association_type_pk PRIMARY KEY (parentUnitTypeId, childUnitTypeId)
);


CREATE TABLE sid.OSU_UNIT_ASSOCIATION (
                id BIGINT NOT NULL,
                associationTypeId INTEGER NOT NULL,
                parentUnitId BIGINT NOT NULL,
                childUnitId BIGINT NOT NULL,
                parentUnitTypeId BIGINT NOT NULL,
                childUnitTypeId INTEGER NOT NULL,
                createDate TIMESTAMP NOT NULL,
                modifyDate TIMESTAMP,
                CONSTRAINT osu_unit_association_pk PRIMARY KEY (id, associationTypeId)
);


CREATE TABLE sid.OSU_UNIT (
                id BIGINT NOT NULL,
                unitTypeId INTEGER NOT NULL,
                sourceId SMALLINT NOT NULL,
                statusId SMALLINT NOT NULL,
                unitClassificationId SMALLINT,
                sourceSystemKeys VARCHAR(800) NOT NULL,
                shortTitle VARCHAR(100),
                longTitle VARCHAR(255) NOT NULL,
                description VARCHAR(255),
                cmsUnitCode VARCHAR(255) NOT NULL,
                lockId SMALLINT NOT NULL,
                createDate TIMESTAMP NOT NULL,
                modifyDate TIMESTAMP,
                CONSTRAINT osu_unit_pk PRIMARY KEY (id)
);


CREATE TABLE sid.OSU_USER_ROLE (
                id INTEGER NOT NULL,
                targetSystemId SMALLINT NOT NULL,
                roleName VARCHAR(255) NOT NULL,
                externalSystemRoleId INTEGER,
                defaultRole SMALLINT NOT NULL,
                canEnroll SMALLINT NOT NULL,
                createDate TIMESTAMP NOT NULL,
                modifyDate TIMESTAMP,
                rank INTEGER,
                sourceRoleName VARCHAR(50),
                sourceId SMALLINT,
                targetSystemRoleValue INTEGER,
                CONSTRAINT osu_user_role_pk PRIMARY KEY (id)
);


CREATE TABLE sid.OSU_SECTION (
                yearQuarterCode VARCHAR(50) NOT NULL,
                checkDigit CHAR(10) NOT NULL,
                callNumber VARCHAR(50) NOT NULL,
                gradeAuthority SMALLINT NOT NULL,
                instructor VARCHAR(255),
                building VARCHAR(50),
                room VARCHAR(50),
                startTime VARCHAR(50),
                endTime VARCHAR(50),
                offeringYearQuarterCode VARCHAR(50),
                offeringCallNumber VARCHAR(50),
                campusId VARCHAR(50),
                departmentNumber VARCHAR(50),
                courseNumber VARCHAR(10),
                session_code VARCHAR(3),
                acad_group VARCHAR(5),
                acad_org VARCHAR(10),
                mon VARCHAR(1),
                tues VARCHAR(1),
                wed VARCHAR(1),
                thurs VARCHAR(1),
                fri VARCHAR(1),
                sat VARCHAR(1),
                sun VARCHAR(1),
                start_dt TIMESTAMP,
                end_dt TIMESTAMP,
                meeting_time_start TIMESTAMP,
                meeting_time_end TIMESTAMP,
                facility_id VARCHAR(10),
                mtg_pat_crse_id VARCHAR(6)
);
COMMENT ON COLUMN sid.OSU_SECTION.mtg_pat_crse_id IS 'If this is null then there is no meeting pattern.';


CREATE INDEX osu_section_altkey1_idx
 ON sid.OSU_SECTION
 ( yearQuarterCode, callNumber, campusId, departmentNumber, courseNumber, session_code, acad_group, acad_org );

CREATE TABLE sid.OSU_TERM_CODE (
                termCode VARCHAR(50) NOT NULL,
                unitClassificationId SMALLINT NOT NULL,
                cmsUnitCode VARCHAR(50) NOT NULL,
                shortTitle VARCHAR(50) NOT NULL,
                description VARCHAR(50),
                active SMALLINT NOT NULL,
                createDate TIMESTAMP NOT NULL,
                modifyDate TIMESTAMP,
                startDate TIMESTAMP,
                endDate TIMESTAMP,
                CONSTRAINT osu_term_code_pk PRIMARY KEY (termCode)
);


CREATE TABLE sid.OSU_OFFERING (
                yearQuarterCode VARCHAR(50) NOT NULL,
                campusId VARCHAR(50) NOT NULL,
                courseNumber VARCHAR(10) NOT NULL,
                departmentNumber VARCHAR(50) NOT NULL,
                session_code VARCHAR(3),
                acad_group VARCHAR(5),
                acad_org VARCHAR(10)
);


CREATE TABLE sid.OSU_UNIT_ENROLLMENT (
                userId BIGINT NOT NULL,
                yearQuarterCode VARCHAR(50),
                callNumber VARCHAR(50),
                campusId VARCHAR(50),
                departmentNumber VARCHAR(50),
                courseNumber VARCHAR(10),
                session_code VARCHAR(3),
                acad_group VARCHAR(5),
                acad_org VARCHAR(10),
                emplid VARCHAR(255),
                instr_role VARCHAR(4)
);


CREATE INDEX osu_unit_enrollment_sect_idx
 ON sid.OSU_UNIT_ENROLLMENT
 ( yearQuarterCode, callNumber, campusId, departmentNumber, courseNumber, session_code, acad_group, acad_org, emplid, instr_role );

CREATE TABLE sid.OSU_COURSE (
                id BIGINT NOT NULL,
                departmentNumber VARCHAR(50) NOT NULL,
                courseNumber VARCHAR(10) NOT NULL,
                yearQuarterCode VARCHAR(50) NOT NULL,
                path VARCHAR(255) NOT NULL,
                descr VARCHAR(30),
                course_title_long VARCHAR(100),
                CONSTRAINT osu_course_pk PRIMARY KEY (id)
);


CREATE INDEX osu_course_altkey_idx
 ON sid.OSU_COURSE
 ( departmentNumber, courseNumber, yearQuarterCode );

CREATE TABLE sid.PS_BLDG_TBL (
                BLDG_CD VARCHAR(10) NOT NULL,
                EFFDT TIMESTAMP NOT NULL,
                EFF_STATUS VARCHAR(1) NOT NULL,
                DESCR VARCHAR(30) NOT NULL,
                DESCRSHORT VARCHAR(10) NOT NULL
);


CREATE TABLE sid.OSU_DEPARTMENT (
                id BIGINT NOT NULL,
                abbreviation VARCHAR(50) NOT NULL,
                odsDepartmentNumber VARCHAR(255) NOT NULL,
                fiscalNumber VARCHAR(50),
                Defunct SMALLINT NOT NULL,
                CONSTRAINT osu_department_pk PRIMARY KEY (id)
);


CREATE TABLE sid.sid_users (
                id BIGINT NOT NULL,
                baseRoleId INTEGER NOT NULL,
                userTypeId INTEGER NOT NULL,
                statusId SMALLINT NOT NULL,
                sourceId SMALLINT NOT NULL,
                iid VARCHAR(255) NOT NULL,
                username VARCHAR(255) NOT NULL,
                firstName VARCHAR(255) NOT NULL,
                lastName VARCHAR(255) NOT NULL,
                affiliation VARCHAR(255) NOT NULL,
                password VARCHAR(255),
                multiLdap SMALLINT NOT NULL,
                lockId SMALLINT NOT NULL,
                owner VARCHAR(255),
                emplid VARCHAR(255) NOT NULL,
                createDate TIMESTAMP NOT NULL,
                modifyDate TIMESTAMP,
                userType VARCHAR(255) NOT NULL,
                middleName VARCHAR(255),
                namePrefix VARCHAR(255),
                nameSuffix VARCHAR(255),
                displayName VARCHAR(2000) NOT NULL,
                CONSTRAINT sid_users_pk PRIMARY KEY (id)
);