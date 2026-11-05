WITH l AS (
  SELECT purchased_at AS purchased_at, item_price AS item_price, (order_status = 'delivered') AS delivered_order
  FROM {{ ref('int_order_lines') }}
)
SELECT date_trunc('month', purchased_at) AS month, SUM(item_price) AS net_revenue
FROM l
WHERE delivered_order
GROUP BY 1
