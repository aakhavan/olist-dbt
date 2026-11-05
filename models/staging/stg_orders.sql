select
    NULLIF(TRIM(order_id), '') as order_id,
    NULLIF(TRIM(customer_id), '') as customer_id,
    LOWER(NULLIF(TRIM(order_status), '')) as order_status,
    CAST(NULLIF(TRIM(order_purchase_timestamp), '') AS timestamp) as purchased_at,
    CAST(NULLIF(TRIM(order_delivered_customer_date), '') AS timestamp) as delivered_at,
    CAST(NULLIF(TRIM(order_estimated_delivery_date), '') AS timestamp) as estimated_at
from {{ source('raw', 'olist_orders_dataset') }}
