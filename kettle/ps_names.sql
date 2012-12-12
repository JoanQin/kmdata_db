WITH RecordsBeforeToday (emplid, effdt, eff_status)
AS
(
	-- Get all Active records up to today
	SELECT
		emplid, 
		effdt,
		eff_status
	FROM
		ps_new.PS_NAMES		
	WHERE
		eff_status = 'A'	AND -- Efective status is Active
		effdt <= GETDATE()	AND -- Effective data is today or before (prevents future dating)
		name_type = 'PRI'		-- Record is primary name
)
SELECT
	MAX(RBT.effdt) AS EFFDT
	, U.username
	, PN.EMPLID
	, PN.NAME_TYPE
	, PN.EFFDT
	, PN.EFF_STATUS
	, PN.NAME
	, PN.NAME_PREFIX
	, PN.NAME_SUFFIX
	, PN.NAME_TITLE
	, PN.LAST_NAME
	, PN.FIRST_NAME
	, PN.MIDDLE_NAME	
	, PN.NAME_AC
	, PN.PREF_FIRST_NAME
	, PN.NAME_DISPLAY
	, PN.NAME_FORMAL
	, PN.LASTUPDOPRID
	, U.username AS INST_USERNAME
	, CASE WHEN PD.DT_OF_DEATH IS NULL THEN 0 ELSE 1 END AS DECEASED_IND
FROM
	(
		SELECT 
			MAX(RBTI.effdt) AS EFFDT
			, RBTI.EMPLID
		FROM 
			RecordsBeforeToday RBTI
		GROUP BY 
			RBTI.EMPLID
	) RBT
		INNER JOIN OSU_USER U			ON  U.emplid = RBT.emplid
		INNER JOIN ps_new.PS_NAMES PN	ON  PN.emplid = U.emplid
										AND PN.effdt = RBT.effdt
										AND	PN.emplid = RBT.emplid
		LEFT JOIN ps_new.PS_PERSONAL_DATA PD	ON PN.emplid = PD.EMPLID
GROUP BY
	-- a bunch of columns you can write out
	U.username
	, PN.EMPLID
	, PN.NAME_TYPE
	, PN.EFFDT
	, PN.EFF_STATUS
	, PN.NAME
	, PN.NAME_PREFIX
	, PN.NAME_SUFFIX
	, PN.NAME_TITLE
	, PN.LAST_NAME
	, PN.FIRST_NAME
	, PN.MIDDLE_NAME	
	, PN.NAME_AC
	, PN.PREF_FIRST_NAME
	, PN.NAME_DISPLAY
	, PN.NAME_FORMAL
	, PN.LASTUPDOPRID
	, CASE WHEN PD.DT_OF_DEATH IS NULL THEN 0 ELSE 1 END