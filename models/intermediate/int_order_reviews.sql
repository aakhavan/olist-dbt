WITH latest_reviews AS (
  SELECT
    order_id,
    review_id,
    review_score,
    review_answer_timestamp,
    ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY review_answer_timestamp DESC NULLS LAST) AS rn
  FROM {{ ref('stg_order_reviews') }}
)
SELECT
  lr.order_id AS order_id,
  lr.review_id AS review_id,
  lr.review_score AS review_score,
  lr.review_answer_timestamp AS answered_at,
  io.purchased_at AS purchased_at
FROM latest_reviews lr
LEFT JOIN {{ ref('int_orders') }} io
  ON lr.order_id = io.order_id
WHERE lr.rn = 1
