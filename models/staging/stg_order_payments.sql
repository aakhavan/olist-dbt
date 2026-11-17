select
    order_id as order_id,
    payment_sequential::integer as payment_sequential,
    payment_type as payment_type,
    payment_installments::integer as payment_installments,
    payment_value::numeric as payment_value
from {{ source('raw', 'olist_order_payments_dataset') }}
