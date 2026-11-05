select
    NULLIF(TRIM(customer_id), '') as customer_id,
    NULLIF(TRIM(customer_unique_id), '') as customer_key
from {{ source('raw', 'olist_customers_dataset') }}
