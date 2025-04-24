WITH step1 AS (
  SELECT uid, reg_ts
  FROM reg_data
  WHERE DATE_PART('year', TO_TIMESTAMP(reg_ts)) = 2018
),

step2 AS (
  SELECT s1.uid, s1.reg_ts
  FROM step1 s1
  JOIN auth_data a ON a.uid = s1.uid
  WHERE (a.auth_ts - s1.reg_ts) BETWEEN 1*86400 AND 2*86400
),

step3 AS (
  SELECT s2.uid, s2.reg_ts
  FROM step2 s2
  JOIN auth_data a ON a.uid = s2.uid
  WHERE (a.auth_ts - s2.reg_ts) BETWEEN 3*86400 AND 4*86400
),

step4 AS (
  SELECT s3.uid, s3.reg_ts
  FROM step3 s3
  JOIN auth_data a ON a.uid = s3.uid
  WHERE (a.auth_ts - s3.reg_ts) BETWEEN 5*86400 AND 6*86400
),

step5 AS (
  SELECT s4.uid, s4.reg_ts
  FROM step4 s4
  JOIN auth_data a ON a.uid = s4.uid
  WHERE (a.auth_ts - s4.reg_ts) BETWEEN 7*86400 AND 8*86400
),

counts AS (
  SELECT 
    (SELECT COUNT(*) FROM step1) AS s1,
    (SELECT COUNT(*) FROM step2) AS s2,
    (SELECT COUNT(*) FROM step3) AS s3,
    (SELECT COUNT(*) FROM step4) AS s4,
    (SELECT COUNT(*) FROM step5) AS s5
)

SELECT 'Step 1: Registered' AS step, 
       s1 AS users, 
       1::NUMERIC AS conversion_from_step1, 
       NULL::NUMERIC AS conversion_from_previous
FROM counts

UNION ALL

SELECT 'Step 2: Logged In Day 1', 
       s2, 
       ROUND(s2::NUMERIC / NULLIF(s1, 0), 4),
       NULL::NUMERIC 
FROM counts

UNION ALL

SELECT 'Step 3: Logged In Day 3', 
       s3, 
       ROUND(s3::NUMERIC / NULLIF(s1, 0), 4),
       ROUND(s3::NUMERIC / NULLIF(s2, 0), 4)
FROM counts

UNION ALL

SELECT 'Step 4: Logged In Day 5', 
       s4, 
       ROUND(s4::NUMERIC / NULLIF(s1, 0), 4),
       ROUND(s4::NUMERIC / NULLIF(s3, 0), 4)
FROM counts

UNION ALL

SELECT 'Step 5: Logged In Day 7', 
       s5, 
       ROUND(s5::NUMERIC / NULLIF(s1, 0), 4),
       ROUND(s5::NUMERIC / NULLIF(s4, 0), 4)
FROM counts;
