select
    NULLIF(order_id, '') as order_id,
    CAST(NULLIF(payment_sequential, '') AS integer) as payment_sequential,
    NULLIF(payment_type, '') as payment_type,
    CAST(NULLIF(payment_installments, '') AS integer) as payment_installments,
    CAST(NULLIF(payment_value, '') AS numeric) as payment_value
from {{ source('raw', 'olist_order_payments_dataset') }}
