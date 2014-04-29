-- Internal Sage users
CREATE TABLE AUDIT_SAGE_USERS AS
SELECT DISTINCT
    UG.ID AS ID,
    UG.CREATION_DATE AS CREATED_ON,
    GROUP_CONCAT(DISTINCT PA.ALIAS_DISPLAY SEPARATOR ';') AS EMAIL
FROM
    JDOUSERGROUP UG
    JOIN PRINCIPAL_ALIAS PA ON UG.ID = PA.PRINCIPAL_ID
    -- Some users, like 'anonymous@sageabase.org', are not associated with any group, thus the left outer join
    LEFT JOIN GROUP_MEMBERS GM ON UG.ID = GM.MEMBER_ID 
WHERE
    UG.ISINDIVIDUAL IS TRUE AND
    PA.TYPE = 'USER_EMAIL' AND (
        GM.GROUP_ID = 273957 OR -- The Sage Employee Team
        GM.GROUP_ID = 2 OR      -- The Administrators Team
        PA.ALIAS_DISPLAY IN (

        ) OR -- Remember to include the list!!!
        PA.ALIAS_DISPLAY LIKE '%@sagebase.org' OR
        PA.ALIAS_DISPLAY LIKE '%@jayhodgson.com' OR
        PA.ALIAS_DISPLAY LIKE '%@sharklasers.com')
GROUP BY
    UG.ID,
    UG.CREATION_DATE;

ALTER TABLE AUDIT_SAGE_USERS ADD INDEX USING HASH (ID);

-- Non-Sage users
CREATE TABLE AUDIT_NON_SAGE_USERS AS
SELECT
    UG.ID AS ID,
    UG.CREATION_DATE AS CREATED_ON,
    GROUP_CONCAT(DISTINCT PA.ALIAS_DISPLAY SEPARATOR '; ') AS EMAIL
FROM
    JDOUSERGROUP UG,
    PRINCIPAL_ALIAS PA
WHERE
    UG.ID = PA.PRINCIPAL_ID AND
    UG.ISINDIVIDUAL = true AND
    PA.TYPE = 'USER_EMAIL' AND
    UG.ID NOT IN(
        SELECT ID FROM AUDIT_SAGE_USERS
    )
GROUP BY
    UG.ID,
    UG.CREATION_DATE;

ALTER TABLE AUDIT_NON_SAGE_USERS ADD INDEX USING HASH (ID);

-- Unit tests
SELECT CONCAT(CASE WHEN
    (SELECT COUNT(DISTINCT ID) FROM AUDIT_SAGE_USERS WHERE EMAIL NOT LIKE '%@sagebase.org') > 25
    THEN 'PASSED' ELSE 'FAILED' END,
    ' -- Sage users hould include some non-sagebase emails. Do not forget to include the list.');

SELECT CONCAT(CASE WHEN
    (SELECT COUNT(ID) FROM AUDIT_NON_SAGE_USERS WHERE EMAIL LIKE '%@sagebase.org') = 0
    THEN 'PASSED' ELSE 'FAILED' END,
    ' -- Non-Sage users should not have any @sagebase.org emails.');