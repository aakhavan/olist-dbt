SELECT
  o.order_id AS order_id,
  c.customer_key AS customer_key,
  o.order_status AS order_status,
  o.purchased_at AS purchased_at,
  o.delivered_at AS delivered_at,
  o.estimated_at AS estimated_at
FROM {{ ref('stg_orders') }} o
LEFT JOIN {{ ref('stg_customers') }} c
  ON o.customer_id = c.customer_id
