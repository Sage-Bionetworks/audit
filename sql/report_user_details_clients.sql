-- Clients that selected users used
-- users_details_clients.csv
SELECT
    NSU.ID AS USER_ID,
    NSU.EMAIL AS USER_EMAIL,
    AR.USER_AGENT AS CLIENT,
    COUNT(DISTINCT AR.SESSION) AS SESSION_COUNT
FROM
    AUDIT_ACCESS_RECORDS AR,
    AUDIT_NON_SAGE_USERS NSU
WHERE
    AR.USER_ID = NSU.ID AND
    AR.USER_ID IN (1586613, 3319668, 3321844, 3319406, 3321882, 3323064, 3320967, 3322446)
GROUP BY
    USER_ID,
    USER_EMAIL,
    CLIENT
ORDER BY
    USER_ID,
    SESSION_COUNT DESC;
