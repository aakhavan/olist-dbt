SELECT
  soi.order_id AS order_id,
  soi.order_item_id AS order_item_id,
  soi.product_id AS product_id,
  soi.seller_id AS seller_id,
  soi.price AS item_price,
  soi.freight_value AS freight,
  io.purchased_at AS purchased_at,
  io.order_status AS order_status,
  io.customer_key AS customer_key
FROM {{ ref('stg_order_items') }} AS soi
LEFT JOIN {{ ref('int_orders') }} AS io
  ON soi.order_id = io.order_id
