-- stg_order_items: primary key (order_id, order_item_id) is unique and not null
select order_id, order_item_id, count(*) as n
from {{ ref('stg_order_items') }}
group by order_id, order_item_id
having count(*) > 1 or bool_or(order_id is null or order_item_id is null)
