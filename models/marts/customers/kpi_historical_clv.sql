WITH l AS (
  SELECT customer_key AS customer_key, purchased_at AS purchased_at, item_price AS item_price,
         (order_status NOT IN ('canceled', 'unavailable')) AS valid_order, (order_status = 'delivered') AS delivered_order
  FROM {{ ref('int_order_lines') }}
),
firsts AS (SELECT customer_key, MIN(purchased_at) AS first_at FROM l WHERE valid_order GROUP BY 1),
per_customer AS (
  SELECT f.customer_key, date_trunc('month', f.first_at) AS cohort_month,
         COALESCE(SUM(CASE WHEN l.delivered_order AND l.purchased_at < f.first_at + INTERVAL '90 days' THEN l.item_price END), 0) AS rev_90,
         COALESCE(SUM(CASE WHEN l.delivered_order AND l.purchased_at < f.first_at + INTERVAL '180 days' THEN l.item_price END), 0) AS rev_180,
         COALESCE(SUM(CASE WHEN l.delivered_order AND l.purchased_at < f.first_at + INTERVAL '365 days' THEN l.item_price END), 0) AS rev_365
  FROM firsts f LEFT JOIN l ON l.customer_key = f.customer_key
  GROUP BY 1, 2
)
SELECT cohort_month, COUNT(*) AS customers,
       AVG(rev_90) AS clv_90d, AVG(rev_180) AS clv_180d, AVG(rev_365) AS clv_365d
FROM per_customer
GROUP BY 1
