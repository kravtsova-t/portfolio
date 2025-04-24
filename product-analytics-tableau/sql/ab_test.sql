WITH reg_2018 AS (
  SELECT uid
  FROM reg_data
  WHERE DATE_PART('year', TO_TIMESTAMP(reg_ts)) = 2018
),

ab_2018 AS (
  SELECT a.*
  FROM ab_test a
  JOIN reg_2018 r ON a.user_id = r.uid
),

base_metrics AS (
  SELECT 
    testgroup,
    COUNT(DISTINCT user_id) AS users,
    COUNT(DISTINCT CASE WHEN revenue > 0 THEN user_id END) AS paying_users,
    SUM(revenue) AS total_revenue,
    ROUND(AVG(revenue), 2) AS avg_revenue,
    ROUND(SUM(revenue)::NUMERIC / COUNT(DISTINCT user_id), 2) AS arpu,
    ROUND(SUM(revenue)::NUMERIC / NULLIF(COUNT(DISTINCT CASE WHEN revenue > 0 THEN user_id END), 0), 0) AS arppu,
    ROUND(
      COUNT(DISTINCT CASE WHEN revenue > 0 THEN user_id END)::NUMERIC / 
      NULLIF(COUNT(DISTINCT user_id), 0), 
      4
    ) AS pct_paying_users
  FROM ab_2018
  GROUP BY testgroup
)
,

metrics_with_uplift AS (
  SELECT
    a.testgroup,
    a.users,
    a.paying_users,
    a.total_revenue,
    a.avg_revenue,
    a.arpu,
    CASE WHEN a.testgroup = 'b' THEN ROUND((a.arpu - b.arpu) / NULLIF(b.arpu, 0),4) END AS uplift_arpu,

    CASE 
      WHEN a.testgroup = 'b' THEN 
        CASE 
          WHEN ROUND(100.0 * (a.arpu - b.arpu) / NULLIF(b.arpu, 0), 2) > 0 
            THEN '↑ ' || ROUND(100.0 * (a.arpu - b.arpu) / NULLIF(b.arpu, 0), 2)::TEXT || '%'
          WHEN ROUND(100.0 * (a.arpu - b.arpu) / NULLIF(b.arpu, 0), 2) < 0 
            THEN '↓ ' || ABS(ROUND(100.0 * (a.arpu - b.arpu) / NULLIF(b.arpu, 0), 2))::TEXT || '%'
          ELSE '→ 0.00%'
        END
    END AS uplift_arpu_label,

    a.arppu,
    CASE WHEN a.testgroup = 'b' THEN ROUND((a.arppu - b.arppu) / NULLIF(b.arppu, 0),4) END AS uplift_arppu,

    CASE 
      WHEN a.testgroup = 'b' THEN 
        CASE 
          WHEN ROUND(100.0 * (a.arppu - b.arppu) / NULLIF(b.arppu, 0), 2) > 0 
            THEN '↑ ' || ROUND(100.0 * (a.arppu - b.arppu) / NULLIF(b.arppu, 0), 2)::TEXT || '%'
          WHEN ROUND(100.0 * (a.arppu - b.arppu) / NULLIF(b.arppu, 0), 2) < 0 
            THEN '↓ ' || ABS(ROUND(100.0 * (a.arppu - b.arppu) / NULLIF(b.arppu, 0), 2))::TEXT || '%'
          ELSE '→ 0.00%'
        END
    END AS uplift_arppu_label,

    a.pct_paying_users,
   CASE WHEN a.testgroup = 'b' THEN ROUND(a.pct_paying_users - b.pct_paying_users,4) END AS uplift_pct_paying_users,

    CASE 
  WHEN a.testgroup = 'b' THEN 
    CASE 
      WHEN (a.pct_paying_users - b.pct_paying_users) > 0 
        THEN '↑ ' || ROUND(100.0 * (a.pct_paying_users - b.pct_paying_users), 2)::TEXT || '%'
      WHEN (a.pct_paying_users - b.pct_paying_users) < 0 
        THEN '↓ ' || ABS(ROUND(100.0 * (a.pct_paying_users - b.pct_paying_users), 2))::TEXT || '%'
      ELSE '→ 0.00%'
    END
END AS uplift_pct_paying_users_label


  FROM base_metrics a
  LEFT JOIN base_metrics b ON b.testgroup = 'a'
)

SELECT * FROM metrics_with_uplift;
