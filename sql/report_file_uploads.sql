-- Public files uploaded by non-sage users during the last audit quarter
SELECT DISTINCT
    FILES.ID AS FILE_ID,
    FILES.NAME AS FILE_NAME,
    FILES.CREATED_ON AS FILE_CREATED_ON,
    NON_SAGE_USERS.EMAIL AS FILE_CREATED_BY,
    FILES.PROJECT_ID AS PROJECT_ID,
    PROJ_NODES.NAME AS PROJECT_NAME,
    PROJ_NODES.ID IN (SELECT ID FROM VIEW_PUBLIC_NODES) AS IS_PROJECT_PUBLIC,
    PA.ALIAS_DISPLAY AS PROJECT_CREATED_BY
FROM
    VIEW_FILES FILES
    JOIN VIEW_PUBLIC_NODES FILE_NODES ON FILES.ID = FILE_NODES.ID
    JOIN JDONODES PROJ_NODES ON FILES.PROJECT_ID = PROJ_NODES.ID
    JOIN VIEW_NON_SAGE_USERS NON_SAGE_USERS ON FILES.CREATED_BY = NON_SAGE_USERS.PRINCIPAL_ID
    JOIN JDOUSERGROUP UG ON PROJ_NODES.CREATED_BY = UG.ID
    JOIN PRINCIPAL_ALIAS PA ON UG.ID = PA.PRINCIPAL_ID 
WHERE
    PA.TYPE = 'USER_EMAIL' AND
    FILES.CREATED_ON > 1383289200000 AND -- 2013-11-01 00:00:00 PST
    FILES.CREATED_ON < 1391241600000;    -- 2014-02-01 00:00:00 PST
