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
FROM dbo.OSU_SECTION a
INNER JOIN dbo.OSU_UNIT a2 ON a.id = a2.id
INNER JOIN dbo.OSU_UNIT_ASSOCIATION_TYPE b ON b.description = 'Offering Sections' AND a2.unitTypeId = b.childUnitTypeId
INNER JOIN dbo.OSU_UNIT_ASSOCIATION c ON b.childUnitTypeId = c.childUnitTypeId AND b.parentUnitTypeId = c.parentUnitTypeId AND a2.id = childUnitId
INNER JOIN dbo.OSU_OFFERING d ON c.parentUnitId = d.id
INNER JOIN ps_new.PS_CLASS_TBL pscl ON d.departmentNumber = pscl.SUBJECT 
	AND d.courseNumber = pscl.CATALOG_NBR 
	AND d.campusId = pscl.LOCATION 
	AND d.yearQuarterCode = pscl.STRM


SELECT COUNT(*) FROM dbo.OSU_SECTION
SELECT COUNT(*) FROM dbo.OSU_OFFERING

SELECT COUNT(*) FROM (SELECT DISTINCT callNumber, yearQuarterCode FROM dbo.OSU_SECTION) subq
SELECT COUNT(*) FROM (SELECT DISTINCT callNumber, yearQuarterCode FROM dbo.OSU_OFFERING) subq

