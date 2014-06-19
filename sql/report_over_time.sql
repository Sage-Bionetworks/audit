# new sage users over time

SELECT *
FROM
    AUDIT_SAGE_USERS USERS
ORDER BY
    CREATED_ON DESC;

# new non sage users over time

SELECT *
FROM
    AUDIT_NON_SAGE_USERS USERS
ORDER BY
    CREATED_ON DESC;

# new projects over time

SELECT *
FROM
    AUDIT_PUBLIC_NODES
WHERE TYPE=2
GROUP BY ID;

# new files over time

SELECT *
FROM
    AUDIT_FILES
ORDER BY
    CREATED_ON DESC;