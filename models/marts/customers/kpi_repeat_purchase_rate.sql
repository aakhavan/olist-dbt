WITH o AS (
  SELECT order_id AS order_id, customer_key AS customer_key, (order_status NOT IN ('canceled', 'unavailable')) AS valid_order
  FROM {{ ref('int_orders') }}
),
per_customer AS (
  SELECT customer_key, COUNT(DISTINCT order_id) AS orders
  FROM o
  WHERE valid_order
  GROUP BY 1
)
SELECT COUNT(*) AS customers,
       AVG(CASE WHEN orders >= 2 THEN 1.0 ELSE 0.0 END) AS repeat_purchase_rate
FROM per_customer
