select
    seller_id as seller_id,
    seller_zip_code_prefix as seller_zip_code_prefix,
    seller_city as seller_city,
    seller_state as seller_state
from {{ source('raw', 'olist_sellers_dataset') }}
