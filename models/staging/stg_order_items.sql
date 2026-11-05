select
    NULLIF(TRIM(order_id), '') as order_id,
    CAST(NULLIF(TRIM(order_item_id), '') AS integer) as order_item_id,
    CAST(NULLIF(TRIM(price), '') AS numeric) as item_price,
    CAST(NULLIF(TRIM(freight_value), '') AS numeric) as freight
from {{ source('raw', 'olist_order_items_dataset') }}
