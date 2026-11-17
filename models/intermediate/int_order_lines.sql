WITH joined AS (
  SELECT
    oi.order_id AS order_id,
    oi.order_item_id AS order_item_id,
    COALESCE(oi.product_id, p.product_id) AS product_id,
    oi.seller_id AS seller_id,
    o.purchased_at AS purchased_at,
    o.order_status AS order_status,
    oi.price AS item_price,
    oi.freight_value AS freight,
    o.customer_key AS customer_key,
    ROW_NUMBER() OVER (PARTITION BY oi.order_id, oi.order_item_id ORDER BY o.purchased_at NULLS LAST) AS rn
  FROM {{ ref('stg_order_items') }} AS oi
  LEFT JOIN {{ ref('int_orders') }} AS o
    ON oi.order_id = o.order_id
  LEFT JOIN {{ ref('stg_products') }} AS p
    ON oi.product_id = p.product_id
)
SELECT
  order_id,
  order_item_id,
  product_id,
  seller_id,
  purchased_at,
  order_status,
  item_price,
  freight,
  customer_key
FROM joined
WHERE rn = 1
