SELECT
      COALESCE(b.[chvCKMRefID], a.[chvKMDataUUID]) AS chvCKMRefID
      ,a.[chvFirstName]
      ,a.[chvMiddleName]
      ,a.[chvLastName]
      ,a.[chvPrefix]
      ,a.[chvSuffix]
      ,a.[chvDisplayName]
      ,a.[chvKerbID]
      ,a.[chvCKMUsername]
      ,a.[chvCKMPassword]
      ,COALESCE(a.[chvWho], 'FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF') AS chvWho
      ,a.[dtmWhen]
      ,CAST(a.[bitGuest] AS BIGINT) AS bitGuest
      ,CAST(a.[bitActive] AS BIGINT) AS bitActive
      ,COALESCE(a.[dtmLastLogin], CONVERT(DATETIME, '1-1-1900')) AS dtmLastLogin
      ,a.[intAppForward]
      ,a.[chvEmplid]
FROM dbo.KMData_Users_Feed a
LEFT JOIN dbo.Pro_UserCRef_Ids b ON a.chvEmplid = b.chvSourceIDValue
WHERE a.chvCKMUsername IN
(
SELECT km.chvCKMUsername
FROM dbo.KMData_Users_Feed km
EXCEPT
SELECT un.chvCKMUsername
FROM dbo.User_Names un
)
AND b.[chvCKMRefID] IS NOT NULL
ORDER BY chvCKMUsername

