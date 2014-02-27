CREATE TABLE USER_ACTIVITY_COUNTS AS
SELECT
    USER_ID,
    MONTH(TIMESTAMP) AS MONTH,
    DAYOFMONTH(TIMESTAMP) AS DAY
FROM
    ACCESS_RECORD
GROUP BY
    USER_ID,
    MONTH,
    DAY
HAVING
    COUNT(DISTINCT SESSION) > 0;


-- Active users are users who have logged at least 3 days of activities every month
CREATE TABLE ACTIVE_USERS AS
SELECT DISTINCT
    USER_ID
FROM
    -- Select the months that have more than 2 days of activities
    (SELECT
        USER_ID,
        MONTH
    FROM
        USER_ACTIVITY_COUNTS
    GROUP BY
        USER_ID,
        MONTH
    HAVING
        COUNT(DISTINCT DAY) > 2) USER_MONTHS
GROUP BY
    USER_ID
HAVING
    COUNT(DISTINCT MONTH) > 2; -- All the 3 months of the quarter
