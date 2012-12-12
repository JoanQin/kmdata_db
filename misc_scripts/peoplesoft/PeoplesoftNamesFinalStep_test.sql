SELECT *
FROM dbo.User_Names
WHERE [chvCKMRefID] = '3fcea5b0-c1cf-11e0-8c9b-005056b749ba'

SELECT * FROM dbo.Pro_UserCRef_Ids where chvCKMRefID = '3fcea5b0-c1cf-11e0-8c9b-005056b749ba'

SELECT *
FROM dbo.User_Names
WHERE [chvCKMRefID] = 'FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF'

SELECT *
FROM dbo.Pro_UserCRef_Ids
WHERE chvCKMRefID = '05c0ff0e-a414-11e0-b27c-005056b749ba'

select * from dbo.Pro_UserCRef_Ids where chvSourceIDValue = '200204791'

SELECT *
FROM dbo.User_Names
WHERE [chvCKMUsername] = 'lockwood.59'

SELECT *
FROM dbo.KMData_Users_Feed
WHERE [chvCKMUsername] = 'kegler.11'

SELECT COUNT(*) FROM dbo.KMData_Users_Feed

TRUNCATE TABLE dbo.KMData_Users_Feed

SELECT *
INTO dbo.User_Names_preKMData2
FROM dbo.User_Names

SELECT *
INTO dbo.Pro_UserCRef_Ids_preKMData2
FROM dbo.Pro_UserCRef_Ids

SELECT COUNT(*) FROM dbo.Pro_UserCRef_Ids -- post: 547862; PROD: 
SELECT COUNT(*) FROM dbo.Pro_UserCRef_Ids_preKMData -- 319396; PROD: 321291


SELECT COUNT(*) FROM dbo.User_Names
-- pre-import: 400148; PROD: 425035
-- post-import: 628615; PROD: 

SELECT COUNT(*) FROM dbo.User_Names_preKMData -- PROD: 425035

SELECT CONVERT(DATETIME, '1-1-1900')


SELECT * FROM dbo.User_Names WHERE chvCKMRefID = '01586D77-0E9C-4222-A937-E95A8458DA6C'

SELECT TOP 100 * FROM dbo.KMData_Users_Feed;
