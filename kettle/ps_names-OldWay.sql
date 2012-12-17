-- Oracle
SELECT
  pso.EMPLID
, pso.NAME_TYPE
, pso.EFFDT
, pso.EFF_STATUS
, pso.COUNTRY_NM_FORMAT
, pso.NAME
, pso.NAME_INITIALS
, pso.NAME_PREFIX
, pso.NAME_SUFFIX
, pso.NAME_ROYAL_PREFIX
, pso.NAME_ROYAL_SUFFIX
, pso.NAME_TITLE
, pso.LAST_NAME
, pso.FIRST_NAME
, pso.MIDDLE_NAME
, pso.SECOND_LAST_NAME
, pso.NAME_AC
, pso.PREF_FIRST_NAME
, pso.PARTNER_LAST_NAME
, pso.PARTNER_ROY_PREFIX
, pso.LAST_NAME_PREF_NLD
, pso.NAME_DISPLAY
, pso.NAME_FORMAL
, pso.LASTUPDDTTM
, pso.LASTUPDOPRID
, NVL(TRIM(REPLACE(pse.EMAIL_ADDR, '@osu.edu', '')), TRIM(psd.CAMPUS_ID)) AS INST_USERNAME
, CASE WHEN psd.DT_OF_DEATH IS NULL THEN 0 ELSE 1 END AS DECEASED_IND
FROM SYSADM.PS_NAMES pso
LEFT JOIN SYSADM.PS_EMAIL_ADDRESSES pse ON pso.EMPLID = pse.EMPLID AND pse.E_ADDR_TYPE = 'CAMP'
LEFT JOIN SYSADM.PS_PERSONAL_DATA psd ON pso.EMPLID = psd.EMPLID
WHERE EXISTS (
  SELECT MAX(psi.effdt), psi.emplid
  FROM sysadm.ps_names psi
  WHERE pso.emplid = psi.emplid
  AND psi.name_type = 'PRI'
  GROUP BY psi.emplid
  HAVING pso.effdt = max(psi.effdt)
)