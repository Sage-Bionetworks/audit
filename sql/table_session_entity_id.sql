-- The object-id column of the access records do not always
-- capture the entity IDs in the responses. These are entity
-- IDs in the request URL. Use this table as a supplement.
CREATE TABLE SESSION_ENTITY (
    SESSION CHAR(36),
    ENTITY_ID BIGINT
);

LOAD DATA LOCAL INFILE
    '/Users/ewu/Documents/logs/2014-02-audit/results/session-synid.csv'
INTO TABLE
    SESSION_ENTITY
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n' (
    SESSION,
    ENTITY_ID
);

ALTER TABLE SESSION_ENTITY ADD INDEX USING HASH (SESSION);
ALTER TABLE SESSION_ENTITY ADD INDEX USING HASH (ENTITY_ID);
