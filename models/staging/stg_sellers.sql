select
    NULLIF(seller_id, '') as seller_id,
    NULLIF(seller_zip_code_prefix, '') as seller_zip_code_prefix,
    NULLIF(seller_city, '') as seller_city,
    NULLIF(seller_state, '') as seller_state
from {{ source('raw', 'olist_sellers_dataset') }}
