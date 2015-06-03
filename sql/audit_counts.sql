CREATE TABLE AUDIT_INPUT_DATA (
    VAR_NAME VARCHAR(40),
    DESCRIPTION VARCHAR(256),
    AUDIT_2014_11 BIGINT,
    AUDIT_2015_02 BIGINT
);

LOAD DATA LOCAL INFILE
    '/Users/kimyen/Documents/Sage/audit_2015_02/audit_input_data.csv' 
INTO TABLE
    AUDIT_INPUT_DATA
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n' 
IGNORE 1 LINES (
    VAR_NAME,
    AUDIT_2014_11,
    DESCRIPTION
);

-- AUDIT_PUBLIC_FILES
-- Count of public files during this audit period
UPDATE 
    AUDIT_INPUT_DATA
SET 
    AUDIT_2015_02 = (
SELECT
    COUNT(DISTINCT ID)
FROM
    AUDIT_PUBLIC_NODES NODES
WHERE
    TYPE = 'file' AND
    CREATED_ON > '2014-11-01 00:00:00' AND
    CREATED_ON < '2015-02-01 00:00:00'
    AND NODES.CREATED_BY NOT IN (SELECT ID FROM AUDIT_DAEMON_USERS)
    AND NODES.CREATED_BY NOT IN (SELECT ID FROM AUDIT_TEST_USERS)
)
WHERE
    VAR_NAME = "AUDIT_PUBLIC_FILES";

-- AUDIT_NONSAGE_PUBLIC_FILES
-- Count of public files created by non-Sage users during this audit period

UPDATE 
    AUDIT_INPUT_DATA
SET 
    AUDIT_2015_02 = (
SELECT
    COUNT(DISTINCT NODES.ID)
FROM
    AUDIT_PUBLIC_NODES NODES,
    AUDIT_NON_SAGE_USERS USERS
WHERE
    NODES.CREATED_BY = USERS.ID AND
    NODES.TYPE = 'file' AND
    NODES.CREATED_ON > '2014-11-01 00:00:00' AND
    NODES.CREATED_ON < '2015-02-01 00:00:00'
)
WHERE
    VAR_NAME = "AUDIT_NONSAGE_PUBLIC_FILES";

-- AUDIT_SAGE_PUBLIC_FILES
-- Count of public files created by Sage users during this audit period

UPDATE 
    AUDIT_INPUT_DATA
SET 
    AUDIT_2015_02 = (
SELECT
    COUNT(DISTINCT NODES.ID)
FROM
    AUDIT_PUBLIC_NODES NODES,
    AUDIT_SAGE_USERS USERS
WHERE
    NODES.CREATED_BY = USERS.ID AND
    NODES.TYPE = 'file' AND
    NODES.CREATED_ON > '2014-11-01 00:00:00' AND
    NODES.CREATED_ON < '2015-02-01 00:00:00'
)
WHERE
    VAR_NAME = "AUDIT_SAGE_PUBLIC_FILES";

-- AUDIT_PRIVATE_FILES
-- Count of non-public files during this audit period

UPDATE 
    AUDIT_INPUT_DATA
SET 
    AUDIT_2015_02 = (
SELECT
    COUNT(DISTINCT ID)
FROM
    AUDIT_NON_PUBLIC_NODES NODES
WHERE
    TYPE = 'file' AND
    CREATED_ON > '2014-11-01 00:00:00' AND
    CREATED_ON < '2015-02-01 00:00:00'
    AND NODES.CREATED_BY NOT IN (SELECT ID FROM AUDIT_DAEMON_USERS)
    AND NODES.CREATED_BY NOT IN (SELECT ID FROM AUDIT_TEST_USERS)
)
WHERE
    VAR_NAME = "AUDIT_PRIVATE_FILES";

-- AUDIT_NONSAGE_PRIVATE_FILES
-- Count of non-public files created by non-Sage users during this audit period

UPDATE 
    AUDIT_INPUT_DATA
SET 
    AUDIT_2015_02 = (
SELECT
    COUNT(DISTINCT NODES.ID)
FROM
    AUDIT_NON_PUBLIC_NODES NODES,
    AUDIT_NON_SAGE_USERS USERS
WHERE
    NODES.CREATED_BY = USERS.ID AND
    NODES.TYPE = 'file' AND
    NODES.CREATED_ON > '2014-11-01 00:00:00' AND
    NODES.CREATED_ON < '2015-02-01 00:00:00'
)
WHERE
    VAR_NAME = "AUDIT_NONSAGE_PRIVATE_FILES";

-- AUDIT_SAGE_PRIVATE_FILES
-- Count of non-public files created by Sage users during this audit period

UPDATE 
    AUDIT_INPUT_DATA
SET 
    AUDIT_2015_02 = (
SELECT
    COUNT(DISTINCT NODES.ID)
FROM
    AUDIT_NON_PUBLIC_NODES NODES,
    AUDIT_SAGE_USERS USERS
WHERE
    NODES.CREATED_BY = USERS.ID AND
    NODES.TYPE = 'file' AND
    NODES.CREATED_ON > '2014-11-01 00:00:00' AND
    NODES.CREATED_ON < '2015-02-01 00:00:00'
)
WHERE
    VAR_NAME = "AUDIT_SAGE_PRIVATE_FILES";

-- PUBLIC_FILES
-- Count of public files

UPDATE 
    AUDIT_INPUT_DATA
SET 
    AUDIT_2015_02 = (
SELECT
    COUNT(DISTINCT ID)
FROM
    AUDIT_PUBLIC_NODES NODES
WHERE
    TYPE = 'file'
    AND NODES.CREATED_BY NOT IN (SELECT ID FROM AUDIT_DAEMON_USERS)
    AND NODES.CREATED_BY NOT IN (SELECT ID FROM AUDIT_TEST_USERS)
)
WHERE
    VAR_NAME = "PUBLIC_FILES";

-- NONSAGE_PUBLIC_FILES
-- Count of public files created by non-Sage users

UPDATE 
    AUDIT_INPUT_DATA
SET 
    AUDIT_2015_02 = (
SELECT
    COUNT(DISTINCT NODES.ID)
FROM
    AUDIT_PUBLIC_NODES NODES,
    AUDIT_NON_SAGE_USERS USERS
WHERE
    NODES.CREATED_BY = USERS.ID AND
    NODES.TYPE = 'file'
)
WHERE
    VAR_NAME = "NONSAGE_PUBLIC_FILES";

-- SAGE_PUBLIC_FILES
-- Count of public files created by Sage users

UPDATE 
    AUDIT_INPUT_DATA
SET 
    AUDIT_2015_02 = (
SELECT
    COUNT(DISTINCT NODES.ID)
FROM
    AUDIT_PUBLIC_NODES NODES,
    AUDIT_SAGE_USERS USERS
WHERE
    NODES.CREATED_BY = USERS.ID AND
    NODES.TYPE = 'file'
)
WHERE
    VAR_NAME = "SAGE_PUBLIC_FILES";

-- PRIVATE_FILES
-- Count of non-public files

UPDATE 
    AUDIT_INPUT_DATA
SET 
    AUDIT_2015_02 = (
SELECT
    COUNT(DISTINCT ID)
FROM
    AUDIT_NON_PUBLIC_NODES NODES
WHERE
    TYPE = 'file'
    AND NODES.CREATED_BY NOT IN (SELECT ID FROM AUDIT_DAEMON_USERS)
    AND NODES.CREATED_BY NOT IN (SELECT ID FROM AUDIT_TEST_USERS)
)
WHERE
    VAR_NAME = "PRIVATE_FILES";

-- NONSAGE_PRIVATE_FILES
-- Count of non-public files created by non-Sage users

UPDATE 
    AUDIT_INPUT_DATA
SET 
    AUDIT_2015_02 = (
SELECT
    COUNT(DISTINCT NODES.ID)
FROM
    AUDIT_NON_PUBLIC_NODES NODES,
    AUDIT_NON_SAGE_USERS USERS
WHERE
    NODES.CREATED_BY = USERS.ID AND
    NODES.TYPE = 'file'
)
WHERE
    VAR_NAME = "NONSAGE_PRIVATE_FILES";

-- SAGE_PRIVATE_FILES
-- Count of non-public files created by Sage users

UPDATE 
    AUDIT_INPUT_DATA
SET 
    AUDIT_2015_02 = (
SELECT
    COUNT(DISTINCT NODES.ID)
FROM
    AUDIT_NON_PUBLIC_NODES NODES,
    AUDIT_SAGE_USERS USERS
WHERE
    NODES.CREATED_BY = USERS.ID AND
    NODES.TYPE = 'file'
)
WHERE
    VAR_NAME = "SAGE_PRIVATE_FILES";

-- AUDIT_PUBLIC_PROJECTS	
-- Count of public projects

UPDATE 
    AUDIT_INPUT_DATA
SET 
    AUDIT_2015_02 = (
SELECT
    COUNT(DISTINCT ID)
FROM
    AUDIT_PUBLIC_NODES
WHERE
    TYPE = 'project' AND
    CREATED_ON > '2014-11-01 00:00:00' AND
    CREATED_ON < '2015-02-01 00:00:00'
)
WHERE
    VAR_NAME = "AUDIT_PUBLIC_PROJECTS";

-- AUDIT_NONSAGE_PUBLIC_PROJECTS
-- Count of public projects created by non-sage users

UPDATE 
    AUDIT_INPUT_DATA
SET 
    AUDIT_2015_02 = (
SELECT
    COUNT(DISTINCT NODES.ID)
FROM
    AUDIT_PUBLIC_NODES NODES,
    AUDIT_NON_SAGE_USERS USERS
WHERE
    NODES.CREATED_BY = USERS.ID AND
    NODES.TYPE = 'project' AND
    NODES.CREATED_ON > '2014-11-01 00:00:00' AND
    NODES.CREATED_ON < '2015-02-01 00:00:00'
)
WHERE
    VAR_NAME = "AUDIT_NONSAGE_PUBLIC_PROJECTS";

-- AUDIT_SAGE_PUBLIC_PROJECTS
-- Count of public projects created by sage users

UPDATE 
    AUDIT_INPUT_DATA
SET 
    AUDIT_2015_02 = (
SELECT
    COUNT(DISTINCT NODES.ID)
FROM
    AUDIT_PUBLIC_NODES NODES,
    AUDIT_SAGE_USERS USERS
WHERE
    NODES.CREATED_BY = USERS.ID AND
    NODES.TYPE = 'project' AND
    NODES.CREATED_ON > '2014-11-01 00:00:00' AND
    NODES.CREATED_ON < '2015-02-01 00:00:00'
)
WHERE
    VAR_NAME = "AUDIT_SAGE_PUBLIC_PROJECTS";

-- AUDIT_PRIVATE_PROJECTS
-- Count of non-public projects

UPDATE 
    AUDIT_INPUT_DATA
SET 
    AUDIT_2015_02 = (
SELECT
    COUNT(DISTINCT ID)
FROM
    AUDIT_NON_PUBLIC_NODES
WHERE
    TYPE = 'project' AND
    CREATED_ON > '2014-11-01 00:00:00' AND
    CREATED_ON < '2015-02-01 00:00:00'
)
WHERE
    VAR_NAME = "AUDIT_PRIVATE_PROJECTS";

-- AUDIT_NONSAGE_PRIVATE_PROJECTS
-- Count of non-public projects created by non-sage users

UPDATE 
    AUDIT_INPUT_DATA
SET 
    AUDIT_2015_02 = (
SELECT
    COUNT(DISTINCT NODES.ID)
FROM
    AUDIT_NON_PUBLIC_NODES NODES,
    AUDIT_NON_SAGE_USERS USERS
WHERE
    NODES.CREATED_BY = USERS.ID AND
    NODES.TYPE = 'project' AND
    NODES.CREATED_ON > '2014-11-01 00:00:00' AND
    NODES.CREATED_ON < '2015-02-01 00:00:00'
)
WHERE
    VAR_NAME = "AUDIT_NONSAGE_PRIVATE_PROJECTS";

-- 	AUDIT_SAGE_PRIVATE_PROJECTS
-- Count of non-public projects created by sage users

UPDATE 
    AUDIT_INPUT_DATA
SET 
    AUDIT_2015_02 = (
SELECT
    COUNT(DISTINCT NODES.ID)
FROM
    AUDIT_NON_PUBLIC_NODES NODES,
    AUDIT_SAGE_USERS USERS
WHERE
    NODES.CREATED_BY = USERS.ID AND
    NODES.TYPE = 'project' AND
    NODES.CREATED_ON > '2014-11-01 00:00:00' AND
    NODES.CREATED_ON < '2015-02-01 00:00:00'
)
WHERE
    VAR_NAME = "AUDIT_SAGE_PRIVATE_PROJECTS";

-- PUBLIC_PROJECTS
-- Count of public projects

UPDATE 
    AUDIT_INPUT_DATA
SET 
    AUDIT_2015_02 = (
SELECT
    COUNT(DISTINCT ID)
FROM
    AUDIT_PUBLIC_NODES
WHERE
    TYPE = 'project'
)
WHERE
    VAR_NAME = "PUBLIC_PROJECTS";

-- NONSAGE_PUBLIC_PROJECTS
-- Count of public projects created by non-sage users

UPDATE 
    AUDIT_INPUT_DATA
SET 
    AUDIT_2015_02 = (
SELECT
    COUNT(DISTINCT NODES.ID)
FROM
    AUDIT_PUBLIC_NODES NODES,
    AUDIT_NON_SAGE_USERS USERS
WHERE
    NODES.CREATED_BY = USERS.ID AND
    NODES.TYPE = 'project'
)
WHERE
    VAR_NAME = "NONSAGE_PUBLIC_PROJECTS";

-- SAGE_PUBLIC_PROJECTS
-- Count of public projects created by sage users

UPDATE 
    AUDIT_INPUT_DATA
SET 
    AUDIT_2015_02 = (
SELECT
    COUNT(DISTINCT NODES.ID)
FROM
    AUDIT_PUBLIC_NODES NODES,
    AUDIT_SAGE_USERS USERS
WHERE
    NODES.CREATED_BY = USERS.ID AND
    NODES.TYPE = 'project'
)
WHERE
    VAR_NAME = "SAGE_PUBLIC_PROJECTS";

-- PRIVATE_PROJECTS
-- Count of non-public projects

UPDATE 
    AUDIT_INPUT_DATA
SET 
    AUDIT_2015_02 = (
SELECT
    COUNT(DISTINCT ID)
FROM
    AUDIT_NON_PUBLIC_NODES
WHERE
    TYPE = 'project'
)
WHERE
    VAR_NAME = "PRIVATE_PROJECTS";

-- NONSAGE_PRIVATE_PROJECTS
-- Count of non-public projects created by non-sage users

UPDATE 
    AUDIT_INPUT_DATA
SET 
    AUDIT_2015_02 = (
SELECT
    COUNT(DISTINCT NODES.ID)
FROM
    AUDIT_NON_PUBLIC_NODES NODES,
    AUDIT_NON_SAGE_USERS USERS
WHERE
    NODES.CREATED_BY = USERS.ID AND
    NODES.TYPE = 'project'
)
WHERE
    VAR_NAME = "NONSAGE_PRIVATE_PROJECTS";

-- SAGE_PRIVATE_PROJECTS
-- Count of non-public projects created by sage users

UPDATE 
    AUDIT_INPUT_DATA
SET 
    AUDIT_2015_02 = (
SELECT
    COUNT(DISTINCT NODES.ID)
FROM
    AUDIT_NON_PUBLIC_NODES NODES,
    AUDIT_SAGE_USERS USERS
WHERE
    NODES.CREATED_BY = USERS.ID AND
    NODES.TYPE = 'project'
)
WHERE
    VAR_NAME = "SAGE_PRIVATE_PROJECTS";

-- SAGE_USERS
-- Count of Sage users

UPDATE 
    AUDIT_INPUT_DATA
SET 
    AUDIT_2015_02 = (
SELECT COUNT(DISTINCT ID) FROM AUDIT_SAGE_USERS
)
WHERE
    VAR_NAME = "SAGE_USERS";

-- 	NONSAGE_USERS
-- Count of non-Sage users

UPDATE 
    AUDIT_INPUT_DATA
SET 
    AUDIT_2015_02 = (
SELECT COUNT(DISTINCT ID) FROM AUDIT_NON_SAGE_USERS
)
WHERE
    VAR_NAME = "NONSAGE_USERS";

-- ALL_USERS
-- Count of all users

UPDATE 
    AUDIT_INPUT_DATA
SET 
    AUDIT_2015_02 = (
SELECT COUNT(DISTINCT ID) FROM JDOUSERGROUP WHERE ISINDIVIDUAL IS TRUE
)
WHERE
    VAR_NAME = "ALL_USERS";

-- NEW_SAGE
-- Sage users registered during the last audit

UPDATE 
    AUDIT_INPUT_DATA
SET 
    AUDIT_2015_02 = (
SELECT
    COUNT(DISTINCT ID)
FROM
    AUDIT_SAGE_USERS
WHERE
    CREATED_ON > '2014-11-01 00:00:00' AND
    CREATED_ON < '2015-02-01 00:00:00'
)
WHERE
    VAR_NAME = "NEW_SAGE";

-- NEW_NONSAGE
-- Non-Sage users registered during the last audit

UPDATE 
    AUDIT_INPUT_DATA
SET 
    AUDIT_2015_02 = (
SELECT
    COUNT(DISTINCT ID)
FROM
    AUDIT_NON_SAGE_USERS
WHERE
    CREATED_ON > '2014-11-01 00:00:00' AND
    CREATED_ON < '2015-02-01 00:00:00'
)
WHERE
    VAR_NAME = "NEW_NONSAGE";

-- OUTPUT FILE
-- AUDIT_INPUT_DATA.csv
SELECT * FROM AUDIT_INPUT_DATA;

-- user_counts_by_email_domains.csv
-- Count of non-Sage users by email domain
SELECT
    SUBSTRING(EMAIL, INSTR(EMAIL, '@')) AS DOMAIN,
    COUNT(ID)
FROM
    AUDIT_NON_SAGE_USERS
GROUP BY
    DOMAIN
ORDER BY
    COUNT(ID) DESC;
