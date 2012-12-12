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
, psd.CAMPUS_ID
FROM SYSADM.PS_NAMES pso
LEFT JOIN SYSADM.PS_PERSONAL_DATA psd ON pso.EMPLID = psd.EMPLID
WHERE EXISTS (
  SELECT MAX(psi.effdt), psi.emplid
  FROM sysadm.ps_names psi
  WHERE pso.emplid = psi.emplid
  AND psi.name_type = 'PRI'
  GROUP BY psi.emplid
  HAVING pso.effdt = max(psi.effdt)
)