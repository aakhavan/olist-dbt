-- stg_order_payments: primary key (order_id, payment_sequential) is unique and not null
select order_id, payment_sequential, count(*) as n
from {{ ref('stg_order_payments') }}
group by order_id, payment_sequential
having count(*) > 1 or bool_or(order_id is null or payment_sequential is null)
