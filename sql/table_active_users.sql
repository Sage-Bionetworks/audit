-- Selects the days where a user has logged some activities
-- 12 minutes
CREATE TABLE AUDIT_USER_ACTIVE_DAYS AS
SELECT
    USER_ID,
    MONTH(TIMESTAMP) AS MONTH,
    DAYOFMONTH(TIMESTAMP) AS DAY,
    COUNT(DISTINCT SESSION) AS SESSION_COUNT
FROM
    AUDIT_ACCESS_RECORDS
GROUP BY
    USER_ID,
    MONTH,
    DAY
HAVING
    SESSION_COUNT > 0;

ALTER TABLE AUDIT_USER_ACTIVE_DAYS ADD INDEX USING HASH (USER_ID);
ALTER TABLE AUDIT_USER_ACTIVE_DAYS ADD INDEX USING BTREE (MONTH, DAY);

-- Active users are users who have logged at least 3 days of activities every month
CREATE TABLE AUDIT_ACTIVE_USERS AS
SELECT DISTINCT
    USER_ACTIVE_MONTHS.USER_ID AS USER_ID
FROM
    (SELECT -- Select the months that have more than 2 days of activities
        UAD.USER_ID,
        UAD.MONTH
    FROM
        AUDIT_USER_ACTIVE_DAYS AS UAD
    GROUP BY
        UAD.USER_ID,
        UAD.MONTH
    HAVING
        COUNT(DISTINCT UAD.DAY) > 2  -- At least 3 days of a month
    ) AS USER_ACTIVE_MONTHS
GROUP BY
    USER_ACTIVE_MONTHS.USER_ID
HAVING
    COUNT(DISTINCT USER_ACTIVE_MONTHS.MONTH) > 2; -- All the 3 months of the quarter


-- Unit tests
SELECT CONCAT(CASE WHEN
    (SELECT COUNT(DISTINCT MONTH) FROM AUDIT_USER_ACTIVE_DAYS) = 3
    THEN 'PASSED' ELSE 'FAILED' END,
    ' -- Should have 3 months.');

SELECT CONCAT(CASE WHEN
    (SELECT COUNT(DISTINCT DAY) FROM AUDIT_USER_ACTIVE_DAYS) = 31
    THEN 'PASSED' ELSE 'FAILED' END,
    ' -- Should have 31 days.');

SELECT CONCAT(CASE WHEN
    (SELECT COUNT(DISTINCT USER_ID) FROM AUDIT_USER_ACTIVE_DAYS) > 1000 AND
    (SELECT COUNT(DISTINCT USER_ID) FROM AUDIT_USER_ACTIVE_DAYS) < 10000
    THEN 'PASSED' ELSE 'FAILED' END,
    ' -- More than 1000 unique users.');

SELECT CONCAT(CASE WHEN
    (SELECT COUNT(DISTINCT USER_ID) FROM AUDIT_ACTIVE_USERS) > 50 AND
    (SELECT COUNT(DISTINCT USER_ID) FROM AUDIT_ACTIVE_USERS) < 500
    THEN 'PASSED' ELSE 'FAILED' END,
    ' -- More than 50 active users.');