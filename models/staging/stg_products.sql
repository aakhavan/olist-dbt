select
    product_id as product_id,
    product_category_name as product_category_name,
    product_weight_g::integer as product_weight_g
from {{ source('raw', 'olist_products_dataset') }}
