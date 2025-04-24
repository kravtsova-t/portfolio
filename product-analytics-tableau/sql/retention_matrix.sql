WITH reg_month AS (
  SELECT 
    uid,
    DATE_TRUNC('month', TO_TIMESTAMP(reg_ts)) AS cohort_month
  FROM reg_data
  WHERE TO_TIMESTAMP(reg_ts) BETWEEN '2019-01-01' AND '2019-12-31 23:59:59'
),

logins AS (
  SELECT 
    uid,
    DATE_TRUNC('month', TO_TIMESTAMP(auth_ts)) AS login_month
  FROM auth_data
  WHERE TO_TIMESTAMP(auth_ts) BETWEEN '2019-01-01' AND '2019-12-31 23:59:59'
),

cohorts AS (
  SELECT DISTINCT uid, cohort_month
  FROM reg_month
),

combined AS (
  SELECT 
    c.cohort_month,
    l.login_month,
    c.uid
  FROM cohorts c
  JOIN logins l ON l.uid = c.uid
),

users_per_cohort AS (
  SELECT cohort_month, COUNT(DISTINCT uid) AS total_users
  FROM cohorts
  GROUP BY cohort_month
),

retention_raw AS (
  SELECT 
    cohort_month,
    login_month,
    COUNT(DISTINCT uid) AS returned_users
  FROM combined
  GROUP BY cohort_month, login_month
),

retention_pct AS (
  SELECT 
    r.cohort_month,
    r.login_month,
    ROUND(r.returned_users::NUMERIC / u.total_users, 4) AS retention_rate
  FROM retention_raw r
  JOIN users_per_cohort u ON r.cohort_month = u.cohort_month
)

SELECT *
FROM retention_pct
ORDER BY cohort_month, login_month;
