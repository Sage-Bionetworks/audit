-- All the individual users
CREATE TABLE AUDIT_USERS AS
SELECT DISTINCT
    UG.ID AS ID,
    UG.CREATION_DATE AS CREATED_ON,
    GROUP_CONCAT(DISTINCT PA.ALIAS_DISPLAY SEPARATOR ';') AS EMAIL
FROM
    JDOUSERGROUP UG
    JOIN PRINCIPAL_ALIAS PA ON UG.ID = PA.PRINCIPAL_ID
WHERE
    UG.ISINDIVIDUAL IS TRUE AND
    PA.TYPE = 'USER_EMAIL'
GROUP BY
    UG.ID,
    UG.CREATION_DATE;

ALTER TABLE AUDIT_USERS ADD INDEX USING HASH (ID);

SELECT CONCAT(CASE WHEN
    (SELECT COUNT(DISTINCT ID) FROM AUDIT_USERS) > 4000
    THEN 'PASSED' ELSE 'FAILED' END,
    ' -- Should have at least 4000 users.');



-- Current Sage employees
CREATE TABLE AUDIT_SAGE_USERS (
    ID BIGINT NOT NULL PRIMARY KEY,
    CREATED_ON DATETIME,
    EMAIL VARCHAR(256)
);

LOAD DATA LOCAL INFILE
    '/Users/ewu/Documents/logs/audit-2014-05/sage-users.csv' 
INTO TABLE
    AUDIT_SAGE_USERS
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES (
    ID,
    EMAIL
);

UPDATE AUDIT_SAGE_USERS ASU SET CREATED_ON = (
    SELECT CREATED_ON
    FROM AUDIT_USERS AU
    WHERE AU.ID = ASU.ID AND INSTR(LCASE(AU.EMAIL), LCASE(ASU.EMAIL)) > 0
);

SELECT CONCAT(CASE WHEN
    (SELECT COUNT(DISTINCT ID) FROM AUDIT_SAGE_USERS) > 30
    THEN 'PASSED' ELSE 'FAILED' END,
    ' -- Should have at least 30 Sag employees.');

SELECT CONCAT(CASE WHEN
    (SELECT COUNT(DISTINCT ID) FROM AUDIT_SAGE_USERS WHERE CREATED_ON IS NULL) = 0
    THEN 'PASSED' ELSE 'FAILED' END,
    ' -- Should match what are in the Synapse database and set the CREATED_ON field.');



-- User accounts used mainly for testing
CREATE TABLE AUDIT_TEST_USERS (
    ID BIGINT NOT NULL PRIMARY KEY,
    CREATED_ON DATETIME,
    EMAIL VARCHAR(256)
);

LOAD DATA LOCAL INFILE
    '/Users/ewu/Documents/logs/audit-2014-05/test-users.csv' 
INTO TABLE
    AUDIT_TEST_USERS
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES (
    ID,
    EMAIL
);

UPDATE AUDIT_TEST_USERS ATU SET CREATED_ON = (
    SELECT CREATED_ON
    FROM AUDIT_USERS AU
    WHERE AU.ID = ATU.ID AND INSTR(LCASE(AU.EMAIL), LCASE(ATU.EMAIL)) > 0
);

INSERT INTO
    AUDIT_TEST_USERS (
        ID,
        CREATED_ON,
        EMAIL)
SELECT
    ID,
    CREATED_ON,
    EMAIL
FROM
    AUDIT_USERS
WHERE
    EMAIL LIKE '%@jayhodgson.com' OR
    EMAIL LIKE '%@sharklasers.com';

SELECT CONCAT(CASE WHEN
    (SELECT COUNT(DISTINCT ID) FROM AUDIT_TEST_USERS) > 20
    THEN 'PASSED' ELSE 'FAILED' END,
    ' -- Should have at least 20 accounts mainly used testing.');



-- Daemons, scripts, programs
CREATE TABLE AUDIT_DAEMON_USERS (
    ID BIGINT NOT NULL PRIMARY KEY,
    CREATED_ON DATETIME,
    EMAIL VARCHAR(256)
);

LOAD DATA LOCAL INFILE
    '/Users/ewu/Documents/logs/audit-2014-05/daemon-users.csv' 
INTO TABLE
    AUDIT_DAEMON_USERS
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES (
    ID,
    EMAIL
);

UPDATE AUDIT_DAEMON_USERS ADU SET CREATED_ON = (
    SELECT CREATED_ON
    FROM AUDIT_USERS AU
    WHERE AU.ID = ADU.ID AND INSTR(LCASE(AU.EMAIL), LCASE(ADU.EMAIL)) > 0
);

SELECT CONCAT(CASE WHEN
    (SELECT COUNT(DISTINCT ID) FROM AUDIT_DAEMON_USERS) > 10
    THEN 'PASSED' ELSE 'FAILED' END,
    ' -- Should have at least 10 daemon accounts.');


-- All other users

CREATE TABLE AUDIT_NON_SAGE_USERS AS
SELECT
    ID,
    CREATED_ON,
    EMAIL
FROM
    AUDIT_USERS
WHERE
    ID NOT IN (SELECT ID FROM AUDIT_SAGE_USERS) AND
    ID NOT IN (SELECT ID FROM AUDIT_TEST_USERS) AND
    ID NOT IN (SELECT ID FROM AUDIT_DAEMON_USERS);

ALTER TABLE AUDIT_NON_SAGE_USERS ADD INDEX USING HASH (ID);
