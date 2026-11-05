WITH joined AS (
  SELECT
    i.order_id AS order_id,
    i.order_item_id AS order_item_id,
    i.item_price AS item_price,
    i.freight AS freight,
    o.order_status AS order_status,
    o.purchased_at AS purchased_at,
    o.customer_key AS customer_key,
    row_number() OVER (PARTITION BY i.order_id, i.order_item_id ORDER BY o.purchased_at DESC NULLS LAST) AS rn
  FROM {{ ref('stg_order_items') }} i
  LEFT JOIN {{ ref('int_orders') }} o
    ON i.order_id = o.order_id
)
SELECT
  order_id,
  order_item_id,
  item_price,
  freight,
  order_status,
  purchased_at,
  customer_key
FROM joined
WHERE rn = 1
