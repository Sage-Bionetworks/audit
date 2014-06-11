-- Data usage has three tiers:
-- ============================================================================
-- 1) Open Use Conditions: Includes data that may be shared
--   with every Registered Synapse user in an unrestricted manner
-- 2) Restricted Use Conditions: Includes data that may be shared
--   only following user agreement to comply with additional data-specific terms
-- 3) Controlled Use Conditions: Includes data requiring additional protections
--   for human subjects, like sensitive information or data from "vulnerable
--   populations" as defined using OHRP guidelines ans its implementation in
--   applicable local law. Controlled data use must be documented and monitored
-- ============================================================================
CREATE TABLE AUDIT_RESTRICTED_TEMP AS
SELECT DISTINCT
    NAR.SUBJECT_ID AS ID
FROM
    NODE_ACCESS_REQUIREMENT NAR,
    ACCESS_REQUIREMENT AR,
    JDONODE NODE
WHERE
    NAR.REQUIREMENT_ID = AR.ID AND
    NAR.SUBJECT_ID = NODE.ID AND
    AR.ENTITY_TYPE = 'org.sagebionetworks.repo.model.TermsOfUseAccessRequirement' AND
    NODE.BENEFACTOR_ID <> 1681355; -- Not in trash can

-- Execute me 15 times to walk down the tree to find all the descendents
INSERT INTO AUDIT_RESTRICTED_TEMP
SELECT
    NODE.ID
FROM
    JDONODE NODE,
    AUDIT_RESTRICTED_TEMP AR
WHERE 
    NODE.PARENT_ID = AR.ID;

CREATE TABLE AUDIT_RESTRICTED AS
SELECT DISTINCT ID FROM AUDIT_RESTRICTED_TEMP;

DROP TABLE AUDIT_RESTRICTED_TEMP;

ALTER TABLE AUDIT_RESTRICTED ADD INDEX USING HASH (ID);



CREATE TABLE AUDIT_CONTROLLED_TEMP AS
SELECT DISTINCT
    NAR.SUBJECT_ID AS ID
FROM
    NODE_ACCESS_REQUIREMENT NAR,
    ACCESS_REQUIREMENT AR,
    JDONODE NODE
WHERE
    NAR.REQUIREMENT_ID = AR.ID AND
    NAR.SUBJECT_ID = NODE.ID AND
    AR.ENTITY_TYPE = 'org.sagebionetworks.repo.model.ACTAccessRequirement' AND 
    NODE.PARENT_ID <> 1681355; -- Not in trash can

-- Excute me at lest 15 times
INSERT INTO AUDIT_CONTROLLED_TEMP
SELECT
    NODE.ID
FROM
    JDONODE NODE,
    AUDIT_CONTROLLED_TEMP AC
WHERE
    NODE.PARENT_ID = AC.ID;

CREATE TABLE AUDIT_CONTROLLED AS
SELECT DISTINCT ID FROM AUDIT_CONTROLLED_TEMP;

DROP TABLE AUDIT_CONTROLLED_TEMP;

ALTER TABLE AUDIT_CONTROLLED ADD INDEX USING HASH (ID);



-- Unit Tests
SELECT CONCAT(CASE WHEN
    (SELECT COUNT(ID) FROM AUDIT_CONTROLLED WHERE ID IN (2331097, 2343226, 2330782, 2344867, 2343207)) = 5
    THEN 'PASSED' ELSE 'FAILED' END,
    ' -- All the 5 entities are CONTROLLED and should be counted.');
