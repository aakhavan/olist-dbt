WITH orders AS (
    SELECT
        *,
        row_number() OVER (PARTITION BY order_id ORDER BY order_purchase_timestamp DESC NULLS LAST) AS rn
    FROM {{ ref('stg_orders') }}
),
customers AS (
    SELECT
        *,
        row_number() OVER (PARTITION BY customer_id ORDER BY customer_unique_id NULLS LAST) AS rn
    FROM {{ ref('stg_customers') }}
)
SELECT
    o.order_id AS order_id,
    o.order_purchase_timestamp AS purchased_at,
    o.order_status AS order_status,
    o.order_approved_at AS order_approved_at,
    o.order_delivered_customer_date AS delivered_at,
    o.order_estimated_delivery_date AS estimated_at,
    c.customer_unique_id AS customer_key
FROM orders o
LEFT JOIN customers c
  ON o.customer_id = c.customer_id
  AND c.rn = 1
WHERE o.rn = 1
