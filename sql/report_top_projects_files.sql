-- Top public projects
-- top_public_projects_current_audit_period.csv
SELECT
    PN.ID,
    PN.NAME,
    COUNT(DISTINCT AR.SESSION) AS SESSION_COUNT
FROM
    AUDIT_PUBLIC_NODES PN
INNER JOIN
    AUDIT_ACCESS_RECORDS AR
ON
    PN.ID = AR.ENTITY_ID AND PN.TYPE = 2 -- project
GROUP BY
    PN.ID,
    PN.NAME
ORDER BY
    COUNT(DISTINCT AR.SESSION) DESC;


-- Top public projects accessed by non-Sage users
-- top_public_projects_non_sage_current_audit_period.csv
SELECT
    PN.ID,
    PN.NAME,
    COUNT(DISTINCT AR.SESSION) AS SESSION_COUNT
FROM
    AUDIT_PUBLIC_NODES PN
INNER JOIN
    AUDIT_ACCESS_RECORDS AR
ON
    PN.ID = AR.ENTITY_ID AND PN.TYPE = 2 -- project
INNER JOIN
    AUDIT_NON_SAGE_USERS NSU
ON
    AR.USER_ID = NSU.ID
GROUP BY
    PN.ID,
    PN.NAME
ORDER BY
    SESSION_COUNT DESC;


-- Top public projects accessed by Sage users
-- top_public_projects_sage_current_audit_period.csv
SELECT
    PN.ID,
    PN.NAME,
    COUNT(DISTINCT AR.SESSION) AS SESSION_COUNT
FROM
    AUDIT_PUBLIC_NODES PN
INNER JOIN
    AUDIT_ACCESS_RECORDS AR
ON
    PN.ID = AR.ENTITY_ID AND PN.TYPE = 2 -- project
INNER JOIN
    AUDIT_SAGE_USERS SU
ON
    AR.USER_ID = SU.ID
GROUP BY
    PN.ID,
    PN.NAME
ORDER BY
    SESSION_COUNT DESC;


-- Top public file downloads
-- top_public_file_downloads_current_audit_period.csv
SELECT
    PN.ID,
    PN.NAME,
    COUNT(DISTINCT AR.SESSION) AS SESSION_COUNT,
    PN.ID IN (SELECT ID FROM AUDIT_CONTROLLED) AS CONTROLLED,
    PN.ID IN (SELECT ID FROM AUDIT_RESTRICTED) AS RESTRICTED
FROM
    AUDIT_PUBLIC_NODES PN
INNER JOIN
    AUDIT_ACCESS_RECORDS AR
ON
    PN.ID = AR.ENTITY_ID AND PN.TYPE = 16 -- file
WHERE
    AR.METHOD = 'GET' AND
    -- File download
    -- /repo/v1/entity/{id}/file
    -- /repo/v1/entity/{id}/version/{ver}/file
    AR.URI REGEXP '^/repo/v1/entity/syn[0-9]+(/version/[0-9]+)?/file$'
GROUP BY
    PN.ID,
    PN.NAME
ORDER BY
    SESSION_COUNT DESC;


-- Top public file downloads by non-Sage users
-- top_public_file_downloads_non_sage_current_audit_period.csv
SELECT
    PN.ID,
    PN.NAME,
    COUNT(DISTINCT AR.SESSION) AS SESSION_COUNT,
    PN.ID IN (SELECT ID FROM AUDIT_CONTROLLED) AS CONTROLLED,
    PN.ID IN (SELECT ID FROM AUDIT_RESTRICTED) AS RESTRICTED
FROM
    AUDIT_PUBLIC_NODES PN
INNER JOIN
    AUDIT_ACCESS_RECORDS AR
ON
    PN.ID = AR.ENTITY_ID AND PN.TYPE = 16 -- file
INNER JOIN
    AUDIT_NON_SAGE_USERS NSU
ON
    AR.USER_ID = NSU.ID
WHERE
    AR.METHOD = 'GET' AND
    -- File download
    -- /repo/v1/entity/{id}/file
    -- /repo/v1/entity/{id}/version/{ver}/file
    AR.URI REGEXP '^/repo/v1/entity/syn[0-9]+(/version/[0-9]+)?/file$'
GROUP BY
    PN.ID,
    PN.NAME
ORDER BY
    SESSION_COUNT DESC;


-- Top public file downloads by Sage users
-- top_public_file_downloads_sage_current_audit_period.csv
SELECT
    PN.ID,
    PN.NAME,
    COUNT(DISTINCT AR.SESSION) AS SESSION_COUNT,
    PN.ID IN (SELECT ID FROM AUDIT_CONTROLLED) AS CONTROLLED,
    PN.ID IN (SELECT ID FROM AUDIT_RESTRICTED) AS RESTRICTED
FROM
    AUDIT_PUBLIC_NODES PN
INNER JOIN
    AUDIT_ACCESS_RECORDS AR
ON
    PN.ID = AR.ENTITY_ID AND PN.TYPE = 16 -- file
INNER JOIN
    AUDIT_SAGE_USERS SU
ON
    AR.USER_ID = SU.ID
WHERE
    AR.METHOD = 'GET' AND
    -- File download
    -- /repo/v1/entity/{id}/file
    -- /repo/v1/entity/{id}/version/{ver}/file
    AR.URI REGEXP '^/repo/v1/entity/syn[0-9]+(/version/[0-9]+)?/file$'
GROUP BY
    PN.ID,
    PN.NAME
ORDER BY
    SESSION_COUNT DESC;
