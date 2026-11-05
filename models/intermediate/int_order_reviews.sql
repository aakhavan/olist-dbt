WITH ranked_reviews AS (
    SELECT
        review_id,
        order_id,
        review_score,
        answered_at,
        ROW_NUMBER() OVER (
            PARTITION BY order_id
            ORDER BY answered_at DESC NULLS LAST, review_id DESC
        ) AS rn
    FROM {{ ref('stg_reviews') }}
)
SELECT
    rr.order_id AS order_id,
    rr.review_id AS review_id,
    rr.review_score AS review_score,
    rr.answered_at AS answered_at,
    o.purchased_at AS purchased_at
FROM ranked_reviews rr
LEFT JOIN {{ ref('stg_orders') }} o
  ON rr.order_id = o.order_id
WHERE rr.rn = 1
