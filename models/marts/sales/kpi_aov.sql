WITH l AS (
  SELECT order_id AS order_id, purchased_at AS purchased_at, item_price AS item_price, (order_status NOT IN ('canceled', 'unavailable')) AS valid_order
  FROM {{ ref('int_order_lines') }}
)
SELECT date_trunc('month', purchased_at) AS month, SUM(item_price) / COUNT(DISTINCT order_id) AS aov
FROM l
WHERE valid_order
GROUP BY 1
