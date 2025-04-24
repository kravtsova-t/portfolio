WITH reg_2018 AS (
  SELECT 
    uid
  FROM reg_data
  WHERE DATE_PART('year', TO_TIMESTAMP(reg_ts)) = 2018
),

base AS (
  SELECT 
    a.user_id,
    a.revenue
  FROM ab_test a
  JOIN reg_2018 r ON a.user_id = r.uid
),

totals AS (
  SELECT 
    COUNT(DISTINCT user_id) AS total_users,
    COUNT(DISTINCT CASE WHEN revenue > 0 THEN user_id END) AS paying_users,
    SUM(revenue) AS total_revenue
  FROM base
)

SELECT 
  total_users,
  paying_users,
  ROUND(paying_users::NUMERIC / total_users, 4) AS pct_paying_users,
  ROUND(total_revenue::NUMERIC / total_users, 4) AS ltv
FROM totals;
