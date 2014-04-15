-- Non-Sage users accessing TCGA content (file and code)
SELECT
    NSU.ID AS USER_ID,
    NSU.EMAIL AS USER_EMAIL,
    COUNT(DISTINCT AR.SESSION) AS SESSION_COUNT
FROM
    AUDIT_ACCESS_RECORDS_TCGA AR,
    AUDIT_NON_SAGE_USERS NSU,
    JDONODE NODE
WHERE
    AR.ENTITY_ID = NODE.ID AND
    AR.USER_ID = NSU.ID AND
    NODE.BENEFACTOR_ID IN (300013, 1682511, 1695313) AND -- TCGA projects and folders
    AR.METHOD = 'GET' AND
    (((NODE.NODE_TYPE = 1 OR NODE.NODE_TYPE = 7) AND -- legacy types: layer or code
    -- Get Entity Bundle
    --   /repo/v1/entity/{id}/bundle
    --   /repo/v1/entity/{id}/version/{versionNumber}/bundle
    (AR.URI REGEXP '^/repo/v1/entity/syn[0-9]+(/version/[0-9]+)?/bundle$' OR
    -- Get Entity
    --   /repo/v1/entity/{id}
    --   /repo/v1/entity/{id}/version
    --   /repo/v1/entity/{id}/version/{versionNumber}
    AR.URI REGEXP '^/repo/v1/entity/syn[0-9]+(/verion(/[0-9]+)?)?$')) OR
    (NODE.NODE_TYPE = 16 AND
    -- File Download
    --   /repo/v1/entity/{id}/file
    --   /repo/v1/entity/{id}/version/{ver}/file
    AR.URI REGEXP '^/repo/v1/entity/syn[0-9]+(/version/[0-9]+)?/file$'))
GROUP BY
    USER_ID,
    USER_EMAIL
ORDER BY
    SESSION_COUNT DESC;



SELECT * FROM JDONODE
WHERE
    BENEFACTOR_ID IN (300013, 1682511, 1695313) AND
    NODE_TYPE <> 1 AND -- LAYER
    NODE_TYPE <> 2 AND -- PROJECT
    NODE_TYPE <> 4 AND -- FOLDER
    NODE_TYPE <> 16    -- FILE
ORDER BY
    NODE_TYPE;

-- 0: dataset, rendered as folder
-- 1: layer, downloadable
-- 7: code, downloadable
-- 8: link, some are S3 downloadable, most are not, ignore
-- 13: summary, ignore
SELECT
    NODE_TYPE,
    COUNT(DISTINCT ID)
FROM
    JDONODE
WHERE
    BENEFACTOR_ID IN (300013, 1682511, 1695313) AND
    NODE_TYPE <> 2 AND -- PROJECT
    NODE_TYPE <> 4     -- FOLDER
GROUP BY
    NODE_TYPE
ORDER BY
    NODE_TYPE;

SELECT * FROM NODE_TYPE;
