-- Count of Sage users
SELECT COUNT(DISTINCT PRINCIPAL_ID) FROM VIEW_SAGE_USERS;


-- Count of non-Sage users
SELECT COUNT(DISTINCT PRINCIPAL_ID) FROM VIEW_NON_SAGE_USERS;


-- Count of all users
SELECT COUNT(DISTINCT ID) FROM JDOUSERGROUP WHERE ISINDIVIDUAL IS TRUE;


-- Count of Sage users registered during this audit quarter
SELECT
    COUNT(DISTINCT PRINCIPAL_ID)
FROM
    VIEW_SAGE_USERS
WHERE
    CREATED_ON > '2013-11-01 00:00:00' AND
    CREATED_ON < '2014-02-01 00:00:00';


-- Count of non-Sage users registered during this audit quarter
SELECT
    COUNT(DISTINCT PRINCIPAL_ID)
FROM
    VIEW_NON_SAGE_USERS
WHERE
    CREATED_ON > '2013-11-01 00:00:00' AND
    CREATED_ON < '2014-02-01 00:00:00';


-- Count of active non-Sage users during this audit quarter


-- Count of active users during this audit quarter

