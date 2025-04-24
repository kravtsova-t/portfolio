SELECT 
  DATE_TRUNC('month', TO_TIMESTAMP(r.reg_ts)) AS reg_month,
  a.testgroup,
  SUM(a.revenue) AS total_revenue,
  COUNT(DISTINCT a.user_id) AS users,
  ROUND(SUM(a.revenue)::NUMERIC / NULLIF(COUNT(DISTINCT a.user_id), 0), 2) AS ltv
FROM ab_test a
JOIN reg_data r ON a.user_id = r.uid
WHERE DATE_PART('year', TO_TIMESTAMP(r.reg_ts)) = 2018
GROUP BY reg_month, a.testgroup
ORDER BY reg_month, a.testgroup;
