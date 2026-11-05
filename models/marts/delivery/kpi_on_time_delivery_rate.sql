WITH o AS (
  SELECT purchased_at AS purchased_at, delivered_at AS delivered_at, estimated_at AS estimated_at,
         (order_status = 'delivered') AS delivered_order
  FROM {{ ref('int_orders') }}
)
SELECT date_trunc('month', purchased_at) AS month,
       AVG(CASE WHEN date_trunc('day', delivered_at) <= date_trunc('day', estimated_at) THEN 1.0 ELSE 0.0 END) AS on_time_delivery_rate
FROM o
WHERE delivered_order AND delivered_at IS NOT NULL AND estimated_at IS NOT NULL
GROUP BY 1
