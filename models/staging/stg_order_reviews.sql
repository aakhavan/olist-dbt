select
    review_id as review_id,
    order_id as order_id,
    review_score::integer as review_score,
    review_creation_date::timestamp as review_creation_date,
    review_answer_timestamp::timestamp as review_answer_timestamp
from {{ source('raw', 'olist_order_reviews_dataset') }}
