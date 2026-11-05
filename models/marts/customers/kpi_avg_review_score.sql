WITH r AS (
  SELECT purchased_at AS purchased_at, review_score AS review_score
  FROM {{ ref('int_order_reviews') }}
)
SELECT date_trunc('month', purchased_at) AS month,
       AVG(review_score * 1.0) AS avg_review_score,
       AVG(CASE WHEN review_score <= 2 THEN 1.0 ELSE 0.0 END) AS low_score_share
FROM r
GROUP BY 1
