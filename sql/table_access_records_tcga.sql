-- The object-id column of the access records does not always capture
-- the entity IDs in the responses. These are entity IDs logged in
-- the request URIs. Use this table as a supplement table for entity IDs.
CREATE TABLE AUDIT_SESSION_ENTITY_TCGA (
    SESSION CHAR(36) NOT NULL,
    ENTITY_ID BIGINT NOT NULL
);

-- 7,049,175 rows, 15 minutes
LOAD DATA LOCAL INFILE
    '/Users/ewu/Documents/logs/audit-tcga-2014-03/session-synid.csv'
INTO TABLE
    AUDIT_SESSION_ENTITY_TCGA
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n' (
    SESSION,
    ENTITY_ID
);

-- 2 minute
ALTER TABLE AUDIT_SESSION_ENTITY_TCGA ADD INDEX USING HASH (SESSION);
-- 0.5 minute
ALTER TABLE AUDIT_SESSION_ENTITY_TCGA ADD INDEX USING HASH (ENTITY_ID);


-- Selected columns of the access records
CREATE TABLE AUDIT_ACCESS_RECORDS_TCGA (
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
-- 10,320,051 rows, 4246 seconds on a medium instance
LOAD DATA LOCAL INFILE
    '/Users/ewu/Documents/logs/audit-tcga-2014-03/access-lean-filtered.csv' 
INTO TABLE
    AUDIT_ACCESS_RECORDS_TCGA
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

-- Converts imported columns to proper types and values
-- 8 minutes
UPDATE
    AUDIT_ACCESS_RECORDS_TCGA
SET
    TIMESTAMP = FROM_UNIXTIME(TIMESTAMP_IMPORT / 1000);

-- 10 minutes
UPDATE
    AUDIT_ACCESS_RECORDS_TCGA
SET
    USER_ID = CAST(USER_ID_IMPORT AS UNSIGNED)
WHERE
    USER_ID_IMPORT IS NOT NULL AND
    USER_ID_IMPORT <> '';

-- 5.5 minutes
UPDATE
    AUDIT_ACCESS_RECORDS_TCGA
SET
    ENTITY_ID = CAST(SUBSTRING(OBJECT_ID_IMPORT, 4) AS UNSIGNED)
WHERE
    OBJECT_ID_IMPORT LIKE 'syn%' OR
    OBJECT_ID_IMPORT LIKE 'SYN%';

-- Adds indices
ALTER TABLE AUDIT_ACCESS_RECORDS_TCGA ADD INDEX USING BTREE (TIMESTAMP); -- 4.5 minutes
ALTER TABLE AUDIT_ACCESS_RECORDS_TCGA ADD INDEX USING HASH (USER_ID);    -- 4.5 minutes
ALTER TABLE AUDIT_ACCESS_RECORDS_TCGA ADD INDEX USING HASH (ENTITY_ID);  -- 4 minutes
ALTER TABLE AUDIT_ACCESS_RECORDS_TCGA ADD INDEX USING HASH (SESSION);    -- 9 minutes
ALTER TABLE AUDIT_ACCESS_RECORDS_TCGA ADD INDEX USING BTREE (SESSION);   -- 10 minutes, for counting distinct


-- Merges in the entity IDs parsed from the URIs
-- 37 minutes
UPDATE
    AUDIT_ACCESS_RECORDS_TCGA AR, AUDIT_SESSION_ENTITY_TCGA SE
SET
    AR.ENTITY_ID = SE.ENTITY_ID
WHERE
    AR.SESSION = SE.SESSION AND
    AR.ENTITY_ID IS NULL; -- Set the entity ID from URI only if the entity ID is missing
