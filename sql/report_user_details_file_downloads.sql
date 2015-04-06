-- File downloads of selected users
-- user_details_file_downloads.csv
SELECT
    NSU.ID AS USER_ID,
    NSU.EMAIL AS USER_EMAIL,
    FILES.ID AS FILE_ID,
    FILES.NAME AS FILE_NAME,
    COUNT(DISTINCT AR.SESSION) AS SESSION_COUNT,
    FILES.ID IN (SELECT ID FROM AUDIT_CONTROLLED) AS CONTROLLED,
    FILES.ID IN (SELECT ID FROM AUDIT_RESTRICTED) AS RESTRICTED
FROM
    AUDIT_ACCESS_RECORDS AR,
    AUDIT_NON_SAGE_USERS NSU,
    AUDIT_FILES FILES
WHERE
    AR.USER_ID = NSU.ID AND
    AR.ENTITY_ID = FILES.ID AND
    AR.USER_ID IN (1586613, 3319668, 3321844, 3319406, 3321882, 3323064, 3320967, 3322446) AND
    AR.METHOD = 'GET' AND
    AR.URI REGEXP '^/repo/v1/entity/syn[0-9]+(/version/[0-9]+)?/file$'
GROUP BY
    USER_ID,
    USER_EMAIL,
    FILE_ID,
    FILE_NAME
ORDER BY
    USER_ID,
    SESSION_COUNT DESC;
