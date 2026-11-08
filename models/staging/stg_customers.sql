select
    NULLIF(customer_id, '') as customer_id,
    NULLIF(customer_unique_id, '') as customer_unique_id,
    NULLIF(customer_zip_code_prefix, '') as customer_zip_code_prefix,
    NULLIF(customer_city, '') as customer_city,
    NULLIF(customer_state, '') as customer_state
from {{ source('raw', 'olist_customers_dataset') }}
