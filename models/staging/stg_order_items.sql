select
    NULLIF(order_id, '') as order_id,
    CAST(NULLIF(order_item_id, '') AS integer) as order_item_id,
    NULLIF(product_id, '') as product_id,
    NULLIF(seller_id, '') as seller_id,
    CAST(NULLIF(shipping_limit_date, '') AS timestamp) as shipping_limit_date,
    CAST(NULLIF(price, '') AS numeric) as price,
    CAST(NULLIF(freight_value, '') AS numeric) as freight_value
from {{ source('raw', 'olist_order_items_dataset') }}
