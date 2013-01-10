SELECT [idmid]
      ,[emplid]
      ,[username]
      ,[firstName]
      ,[lastName]
      ,[affiliation]
      ,[owner]
      ,[emailAddress]
      ,[owner_org_descr]
      ,[primary_college]
      ,[primary_department]
      ,[idmCreateDate]
      ,[idmModifyDate]
      ,[owner_org_code]
      ,[old_iid]
      ,[middleName]
      ,[FERPA_flag]
  FROM [IDM].[dbo].[OSU_USER]
WHERE 
--username = 'wilkins.8'
emplid = '06169467'

