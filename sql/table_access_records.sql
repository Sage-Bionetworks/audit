-- The object-id column of the access records does not always capture
-- the entity IDs in the responses. These are entity IDs logged in
-- the request URIs. Use this table as a supplement table for entity IDs.
CREATE TABLE AUDIT_SESSION_ENTITY (
    SESSION CHAR(36) NOT NULL,
    ENTITY_ID BIGINT NOT NULL
);

-- 3,167,850 rows, 1.5 minutes
LOAD DATA LOCAL INFILE
    '/Users/kimyen/Documents/Sage/audit-2014-11/session-synid.csv'
INTO TABLE
    AUDIT_SESSION_ENTITY
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n' (
    SESSION,
    ENTITY_ID
);

-- 1 minute
ALTER TABLE AUDIT_SESSION_ENTITY ADD INDEX USING HASH (SESSION);
-- 0.5 minute
ALTER TABLE AUDIT_SESSION_ENTITY ADD INDEX USING HASH (ENTITY_ID);


-- Selected columns of the access records
CREATE TABLE AUDIT_ACCESS_RECORDS (
    OBJECT_ID_IMPORT VARCHAR(12),
    ENTITY_ID BIGINT,
    LATENCY BIGINT,
    TIMESTAMP_IMPORT BIGINT,    -- Import as long integers first
    TIMESTAMP DATETIME,         -- Then convert to date time
    USER_AGENT VARCHAR(256),
    SESSION CHAR(36),
    URI VARCHAR(256),
    USER_ID_IMPORT VARCHAR(12), -- Import as strings (as some are empty strings)
    USER_ID INT,                -- Then convert to integers
    METHOD VARCHAR(12),
    STACK INT,
    SUCCESS VARCHAR(5)
);

-- Imports merged access-record files of selected columns
-- 21,731,753 rows, 45 minutes on a medium instance
LOAD DATA LOCAL INFILE
    '/Users/kimyen/Documents/Sage/audit-2014-11/access-record-lean.csv' 
INTO TABLE
    AUDIT_ACCESS_RECORDS
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n' (
    OBJECT_ID_IMPORT,
    LATENCY,
    TIMESTAMP_IMPORT,
    USER_AGENT,
    SESSION,
    URI,
    USER_ID_IMPORT,
    METHOD,
    STACK,
    SUCCESS
);

-- For Error 1175 on update, run the following command
-- SET SQL_SAFE_UPDATES = 0;
-- For Error 1205, run the following commands
-- show variables like 'innodb_lock_wait_timeout';
-- set innodb_lock_wait_timeout=200;

-- Converts imported columns to proper types and values
-- 25 minutes
UPDATE
    AUDIT_ACCESS_RECORDS
SET
    TIMESTAMP = FROM_UNIXTIME(TIMESTAMP_IMPORT / 1000);

-- 25 minutes
UPDATE
    AUDIT_ACCESS_RECORDS
SET
    USER_ID = CAST(USER_ID_IMPORT AS UNSIGNED)
WHERE
    USER_ID_IMPORT IS NOT NULL AND
    USER_ID_IMPORT <> '';

-- 5.5 minutes
UPDATE
    AUDIT_ACCESS_RECORDS
SET
    ENTITY_ID = CAST(SUBSTRING(OBJECT_ID_IMPORT, 4) AS UNSIGNED)
WHERE
    OBJECT_ID_IMPORT LIKE 'syn%' OR
    OBJECT_ID_IMPORT LIKE 'SYN%';

-- Adds indices
ALTER TABLE AUDIT_ACCESS_RECORDS ADD INDEX USING BTREE (TIMESTAMP); -- 4.5 minutes
ALTER TABLE AUDIT_ACCESS_RECORDS ADD INDEX USING HASH (USER_ID);    -- 4.5 minutes
ALTER TABLE AUDIT_ACCESS_RECORDS ADD INDEX USING HASH (ENTITY_ID);  -- 4 minutes
ALTER TABLE AUDIT_ACCESS_RECORDS ADD INDEX USING HASH (SESSION);    -- 9 minutes
ALTER TABLE AUDIT_ACCESS_RECORDS ADD INDEX USING BTREE (SESSION);   -- 10 minutes, for counting distinct


-- Merges in the entity IDs parsed from the URIs
-- 37 minutes
UPDATE
    AUDIT_ACCESS_RECORDS AR, AUDIT_SESSION_ENTITY SE
SET
    AR.ENTITY_ID = SE.ENTITY_ID
WHERE
    AR.SESSION = SE.SESSION AND
    AR.ENTITY_ID IS NULL; -- Set the entity ID from URI only if the entity ID is missing


-- Unit tests
SELECT CONCAT(CASE WHEN
    (SELECT COUNT(DISTINCT ENTITY_ID) FROM AUDIT_ACCESS_RECORDS WHERE ENTITY_ID IS NOT NULL) > 50000
    THEN 'PASSED' ELSE 'FAILED' END,
    ' -- There should be at least 50,000 entities with activitieis during the quarter.');

SELECT CONCAT(CASE WHEN
    (SELECT COUNT(DISTINCT USER_ID) FROM AUDIT_ACCESS_RECORDS WHERE USER_ID IS NOT NULL) > 1000
    THEN 'PASSED' ELSE 'FAILED' END,
    ' -- There should be at least 1000 users with activities during the quarter.');

SELECT * FROM AUDIT_ACCESS_RECORDS LIMIT 300;
