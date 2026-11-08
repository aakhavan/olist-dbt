select
    NULLIF(order_id, '') as order_id,
    NULLIF(customer_id, '') as customer_id,
    NULLIF(order_status, '') as order_status,
    CAST(NULLIF(order_purchase_timestamp, '') AS timestamp) as order_purchase_timestamp,
    CAST(NULLIF(order_approved_at, '') AS timestamp) as order_approved_at,
    CAST(NULLIF(order_delivered_carrier_date, '') AS timestamp) as order_delivered_carrier_date,
    CAST(NULLIF(order_delivered_customer_date, '') AS timestamp) as order_delivered_customer_date,
    CAST(NULLIF(order_estimated_delivery_date, '') AS timestamp) as order_estimated_delivery_date
from {{ source('raw', 'olist_orders_dataset') }}
