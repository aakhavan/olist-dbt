WITH ranked AS (
  SELECT
    review_id,
    order_id,
    review_score,
    review_answer_timestamp,
    ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY review_answer_timestamp DESC, review_id DESC) AS rn
  FROM {{ ref('stg_order_reviews') }}
)
SELECT
  r.order_id AS order_id,
  r.review_id AS review_id,
  r.review_score AS review_score,
  r.review_answer_timestamp AS review_answer_timestamp,
  o.purchased_at AS purchased_at
FROM ranked r
LEFT JOIN {{ ref('int_orders') }} o USING (order_id)
WHERE r.rn = 1
