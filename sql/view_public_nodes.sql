-- Public nodes
CREATE OR REPLACE VIEW VIEW_PUBLIC_NODES AS
SELECT
    NODE.ID AS ID,
    NODE.NODE_TYPE AS TYPE,
    NODE.NAME AS NAME,
    NODE.CREATED_ON AS CREATED_ON,
    NODE.CREATED_BY AS CREATED_BY,
    NODE.PARENT_ID AS PARENT_ID,
    NODE.BENEFACTOR_ID AS BENEFACTOR_ID
FROM
    ACL,
    JDONODE NODE,
    JDONODE BNODE,
    JDOUSERGROUP UG,
    JDORESOURCEACCESS RA,
    JDORESOURCEACCESS_ACCESSTYPE RAAT
WHERE
    NODE.BENEFACTOR_ID = BNODE.ID AND
    ACL.ID = BNODE.ID AND
    UG.ID = RA.GROUP_ID AND
    RA.OWNER_ID = ACL.ID AND
    RAAT.OWNER_ID = ACL.ID AND
    RA.ID = RAAT.ID_OID AND
    -- If the anonymous user group can read
    UG.ID = 273949 AND
    RAAT.STRING_ELE = 'READ' AND
    NODE.BENEFACTOR_ID <> 1681355; -- Not in trash can


-- Unit tests
SELECT CONCAT(CASE WHEN
    (SELECT COUNT(DISTINCT ID) FROM VIEW_PUBLIC_NODES) > 50000 AND
    (SELECT COUNT(DISTINCT ID) FROM VIEW_PUBLIC_NODES) < 500000
    THEN 'PASSED' ELSE 'FAILED' END,
    ' -- Should have more than 5000 public entites.');

SELECT CONCAT(CASE WHEN
    (SELECT COUNT(DISTINCT ID) FROM JDONODE WHERE ID NOT IN (SELECT ID FROM VIEW_PUBLIC_NODES)) > 900000
    THEN 'PASSED' ELSE 'FAILED' END,
    ' -- The majority are private entites.');
