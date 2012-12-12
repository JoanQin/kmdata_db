SELECT DISTINCT
  a.yearQuarterCode
, a.checkDigit
, a.callNumber
, CONVERT(SMALLINT, a.gradeAuthority) AS gradeAuthority
, a.instructor
, a.building
, a.room
, a.startTime
, a.endTime
, d.yearQuarterCode AS offeringYearQuarterCode
, d.callNumber AS offeringCallNumber
, d.campusId
, d.departmentNumber
, d.courseNumber
, pscl.SESSION_CODE
, pscl.ACAD_GROUP
, psco.ACAD_ORG
, mtg.MON
, mtg.TUES
, mtg.WED
, mtg.THURS
, mtg.FRI
, mtg.SAT
, mtg.SUN
, mtg.START_DT
, mtg.END_DT
, mtg.MEETING_TIME_START
, mtg.MEETING_TIME_END
, mtg.FACILITY_ID
FROM dbo.OSU_SECTION a
INNER JOIN dbo.OSU_UNIT a2 ON a.id = a2.id
INNER JOIN dbo.OSU_UNIT_ASSOCIATION_TYPE b ON b.description = 'Offering Sections' AND a2.unitTypeId = b.childUnitTypeId
INNER JOIN dbo.OSU_UNIT_ASSOCIATION c ON b.childUnitTypeId = c.childUnitTypeId AND b.parentUnitTypeId = c.parentUnitTypeId AND a2.id = childUnitId
INNER JOIN dbo.OSU_OFFERING d ON c.parentUnitId = d.id
INNER JOIN ps_new.PS_CLASS_TBL pscl ON d.departmentNumber = pscl.SUBJECT 
	AND d.courseNumber = pscl.CATALOG_NBR 
	AND d.campusId = pscl.LOCATION 
	AND LTRIM(RTRIM(a.yearQuarterCode)) = LTRIM(RTRIM(pscl.STRM))
	AND LTRIM(RTRIM(a.callNumber)) = LTRIM(RTRIM(pscl.CLASS_NBR))
INNER JOIN ps_new.vwPS_CRSE_OFFER psco ON pscl.CRSE_ID = psco.CRSE_ID
    AND pscl.CRSE_OFFER_NBR = psco.CRSE_OFFER_NBR
INNER JOIN ps_new.PS_CLASS_MTG_PAT mtg ON pscl.STRM = mtg.STRM
	AND pscl.SESSION_CODE = mtg.SESSION_CODE
	AND pscl.CRSE_ID = mtg.CRSE_ID
	AND pscl.CRSE_OFFER_NBR = mtg.CRSE_OFFER_NBR
	AND pscl.CLASS_SECTION = mtg.CLASS_SECTION
	AND a.checkDigit = ISNULL(CAST( mtg.CLASS_MTG_NBR AS VARCHAR ),'UNKNOWN')
--	AND a.checkDigit = mtg.CLASS_MTG_NBR