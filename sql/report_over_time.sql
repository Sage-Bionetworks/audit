-- new sage users over time
-- sage_users_over_time.csv
SELECT *
FROM
    AUDIT_SAGE_USERS USERS
ORDER BY
    CREATED_ON DESC;

-- new non sage users over time
-- non_sage_users_over_time.csv
SELECT *
FROM
    AUDIT_NON_SAGE_USERS USERS
ORDER BY
    CREATED_ON DESC;

-- new projects over time
-- projects_over_time.csv
SELECT *
FROM
    AUDIT_PUBLIC_NODES
WHERE TYPE=2
GROUP BY ID;

-- new public files over time
-- public_files_over_time.csv
SELECT 
    AF.ID AS ID, 
    AF.NAME AS NAME, 
    AF.CREATED_ON AS CREATED_ON,
    AF.CREATED_BY AS CREATED_BY,
    AF.PROJECT_ID AS PROJECT_ID
FROM
    AUDIT_FILES AF
JOIN
    AUDIT_PUBLIC_NODES APN
ON
    AF.ID = APN.ID
ORDER BY
    CREATED_ON DESC;

