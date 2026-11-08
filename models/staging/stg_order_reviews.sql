select
    NULLIF(review_id, '') as review_id,
    NULLIF(order_id, '') as order_id,
    CAST(NULLIF(review_score, '') AS integer) as review_score,
    NULLIF(review_comment_title, '') as review_comment_title,
    NULLIF(review_comment_message, '') as review_comment_message,
    CAST(NULLIF(review_creation_date, '') AS timestamp) as review_creation_date,
    CAST(NULLIF(review_answer_timestamp, '') AS timestamp) as review_answer_timestamp
from {{ source('raw', 'olist_order_reviews_dataset') }}
