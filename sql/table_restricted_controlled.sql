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
CREATE TABLE AUDIT_RESTRICTED AS
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

ALTER TABLE AUDIT_RESTRICTED ADD INDEX USING HASH (ID);


CREATE TABLE AUDIT_CONTROLLED AS
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

ALTER TABLE AUDIT_CONTROLLED ADD INDEX USING HASH (ID);

