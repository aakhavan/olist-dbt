WITH o AS (
  SELECT customer_key AS customer_key, date_trunc('month', purchased_at) AS order_month, (order_status NOT IN ('canceled', 'unavailable')) AS valid_order
  FROM {{ ref('int_orders') }}
),
valid AS (SELECT customer_key, order_month FROM o WHERE valid_order),
firsts AS (SELECT customer_key, MIN(order_month) AS cohort_month FROM valid GROUP BY 1),
sizes AS (SELECT cohort_month, COUNT(*) AS cohort_size FROM firsts GROUP BY 1),
last_month AS (SELECT MAX(order_month) AS m FROM valid),
activity AS (
  SELECT DISTINCT f.cohort_month, v.customer_key,
         (EXTRACT(YEAR FROM v.order_month) - EXTRACT(YEAR FROM f.cohort_month)) * 12
           + EXTRACT(MONTH FROM v.order_month) - EXTRACT(MONTH FROM f.cohort_month) AS months_since_first,
         v.order_month
  FROM valid v JOIN firsts f USING (customer_key)
)
SELECT a.cohort_month, a.months_since_first,
       COUNT(DISTINCT a.customer_key) * 1.0 / MAX(s.cohort_size) AS retention,
       BOOL_OR(a.order_month = lm.m) AS incomplete_month
FROM activity a
JOIN sizes s USING (cohort_month)
CROSS JOIN last_month lm
GROUP BY 1, 2
