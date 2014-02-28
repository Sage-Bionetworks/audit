-- Top public projects
-- 8 minutes
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
-- 9 minutes
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


-- Top public file downloads
-- 12 minutes
SELECT
    PN.ID,
    PN.NAME,
    COUNT(DISTINCT AR.SESSION) AS SESSION_COUNT
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
    AR.URI REGEXP '^/repo/v1/entity/syn[0-9]+/.*/file$'
GROUP BY
    PN.ID,
    PN.NAME
ORDER BY
    SESSION_COUNT DESC;

-- Top public file downloads by non-Sage users
-- 12 minutes
SELECT
    PN.ID,
    PN.NAME,
    COUNT(DISTINCT AR.SESSION) AS SESSION_COUNT
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
    AR.URI REGEXP '^/repo/v1/entity/syn[0-9]+/.*/file$'
GROUP BY
    PN.ID,
    PN.NAME
ORDER BY
    SESSION_COUNT DESC;