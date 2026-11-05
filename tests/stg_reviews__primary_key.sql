-- stg_reviews: primary key (review_id, order_id) is unique and not null
select review_id, order_id, count(*) as n
from {{ ref('stg_reviews') }}
group by review_id, order_id
having count(*) > 1 or bool_or(review_id is null or order_id is null)
