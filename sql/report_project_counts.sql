-- Count of public projects
SELECT
    COUNT(DISTINCT ID)
FROM
    VIEW_PUBLIC_NODES
WHERE
    TYPE = 2;


-- Count of public projects created by non-sage users
SELECT
    COUNT(DISTINCT NODES.ID)
FROM
    VIEW_PUBLIC_NODES NODES,
    VIEW_NON_SAGE_USERS USERS
WHERE
    NODES.CREATED_BY = USERS.PRINCIPAL_ID AND
    NODES.TYPE = 2;


-- Count of non-public projects
SELECT
    COUNT(DISTINCT ID)
FROM
    JDONODE
WHERE
    ID NOT IN (SELECT ID FROM VIEW_PUBLIC_NODES) AND
    NODE_TYPE = 2 AND         -- Type is file
    BENEFACTOR_ID <> 1681355; -- Not in trash can


-- Count of non-public projects created by non-sage users
SELECT
    COUNT(DISTINCT NODES.ID)
FROM
    JDONODE NODES,
    VIEW_NON_SAGE_USERS USERS
WHERE
    NODES.ID NOT IN (SELECT ID FROM VIEW_PUBLIC_NODES) AND
    NODES.CREATED_BY = USERS.PRINCIPAL_ID AND
    NODE_TYPE = 2 AND         -- Type is file
    BENEFACTOR_ID <> 1681355; -- Not in trash can
