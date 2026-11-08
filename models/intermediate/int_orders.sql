SELECT
  o.order_id AS order_id,
  o.customer_id AS customer_id,
  c.customer_unique_id AS customer_key,
  o.order_purchase_timestamp AS purchased_at,
  o.order_status AS order_status,
  o.order_delivered_customer_date AS delivered_at,
  o.order_estimated_delivery_date AS estimated_at
FROM {{ ref('stg_orders') }} AS o
LEFT JOIN {{ ref('stg_customers') }} AS c
  ON o.customer_id = c.customer_id
