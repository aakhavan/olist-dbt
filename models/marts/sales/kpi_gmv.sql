WITH l AS (
  SELECT purchased_at AS purchased_at, item_price AS item_price, freight AS freight, (order_status NOT IN ('canceled', 'unavailable')) AS valid_order
  FROM {{ ref('int_order_lines') }}
)
SELECT date_trunc('month', purchased_at) AS month, SUM(item_price + freight) AS gmv
FROM l
WHERE valid_order
GROUP BY 1
