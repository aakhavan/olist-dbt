select
    NULLIF(TRIM(review_id), '') as review_id,
    NULLIF(TRIM(order_id), '') as order_id,
    CAST(NULLIF(TRIM(review_score), '') AS integer) as review_score,
    CAST(NULLIF(TRIM(review_answer_timestamp), '') AS timestamp) as answered_at
from {{ source('raw', 'olist_order_reviews_dataset') }}
